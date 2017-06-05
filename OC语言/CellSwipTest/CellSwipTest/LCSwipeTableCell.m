//
//  LCTableViewCell.m
//  CellSwipTest
//
//  Created by walg on 16/7/1.
//  Copyright © 2016年 walg. All rights reserved.
//

#import "LCSwipeTableCell.h"

#pragma mark Input Overlay Helper Class
/** Used to capture table input while swipe buttons are visible*/
@interface LCSwipeTableInputOverlay : UIView
@property (nonatomic, weak) LCSwipeTableCell * currentCell;
@end

@implementation LCSwipeTableInputOverlay
//用到
-(id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}
//用到
-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!_currentCell) {
        [self removeFromSuperview];
        return nil;
    }
    CGPoint p = [self convertPoint:point toView:_currentCell];
    if (_currentCell && (_currentCell.hidden || CGRectContainsPoint(_currentCell.bounds, p))) {
        return nil;
    }
    BOOL hide = YES;

    if (hide) {
        [_currentCell hideSwipeAnimated:YES];
    }
    return _currentCell.touchOnDismissSwipe ? nil : self;;
}

@end

#pragma mark Button Container View and transitions

@interface LCSwipeButtonsView : UIView
@property (nonatomic, weak) LCSwipeTableCell * cell;
@property (nonatomic, strong) UIColor * backgroundColorCopy;
@end

@implementation LCSwipeButtonsView
{
    NSArray * _buttons;
    UIView * _container;
    BOOL _fromLeft;
    UIView * _expandedButton;
    UIView * _expandedButtonAnimated;
    UIView * _expansionBackground;
    UIView * _expansionBackgroundAnimated;
    CGRect _expandedButtonBoundsCopy;
    LCSwipeExpansionLayout _expansionLayout;
    CGFloat _expansionOffset;
    BOOL _autoHideExpansion;
}

#pragma mark Layout
//用到
-(instancetype) initWithButtons:(NSArray*) buttonsArray direction:(LCSwipeDirection) direction differentWidth:(BOOL) differentWidth
{
    CGFloat containerWidth = 0;
    CGSize maxSize = CGSizeZero;
    
    for (UIView * button in buttonsArray) {
        containerWidth += button.bounds.size.width;
        maxSize.width = MAX(maxSize.width, button.bounds.size.width);
        maxSize.height = MAX(maxSize.height, button.bounds.size.height);
    }
    if (!differentWidth) {
        containerWidth = maxSize.width * buttonsArray.count;
    }
    
    if (self = [super initWithFrame:CGRectMake(0, 0, containerWidth, maxSize.height)]) {
        _fromLeft = direction == LCSwipeDirectionLeftToRight;
        _container = [[UIView alloc] initWithFrame:self.bounds];
        _container.clipsToBounds = YES;
        _container.backgroundColor = [UIColor clearColor];
        [self addSubview:_container];
        _buttons = _fromLeft ? buttonsArray: [[buttonsArray reverseObjectEnumerator] allObjects];
        for (UIView * button in _buttons) {
//            if ([button isKindOfClass:[UIButton class]]) {
//                UIButton * btn = (UIButton*)button;
//                [btn removeTarget:nil action:@selector(LCButtonClicked:) forControlEvents:UIControlEventTouchUpInside]; //Remove all targets to avoid problems with reused buttons among many cells
//                [btn addTarget:self action:@selector(LCButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            }
            if (!differentWidth) {
                button.frame = CGRectMake(0, 0, maxSize.width, maxSize.height);
            }
            button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [_container insertSubview:button atIndex: _fromLeft ? 0: _container.subviews.count];
        }
        [self resetButtons];
    }
    return self;
}

//用到
-(void) resetButtons
{
    CGFloat offsetX = 0;
    for (UIView * button in _buttons) {
        button.frame = CGRectMake(offsetX, 0, button.bounds.size.width, self.bounds.size.height);
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        offsetX += button.bounds.size.width;
    }
}


//用到
-(void) layoutSubviews
{
    [super layoutSubviews];
        _container.frame = self.bounds;
}
//用到
-(void) transtitionFloatBorder:(CGFloat) t
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat offsetX = 0;
    
    for (UIView *button in _buttons) {
        CGRect frame = button.frame;
        frame.origin.x = _fromLeft ? (selfWidth - frame.size.width - offsetX) * (1.0 - t) + offsetX : offsetX * t;
        button.frame = frame;
        offsetX += frame.size.width;
    }
}


//用到
-(void) transition:(LCSwipeTransition) mode percent:(CGFloat) t
{
   
     [self transtitionFloatBorder:t];
    
    
}

@end

#pragma mark Settings Classes
@implementation LCSwipeSettings
//用到
-(instancetype) init
{
    if (self = [super init]) {
        self.transition = LCSwipeTransitionBorder;
        self.threshold = 0.5;
        self.offset = 0;
        self.keepButtonsSwiped = YES;
        self.enableSwipeBounces = YES;
        self.showAnimation = [[LCSwipeAnimation alloc] init];
        self.hideAnimation = [[LCSwipeAnimation alloc] init];
        self.stretchAnimation = [[LCSwipeAnimation alloc] init];
    }
    return self;
}
@end

@implementation LCSwipeExpansionSettings
//用到
-(instancetype) init
{
    if (self = [super init]) {
        self.buttonIndex = -1;
        self.threshold = 1.3;
        self.animationDuration = 0.2;
        self.triggerAnimation = [[LCSwipeAnimation alloc] init];
    }
    return self;
}
@end

@interface LCSwipeAnimationData : NSObject
@property (nonatomic, assign) CGFloat from;
@property (nonatomic, assign) CGFloat to;
@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval start;
@property (nonatomic, strong) LCSwipeAnimation * animation;

@end

@implementation LCSwipeAnimationData
@end


#pragma mark Easing Functions and LCSwipeAnimation

static inline CGFloat LCEaseLinear(CGFloat t, CGFloat b, CGFloat c) {
    return c*t + b;
}

static inline CGFloat LCEaseInQuad(CGFloat t, CGFloat b, CGFloat c) {
    return c*t*t + b;
}
static inline CGFloat LCEaseOutQuad(CGFloat t, CGFloat b, CGFloat c) {
    return -c*t*(t-2) + b;
}
static inline CGFloat LCEaseInOutQuad(CGFloat t, CGFloat b, CGFloat c) {
    if ((t*=2) < 1) return c/2*t*t + b;
    --t;
    return -c/2 * (t*(t-2) - 1) + b;
}
static inline CGFloat LCEaseInCubic(CGFloat t, CGFloat b, CGFloat c) {
    return c*t*t*t + b;
}
static inline CGFloat LCEaseOutCubic(CGFloat t, CGFloat b, CGFloat c) {
    --t;
    return c*(t*t*t + 1) + b;
}
static inline CGFloat LCEaseInOutCubic(CGFloat t, CGFloat b, CGFloat c) {
    if ((t*=2) < 1) return c/2*t*t*t + b;
    t-=2;
    return c/2*(t*t*t + 2) + b;
}
static inline CGFloat LCEaseOutBounce(CGFloat t, CGFloat b, CGFloat c) {
    if (t < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        t-=(1.5/2.75);
        return c*(7.5625*t*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        t-=(2.25/2.75);
        return c*(7.5625*t*t + .9375) + b;
    } else {
        t-=(2.625/2.75);
        return c*(7.5625*t*t + .984375) + b;
    }
};
static inline CGFloat LCEaseInBounce(CGFloat t, CGFloat b, CGFloat c) {
    return c - LCEaseOutBounce (1.0 -t, 0, c) + b;
};

static inline CGFloat LCEaseInOutBounce(CGFloat t, CGFloat b, CGFloat c) {
    if (t < 0.5) return LCEaseInBounce (t*2, 0, c) * .5 + b;
    return LCEaseOutBounce (1.0 - t*2, 0, c) * .5 + c*.5 + b;
};

@implementation LCSwipeAnimation
//用到
-(instancetype) init {
    if (self = [super init]) {
        _duration = 0.3;
        _easingFunction = LCSwipeEasingFunctionCubicOut;
    }
    return self;
}
//用到
-(CGFloat) value:(CGFloat)elapsed duration:(CGFloat)duration from:(CGFloat)from to:(CGFloat)to
{
    CGFloat t = MIN(elapsed/duration, 1.0f);
    if (t == 1.0) {
        return to; //precise last value
    }
    CGFloat (*easingFunction)(CGFloat t, CGFloat b, CGFloat c) = 0;
    switch (_easingFunction) {
        case LCSwipeEasingFunctionLinear: easingFunction = LCEaseLinear; break;
        case LCSwipeEasingFunctionQuadIn: easingFunction = LCEaseInQuad;;break;
        case LCSwipeEasingFunctionQuadOut: easingFunction = LCEaseOutQuad;;break;
        case LCSwipeEasingFunctionQuadInOut: easingFunction = LCEaseInOutQuad;break;
        case LCSwipeEasingFunctionCubicIn: easingFunction = LCEaseInCubic;break;
        default:
        case LCSwipeEasingFunctionCubicOut: easingFunction = LCEaseOutCubic;break;
        case LCSwipeEasingFunctionCubicInOut: easingFunction = LCEaseInOutCubic;break;
        case LCSwipeEasingFunctionBounceIn: easingFunction = LCEaseInBounce;break;
        case LCSwipeEasingFunctionBounceOut: easingFunction = LCEaseOutBounce;break;
        case LCSwipeEasingFunctionBounceInOut: easingFunction = LCEaseInOutBounce;break;
    }
    return (*easingFunction)(t, from, to - from);
}

@end

#pragma mark LCSwipeTableCell Implementation


@implementation LCSwipeTableCell
{
    UITapGestureRecognizer * _tapRecognizer;
    UIPanGestureRecognizer * _panRecognizer;
    CGPoint _panStartPoint;
    CGFloat _panStartOffset;
    CGFloat _targetOffset;
    
    UIView * _swipeOverlay;
    UIImageView * _swipeView;
  
    LCSwipeButtonsView * _rightView;
    bool _allowSwipeRightToLeft;
    bool _allowSwipeLeftToRight;
    __weak LCSwipeButtonsView * _activeExpansion;
    
    LCSwipeTableInputOverlay * _tableInputOverlay;
    bool _overlayEnabled;
    __weak UITableView * _cachedParentTable;
    UITableViewCellSelectionStyle _previusSelectionStyle;
    NSMutableSet * _previusHiddenViews;
    BOOL _triggerStateChanges;
    
    LCSwipeAnimationData * _animationData;
    void (^_animationCompletion)(BOOL finished);
    CADisplayLink * _displayLink;
    LCSwipeState _firstSwipeState;
}

#pragma mark View creation & layout

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews:YES];
    }
    return self;
}
//用到
-(void) initViews: (BOOL) cleanButtons
{
    if (cleanButtons) {
        
        _rightButtons = [NSArray array];
        
        _rightSwipeSettings = [[LCSwipeSettings alloc] init];
        
        _rightExpansion = [[LCSwipeExpansionSettings alloc] init];
    }
    _animationData = [[LCSwipeAnimationData alloc] init];
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self addGestureRecognizer:_panRecognizer];
    _panRecognizer.delegate = self;
    _activeExpansion = nil;
    _previusHiddenViews = [NSMutableSet set];
    _swipeState = LCSwipeStateNone;
    _triggerStateChanges = YES;
    _allowsSwipeWhenTappingButtons = YES;
    _preservesSelectionStatus = NO;
    _allowsOppositeSwipe = YES;
    _firstSwipeState = LCSwipeStateNone;
    
}
//用到
-(void) cleanViews
{
    [self hideSwipeAnimated:NO];
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    if (_swipeOverlay) {
        [_swipeOverlay removeFromSuperview];
        _swipeOverlay = nil;
    }
   _rightView = nil;
    if (_panRecognizer) {
        _panRecognizer.delegate = nil;
        [self removeGestureRecognizer:_panRecognizer];
        _panRecognizer = nil;
    }
}
-(void) layoutSubviews
{
    [super layoutSubviews];
   
    if (_swipeOverlay) {
        _swipeOverlay.frame = CGRectMake(0, 0, self.bounds.size.width, self.contentView.bounds.size.height);
    }
}

//用到
-(void) createSwipeViewIfNeeded
{
    if (!_swipeOverlay) {
        _swipeOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//        [self fixRegionAndAccesoryViews];
        _swipeOverlay.hidden = YES;
//        _swipeOverlay.backgroundColor = [self backgroundColorForSwipe];//决定滑动时cell是否向左移动
        _swipeOverlay.backgroundColor = [UIColor redColor];
        _swipeOverlay.layer.zPosition = 10; //force render on top of the contentView;
        _swipeView = [[UIImageView alloc] initWithFrame:_swipeOverlay.bounds];
        _swipeView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _swipeView.contentMode = UIViewContentModeCenter;
        _swipeView.clipsToBounds = YES;
        _swipeView.backgroundColor = [UIColor greenColor];
        [_swipeOverlay addSubview:_swipeView];
        [self.contentView addSubview:_swipeOverlay];
    }
    

    if (!_rightView && _rightButtons.count > 0) {
        _rightView = [[LCSwipeButtonsView alloc] initWithButtons:_rightButtons direction:LCSwipeDirectionRightToLeft differentWidth:_allowsButtonsWithDifferentWidth];
        _rightView.cell = self;
        _rightView.frame = CGRectMake(_swipeOverlay.bounds.size.width, _rightSwipeSettings.topMargin+20, _rightView.bounds.size.width, _swipeOverlay.bounds.size.height - _rightSwipeSettings.topMargin - _rightSwipeSettings.bottomMargin-40);
        _rightView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [_swipeOverlay addSubview:_rightView];
    }
}

//用到
- (void) showSwipeOverlayIfNeeded
{
    if (_overlayEnabled) {
        return;
    }
    _overlayEnabled = YES;
    
    if (!_preservesSelectionStatus)
        self.selected = NO;
 
    _swipeOverlay.hidden = NO;

    if (!_allowsMultipleSwipe) {
//        input overlay on the whole table
        UITableView * table = [self parentTable];
        if (_tableInputOverlay) {
            [_tableInputOverlay removeFromSuperview];
        }
        _tableInputOverlay = [[LCSwipeTableInputOverlay alloc] initWithFrame:table.bounds];
        _tableInputOverlay.currentCell = self;
        [table addSubview:_tableInputOverlay];
    }
    
    _previusSelectionStyle = self.selectionStyle;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    _tapRecognizer.cancelsTouchesInView = YES;
    _tapRecognizer.delegate = self;
    [self addGestureRecognizer:_tapRecognizer];
}
//用到
-(void) hideSwipeOverlayIfNeeded
{
    if (!_overlayEnabled) {
        return;
    }
    _overlayEnabled = NO;
    _swipeOverlay.hidden = YES;
    _swipeView.image = nil;

    
    if (_tableInputOverlay) {
        [_tableInputOverlay removeFromSuperview];
        _tableInputOverlay = nil;
    }
    
    self.selectionStyle = _previusSelectionStyle;
    NSArray * selectedRows = self.parentTable.indexPathsForSelectedRows;
    if ([selectedRows containsObject:[self.parentTable indexPathForCell:self]]) {
        self.selected = NO; //Hack: in some iOS versions setting the selected property to YES own isn't enough to force the cell to redraw the chosen selectionStyle
        self.selected = YES;
    }

    
    
    if (_tapRecognizer) {
        [self removeGestureRecognizer:_tapRecognizer];
        _tapRecognizer = nil;
    }
}

//用到
-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.hidden && _swipeOverlay && !_swipeOverlay.hidden) {
        UIView * target = _rightView;
        if (target) {
            CGPoint p = [self convertPoint:point toView:target];
            if (CGRectContainsPoint(target.bounds, p)) {
                return [target hitTest:p withEvent:event];
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

//用到
-(UIColor *) backgroundColorForSwipe
{
    if (_swipeBackgroundColor) {
        return _swipeBackgroundColor; //user defined color
    }
    else if (self.contentView.backgroundColor && ![self.contentView.backgroundColor isEqual:[UIColor clearColor]]) {
        return self.contentView.backgroundColor;
    }
    else if (self.backgroundColor) {
        return self.backgroundColor;
    }
    return [UIColor clearColor];
}
//用到
-(UITableView *) parentTable
{
    if (_cachedParentTable) {
        return _cachedParentTable;
    }
    
    UIView * view = self.superview;
    while(view != nil) {
        if([view isKindOfClass:[UITableView class]]) {
            _cachedParentTable = (UITableView*) view;
        }
        view = view.superview;
    }
    return _cachedParentTable;
}
//用到
-(void) updateState: (LCSwipeState) newState;
{
    if (!_triggerStateChanges || _swipeState == newState) {
        return;
    }
    _swipeState = newState;

}

#pragma mark Swipe Animation
//用到了
- (void)setSwipeOffset:(CGFloat) newOffset;
{
    CGFloat sign =  -1.0;
    LCSwipeButtonsView * activeButton =  _rightView ;
    LCSwipeSettings * activeSetting = _rightSwipeSettings ;
    
    if(activeSetting.enableSwipeBounces) {
        _swipeOffset = newOffset;
    }
    else {
        CGFloat maxOffset = sign * activeButton.bounds.size.width;
        _swipeOffset = sign > 0 ? MIN(newOffset, maxOffset) : MAX(newOffset, maxOffset);
    }
    CGFloat offset = fabs(_swipeOffset);
    
    if (!activeButton || offset == 0) {
      
        if (_rightView)
        [self hideSwipeOverlayIfNeeded];
        _targetOffset = 0;
        [self updateState:LCSwipeStateNone];
        return;
    }
    else {
        [self showSwipeOverlayIfNeeded];
        CGFloat swipeThreshold = activeSetting.threshold;
        BOOL keepButtons = activeSetting.keepButtonsSwiped;
        _targetOffset = keepButtons && offset > activeButton.bounds.size.width * swipeThreshold ? activeButton.bounds.size.width * sign : 0;
    }
    
    BOOL onlyButtons = activeSetting.onlySwipeButtons;
    _swipeView.transform = CGAffineTransformMakeTranslation(onlyButtons ? 0 : _swipeOffset, 0);
    //animate existing buttons
    LCSwipeButtonsView* view =  _rightView;
    LCSwipeSettings* setting =  _rightSwipeSettings;
    LCSwipeExpansionSettings * expansion =  _rightExpansion;
    
    if (view) {
        //buttons view position
        CGFloat translation = MIN(offset, view.bounds.size.width) * sign + setting.offset * sign;
        view.transform = CGAffineTransformMakeTranslation(translation, 0);
        
      
        bool expand = expansion.buttonIndex >= 0 && offset > view.bounds.size.width * expansion.threshold;
        if (expand) {
            
            _targetOffset = expansion.fillOnTrigger ? self.bounds.size.width * sign : 0;
            _activeExpansion = view;
            [self updateState:LCSwipeStateExpandingRightToLeft];
        }
        else {

            _activeExpansion = nil;
            CGFloat t = MIN(1.0f, offset/view.bounds.size.width);
            [view transition:setting.transition percent:t];
            [self updateState: LCSwipeStateSwipingRightToLeft ];
        }
        }
    
}

-(void) hideSwipeAnimated: (BOOL) animated
{

    LCSwipeAnimation * animation = animated ?  _rightSwipeSettings.hideAnimation : nil;
        [self setSwipeOffset:0 animation:animation completion:nil];
}

//动画效果
-(void) animationTick: (CADisplayLink *) timer
{
    if (!_animationData.start) {
        _animationData.start = timer.timestamp;
    }
    CFTimeInterval elapsed = timer.timestamp - _animationData.start;
    bool completed = elapsed >= _animationData.duration;
    if (completed) {
        _triggerStateChanges = YES;
    }
    self.swipeOffset = [_animationData.animation value:elapsed duration:_animationData.duration from:_animationData.from to:_animationData.to];
    
    //call animation completion and invalidate timer
    if (completed){
        [timer invalidate];
        _displayLink = nil;
        if (_animationCompletion) {
            _animationCompletion(YES);
            _animationCompletion = nil;
        }
    }
}

//设置frame
-(void) setSwipeOffset:(CGFloat)offset animation: (LCSwipeAnimation *) animation completion:(void(^)(BOOL finished)) completion
{
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    if (_animationCompletion) { //notify previous animation cancelled
        _animationCompletion(NO);
        _animationCompletion = nil;
    }
    if (offset !=0) {
        [self createSwipeViewIfNeeded];
    }
    
    if (!animation) {
        self.swipeOffset = offset;
        if (completion) {
            completion(YES);
        }
        return;
    }
    
    _animationCompletion = completion;
    _triggerStateChanges = NO;
    _animationData.from = _swipeOffset;
    _animationData.to = offset;
    _animationData.duration = animation.duration;
    _animationData.start = 0;
    _animationData.animation = animation;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationTick:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark Gestures
//用到
-(void) cancelPanGesture
{
    if (_panRecognizer.state != UIGestureRecognizerStateEnded && _panRecognizer.state != UIGestureRecognizerStatePossible) {
        _panRecognizer.enabled = NO;
        _panRecognizer.enabled = YES;
        if (self.swipeOffset) {
            [self hideSwipeAnimated:YES];
        }
    }
}

-(void) tapHandler: (UITapGestureRecognizer *) recognizer
{
        [self hideSwipeAnimated:YES];
    
}
//用到
-(CGFloat) filterSwipe: (CGFloat) offset
{
    bool allowed = offset > 0 ? 0 : _allowSwipeRightToLeft;
    UIView * buttons =  _rightView;
    if (!buttons || ! allowed) {
        offset = 0;
    }
    else if (!_allowsOppositeSwipe && _firstSwipeState == LCSwipeStateSwipingLeftToRight && offset < 0) {
        offset = 0;
    }
    else if (!_allowsOppositeSwipe && _firstSwipeState == LCSwipeStateSwipingRightToLeft && offset > 0 ) {
        offset = 0;
    }
    return offset;
}
//侧滑
-(void) panHandler: (UIPanGestureRecognizer *)gesture
{
    CGPoint current = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (!_preservesSelectionStatus)
            self.highlighted = NO;
        [self createSwipeViewIfNeeded];
        _panStartPoint = current;
        _panStartOffset = _swipeOffset;
        if (_swipeOffset != 0) {
            _firstSwipeState = _swipeOffset > 0 ? LCSwipeStateSwipingLeftToRight : LCSwipeStateSwipingRightToLeft;
        }
        
        if (!_allowsMultipleSwipe) {
            NSArray * cells = [self parentTable].visibleCells;
            for (LCSwipeTableCell * cell in cells) {
                if ([cell isKindOfClass:[LCSwipeTableCell class]] && cell != self) {
                    [cell cancelPanGesture];
                }
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat offset = _panStartOffset + current.x - _panStartPoint.x;
        if (_firstSwipeState == LCSwipeStateNone) {
            _firstSwipeState = offset > 0 ? LCSwipeStateSwipingLeftToRight : LCSwipeStateSwipingRightToLeft;
        }
        self.swipeOffset = [self filterSwipe:offset];
    }
    else {
      
            CGFloat velocity = [_panRecognizer velocityInView:self].x;
            CGFloat inertiaThreshold = 100.0; //points per second
            
          if (velocity < -inertiaThreshold) {
                _targetOffset = _swipeOffset > 0 ? 0 : (_rightView && _rightSwipeSettings.keepButtonsSwiped ? -_rightView.bounds.size.width : _targetOffset);
            }
            _targetOffset = [self filterSwipe:_targetOffset];
            LCSwipeSettings * settings = _swipeOffset > 0 ? nil : _rightSwipeSettings;
            LCSwipeAnimation * animation = nil;
            if (_targetOffset == 0) {
                animation = settings.hideAnimation;
            }
            else if (fabs(_swipeOffset) > fabs(_targetOffset)) {
                animation = settings.stretchAnimation;
            }
            else {
                animation = settings.showAnimation;
            }
            [self setSwipeOffset:_targetOffset animation:animation completion:nil];
        
        _firstSwipeState = LCSwipeStateNone;
    }
}
//用到
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == _panRecognizer) {
        
        if (self.isEditing) {
            return NO; //do not swipe while editing table
        }
        
        CGPoint translation = [_panRecognizer translationInView:self];
        if (fabs(translation.y) > fabs(translation.x)) {
            return NO; // user is scrolling vertically
        }
        if (_swipeView) {
            CGPoint point = [_tapRecognizer locationInView:_swipeView];
            if (!CGRectContainsPoint(_swipeView.bounds, point)) {
                return _allowsSwipeWhenTappingButtons; //user clicked outside the cell or in the buttons area
            }
        }
        
        if (_swipeOffset != 0.0) {
            return YES; //already swiped, don't need to check buttons or canSwipe delegate
        }
        _allowSwipeRightToLeft = _rightButtons.count > 0;
        return  _allowSwipeRightToLeft && translation.x < 0;
    }
    else if (gestureRecognizer == _tapRecognizer) {
        CGPoint point = [_tapRecognizer locationInView:_swipeView];
        return CGRectContainsPoint(_swipeView.bounds, point);
    }
    return YES;
}



@end
