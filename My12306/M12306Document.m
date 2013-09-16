//
//  M12306Document.m
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import "M12306Document.h"
#import "M12306Base32.h"
@implementation M12306Document
{
    NSDictionary *_savedDate;
}
- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"M12306Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURL *url = [NSURL URLWithString:HOST_URL];
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            
        }
    }
    [self initSeat];
    NSTimeInterval timei = 19*24*60*60;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timei];
    self.dtpDate.dateValue=date;
    NSString * username=[self.savedDate objectForKey:@"username"];
    NSString * password=[self.savedDate objectForKey:@"password"];
    if(username!=nil && password!=nil)
    {
        self.txtUsername.stringValue=username;
        self.txtPassword.stringValue =password;
    }
    NSString *trainnameregx=[self.savedDate objectForKey:@"trainnameregx"];
    if(trainnameregx!=nil)
    {
        self.txtTrainNameRegx.stringValue=trainnameregx;
    }
    
    [(M12306TextField *) self.txtImgcode setTextChangeAction:@selector(txtImgLoginCodeAction) toTarget:self];
    [self.txtCommitCode setTextChangeAction:@selector(txtCommitCodeTextChageAction) toTarget:self];
   
    NSLog(@"%@",self.webview.mainFrame);
    NSString  * html=[self getResFile:@"login.html"];
    [self.webview.mainFrame loadHTMLString:html baseURL:nil];
    
    
    [NSThread detachNewThreadSelector:@selector(myinit) toTarget:self withObject:nil];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

-(void) myinit
{
//    while (TRUE) {
//        [[NSURLCache sharedURLCache] removeAllCachedResponses];
//        
//        NSURL *url = [NSURL URLWithString:HOST_URL];
//        if (url) {
//            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
//            for (int i = 0; i < [cookies count]; i++) {
//                NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
//                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//                
//            }
//        }
//        NSString * str = [self getText:[NSString stringWithFormat:HOST_URL@"/otsweb/dynamicJsAction.do?jsversion=%@&method=queryJs",@"123"] IsPost:NO];
//        if([str rangeOfString:@"function(){var dobj=new Object()"].location!=NSNotFound)
//        {
//            NSLog(@"find el");
//        }
//        else
//        {
//            NSLog(@"no el");
//        }
//        sleep(10);
//    }
    NSNotification * noti = [NSNotification notificationWithName:@"center" object:@"ok"];
    [[NSNotificationCenter defaultCenter]postNotification:noti];
    [self addLog:@"初始化..."];
    [self getStations];
    [self getLoginImgCode];
    [self addLog:@"初始化完成。"];



}

-(void) addLogLock:(NSString *)log
{
    if(log!=nil && self.txtLogParent)
    {
        NSDate  * now =[NSDate date];
        NSDateFormatter * formate=[[NSDateFormatter alloc]init];
        [formate setDateFormat:@"HH:mm:ss"];
        NSString * str = [formate stringFromDate:now];
        str = [str stringByAppendingFormat:@" %@",log];
        
        self.txtLog.string=[self.txtLog.string stringByAppendingFormat:@"%@\n",str];
        
        NSRange range = NSMakeRange ([[self.txtLog string] length], 0);
        
        [self.txtLog scrollRangeToVisible: range];
        
    }
}
-(void) addLog:(NSString *)log
{
    [self performSelectorOnMainThread:@selector(addLogLock:) withObject:log waitUntilDone:YES];
}
- (void)setLoginImgCode:(NSImage *)image
{
    [self.imgLoginCode setImage:image];
    if(self.txtUsername.stringValue && ![self.txtUsername.stringValue isEqualToString:@""] && self.txtPassword.stringValue && ![self.txtPassword.stringValue isEqualToString:@""])
    {
        self.txtImgcode.stringValue=@"";
        [self.txtImgcode becomeFirstResponder];
    }
//    else
//    {
//        [self.txtUsername becomeFirstResponder];
//    }
}
-(void) getLoginImgCodeLock
{
//    [self getText:@"http://www.12306.cn/mormhweb/kyfw/" IsPost:NO];
//    NSString *t1 = [self getText:HOST_URL@"/otsweb/" IsPost:NO];
//    NSString * test=[self getText:HOST_URL@"/otsweb/loginAction.do?method=init" IsPost:NO];
    self.loginKey=nil;
    while (!self.loginKey) {
        [self performSelectorOnMainThread:@selector(getLoginKeyValueLock) withObject:nil waitUntilDone:YES];
        if(!self.loginKey)
        {
            [self addLog:@"获取加密字段错误"];
        }
    }
    NSImage *image=nil;
    while (!image) {
    image = [self getImageWithUrl:HOST_URL@"/otsweb/passCodeNewAction.do?module=login&rand=sjrand" refUrl:HOST_URL@"/otsweb/loginAction.do?method=init"];
        if(!image)
        {
            [self addLog:@"获取验证码错误,重新获取!"];
            sleep(3);
        }
    }
    [self performSelectorOnMainThread:@selector(setLoginImgCode:) withObject:image waitUntilDone:YES];
    
}
-(void) getLoginImgCode
{
    [NSThread detachNewThreadSelector:@selector(getLoginImgCodeLock) toTarget:self withObject:nil];

}
- (NSImage *) getImageWithUrl:(NSString *)url refUrl:(NSString *)refUrl
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url ] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    
    [request setValue:refUrl forHTTPHeaderField:@"Referer"];
    NSData * data=[M12306URLConnection sendSynchronousRequest:request];
    NSImage* image = [[NSImage alloc]initWithData:data];

    return image;
}
-(NSString *)getLoginKey
{
    NSString * html=[self getText:HOST_URL@"/otsweb/loginAction.do?method=init" IsPost:NO];
    NSString *html_keyWard = @"/otsweb/dynamicJsAction.do?jsversion=";
    NSRange htmlR1=[html rangeOfString:html_keyWard];
    if(htmlR1.location!=NSNotFound)
    {
        NSRange htmlR;
        htmlR.location=htmlR1.location+html_keyWard.length;
        htmlR.length=25;
        
        NSRange htmlR2 = [html rangeOfString:@"&method=loginJs" options:0 range:htmlR];
        
        unsigned long length = htmlR2.location-htmlR.location;
        htmlR.length=length;
        NSString * version=[html substringWithRange:htmlR];
        
        NSString * str = [self getText:[NSString stringWithFormat:HOST_URL@"/otsweb/dynamicJsAction.do?jsversion=%@&method=loginJs",version] IsPost:NO];
        if([str rangeOfString:@"function(){var dobj=new Object()"].location!=NSNotFound)
        {
            [self getText:HOST_URL@"/otsweb/loginAction.do?method=el" IsPost:YES];
        }
        NSString *keyword =@"gc(){var key='";
        NSRange range=[str rangeOfString:keyword];
        if(range.location!=NSNotFound)
        {
            
            NSRange range1;
            range1.location=range.location+keyword.length;
            range1.length=12;
            return  [str substringWithRange:range1];
        }
    }
 
    return nil;
}
-(NSString *)getEncValue:(NSString *)key
{
    NSString * str=[NSString stringWithFormat:@"myenc('%@')",key];
   return [self.webview stringByEvaluatingJavaScriptFromString:str];
}
-(void)getLoginKeyValueLock
{
    self.loginKey = [self getLoginKey];
    self.loginValue = [self getEncValue:self.loginKey];
    
//    self.loginKey = @"tem";
//    self.loginValue = @"tem";
    
}

-(NSString *)getQueryKey
{
    NSString * html=[self getText:HOST_URL@"/otsweb/order/querySingleAction.do?method=init" IsPost:NO];
    NSString *html_keyWard = @"/otsweb/dynamicJsAction.do?jsversion=";
    NSRange htmlR1=[html rangeOfString:html_keyWard];
    if(htmlR1.location!=NSNotFound)
    {
        NSRange htmlR;
        htmlR.location=htmlR1.location+html_keyWard.length;
        htmlR.length=25;
        
        NSRange htmlR2 = [html rangeOfString:@"&method=queryJs" options:0 range:htmlR];
        
        unsigned long length = htmlR2.location-htmlR.location;
        htmlR.length=length;
        NSString * version=[html substringWithRange:htmlR];
        
        NSString * str = [self getText:[NSString stringWithFormat:HOST_URL@"/otsweb/dynamicJsAction.do?jsversion=%@&method=queryJs",version] IsPost:NO];
        if([str rangeOfString:@"function(){var dobj=new Object()"].location!=NSNotFound)
        {
            [self getText:HOST_URL@"/otsweb/trainQueryAppAction.do?method=kp" IsPost:YES];
        }
        NSString *keyword =@"gc(){var key='";
        NSRange range=[str rangeOfString:keyword];
        if(range.location!=NSNotFound)
        {
            
            NSRange range1;
            range1.location=range.location+keyword.length;
            range1.length=12;
            return  [str substringWithRange:range1];
        }
    }
    
    return nil;
}

-(void)getQueryKeyValueLock
{
    self.queryKey = [self getQueryKey];
    self.queryValue = [self getEncValue:self.queryKey];

}


- (IBAction)btnLoginClick:(id)sender {

    [self login];
}

- (void)txtImgLoginCodeAction{
    if([self.txtImgcode.stringValue isEqualToString:@" "])
    {
        [self getLoginImgCode];
    }
    else if([self.txtImgcode.stringValue length]==4)
    {
        [self login];
    }
}
- (void)delayLoginLock
{
    
    sleep(2);
    [self loginLock];
}
- (void)delayLogin
{
    [NSThread detachNewThreadSelector:@selector(delayLoginLock) toTarget:self withObject:nil];
}
- (void)reLoginMainThread
{
    [self addLog:@"已不在线"];
    self.lblLoginMsg.stringValue=@"【未登录】";
    self.isLogin=NO;
    [self login];
}
- (void)reLogin
{
    [self performSelectorOnMainThread:@selector(reLoginMainThread) withObject:nil waitUntilDone:YES];
}
- (void)login
{
    NSMutableArray *sd = [self.savedDate mutableCopy];
    [sd setValue:self.txtUsername.stringValue forKey:@"username"];
    [sd setValue:self.txtPassword.stringValue forKey:@"password"];
    self.savedDate=(NSDictionary *)sd;
    [NSThread detachNewThreadSelector:@selector(loginLock) toTarget:self withObject:nil];
}
- (void)loginLock
{
    [self addLog:@"开始登录"];
    M12306Form * form =[[M12306Form alloc]initWithActionURL:HOST_URL@"/otsweb/loginAction.do?method=login"];
    [self setYuanshiForFile:@"loginform" forFrom:form];

    while (YES){
        NSData * data = [self getData:HOST_URL@"/otsweb/loginAction.do?method=loginAysnSuggest" IsPost:YES];
        if(data!=nil)
        {
            NSDictionary* items= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if( [(NSString *)[items objectForKey:@"randError"] isEqualToString:@"Y" ])
            {
                [form setTagValue:[items objectForKey:@"loginRand"] forKey:@"loginRand"];
                break;
            }
        }
        [self addLog:@"获取TOKEN错误，重新获取"];
    }

    [form setTagValue:self.txtUsername.stringValue forKey:@"loginUser.user_name"];
    [form setTagValue:self.txtPassword.stringValue forKey:@"user.password"];
    [form setTagValue:self.txtImgcode.stringValue forKey:@"randCode"];
   
    [form setTagValue:self.loginValue  forKey:self.loginKey];
    
    form.referer=HOST_URL@"/otsweb/loginAction.do?method=init";
    NSString * outs= [form post];
    [self performSelectorOnMainThread:@selector(loginDidResult:) withObject:outs waitUntilDone:YES];
}
- (void)loginDidResult:(NSString *)strresult
{
    BOOL error = NO;
    NSString* errormsg =nil;
    if ([strresult rangeOfString:@"请输入正确的验证码"].location!=NSNotFound)
    {
        errormsg = @"验证错误";
        
        [self getLoginImgCode];
        error = YES;
    }
    else if ([strresult rangeOfString:@"密码输入错误"].location!=NSNotFound)
    {
        NSMutableArray * mathcStrs = [NSMutableArray array];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\"(密码输入错误.*?)\"" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
        [regex enumerateMatchesInString:strresult options:0 range:NSMakeRange(0, strresult.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
        {
            if([result numberOfRanges]>0)
            {
             [mathcStrs addObject: [strresult substringWithRange:[result rangeAtIndex:1]]];
            }
        } ];
        
        if (mathcStrs.count>0)
        {
            errormsg = [mathcStrs objectAtIndex:0];
        }
        else
        {
            errormsg = @"密码输入错误";
        }
        //setTextAndFocus(txtPassword, "");
        [self.txtPassword becomeFirstResponder];
        error = YES;
    }
    else if ([strresult rangeOfString:@"您的用户已经被锁定"].location!=NSNotFound)
    {
        NSMutableArray * mathcStrs = [NSMutableArray array];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\"(您的用户已经被锁定.*?)\"" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    
        [regex enumerateMatchesInString:strresult options:0 range:NSMakeRange(0, strresult.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if([result numberOfRanges]>0)
            {
                [mathcStrs addObject: [strresult substringWithRange:[result rangeAtIndex:1]]];
            }
            
        }];
        if (mathcStrs.count>0)
        {
            errormsg = [mathcStrs objectAtIndex:0];
        }
        else
        {
            errormsg = @"您的用户已经被锁定";
        }
        [self.txtPassword becomeFirstResponder];
        error = YES;
    }
    else if ([strresult rangeOfString:@"登录名不存在"].location!=NSNotFound)
    {
        self.txtPassword.stringValue=@"";
        self.txtUsername.stringValue=@"";
        [self.txtUsername becomeFirstResponder];
    
        errormsg = @"登录名不存在";
        error = YES;
    }
    else if ([strresult rangeOfString:@"系统维护中"].location!=NSNotFound)
    {
        errormsg = @"系统维护中";
        error = YES;
    }
    if ([strresult rangeOfString:@"我的订单"].location!=NSNotFound)
    {
        [self addLog:@"登录成功"];
        self.isLogin = YES;
        NSMutableArray * mathcStrs = [NSMutableArray array];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"u_name = '(.*?)'" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
        
        [regex enumerateMatchesInString:strresult options:0 range:NSMakeRange(0, strresult.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if([result numberOfRanges]>0)
            {
                [mathcStrs addObject: [strresult substringWithRange:[result rangeAtIndex:1]]];
            }
            
        }];
        
        if (mathcStrs.count>0)
        {
            //setLable(lblLoginError, "【" + m.Groups[1].Value + "】已登录");
            self.lblLoginMsg.stringValue=[NSString stringWithFormat:@"【%@】已登录",[mathcStrs objectAtIndex:0]];
        }
        else
        {
            self.lblLoginMsg.stringValue=@"登录成功";
        }
        //[self getCommitImgCode];
        //getPassenger();
        [self getPassenger];
        [self resetQuerKey];
    }
    else
    {
        if (error)
        {
            
            [self addLog:errormsg];
            self.lblLoginMsg.stringValue=errormsg;
            //setLable(lblLoginError, errormsg);
        }
        else
        {
            NSLog(@"%@",strresult);
            [self addLog:@"登录失败，重新登录"];
            [self delayLogin];
        }
    }
}
-(void)setPassenger
{
    self.tablePassenger.data=self.allPassengers;
    NSArray * array =[self.savedDate objectForKey:@"selectedpassenger"];
    [self.tablePassenger initSelected:array];
    [self.tablePassenger reloadData];
    
    [self addLog:@"联系人加载完成。"];
}

-(void)getPassengerLock
{
    [self addLog:@"初始化常用联系人..."];
    NSData*  tem1 = nil;
    NSDictionary * json;
    while (true)
    {
        tem1 = [self getData:HOST_URL@"/otsweb/order/confirmPassengerAction.do?method=getpassengerJson" IsPost:YES];
        if (tem1 == nil)
        {
            [self addLog:@"初始化常用联系人错误，稍候重试"];
            usleep(500*1000);
            continue;
        }
        NSLog(@"%@",[[NSString alloc] initWithData:tem1 encoding:NSUTF8StringEncoding]);
        json = [NSJSONSerialization JSONObjectWithData:tem1 options:kNilOptions error:nil];
   
    
        if(!json)
        {
            [self addLog:@"初始化常用联系人错误，稍候重试"];
            usleep(500*1000);
            continue;
        }
        break;
    }
    NSArray *jsonPassengersArray=[json objectForKey:@"passengerJson"];
    NSMutableArray * tempassenger=[NSMutableArray array];
    for (int i=0; i<[jsonPassengersArray count ]; i++) {
        NSDictionary *p=[jsonPassengersArray objectAtIndex:i];
        M12306passengerTicketItem * item =[[M12306passengerTicketItem alloc]init];
        item.Cardno=[p objectForKey:@"passenger_id_no"];
        item.Cardtype=[p objectForKey:@"passenger_id_type_code"];
        item.Mobileno=[p objectForKey:@"mobile_no"];
        item.Name=[p objectForKey:@"passenger_name"];
        item.Ticket=[p objectForKey:@"passenger_type"];
        [tempassenger addObject:item];
    }
    self.allPassengers=[tempassenger copy];
    [self performSelectorOnMainThread:@selector(setPassenger) withObject:nil waitUntilDone:YES];
//    {
//        passengerTicketItem item = new passengerTicketItem(0);
//        item.Cardno = p["passenger_id_no"].ToString();
//        item.Cardtype = p["passenger_id_type_code"].ToString();
//        item.Mobileno = p["mobile_no"].ToString();
//        item.Name = p["passenger_name"].ToString();
//        item.Ticket = p["passenger_type"].ToString();
//        allPassengers.Add(item);
//        
//    }
//    AddPassengerToList();
}
- (void)getPassenger
{
    [NSThread detachNewThreadSelector:@selector(getPassengerLock) toTarget:self withObject:nil];
}
//- (void)setYuanshi:(NSString *)yuanshistrkey forFrom:(M12306Form *)form
//{
//    NSString *resPath= [[NSBundle mainBundle]pathForResource:@"string" ofType:@"plist"];
//    NSString * value =[[[NSDictionary alloc] initWithContentsOfFile:resPath] objectForKey:yuanshistrkey];
//    NSArray * lines = [value componentsSeparatedByString:@"|"];
//    for (int i=0; i<[lines count]; i++) {
//        NSArray * kv =[[lines objectAtIndex:i]componentsSeparatedByString:@"#"];
//        [form setTagValue:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
//    }
//    
//}

- (void)setYuanshiForFile:(NSString *)filename forFrom:(M12306Form *)form
{
    NSString *resPath= [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:filename];
    NSString * value = [NSString stringWithContentsOfFile:resPath encoding:NSUTF8StringEncoding error:nil];
    NSArray * lines = [value componentsSeparatedByString:@"\n"];
    for (int i=0; i<[lines count]; i++) {
        NSArray * kv =[[lines objectAtIndex:i]componentsSeparatedByString:@"="];
        if(kv.count==2)
        {
            [form setTagValue:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
        }
    }
    
}

- (NSData *)getData:(NSString *)url IsPost:(BOOL)isPost
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url ] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    
    [request setValue:url forHTTPHeaderField:@"Referer"];
    //[request setValue:@"application/javascript, */*;q=0.8" forHTTPHeaderField:@"Accept"];
    if(isPost)
    {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[NSMutableData dataWithLength:0]];
    }
    else
    {
        [request setHTTPMethod:@"GET"];
    }
    NSData * data=[M12306URLConnection sendSynchronousRequest:request];
    return data;
}
- (NSString *)getText:(NSString *)url IsPost:(BOOL)isPost
{
    NSData *data = [self getData:url IsPost:isPost];
    return  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
- (id)getJson:(NSString *)url IsPost:(BOOL)isPost
{
    NSData *data = [self getData:url IsPost:isPost];
    return  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
- (void)initSeat
{
    NSArray * seatDataValue=[NSArray arrayWithObjects:  @"二等座",@"一等座",@"商务座",@"特等座",@"高级软卧",@"软卧",@"硬卧",@"软座",@"硬座",@"无座", nil];
    self.seatData = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: @"O",@"M",@"9",@"P",@"6",@"4",@"3",@"2",@"1",@"empty", nil] forKeys:seatDataValue];
    [self.popupSeat addItemsWithTitles:seatDataValue];
    NSString * index=[self.savedDate objectForKey:@"seatindex"];
    if(index!=nil)
    {
        [self.popupSeat selectItemAtIndex:[index intValue]];
    }

}
- (IBAction)popupSeat:(id)sender {
    //NSString * set=[self.popupSeat selectedItem].title;
    //NSString * value=[self.seatData objectForKey:set];
}
-(void)doStationsResult
{
    self.cbxFromStation.data=self.stations;
    self.cbxToStation.data=self.stations;
    [self.cbxToStation reloadData];
    [self.cbxFromStation reloadData];
    NSString * fromstationindex = [self.savedDate objectForKey:@"fromstationindex"];
    NSString *tostationindex = [self.savedDate objectForKey:@"tostationindex"];

    if(fromstationindex!=nil && tostationindex!=nil)
    {
        [self.cbxFromStation selectItemAtIndex:[fromstationindex intValue]];
        [self.cbxToStation selectItemAtIndex:[tostationindex intValue]];
    }

   
    
}
- (void)getStations
{
    NSString * res;
    while (res==nil) {
        res=[self getText:HOST_URL@"/otsweb/js/common/station_name.js" IsPost:YES];
        if (res == nil)
        {
            [self addLog:@"获取车站信息错误，稍候重试"];
            usleep(500*1000);
        }
    }
    NSArray * buffer = [res componentsSeparatedByString:@"|"];
    NSMutableArray *stations=[[NSMutableArray alloc]initWithCapacity:2166];
    for (int i=0; i<buffer.count-5; i+=5) {
        NSString *display=[buffer objectAtIndex:i+1];
        NSString *value=[buffer objectAtIndex:i+2];
        NSString *pinyin=[buffer objectAtIndex:i+3];
        NSDictionary* item =[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:display,value,pinyin, nil] forKeys:[NSArray arrayWithObjects:@"display",@"value",@"pinyin", nil]];
        [stations addObject:item];
    }
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"pinyin" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
    self.stations = [stations sortedArrayUsingDescriptors:sortDescriptors];
    [self performSelectorOnMainThread:@selector(doStationsResult) withObject:nil waitUntilDone:YES];
}

- (IBAction)btnSearchClick:(id)sender {
    if (!self.isLogin) {
        NSAlert * alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"未登录"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
    else if([self.cbxFromStation indexOfSelectedItem]<0)
    {
        NSAlert * alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"未选择出发站"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
    else if([self.cbxToStation indexOfSelectedItem]<0)
    {
        NSAlert * alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"未选择到达站"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
    else
    {
        NSMutableArray *sd = [self.savedDate mutableCopy];
        [sd setValue:[NSString stringWithFormat:@"%ld",self.cbxFromStation.indexOfSelectedItem] forKey:@"fromstationindex"];
        [sd setValue:[NSString stringWithFormat:@"%ld",self.cbxToStation.indexOfSelectedItem] forKey:@"tostationindex"];
        self.savedDate=(NSDictionary *)sd;
        
        self.queryCanRun = YES;
        self.QueryCount = 0;
        [self query:NO];
    }
}
- (void) setQueryResultToTableView
{
    self.dtQuery.data=self.queryResultData;
    [self.dtQuery reloadData];
}
- (void)queryLock:(NSString *)loop
{
    BOOL bLoop=[loop boolValue];
    NSMutableArray *trainList=[NSMutableArray array];
    while (self.queryCanRun)
    {
        [self addLog:[NSString stringWithFormat:@"查询车次：%ld",self.QueryCount]];
        //string date = dtpDate.Value.ToString("yyyy-MM-dd");
        NSDateFormatter * formate=[[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [formate stringFromDate:self.dtpDate.dateValue];
        NSString *search = nil;
        NSString *sessionFrom =[[self.stations objectAtIndex:[self.cbxFromStation indexOfSelectedItem]] objectForKey:@"value"];
        NSString *sessionTo =[[self.stations objectAtIndex:[self.cbxToStation indexOfSelectedItem]] objectForKey:@"value"];
        NSString *url1 = [NSString stringWithFormat:HOST_URL@"/otsweb/order/querySingleAction.do?method=qt&orderRequest.train_date=%@&orderRequest.from_station_telecode=%@&orderRequest.to_station_telecode=%@&orderRequest.train_no=&trainPassType=QB&trainClass=QB%%23D%%23Z%%23T%%23K%%23QT%%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%%3A00--24%%3A00",date,sessionFrom,sessionTo];
        [self getText:url1 IsPost:NO];
        NSString *url = [NSString stringWithFormat:HOST_URL@"/otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=%@&orderRequest.from_station_telecode=%@&orderRequest.to_station_telecode=%@&orderRequest.train_no=&trainPassType=QB&trainClass=QB%%23D%%23Z%%23T%%23K%%23QT%%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%%3A00--24%%3A00",date,sessionFrom,sessionTo];
        NSLog(@"%@",url);
        while (search==nil) {
            search = [self getText:url IsPost:NO];
            if(search==nil)
            {
                usleep(500*1000);
            }
        }
        NSLog(@"%@",search);
        if ([search isEqualToString:@"-10"])		
        {
            [self addLog:@"查询错误"];
            return;
        }
        search=[search stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<.*?>" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
        NSMutableArray * table=[NSMutableArray array];
        NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"onStopHover\\('(.*?)'\\)" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
        NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"getSelected\\('(.*?)'\\)" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
        NSArray *lines=[search componentsSeparatedByString:@"\\n"];
        NSArray *cname =[NSArray arrayWithObjects:@"序号",@"车次",@"发站",@"到站",@"历时",@"商务座",@"特等座",@"一等座",@"二等座",@"高级软卧",@"软卧",@"硬卧",@"软座",@"硬座",@"无座",@"其他",@"购票", nil];
        for (int i=0; i<[lines count]; i++) {
            NSString * line=[lines objectAtIndex:i];
            NSArray *strs=[line componentsSeparatedByString:@","];
            NSMutableDictionary * row=[NSMutableDictionary dictionary];
            for (int j=0; j<[strs count]; j++) {
                
                NSString *item=[strs objectAtIndex:j];
                NSString *itemr =[regex stringByReplacingMatchesInString:item options:0 range:NSMakeRange(0, [item length]) withTemplate:@""];
                [row setValue:itemr forKey:[cname objectAtIndex:j]];
                
                [regex1 enumerateMatchesInString:item options:0 range:NSMakeRange(0, [item length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    if([result numberOfRanges]>0)
                    {
                        NSString* commitstr=[item substringWithRange:[result rangeAtIndex:1]];
                        NSArray *code = [commitstr componentsSeparatedByString:@"#"];
                        [row setValue:[code objectAtIndex:0] forKey:@"train_code"];
                        [row setValue:[code objectAtIndex:1] forKey:@"from_code"];
                        [row setValue:[code objectAtIndex:2] forKey:@"to_code"];
                    }
                }];
                
                [regex2 enumerateMatchesInString:item options:0 range:NSMakeRange(0, [item length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    if([result numberOfRanges]>0)
                    {
                        NSString* str=[item substringWithRange:[result rangeAtIndex:1]];
                        //NSLog(@"%@",str);
                        M12306TrainInfo *info=[[M12306TrainInfo alloc]initWithYuanshi:str];
                        if([info Success:self.txtTrainNameRegx.stringValue])
                        {
                            [trainList addObject:info];
                        }
                        [row setValue:str forKey:@"pass"];
                        [row setValue:@"可预订" forKey:@"has"];
                        
                    }
                }];
            }
            [table addObject:row];
        }
        self.queryResultData=[table copy];
        [self performSelectorOnMainThread:@selector(setQueryResultToTableView) withObject:nil waitUntilDone:NO];
        if(bLoop)
        {
            if([trainList count]>0)
            {
                if(self.queryCanRun)
                {
                    self.currTrainInfo=[trainList objectAtIndex:0];
                    NSString * seatCode=[self.seatData objectForKey:[self.popupSeat selectedItem].title];
                    NSInteger ticketCoun=[self.currTrainInfo TicketCountForSeat:seatCode];
                    NSString *trainName=[self.currTrainInfo TrainName];
                    [self addLog:[NSString stringWithFormat:@"开始预订:%@,余票:%ld",trainName,ticketCoun]];
                    self.queryCanRun=NO;
                    [self yuding:self.currTrainInfo];
                    break;
                }
            }
        }
        if(!bLoop)
            break;
        self.QueryCount++;
        usleep(500*1000);
    }
    
}
-(void)resetQuerKey
{
    self.queryKey=nil;
    for (int i=0; i<20;i++) {
        [self performSelectorOnMainThread:@selector(getQueryKeyValueLock) withObject:nil waitUntilDone:YES];
        if(!self.queryKey)
        {
            [self addLog:@"获取加密字段错误,重新获取"];
            sleep(1);
        }
        else
        {
            break;
        }
    }
}
- (void)yuding:(M12306TrainInfo *)info
{

    M12306Form* yudingForm=[[M12306Form alloc]initWithActionURL:HOST_URL@"/otsweb/order/querySingleAction.do?method=submutOrderRequest"];
    [self setYuanshiForFile:@"yudingform" forFrom:yudingForm];
    NSArray * commsp=[info.Yuanshi componentsSeparatedByString:@"#"];
    NSArray * setField = [NSArray arrayWithObjects:@"station_train_code", @"lishi", @"train_start_time", @"trainno4", @"from_station_telecode", @"to_station_telecode", @"arrive_time", @"from_station_name", @"to_station_name", @"from_station_no", @"to_station_no", @"ypInfoDetail", @"mmStr", @"locationCode", nil];
    for (int i=0; i<[setField count]; i++) {
        [yudingForm setTagValue:[commsp objectAtIndex:i] forKey:[setField objectAtIndex:i]];
    }

    [yudingForm setTagValue:[yudingForm getTagValue:@"from_station_name"] forKey:@"from_station_telecode_name"];

    [yudingForm setTagValue:[yudingForm getTagValue:@"to_station_name"] forKey:@"to_station_telecode_name"];
    [yudingForm setTagValue:[self formatDate:[self.dtpDate dateValue] strFormat:@"yyyy-MM-dd"] forKey:@"train_date"];
    [yudingForm setTagValue:[self formatDate:[self.dtpDate dateValue] strFormat:@"yyyy-MM-dd"] forKey:@"round_train_date"];
    [yudingForm setTagValue:self.queryValue forKey:self.queryKey];
    NSLog(@"%@",yudingForm.debug);
    // NSLog(@"预定*****************************\n%@",[yudingForm debug]);
    NSString * postResult = [yudingForm post];
    //NSLog(@"%@",postResult);
    [self yudingDoResult:postResult];
}
- (void)yudingDoResult:(NSString *)strResult
{
    if([strResult rangeOfString:@"登录名"].location!=NSNotFound)
    {
        [self reLogin];
    }
    else if([strResult rangeOfString:@"系统忙"].location!=NSNotFound)
    {
        if (!self.queryCanRun)
        {
            [self addLog:@"系统忙，稍候重试"];
            sleep(1);
            [self yuding:self.currTrainInfo];
        }
    }
    else
    {
        if (!self.queryCanRun)
        {
            [self getCommitPage];
        }
    }
}
- (void)getCommitPage
{
    [self addLog:@"getCommitPage"];
    NSString *strresult=nil;
    while (strresult==nil) {
        strresult=[self getText:HOST_URL@"/otsweb/order/confirmPassengerAction.do?method=init" IsPost:NO];
        if(strresult==nil)
            usleep(500*1000);
    }
    self.getCommitTime=[NSDate date];
    if([strresult rangeOfString:@"系统忙"].location!=NSNotFound)
    {
        if (!self.queryCanRun)
        {
            [self addLog:@"系统忙,稍候重试"];
        //self.queryCanRun = true;
            sleep(3);
            [self getCommitPage];
        }
    }
    else
    {
       NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<input.*?name=\"leftTicketStr\".*?value=\"(.*?)\".*?/>" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
        [regex enumerateMatchesInString:strresult options:0 range:NSMakeRange(0, [strresult length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            self.lefttick=[strresult substringWithRange:[result rangeAtIndex:1]];
        }];
        
        NSRegularExpression *tokenReg = [NSRegularExpression regularExpressionWithPattern:@"<input.*?name=\"org\\.apache\\.struts\\.taglib\\.html\\.TOKEN\".*?value=\"(.*?)\".*?/>" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
        [tokenReg enumerateMatchesInString:strresult options:0 range:NSMakeRange(0, [strresult length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            self.token=[strresult substringWithRange:[result rangeAtIndex:1]];
        }];

        if (self.lefttick != nil && self.token != nil)
        {
            [self getCommitImgCode];
        }
        else
        {
            [self addLog:@"获取提交页面错误"];
            [self getCommitPage];
        }
    
    }
    
}
- (void)getCommitImgCode
{
    [NSThread detachNewThreadSelector:@selector(getCommitImgCodeLock) toTarget:self withObject:nil];
}
- (void)getCommitImgCodeLock
{
    NSString * url= HOST_URL@"/otsweb/passCodeNewAction.do?module=passenger&rand=randp";
    NSImage * map=nil;
    while (map==nil) {
        map=[self getImageWithUrl:url refUrl:HOST_URL@"/otsweb/order/confirmPassengerAction.do?method=init"];
        if(map==nil)
        {
            [self addLog:@"获取验证码错误,稍候重试!"];
            usleep(500*1000);
        }
    }
    [self performSelectorOnMainThread:@selector(setCommitImgCodeLock:) withObject:map waitUntilDone:YES];
}
- (void)setCommitImgCodeLock:(NSImage *)image
{
    self.imgCommitCode.image=image;
    self.txtCommitCode.stringValue=@"";
    [self.txtCommitCode becomeFirstResponder];
    
}
- (void)txtCommitCodeTextChageAction
{
    if ([self.txtCommitCode.stringValue isEqualToString:@" "])
    {
        [self getCommitImgCode];
    }
    else if ([self.txtCommitCode.stringValue length] == 4)
    {
        if (self.lefttick != nil && self.token !=nil)
        {
            
            NSTimeInterval interval =-[self.getCommitTime timeIntervalSinceNow];
            
            if (interval < COMMIT_DELAY_SECOND)
            {
                if (!self.delayCommitRuning)
                    [NSThread detachNewThreadSelector:@selector(delayCommit) toTarget:self withObject:nil];
            }
            else
            {
                [self commitForLefttick:self.lefttick forToken:self.token forImgCode:self.txtCommitCode.stringValue];
            }
        }
        else
        {
            if (!self.queryCanRun)
            {
                [self getCommitPage];
            }
        }
    }
}
- (void)doLblDelayCommit:(NSString *)str
{
    self.lblDelayCommit.stringValue=str;
}

- (void)delayCommit
{
    self.delayCommitRuning = YES;
    NSTimeInterval interval = COMMIT_DELAY_SECOND + [self.getCommitTime timeIntervalSinceNow];
    while (interval > 0)
    {
        NSString * str = [NSString stringWithFormat:@"%f秒后提交",interval];
        [self performSelectorOnMainThread:@selector(doLblDelayCommit:) withObject:str waitUntilDone:YES];
        usleep(10*1000);
        interval = COMMIT_DELAY_SECOND + [self.getCommitTime timeIntervalSinceNow];
    }
    [self performSelectorOnMainThread:@selector(doLblDelayCommit:) withObject:@"" waitUntilDone:YES];
    [self commitForLefttick:self.lefttick forToken:self.token forImgCode:self.txtCommitCode.stringValue];
}

- (void)commitForLefttick:(NSString *)lefttick forToken:(NSString *)token forImgCode:(NSString *)imgCode
{
    M12306Form *commitForm=[[M12306Form alloc]initWithActionURL:HOST_URL@"/otsweb/order/confirmPassengerAction.do?method=checkOrderInfo"];
    [self setYuanshiForFile:@"commitform" forFrom:commitForm];
    NSString * date=[self formatDate:self.dtpDate.dateValue strFormat:@"yyyy-MM-dd"];
    [commitForm addQueryStringValue:imgCode forKey:@"rand"];
    int selectedPassengerCount=0;
    for (int i=0; i<[self.tablePassenger.data count]; i++) {
        M12306passengerTicketItem * item =[self.tablePassenger.data objectAtIndex:i];
        if(item.state)
        {
            selectedPassengerCount++;
            [self addLog:[item getInfo]];
            [item addToForm:commitForm forIndex:selectedPassengerCount forSeat:[self.seatData objectForKey:[self.popupSeat selectedItem].title]];
        }
    }
    M12306passengerTicketItem *empty=[[M12306passengerTicketItem alloc]init];
    for (; selectedPassengerCount<5; selectedPassengerCount++) {
        [empty addToForm:commitForm forIndex:0 forSeat:nil];
    }
    [self setYuanshiForFile:@"commitform2" forFrom:commitForm];
    
    
    [commitForm setTagValue:date forKey:@"orderRequest.train_date"];
    [commitForm setTagValue:self.currTrainInfo.TrainCode forKey:@"orderRequest.train_no"];
    
    [commitForm setTagValue:self.currTrainInfo.TrainName forKey:@"orderRequest.station_train_code"];
    [commitForm setTagValue:self.currTrainInfo.FromStationCode forKey:@"orderRequest.from_station_telecode"];
    
    [commitForm setTagValue:self.currTrainInfo.TotationCode forKey:@"orderRequest.to_station_telecode"];
    [commitForm setTagValue:self.currTrainInfo.FromStationName forKey:@"orderRequest.from_station_name"];
    [commitForm setTagValue:self.currTrainInfo.ToStationName forKey:@"orderRequest.to_station_name"];
    
    [commitForm setTagValue:self.currTrainInfo.StartTime forKey:@"orderRequest.start_time"];
    [commitForm setTagValue:self.currTrainInfo.ArriveTime forKey:@"orderRequest.end_time"];
    
    [commitForm setTagValue:token forKey:@"org.apache.struts.taglib.html.TOKEN"];
    
    [commitForm setTagValue:lefttick forKey:@"leftTicketStr"];
    
    [commitForm setTagValue:imgCode forKey:@"randCode"];
    NSString * strresult=[commitForm post];
    NSLog(@"%@",strresult);
    [self commitDoResult:strresult];
}
-(void)commitDoResult:(NSString *)strresult
{
    if ([strresult rangeOfString:@"登录名"].location!=NSNotFound)
    {
        self.isLogin=NO;
        [self addLog:@"已不在线，重新登录"];
        [self reLogin];
        
    }
    else if([strresult rangeOfString:@"登录名"].location!=NSNotFound)
    {
        if(!self.queryCanRun)
        {
            [self addLog:@"网络错误，稍候重试"];
            sleep(1);
            [self commitForLefttick:self.lefttick forToken:self.token forImgCode:self.txtCommitCode.stringValue];
        }
        
    }
    NSData *dataResult=[strresult dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:nil];
    NSString *error=[json objectForKey:@"errMsg"];
    NSString *msg=[json objectForKey:@"msg"];
    NSString *checkHuimd=[json objectForKey:@"checkHuimd"];
    NSString *check608=[json objectForKey:@"check608"];
    NSLog(@"%@",strresult);
    //[self addLog:strresult];
  
    if ([checkHuimd isEqualToString:@"Y"] && [check608 isEqualToString:@"Y"]&&[error isEqualToString:@"Y"]) {
        if ([self getTickCount])
        {
            sleep(1);//重点
            [self checkForLefttick:self.lefttick forToken:self.token forImgCode:self.txtCommitCode.stringValue];
        }
        else
        {
            if (!self.queryCanRun)
            {
                sleep(3);
                [self commitForLefttick:self.lefttick forToken:self.token forImgCode:self.txtCommitCode.stringValue];
            }
        }
         
    }
    else
    {
        [self addLog:error];
        [self addLog:msg];
        if ([error rangeOfString:@"验证码"].location!=NSNotFound)
        {
            [self getCommitImgCode];
        }
        else if ([error rangeOfString:@"取消次数过多"].location!=NSNotFound)
        {
            NSAlert * alert=[[NSAlert alloc]init];
            [alert addButtonWithTitle:@"确定"];
            [alert setMessageText:@"取消次数过多，无法购票"];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert runModal];
        }
        else
        {
            if (!self.queryCanRun)
            {
                [self commitForLefttick:self.lefttick forToken:self.token forImgCode:self.txtCommitCode.stringValue];
            }
        }
        
    }
   
}
-(BOOL)getTickCount
{
    NSString * seatCode=[self.seatData objectForKey:[self.popupSeat selectedItem].title];
    NSString * date=[self formatDate:self.dtpDate.dateValue strFormat:@"yyyy-MM-dd"];
    NSString *url=[NSString stringWithFormat:HOST_URL@"/otsweb/order/confirmPassengerAction.do?method=getQueueCount&train_date=%@&train_no=%@&station=%@&seat=%@&from=%@&to=%@&ticket=%@",date,self.currTrainInfo.TrainCode,self.currTrainInfo.TrainName,seatCode,self.currTrainInfo.FromStationCode,self.currTrainInfo.TotationCode,self.lefttick];
    NSDictionary *traincount = nil;
    while (traincount == nil)
    {
        traincount = [self getJson:url IsPost:NO];
        if (traincount == nil)
            usleep(500*1000);
    }
    //[self addLog:[traincount description]];
    int waiteCount = 0;
    NSString *waito=[traincount objectForKey:@"count"];
    NSString *op_2=[traincount objectForKey:@"op_2"];

    if (waito != nil)
    {
        waiteCount = [waito intValue];
    }
    
    [self addLog:[NSString stringWithFormat:@"排队人数：%d",waiteCount]];
    if (op_2!=nil && [op_2 boolValue])
    {
        [self addLog:@"不允许排队，稍候重试"];
        return NO;
    }
    else
    {
        return YES;
    }
}
-(void)checkForLefttick:(NSString *)lefttick forToken:(NSString *)token forImgCode:(NSString *)imgCode
{
    M12306Form *checkForm=[[M12306Form alloc]initWithActionURL:HOST_URL@"/otsweb/order/confirmPassengerAction.do?method=confirmSingleForQueue"];
    [self setYuanshiForFile:@"checkform" forFrom:checkForm];
    NSString * date=[self formatDate:self.dtpDate.dateValue strFormat:@"yyyy-MM-dd"];
    int selectedPassengerCount=0;
    for (int i=0; i<[self.tablePassenger.data count]; i++) {
        M12306passengerTicketItem * item =[self.tablePassenger.data objectAtIndex:i];
        if(item.state)
        {
            selectedPassengerCount++;
            [item addToForm:checkForm forIndex:selectedPassengerCount forSeat:[self.seatData objectForKey:[self.popupSeat selectedItem].title]];
        }
    }
    M12306passengerTicketItem *empty=[[M12306passengerTicketItem alloc]init];
    for (; selectedPassengerCount<5; selectedPassengerCount++) {
        [empty addToForm:checkForm forIndex:0 forSeat:nil];
    }
    [self setYuanshiForFile:@"checkform2" forFrom:checkForm];
    
    
    [checkForm setTagValue:date forKey:@"orderRequest.train_date"];
    [checkForm setTagValue:self.currTrainInfo.TrainCode forKey:@"orderRequest.train_no"];
    
    [checkForm setTagValue:self.currTrainInfo.TrainName forKey:@"orderRequest.station_train_code"];
    [checkForm setTagValue:self.currTrainInfo.FromStationCode forKey:@"orderRequest.from_station_telecode"];
    
    [checkForm setTagValue:self.currTrainInfo.TotationCode forKey:@"orderRequest.to_station_telecode"];
    [checkForm setTagValue:self.currTrainInfo.FromStationName forKey:@"orderRequest.from_station_name"];
    [checkForm setTagValue:self.currTrainInfo.ToStationName forKey:@"orderRequest.to_station_name"];
    
    [checkForm setTagValue:self.currTrainInfo.StartTime forKey:@"orderRequest.start_time"];
    [checkForm setTagValue:self.currTrainInfo.ArriveTime forKey:@"orderRequest.end_time"];
    
    [checkForm setTagValue:token forKey:@"org.apache.struts.taglib.html.TOKEN"];
    
    [checkForm setTagValue:lefttick forKey:@"leftTicketStr"];
    
    [checkForm setTagValue:imgCode forKey:@"randCode"];
    NSString * strresult=[checkForm post];
    NSLog(@"%@",strresult);
    [self checkTickDoResult:strresult];

}
-(void)checkTickDoResult:(NSString *)strresult
{
    if ([strresult rangeOfString:@"登录名"].location!=NSNotFound)
    {
        [self addLog:@"已不在线"];
        [self reLogin];
        return;
    }
    
    
    NSData *dataResult=[strresult dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:nil];
    if (json!=nil) {
        NSString *error=[json objectForKey:@"errMsg"];
        [self addLog:[NSString stringWithFormat:@"check:%@",error]];
        if ([error rangeOfString:@"验证码"].location!=NSNotFound)
        {
            [self getCommitImgCode];
            
        }
        else if ([error rangeOfString:@"非法"].location!=NSNotFound)
        {
            if (!self.queryCanRun)
            {
                sleep(3);
                [self commitForLefttick:self.lefttick forToken:self.token forImgCode:self.txtCommitCode.stringValue];
            }
        }
        else if ([error rangeOfString:@"重复提交"].location!=NSNotFound)
        {
            if (!self.queryCanRun)
            {
                [self addLog:@"##############"];
                [self getCommitPage];
            }
        }
        else if ([error rangeOfString:@"已超过余票数"].location!=NSNotFound)
        {
            if (!self.queryCanRun)
            {
                sleep(3);
                [self commitForLefttick:self.lefttick forToken:self.token forImgCode:self.txtCommitCode.stringValue];
            }
        }
        else if ([error rangeOfString:@"未付款订单"].location!=NSNotFound)
        {
            [self addLog:@"包含未付款订单,快去付款!!!!!!!!!!!!!!"];
        }
        else if ([error isEqualToString:@"Y"])
        {
            [self addLog:@"成功提交订单"];
            [self getOrder];
        }
    }
    else
    {
        if (!self.queryCanRun)
        {
            [self getCommitPage];
        }
    }
}
-(void)getOrder
{
    while (YES)
    {
        NSDictionary* json=[self getJson:HOST_URL@"/otsweb/order/myOrderAction.do?method=queryOrderWaitTime&tourFlag=dc" IsPost:NO];
      
        NSString *oWaiteTime = [json objectForKey:@"waitTime"];
        NSString *oWaiteCount = [json objectForKey:@"waitCount"];
        NSString *oOrderId = [json objectForKey:@"orderId"];
        NSString *msg = [json objectForKey:@"msg"];
        if (oWaiteTime != nil)
        {
            int waiteTime = [oWaiteTime intValue];
            int count = [oWaiteCount intValue];
            int minutes = waiteTime/60;
            int second =waiteTime%60;

            if (waiteTime >= 0)
            {
                NSString * log=[NSString stringWithFormat:@"排队时间：%d分钟%d秒,排队人数：%d",minutes,second,count];
                [self addLog:log];
            }
            else
            {
                if (waiteTime == -1)
                {
                    NSString * log=[NSString stringWithFormat:@"购票成功，订单号：%@.快去付款！",oOrderId];
                    [self addLog:log];
                    
                }
                else if (waiteTime == -2)
                {
                    NSString * log=[NSString stringWithFormat:@"出票失败:%@,重新购票.",msg];
                    [self addLog:log];

                    if (self.queryCanRun)
                    {
                        
                        [self getCommitPage];
                    }
                }
                else if (waiteTime == -3)
                {
                    [self addLog:@"订单已经被取消！"];
                }
                else if (waiteTime == -4)
                {
                    [self addLog:@"正在处理中...."];
                }
                break;
            }
        }
        else
        {
            [self addLog:@"未知状态"];
            break;
        }
        sleep(1);
    }
}

- (IBAction)loginOutClick:(id)sender {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURL *url = [NSURL URLWithString:HOST_URL];
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            
        }
    }
    [self addLog:@"已不在线"];
    self.lblLoginMsg.stringValue=@"【未登录】";
    self.isLogin=NO;
    [self getLoginImgCode];
}
- (void)query:(BOOL) loop
{
    [NSThread detachNewThreadSelector:@selector(queryLock:) toTarget:self withObject:loop?@"YES":@"NO"];
}
- (NSString *)formatDate:(NSDate *)date strFormat:(NSString *)format
{
    NSDateFormatter * dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}
- (IBAction)tablePassengerChange:(id)sender {
    NSArray * array = self.tablePassenger.getSelectedCardNoArray;
    NSMutableArray *sd = [self.savedDate mutableCopy];
    [sd setValue:array forKey:@"selectedpassenger"];
    self.savedDate=(NSDictionary *)sd;
}

- (IBAction)btnStopYudingClick:(id)sender {
    self.QueryCount = 0;
    self.queryCanRun = NO;
}

- (IBAction)btnYudingClick:(id)sender {
    int selectedPassengerCount=0;
    for (int i=0; i<[self.tablePassenger.data count]; i++) {
        M12306passengerTicketItem * item =[self.tablePassenger.data objectAtIndex:i];
        if(item.state)
        {
            selectedPassengerCount++;
        }
    }
    if(selectedPassengerCount==0)
    {
        NSAlert * alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"未选择联系人"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
    else if (!self.isLogin) {
        NSAlert * alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"未登录"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
    else if([self.cbxFromStation indexOfSelectedItem]<0)
    {
        NSAlert * alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"未选择出发站"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
    else if([self.cbxToStation indexOfSelectedItem]<0)
    {
        NSAlert * alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"未选择到达站"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
    else
    {
        NSMutableArray *sd = [self.savedDate mutableCopy];
        [sd setValue:[NSString stringWithFormat:@"%ld",self.cbxFromStation.indexOfSelectedItem] forKey:@"fromstationindex"];
        [sd setValue:[NSString stringWithFormat:@"%ld",self.cbxToStation.indexOfSelectedItem] forKey:@"tostationindex"];
        [sd setValue:self.txtTrainNameRegx.stringValue forKey:@"trainnameregx"];
        [sd setValue:[NSString stringWithFormat:@"%ld",self.popupSeat.indexOfSelectedItem] forKey:@"seatindex"];
        self.savedDate=(NSDictionary *)sd;
        self.queryCanRun = YES;
        self.QueryCount = 0;
        [self query:YES];
    }
}
-(NSDictionary *)savedDate
{
    @synchronized(self)
    {
        if(_savedDate==nil)
        {
            NSString *path= [self storeFilePath];
            NSFileManager *fm =[NSFileManager defaultManager];
            if([fm fileExistsAtPath:path])
            {
                _savedDate =[[NSDictionary alloc] initWithContentsOfFile:path];
            }
            if(_savedDate==nil)
            {
                _savedDate=[NSDictionary dictionary];
            }
        }
        
        return _savedDate;
    }

}
-(void)setSavedDate:(NSDictionary *)savedDate
{
    @synchronized(self)
    {
        _savedDate=savedDate;
        NSString *path= [self storeFilePath];
        NSFileManager *fm =[NSFileManager defaultManager];
        if(![fm fileExistsAtPath:path])
        {
            [fm createFileAtPath:path contents:nil attributes:nil];
        }
        [_savedDate writeToFile:path atomically:YES];
    }
}
-(NSString *)storeFilePath
{
    NSString * path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"store.plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager]createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}
-(NSString *)getResFile:(NSString *)fileName
{
    NSString * path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];;
}
@end
