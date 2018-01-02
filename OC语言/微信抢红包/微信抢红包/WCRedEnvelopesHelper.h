
#import <UIKit/UIKit.h>

@interface WCPayInfoItem: NSObject
- (NSString *)m_nsPayMsgID;
@end
@interface CMessageWrap : NSObject

@property(nonatomic) unsigned int m_uiMessageType; // @synthesize m_uiMessageType;
@property(retain, nonatomic) NSString *m_nsContent; // @synthesize m_nsContent;
@property(nonatomic) long long m_n64MesSvrID; // @synthesize m_n64MesSvrID;
@property(nonatomic) unsigned int m_uiMesLocalID; // @synthesize m_uiMesLocalID;
@property(nonatomic) unsigned int m_uiCreateTime; // @synthesize m_uiCreateTime;
@property(retain, nonatomic) NSString *m_nsFromUsr; // @synthesize m_nsFromUsr;
@property(retain, nonatomic) NSString *m_nsToUsr; // @synthesize m_nsToUsr;

- (WCPayInfoItem *)m_oWCPayInfoItem;
- (id)nativeUrl;

@end

@interface CBaseContact : NSObject

@property(retain, nonatomic) NSString *m_nsAliasName; // @synthesize m_nsAliasName;
@property(retain, nonatomic) NSString *m_nsUsrName; // @synthesize m_nsUsrName;
@property(nonatomic) unsigned int m_uiSex; // @synthesize m_uiSex;
@property(retain, nonatomic) NSString *m_nsHeadImgUrl; // @synthesize m_nsHeadImgUrl;

- (_Bool)isEqualToContact:(id)arg1;

@end

@interface CContact: CBaseContact

@end

@interface CContactMgr: NSObject

- (id)getContactByName:(id)arg1;

@end

@interface MMSessionInfo : NSObject

@property(retain, nonatomic) CMessageWrap *m_msgWrap; // @synthesize m_msgWrap;
@property(retain, nonatomic) CContact *m_contact; // @synthesize m_contact;

@end 

@interface BaseMsgContentViewController : UIViewController
{
	UITableView *m_tableView;
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
- (long long)numberOfSectionsInTableView:(id)arg1;
- (void)tapAppNodeView:(id)arg1;
- (CContact *)getChatContact;

@end

@interface NewMainFrameViewController : UIViewController
{
	UITableView *m_tableView;
}

- (void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2;
- (void)openRedEnvelopes;

@end

@interface UINavigationController (LogicController)

- (void)PushViewController:(id)arg1 animated:(_Bool)arg2;

@end

@interface WCRedEnvelopesReceiveHomeView : UIView

- (void)OnOpenRedEnvelopes;

@end

@interface MMTableView: UITableView

@end

@interface MMUIViewController : UIViewController

@end

@interface MMTableViewInfo : NSObject

- (void)setDelegate:(id)delegate;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (MMTableView *)getTableView;
- (void)clearAllSection;
- (void)addSection:(id)arg1;
- (void)insertSection:(id)arg1 At:(unsigned int)arg2;

@end

@interface MMTableViewSectionInfo : NSObject

+ (id)sectionInfoDefaut;
- (void)addCell:(id)arg1;
- (void)setHeaderView:(UIView *)headerView;
- (void)setFHeaderHeight:(CGFloat)height;

@end

@interface MMTableViewUserInfo : NSObject

- (id)getUserInfoValueForKey:(id)arg1;
- (void)addUserInfoValue:(id)arg1 forKey:(id)arg2;

@end

@interface MMTableViewCellInfo : MMTableViewUserInfo

+ (id)editorCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 margin:(double)arg4 tip:(id)arg5 focus:(_Bool)arg6 autoCorrect:(_Bool)arg7 text:(id)arg8 isFitIpadClassic:(_Bool)arg9;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 accessoryType:(long long)arg4;
+ (id)switchCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 on:(_Bool)arg4;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 rightValue:(id)arg4 accessoryType:(long long)arg5;
+ (id)normalCellForTitle:(id)arg1 rightValue:(id)arg2;
+ (id)urlCellForTitle:(id)arg1 url:(id)arg2;

@end

@interface MMUICommonUtil : NSObject

+ (id)getBarButtonWithTitle:(id)arg1 target:(id)arg2 action:(SEL)arg3 style:(int)arg4 color:(id)arg6;
+ (id)getBarButtonWithImageName:(id)arg1 target:(id)arg2 action:(SEL)arg3 style:(int)arg4 accessibility:(id)arg5 useTemplateMode:(_Bool)arg6;

@end

@interface MMWebViewController : UIViewController

- (id)initWithURL:(NSURL *)url presentModal:(BOOL)presentModal extraInfo:(id)extraInfo delegate:(id)delegate;

@end

@interface WCRedEnvelopesControlData: NSObject

- (void)setM_oSelectedMessageWrap:(CMessageWrap *)msgWrap;

@end

@interface MMServiceCenter 

+ (id)defaultCenter;
- (id)getService:(Class)aClass;

@end

@interface WCRedEnvelopesControlMgr: NSObject 

- (void)startReceiveRedEnvelopesLogic:(UIViewController *)controller Data:(WCRedEnvelopesControlData *)data;

@end

@interface BaseMsgContentLogicController: NSObject

- (id)initWithLocalID:(unsigned int)arg1 CreateTime:(unsigned int)arg2 ContentViewDisshowStatus:(int)arg3;
- (BaseMsgContentViewController *)getViewController;
- (void)setM_contact:(CContact *)contact;
- (void)setM_dicExtraInfo:(id)info;
- (void)onWillEnterRoom;
- (id)getMsgContentViewController;

@end

@interface MemberDataLogic: NSObject

- (id)initWithMemberList:(id)arg1 admin:(id)arg2;

@end

@protocol ContactsDataLogicDelegate <NSObject>
- (_Bool)onFilterContactCandidate:(CContact *)arg1;
- (void)onContactsDataChange;

@optional
- (void)onContactAsynSearchSectionResultChanged:(NSArray *)arg1 sectionTitles:(NSDictionary *)arg2 sectionResults:(NSDictionary *)arg3;
- (void)onContactsDataNeedChange;
@end

@interface ContactsDataLogic: NSObject

- (id)initWithScene:(unsigned int)arg1 delegate:(id)arg2 sort:(_Bool)arg3 extendChatRoom:(_Bool)arg4;
- (id)getChatRoomContacts;

@end

@interface ChatRoomListViewController: UIViewController

- (void)setMemberLogic:(MemberDataLogic *)logic;

@end

@interface LLFilterChatRoomController: ChatRoomListViewController

@end

@interface CAppViewControllerManager: NSObject

+ (UITabBarController *)getTabBarController;

@end
