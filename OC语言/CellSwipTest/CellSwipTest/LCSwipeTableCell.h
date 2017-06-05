//
//  LCSwipeTableCell.h
//  CellSwipTest
//
//  Created by walg on 16/7/1.
//  Copyright © 2016年 walg. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 转换形式 */
typedef NS_ENUM(NSInteger, LCSwipeTransition) {
    LCSwipeTransitionBorder = 0,
    LCSwipeTransitionStatic,
    LCSwipeTransitionDrag,
    LCSwipeTransitionClipCenter,
    LCSwipeTransitionRotate3D
};
/** 滑动方向 */
typedef NS_ENUM(NSInteger, LCSwipeDirection) {
    LCSwipeDirectionLeftToRight = 0,
    LCSwipeDirectionRightToLeft
};

/** 滑动状态 */
typedef NS_ENUM(NSInteger, LCSwipeState) {
    LCSwipeStateNone = 0,
    LCSwipeStateSwipingLeftToRight,
    LCSwipeStateSwipingRightToLeft,
    LCSwipeStateExpandingLeftToRight,
    LCSwipeStateExpandingRightToLeft,
};

/** 滑动位置 */
typedef NS_ENUM(NSInteger, LCSwipeExpansionLayout) {
    LCSwipeExpansionLayoutBorder = 0,
    LCSwipeExpansionLayoutCenter
};

/** Swipe Easing Function */
typedef NS_ENUM(NSInteger, LCSwipeEasingFunction) {
    LCSwipeEasingFunctionLinear = 0,
    LCSwipeEasingFunctionQuadIn,
    LCSwipeEasingFunctionQuadOut,
    LCSwipeEasingFunctionQuadInOut,
    LCSwipeEasingFunctionCubicIn,
    LCSwipeEasingFunctionCubicOut,
    LCSwipeEasingFunctionCubicInOut,
    LCSwipeEasingFunctionBounceIn,
    LCSwipeEasingFunctionBounceOut,
    LCSwipeEasingFunctionBounceInOut
};
@interface LCSwipeAnimation : NSObject
/** Animation duration in seconds. Default value 0.3 */
@property (nonatomic, assign) CGFloat duration;
/** Animation easing function. Default value EaseOutBounce */
@property (nonatomic, assign) LCSwipeEasingFunction easingFunction;
/** Override this method to implement custom easing functions */
-(CGFloat) value:(CGFloat) elapsed duration:(CGFloat) duration from:(CGFloat) from to:(CGFloat) to;

@end

/**
 * Swipe settings
 **/
@interface LCSwipeSettings: NSObject
/** Transition used while swiping buttons */
@property (nonatomic, assign) LCSwipeTransition transition;
/** Size proportional threshold to hide/keep the buttons when the user ends swiping. Default value 0.5 */
@property (nonatomic, assign) CGFloat threshold;
/** Optional offset to change the swipe buttons position. Relative to the cell border position. Default value: 0
 ** For example it can be used to avoid cropped buttons when sectionIndexTitlesForTableView is used in the UITableView
 **/
@property (nonatomic, assign) CGFloat offset;
/** Top margin of the buttons relative to the contentView */
@property (nonatomic, assign) CGFloat topMargin;
/** Bottom margin of the buttons relative to the contentView */
@property (nonatomic, assign) CGFloat bottomMargin;

/** Animation settings when the swipe buttons are shown */
@property (nonatomic, strong) LCSwipeAnimation * showAnimation;
/** Animation settings when the swipe buttons are hided */
@property (nonatomic, strong) LCSwipeAnimation * hideAnimation;
/** Animation settings when the cell is stretched from the swipe buttons */
@property (nonatomic, strong) LCSwipeAnimation * stretchAnimation;

/** Property to read or change swipe animation durations. Default value 0.3 */
@property (nonatomic, assign) CGFloat animationDuration DEPRECATED_ATTRIBUTE;

/** If true the buttons are kept swiped when the threshold is reached and the user ends the gesture
 * If false, the buttons are always hidden when the user ends the swipe gesture
 */
@property (nonatomic, assign) BOOL keepButtonsSwiped;

/** If true the table cell is not swiped, just the buttons **/
@property (nonatomic, assign) BOOL onlySwipeButtons;

/** If NO the swipe bounces will be disabled, the swipe motion will stop right after the button */
@property (nonatomic, assign) BOOL enableSwipeBounces;

@end

//设置是否可以滑动删除
@interface LCSwipeExpansionSettings: NSObject

@property (nonatomic, assign) NSInteger buttonIndex;

@property (nonatomic, assign) BOOL fillOnTrigger;

@property (nonatomic, assign) CGFloat threshold;

//@property (nonatomic, strong) UIColor * expansionColor;

//@property (nonatomic, assign) LCSwipeExpansionLayout expansionLayout;
@property (nonatomic, strong) LCSwipeAnimation * triggerAnimation;
@property (nonatomic, assign) CGFloat animationDuration;
@end



@class LCSwipeTableCell;



@interface LCSwipeTableCell : UITableViewCell

@property (nonatomic, strong, readonly) UIView * swipeContentView;

@property (nonatomic, copy) NSArray * rightButtons;

@property (nonatomic, strong) LCSwipeSettings * rightSwipeSettings;

@property (nonatomic, strong) LCSwipeExpansionSettings * rightExpansion;


@property (nonatomic, readonly) LCSwipeState swipeState;

@property (nonatomic, readonly) BOOL isSwipeGestureActive;


@property (nonatomic) BOOL allowsMultipleSwipe;

@property (nonatomic) BOOL allowsButtonsWithDifferentWidth;

@property (nonatomic) BOOL allowsSwipeWhenTappingButtons;

@property (nonatomic) BOOL allowsOppositeSwipe;

@property (nonatomic) BOOL preservesSelectionStatus;
@property (nonatomic) BOOL touchOnDismissSwipe;
@property (nonatomic, strong) UIColor * swipeBackgroundColor;

@property (nonatomic, assign) CGFloat swipeOffset;


-(void) hideSwipeAnimated: (BOOL) animated;
-(void) setSwipeOffset:(CGFloat)offset animation: (LCSwipeAnimation *) animation completion:(void(^)(BOOL finished)) completion;


@end
