//
//  M12306Document.h
//  My12306
//
//  Created by 范 俊伟 on 13-7-11.
//  Copyright (c) 2013年 fjw. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "M12306URLConnection.h"
#import "M12306TextField.h"
#import "M12306Form.h"
#import "M12306ComboBox.h"
#import "M12306passengerTicketItem.h"
#import "M12306PassengerTableView.h"
#import "M12306QueryTableView.h"
#import "M12306TrainInfo.h"
#import <WebKit/WebKit.h>
#define COMMIT_DELAY_SECOND 5.0
#define HOST_URL @"http://dynamic.12306.cn"
@interface M12306Document : NSDocument
- (IBAction)tablePassengerChange:(id)sender;
- (IBAction)btnStopYudingClick:(id)sender;
- (IBAction)btnYudingClick:(id)sender;
@property (weak) IBOutlet NSImageView *imgCommitCode;
@property (weak) IBOutlet M12306TextField *txtCommitCode;
@property (weak) IBOutlet NSTextField *lblDelayCommit;

@property (weak) IBOutlet NSTextField *txtTrainNameRegx;
@property (weak) IBOutlet M12306QueryTableView *dtQuery;
@property (weak) IBOutlet NSTableView *tableViewQuery;
@property (weak) IBOutlet NSDatePicker *dtpDate;
- (IBAction)btnSearchClick:(id)sender;
@property (weak) IBOutlet NSTextField *lblLoginMsg;
- (IBAction)popupSeat:(id)sender;
@property (weak) IBOutlet NSPopUpButton *popupSeat;
@property (weak) IBOutlet M12306PassengerTableView *tablePassenger;
@property (weak) IBOutlet NSScrollView *txtLogParent;

@property (weak) IBOutlet M12306ComboBox *cbxToStation;
@property (weak) IBOutlet M12306ComboBox *cbxFromStation;
@property (unsafe_unretained) IBOutlet NSTextView *txtLog;
@property (weak) IBOutlet NSTextField *txtUsername;
@property (weak) IBOutlet NSSecureTextField *txtPassword;
@property (weak) IBOutlet NSTextField *txtImgcode;
@property (weak) IBOutlet NSImageView *imgLoginCode;
- (IBAction)btnLoginClick:(id)sender;
- (void)txtImgLoginCodeAction;

@property (strong,nonatomic) NSDictionary *seatData;
@property (strong,nonatomic) NSArray * stations;
@property BOOL isLogin;
@property (strong,nonatomic) NSArray* allPassengers;
@property BOOL queryCanRun;
@property NSInteger QueryCount;
@property NSArray* queryResultData;
@property (strong,nonatomic) M12306TrainInfo * currTrainInfo;
@property (strong,nonatomic) NSDate * getCommitTime;
@property (strong,nonatomic) NSString *lefttick;
@property (strong,nonatomic) NSString *token;
@property BOOL delayCommitRuning;
@property (strong,nonatomic)NSDictionary* savedDate;
@property (weak) IBOutlet WebView *webview;
@property (strong,nonatomic)NSString *loginKey;
@property (strong,nonatomic)NSString *loginValue;

@property (strong,nonatomic)NSString *queryKey;
@property (strong,nonatomic)NSString *queryValue;
- (void) myinit;
- (void) addLog:(NSString *) log;
- (void) addLogLock:(NSString *)log;
- (void) getLoginImgCode;
- (NSImage *) getImageWithUrl:(NSString *)url refUrl:(NSString *)refUrl;
- (void)delayLogin;
- (void)login;
- (void)loginLock;
- (void)reLogin;
- (NSData *)getData:(NSString *)url IsPost:(BOOL)isPost;
- (NSString *)getText:(NSString *)url IsPost:(BOOL)isPost;
- (id)getJson:(NSString *)url IsPost:(BOOL)isPost;
- (void)initSeat;
- (void)getStations;
- (void)loginDidResult:(NSString *)result;
- (void)getPassenger;
- (void)query:(BOOL) loop;
- (NSString *)formatDate:(NSDate *) date strFormat:(NSString *)format;
- (void)yuding:(M12306TrainInfo *)info;
- (void)yudingDoResult:(NSString *)strResult;
- (void)getCommitPage;
- (void)getCommitImgCode;
- (void)getCommitImgCodeLock;
- (void)setCommitImgCodeLock:(NSImage *)image;
-(void)txtCommitCodeTextChageAction;
- (void)delayCommit;
- (void)commitForLefttick:(NSString *)lefttick forToken:(NSString *)token forImgCode:(NSString *)imgCode;
-(void)commitDoResult:(NSString *)strresult;
- (void)checkForLefttick:(NSString *)lefttick forToken:(NSString *)token forImgCode:(NSString *)imgCode;
- (BOOL)getTickCount;
- (void)checkTickDoResult:(NSString *)strresult;
-(void)getOrder;
- (IBAction)loginOutClick:(id)sender;


@end
