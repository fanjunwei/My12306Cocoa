# coding=utf8
import urllib2
import urllib
import cookielib
import  datetime
import time
import json
import  threading
import thread
import sys
import base64

proxyFilePath=sys.argv[1]
argdate=sys.argv[2]
argsessionFrom=sys.argv[3]
argsessionTo=sys.argv[4]

QueryAddrss='https://kyfw.12306.cn/otn/leftTicket/query?leftTicketDTO.train_date=%s&leftTicketDTO.from_station=%s&leftTicketDTO.to_station=%s&purpose_codes=ADULT'%(argdate,argsessionFrom,argsessionTo)
Tranicode=sys.argv[5]
Seat=sys.argv[6]
MustCount=2

UserAgent='Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/11B554a (392691824)/Worklight/6.0.0'
countLock=threading.RLock()
index=0
proxyadds =[]
mFinded=False
def propxy(url,proxyUrl):
    sys.stderr.write(proxyUrl+'\n')
    starts = time.time()
    proxy_support = urllib2.ProxyHandler({"http":"http://"+proxyUrl})
    opener = urllib2.build_opener(proxy_support)
    req = urllib2.Request(url)
    req.add_header('User-Agent', UserAgent)
    res=''
    try:
        f=opener.open(req)
        res= f.read()
    except urllib2.URLError ,e:
        res=None

    return res


def readProxyAddFile():
    global proxyadds
    file = open(proxyFilePath,'r')
    for line in file.readlines():
        args=line.split('\t')
        proxyadds.append(args[0])

def getYupiaoCount(yupiaoStr,seat):

    for i in range(0,len(yupiaoStr)/10):
        s=yupiaoStr[i*10:i*10+10]
        c_seat=s[0:1]
        if(c_seat==seat):
            count=int(s[6:6+4])
            if(count<3000):
                return count

    return 0

def getNewIndex():
    global countLock,index
    countLock.acquire()
    index=index+1
    if(index>=len(proxyadds)):
        index=0
    return index
    countLock.release()


def query(proxy):
    global QueryAddrss, Tranicode, Seat,MustCount,mFinded
    res = propxy(QueryAddrss,proxy)
    obj = json.loads(res)
    data=obj['data']
    #queryLeftNewDTO=data['queryLeftNewDTO']
    for tr in data:

        secretStr = tr['secretStr']
        unquoteSecretStr=urllib.unquote(secretStr)
        decodeSecretStr=base64.b64decode(unquoteSecretStr)
        args = decodeSecretStr.split('#')
        code=args[2]
        yupiaoStr=args[13]
        count=getYupiaoCount(yupiaoStr,Seat)
        timeTick=float(args[15])/1000.0
        if(count>MustCount and code==Tranicode):
            # print decodeSecretStr

            # print code
            # print yupiaoStr
            # print count
            if(not mFinded):
                print unquoteSecretStr
                #print time.ctime() +'\t'+time.ctime(timeTick)
                #print args[15]
                mFinded=True
def queryThread():
    global mFinded
    while not mFinded:
        index=getNewIndex()
        query(proxyadds[index])

readProxyAddFile()

for i in range(0,10):
    thread.start_new_thread(queryThread,())
while not mFinded:
    time.sleep(1)

