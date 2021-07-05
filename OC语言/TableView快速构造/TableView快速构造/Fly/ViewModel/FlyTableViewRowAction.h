//
//  FlyTableRowAction.h
//  TableView快速构造
//
//  Created by Walg on 2021/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FlyRowActionStyle) {
    FlyRowActionStyle_Normal,
    FlyRowActionStyle_Destructive
};

@class FlyTableViewRowAction;
typedef void (^FlyRowActionHandler)(FlyTableViewRowAction *action, __kindof UIView *_Nullable sourceView, void(^completionHandler)(BOOL actionPerformed));


/// FlyRowActionsConfiguration
@interface FlyRowActionsConfiguration : NSObject

+ (instancetype)configurationWithActions:(NSArray<FlyTableViewRowAction *> *)actions;
@property (nonatomic, copy, readonly) NSArray<FlyTableViewRowAction *> *actions;
@property (nonatomic) BOOL performsFirstActionWithFullSwipe; // default NO, set to NO to prevent a full swipe from performing the first action

@end


/// FlyTableViewRowAction
@interface FlyTableViewRowAction : NSObject

+ (instancetype)rowActionWithStyle:(FlyRowActionStyle)style title:(nullable NSString *)title handler:(FlyRowActionHandler)handler;

@property (nonatomic, assign, readonly) FlyRowActionStyle style;
@property (nonatomic, copy, readonly) FlyRowActionHandler handler;
@property (nonatomic, copy, nullable) NSString * title;
@property (nonatomic, copy, nullable) UIColor  * backgroundColor;
@property (nonatomic, copy, nullable) UIImage  * image;
@property (nonatomic, assign) CGFloat   width;

@end

NS_ASSUME_NONNULL_END
