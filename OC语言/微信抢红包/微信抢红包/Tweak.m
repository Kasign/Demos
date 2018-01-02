



#import "WCRedEnvelopesHelper.h"
#import "LLRedEnvelopesMgr.h"
#import "LLSettingController.h"
#import <AVFoundation/AVFoundation.h>

@implementation WCDeviceStepObject

- (unsigned long)m7StepCount{
	if([LLRedEnvelopesMgr shared].isOpenSportHelper){
		return [LLRedEnvelopesMgr shared].wantSportStepCount; // max value is 98800
	} else {
		return   0;
	}
}

@end

@implementation UINavigationController

- (void)PushViewController:(UIViewController *)controller animated:(BOOL)animated{
	UILabel *lbl = [UILabel new];
		lbl.tag = 1111;
		lbl.text = [NSString stringWithFormat:@"%@",self.viewControllers];
		lbl.frame = CGRectMake(10,200,300,200);
		lbl.textColor = [UIColor blueColor];
		lbl.numberOfLines = 0;
		[[UIApplication sharedApplication].keyWindow addSubview:lbl];
	if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].isHongBaoPush && [controller isMemberOfClass:NSClassFromString(@"BaseMsgContentViewController")]) {
		[LLRedEnvelopesMgr shared].isHongBaoPush = NO;
        [[LLRedEnvelopesMgr shared] handleRedEnvelopesPushVC:(BaseMsgContentViewController *)controller]; 
    } else {
    	  ;
    }
}

@end

@implementation UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
	if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView && [viewControllerToPresent isKindOfClass:NSClassFromString(@"MMUINavigationController")]){
		[LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView = NO;
		UINavigationController *navController = (UINavigationController *)viewControllerToPresent;
		if (navController.viewControllers.count > 0){
			if ([navController.viewControllers[0] isKindOfClass:NSClassFromString(@"WCRedEnvelopesRedEnvelopesDetailViewController")]){
				//模态红包详情视图
				return;
			}
		}
	} 
	  ;
}

@end

@implementation CMessageMgr

- (void)MainThreadNotifyToExt:(NSDictionary *)ext{
	  ;
	if([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper){
		CMessageWrap *msgWrap = ext[@"3"];
	    if (msgWrap && msgWrap.m_uiMessageType == 49 && msgWrap.m_n64MesSvrID != [LLRedEnvelopesMgr shared].lastMsgWrap.m_n64MesSvrID){
	        //红包消息
	        [LLRedEnvelopesMgr shared].lastMsgWrap = [LLRedEnvelopesMgr shared].msgWrap;
	        [LLRedEnvelopesMgr shared].msgWrap = msgWrap;
	        [LLRedEnvelopesMgr shared].haveNewRedEnvelopes = YES;
	    }
	}
}

- (void)onNewSyncShowPush:(NSDictionary *)message{
	  ;
	if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].isOpenBackgroundMode && [UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
		//app在后台运行
		CMessageWrap *msgWrap = (CMessageWrap *)message;
	    if (msgWrap && msgWrap.m_uiMessageType == 49 && msgWrap.m_n64MesSvrID != [LLRedEnvelopesMgr shared].lastMsgWrap.m_n64MesSvrID){
	        //红包消息
	        [LLRedEnvelopesMgr shared].lastMsgWrap = [LLRedEnvelopesMgr shared].msgWrap;
	        [LLRedEnvelopesMgr shared].msgWrap = msgWrap;
	        [LLRedEnvelopesMgr shared].haveNewRedEnvelopes = YES;
	        if([LLRedEnvelopesMgr shared].openRedEnvelopesBlock){
	        	[LLRedEnvelopesMgr shared].openRedEnvelopesBlock();
			}
	    }
	}
}

@end

@implementation WCRedEnvelopesReceiveHomeView

- (id)initWithFrame:(CGRect)frame andData:(id)data delegate:(id)delegate{
	WCRedEnvelopesReceiveHomeView *view =   ;
	if([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView){
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([LLRedEnvelopesMgr shared].openRedEnvelopesDelaySecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			//打开红包
        	[view OnOpenRedEnvelopes];
    	});
	    view.hidden = YES;
	}
    return view;
}

- (void)showSuccessOpenAnimation{
	  ;
	if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [UIApplication sharedApplication].applicationState == UIApplicationStateBackground){ 
		[[LLRedEnvelopesMgr shared] successOpenRedEnvelopesNotification];
	}
}

@end

@implementation MMUIWindow

- (void)addSubview:(UIView *)subView{
	if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [subView isKindOfClass:NSClassFromString(@"WCRedEnvelopesReceiveHomeView")] && [LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView){
		//隐藏弹出红包领取完成页面所在window
		((UIView *)self).hidden = YES;
	} else {
		  ;
	}
}

- (void)dealloc{
	if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView){
		[LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView = NO;
	} else {
		  ;
	}
}

@end

@implementation NewMainFrameViewController

- (void)viewDidLoad{
	  ;
	[LLRedEnvelopesMgr shared].openRedEnvelopesBlock = ^{
		if([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].haveNewRedEnvelopes){
			[LLRedEnvelopesMgr shared].haveNewRedEnvelopes = NO;
			[LLRedEnvelopesMgr shared].isHongBaoPush = YES;
			[[LLRedEnvelopesMgr shared] openRedEnvelopes:self];
		}
	};
}

- (void)reloadSessions{
	  ;
	if([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].openRedEnvelopesBlock){
		[LLRedEnvelopesMgr shared].openRedEnvelopesBlock();
	}
}

@end

@implementation WCRedEnvelopesControlLogic

- (void)startLoading{
	if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView){
		//隐藏加载菊花
		//do nothing	
	} else {
		  ;
	}
}

@end

@implementation NewSettingViewController

- (void)reloadTableData{
	  ;
    MMTableViewCellInfo *configCell = [%c(MMTableViewCellInfo) normalCellForSel:@selector(configHandler) target:self title:@"微信助手设置" accessoryType:1];
    MMTableViewSectionInfo *sectionInfo = [%c(MMTableViewSectionInfo) sectionInfoDefaut];
    [sectionInfo addCell:configCell];
    MMTableViewInfo *tableViewInfo = [self valueForKey:@"m_tableViewInfo"];
    [tableViewInfo insertSection:sectionInfo At:0];
    [[tableViewInfo getTableView] reloadData];
}

%new
- (void)configHandler{
    LLSettingController *settingVC = [[LLSettingController alloc] init];
    [((UIViewController *)self).navigationController PushViewController:settingVC animated:YES];
}

@end

@implementation MicroMessengerAppDelegate

- (void)applicationWillEnterForeground:(UIApplication *)application {
	  ;
	[[LLRedEnvelopesMgr shared] reset];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    ;
  [[LLRedEnvelopesMgr shared] enterBackgroundHandler];
}

@end

@implementation MMMsgLogicManager

- (id)GetCurrentLogicController{
	if([LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView && [LLRedEnvelopesMgr shared].logicController){
		return [LLRedEnvelopesMgr shared].logicController;
	} 
	return   ;
}

@end

%subclass LLFilterChatRoomController : ChatRoomListViewController

- (void)viewDidLoad{
	[super viewDidLoad];

}

- (void)setNavigationBar{
    self.title = @"群聊过滤设置";
    
    UIBarButtonItem *saveItem = [NSClassFromString(@"MMUICommonUtil") getBarButtonWithTitle:@"保存" target:self action:@selector(clickSaveItem) style:0 color:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)clickSaveItem{
	
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

@end
