//
//  LLRedEnvelopesMgr.m
//  test
//
//  Created by fqb on 2017/12/12.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import "LLRedEnvelopesMgr.h"

static NSString * const isOpenRedEnvelopesHelperKey = @"isOpenRedEnvelopesHelperKey";
static NSString * const isOpenSportHelperKey = @"isOpenSportHelperKey";
static NSString * const isOpenBackgroundModeKey = @"isOpenBackgroundModeKey";
static NSString * const isOpenRedEnvelopesAlertKey = @"isOpenRedEnvelopesAlertKey";
static NSString * const openRedEnvelopesDelaySecondKey = @"openRedEnvelopesDelaySecondKey";
static NSString * const wantSportStepCountKey = @"wantSportStepCountKey"; 

@implementation LLRedEnvelopesMgr

+ (LLRedEnvelopesMgr *)shared{
    static LLRedEnvelopesMgr *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LLRedEnvelopesMgr alloc] init];
    });
    return manager;
}

- (id)init{
    if(self = [super init]){
        _isOpenRedEnvelopesHelper = [[NSUserDefaults standardUserDefaults] boolForKey:isOpenRedEnvelopesHelperKey];
        _isOpenSportHelper = [[NSUserDefaults standardUserDefaults] boolForKey:isOpenSportHelperKey];
        _isOpenBackgroundMode = [[NSUserDefaults standardUserDefaults] boolForKey:isOpenBackgroundModeKey];
        _isOpenRedEnvelopesAlert = [[NSUserDefaults standardUserDefaults] boolForKey:isOpenRedEnvelopesAlertKey];
        _openRedEnvelopesDelaySecond = [[NSUserDefaults standardUserDefaults] floatForKey:openRedEnvelopesDelaySecondKey];
        _wantSportStepCount = [[NSUserDefaults standardUserDefaults] integerForKey:wantSportStepCountKey];
    }
    return self;
}

- (void)reset{
    _haveNewRedEnvelopes = NO;
    _isHiddenRedEnvelopesReceiveView = NO;
    _isHongBaoPush = NO;
}

#pragma mark SET GET METHOD

- (void)setHaveNewRedEnvelopes:(BOOL)haveNewRedEnvelopes{
    _haveNewRedEnvelopes = haveNewRedEnvelopes;
}

- (void)setIsHongBaoPush:(BOOL)isHongBaoPush{
    _isHongBaoPush = isHongBaoPush;
}

- (void)setIsHiddenRedEnvelopesReceiveView:(BOOL)isHiddenRedEnvelopesReceiveView{
    _isHiddenRedEnvelopesReceiveView = isHiddenRedEnvelopesReceiveView;
}

- (void)setBgTaskIdentifier:(UIBackgroundTaskIdentifier)bgTaskIdentifier{
    _bgTaskIdentifier = bgTaskIdentifier;
}

- (void)setBgTaskTimer:(NSTimer *)bgTaskTimer{
    _bgTaskTimer = bgTaskTimer;
}

- (void)setOpenRedEnvelopesBlock:(void (^)(void))openRedEnvelopesBlock{
    _openRedEnvelopesBlock = [openRedEnvelopesBlock copy];
}

- (void)setIsOpenRedEnvelopesHelper:(BOOL)isOpenRedEnvelopesHelper{
    _isOpenRedEnvelopesHelper = isOpenRedEnvelopesHelper;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenRedEnvelopesHelper forKey:isOpenRedEnvelopesHelperKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsOpenSportHelper:(BOOL)isOpenSportHelper{
    _isOpenSportHelper = isOpenSportHelper;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenSportHelper forKey:isOpenSportHelperKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsOpenBackgroundMode:(BOOL)isOpenBackgroundMode{
    _isOpenBackgroundMode = isOpenBackgroundMode;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenBackgroundMode forKey:isOpenBackgroundModeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsOpenRedEnvelopesAlert:(BOOL)isOpenRedEnvelopesAlert{
    _isOpenRedEnvelopesAlert = isOpenRedEnvelopesAlert;
    [[NSUserDefaults standardUserDefaults] setBool:isOpenRedEnvelopesAlert forKey:isOpenRedEnvelopesAlertKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOpenRedEnvelopesDelaySecond:(CGFloat)openRedEnvelopesDelaySecond{
    _openRedEnvelopesDelaySecond = openRedEnvelopesDelaySecond;
    [[NSUserDefaults standardUserDefaults] setFloat:openRedEnvelopesDelaySecond forKey:openRedEnvelopesDelaySecondKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setWantSportStepCount:(NSInteger)wantSportStepCount{
    _wantSportStepCount = wantSportStepCount;
    [[NSUserDefaults standardUserDefaults] setInteger:wantSportStepCount forKey:wantSportStepCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark HANDLER METHOD

- (void)openRedEnvelopes:(NewMainFrameViewController *)mainVC{
    NSArray *controllers = mainVC.navigationController.viewControllers;
    UIViewController *msgContentVC = nil;
    for (UIViewController *aController in controllers) {
        if ([aController isMemberOfClass:NSClassFromString(@"BaseMsgContentViewController")]) {
            msgContentVC = aController;
            break;
        }
    }
    if (msgContentVC) {
        [mainVC.navigationController PushViewController:msgContentVC animated:YES];
    } else {
        [mainVC tableView:[mainVC valueForKey:@"m_tableView"] didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
}

- (void)handleRedEnvelopesPushVC:(BaseMsgContentViewController *)baseMsgVC{
    //红包push
    if(![[self.msgWrap nativeUrl] containsString:@"weixin://openNativeUrl/weixinHB/startreceivebizhbrequest?"] && [[self.msgWrap m_oWCPayInfoItem] m_nsPayMsgID].length){
        CContactMgr *contactMgr = [[NSClassFromString(@"MMServiceCenter") defaultCenter] getService:NSClassFromString(@"CContactMgr")];
        CContact *fromContact = [contactMgr getContactByName:self.msgWrap.m_nsFromUsr];
        if(![[baseMsgVC getChatContact] isEqualToContact:fromContact]){
            BaseMsgContentLogicController *logicController = [[NSClassFromString(@"BaseMsgContentLogicController") alloc] initWithLocalID:self.msgWrap.m_uiMesLocalID CreateTime:self.msgWrap.m_uiCreateTime ContentViewDisshowStatus:0x4];
            [logicController setM_contact:fromContact];
            [logicController setM_dicExtraInfo:nil];
            [logicController onWillEnterRoom];
            self.logicController = logicController;
            baseMsgVC = [logicController getMsgContentViewController];
        } else {
            self.logicController = nil;
        }
        WCRedEnvelopesControlData *data = [[NSClassFromString(@"WCRedEnvelopesControlData") alloc] init];
        [data setM_oSelectedMessageWrap:self.msgWrap];
        WCRedEnvelopesControlMgr *controlMgr = [[NSClassFromString(@"MMServiceCenter") defaultCenter] getService:NSClassFromString(@"WCRedEnvelopesControlMgr")];
        //if(baseMsgVC.view){
            self.isHiddenRedEnvelopesReceiveView = YES;
            [controlMgr startReceiveRedEnvelopesLogic:baseMsgVC Data:data];                
        //}
    }
}

- (void)successOpenRedEnvelopesNotification{
    if(self.isOpenRedEnvelopesAlert){
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = @"帮您领了一个大红包！快去查看吧~";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        [self playCashReceivedAudio];
    }
}

//程序进入后台处理
- (void)enterBackgroundHandler{
    if(!self.isOpenBackgroundMode){
        return;
    }
    UIApplication *app = [UIApplication sharedApplication];
    self.bgTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:self.bgTaskIdentifier];
        self.bgTaskIdentifier = UIBackgroundTaskInvalid;
    }];
    self.bgTaskTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(requestMoreTime) userInfo:nil repeats:YES];
    [self.bgTaskTimer fire];
}

- (void)requestMoreTime{
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 30) {
    	[self playBlankAudio];
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskIdentifier];
        self.bgTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskIdentifier];
            self.bgTaskIdentifier = UIBackgroundTaskInvalid;
        }];
    }
}

//播放收到红包音频
- (void)playCashReceivedAudio{
    [self playAudioForResource:@"cash_received" ofType:@"caf"];
}

//播放无声音频
- (void)playBlankAudio{
    [self playAudioForResource:@"blank" ofType:@"caf"];
}

//开始播放音频
- (void)playAudioForResource:(NSString *)resource ofType:(NSString *)ofType{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     withOptions: AVAudioSessionCategoryOptionMixWithOthers
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
    NSURL *blankSoundURL = [[NSURL alloc]initWithString:[[NSBundle mainBundle] pathForResource:resource ofType:ofType]];
    if(blankSoundURL){
        self.blankPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:blankSoundURL error:nil];
        [self.blankPlayer play];
    }
}

@end
