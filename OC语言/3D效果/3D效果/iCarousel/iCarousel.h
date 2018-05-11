//
//  iCarousel.h
//
//  Version 1.8.3
//
//  Created by Nick Lockwood on 01/04/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/iCarousel
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wreserved-id-macro"
#pragma clang diagnostic ignored "-Wobjc-missing-property-synthesis"


#import <Availability.h>
#undef weak_delegate
#undef __weak_delegate
#if __has_feature(objc_arc) && __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


#import <QuartzCore/QuartzCore.h>
#if defined USING_CHAMELEON || defined __IPHONE_OS_VERSION_MAX_ALLOWED
#define ICAROUSEL_IOS
#else
#define ICAROUSEL_MACOS
#endif


#ifdef ICAROUSEL_IOS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
typedef NSView UIView;
#endif


typedef NS_ENUM(NSInteger, iCarouselType)
{
    iCarouselTypeLinear = 0,
    iCarouselTypeRotary,
    iCarouselTypeInvertedRotary,
    iCarouselTypeCylinder,
    iCarouselTypeInvertedCylinder,
    iCarouselTypeWheel,
    iCarouselTypeInvertedWheel,
    iCarouselTypeCoverFlow,
    iCarouselTypeCoverFlow2,
    iCarouselTypeTimeMachine,
    iCarouselTypeInvertedTimeMachine,
    iCarouselTypeCustom
};


/**
 - iCarouselOptionWrap: 一个布尔值，表示滚动条滚动到最后是否环绕。如果您希望carousel到达结束时环绕则返回YES，否则返回 NO.一般来说，循环carousel类型将默认为环绕，而线性转盘类型不会环绕。 不要担心返回类型是浮点值，因为除0.0之外的任何值都将被视为YES。
 - iCarouselOptionShowBackfaces: 对于某些carousel类型，例如 iCarouselTypeCylinder，可以看到某些视图的后侧（默认情况下，iCarouselTypeInvertedCylinder隐藏背面）。如果您希望隐藏后视图，您可以为此选项返回 NO。要重写iCarouselTypeInvertedCylinder的默认背景隐藏，可以返回YES。 此选项也可用于导致视图背面显示的自定义轮播转换。
 - iCarouselOptionOffsetMultiplier: 用户用手指拖动转盘时使用的偏移倍数。它不影响程序滚动或减速速度。对于大多数轮播类型，默认值为1.0，但对于CoverFlow样式的 carousel，默认值为2.0，以补偿其项目间隔更紧密的事实，因此必须进一步拖动以移动相同的距离。
 - iCarouselOptionVisibleItems: 这是一次应该在轮播中可见的视图（包括占位符）的最大数量。这一数量的一半视图将显示在当前所选项目索引的两边。超出该视图的视图在滚动到视图之前将不会被加载。这是考虑到carousel 中大量 item 会对性能产生不好的影响.。iCarousel根据轮播类型选择合适的默认值，如果您希望重写该值可以使用这个属性（例如，自定义的轮播类型）。
 - iCarouselOptionCount: 在 Rotary,Cylinder 和 Wheel 类型中显示的 item 的数量。通常，这是根据轮播中的视图大小和item 的数量自动计算的，但如果要更精确地控制carousel的显示，则可以重写此选项。该属性用于计算 carousel半径，因此另一个选项是直接操作半径。
 - iCarouselOptionArc: Rotary，Cylinder和Wheel 类型的弧线转换（弧度）。通常默认为2 * M_PI（一个完整的圆），但您可以指定较小的值，因此例如，M_PI的值将创建一个半圆或圆柱。该属性用于计算圆盘传送带半径和角度步长，因此另一个选项是直接操作这些值。
 - iCarouselOptionAngle: 旋转，圆柱和轮的半径以像素/点转换。为了可见item显示的数量更好的适应特定的弧度,这个值通常被计算 。您可以操作该值来增加或减少项目间距（以及圆的半径）。
 - iCarouselOptionRadius: Rotary，Cylinder和Wheel之间的每个项目之间的角度步长（以弧度表示）。 在不改变半径的情况下,在 carousel 滚动到最后时改变间隙或使item 交叠。
 - iCarouselOptionTilt: tilt用于CoverFlow，CoverFlow2和TimeMachine的 carousel类型中的非居中项目。 该值应在0.0到1.0的范围内。
 - iCarouselOptionSpacing: 项目视图之间的间距。该值乘以项目宽度（或高度，如果carousel 是垂直的），以获得每个项目之间的总空间，因此值为1.0（默认值）表示视图之间没有空隙（除非视图已经包括填充，因为 他们在许多示例项目中做）。
 - iCarouselOptionFadeMin/iCarouselOptionFadeMax/iCarouselOptionFadeRange: 这三个选项根据它们与当前居中的item的偏移量来控制carousel的视图的淡出。FadeMin是item视图在开始淡入之前可以达到的最小负偏移量。 FadeMax是视图在开始淡化之前可以达到的最大正偏移量。FadeRange是项目可以在开始褪色的点与完全不可见的点之间移动的距离。
 - iCarouselOptionFadeMinAlpha: 透明度
 */
typedef NS_ENUM(NSInteger, iCarouselOption)
{
    iCarouselOptionWrap = 0,
    iCarouselOptionShowBackfaces,
    iCarouselOptionOffsetMultiplier,
    iCarouselOptionVisibleItems,
    iCarouselOptionCount,
    iCarouselOptionArc,
    iCarouselOptionAngle,
    iCarouselOptionRadius,
    iCarouselOptionTilt,
    iCarouselOptionSpacing,
    iCarouselOptionFadeMin,
    iCarouselOptionFadeMax,
    iCarouselOptionFadeRange,
    iCarouselOptionFadeMinAlpha
};


NS_ASSUME_NONNULL_BEGIN

@protocol iCarouselDataSource, iCarouselDelegate;

@interface iCarousel : UIView

@property (nonatomic, weak_delegate) IBOutlet __nullable id<iCarouselDataSource> dataSource;
@property (nonatomic, weak_delegate) IBOutlet __nullable id<iCarouselDelegate> delegate;
@property (nonatomic, assign) iCarouselType type;

/**
 用于调整各种3D轮播视图的透视缩小效果。
 超出此范围的值将产生非常奇怪的结果。
 默认值为-1/500或-0.005。
 */
@property (nonatomic, assign) CGFloat perspective;

/**
 这个率用于carousel被快速轻击时carousel减速率。值越大表示减速越慢。
 默认值是0.95.值应该在 0.0 和 1.0 之间。
 0.0表示:设置为这个值时，carousel被释放时立即停止滚动
 1.0表示:设置为这个值时，carousel继续无限滚动而不减速，直到它到达底部
 */
@property (nonatomic, assign) CGFloat decelerationRate;

/**
 这是当用户用手指轻击carousel时 滚动速度乘数。默认值是1.0.
 */
@property (nonatomic, assign) CGFloat scrollSpeed;

/**
 一个非包裹样式的carousel在超过底部时将弹跳的最大距离。
 这个用itemWidth的倍数来衡量的，
 所以1.0这个值意味着弹跳一整个item的宽度，
 0.5这个值是一个item宽度的一半，以此类推。
 默认值是1.0.
 */
@property (nonatomic, assign) CGFloat bounceDistance;

/**
 使能或者禁止用户滚动carousel。
 如果这个值被设为no，carousel仍然可以以编程方式被滚动。
 */
@property (nonatomic, assign, getter = isScrollEnabled) BOOL scrollEnabled;

/**
 是否支持翻页
 */
@property (nonatomic, assign, getter = isPagingEnabled) BOOL pagingEnabled;

/**
 这个属性切换，不管carousel 是水平展示还是垂直展示的。
 所有内嵌的carousel样式在这两个方向上都可以运行。
 切换到垂直将会改变carousel的布局和屏幕上的切换方向。
 --***--注意，
 自定义的carousel 变换不受这个属性影响，但是，切换手势的方向还是会受影响。
 */
@property (nonatomic, assign, getter = isVertical) BOOL vertical;

/**
 如果打包被使能的话，返回yes，如果不是返回no。
 这个属性是只读的。
 如果你想重写这个默认值，
 实现carousel:valueForOption:withDefault:方法且给iCarouselOptionWrap返回一个值。
 */
@property (nonatomic, readonly, getter = isWrapEnabled) BOOL wrapEnabled;

/**
 设置carousel在超出底部和返回时是否应该弹跳，或者是停止并挂掉。
 --***--注意，
 在carousel样式设置为缠绕样式时或者carouselShouldWrap代理方法返回为yes时，这个属性不起作用。
 */
@property (nonatomic, assign) BOOL bounces;

/**
 这是以itemWidth的整数倍来计算的carousel当前的滚动偏移量，
 这个值，被截取为最接近的整数，是currentItemIndex值。
 当carousel运动中，你可以使用这个值定位其他屏幕的元素。
 这个值也可以被编程方式设置如果你想滚动carousel到一个特定的偏移。
 如果你想禁用内置手势处理并提供自己的实现时，这个可能有用。
 */
@property (nonatomic, assign) CGFloat scrollOffset;

/**
 这是当用户用手指拖动carousel时偏移量的乘数。
 它并不影响编程的滚动和减速的速度。
 对大多数carousel样式这个默认值是1.0，
 但是对CoverFlow-style样式的carousels默认值是2.0，
 来弥补他们的items在空间上更紧凑，
 所以必须拖拽更远来移动相同的距离的事实。
 你不能直接设置这个值，
 但是可以通过实现carouselOffsetMultiplier:代理方法来重写默认值。
 这个应该是滑动一下移动的距离。
 */
@property (nonatomic, readonly) CGFloat offsetMultiplier;

/**
 这个属性用来调整carousel item views相对于carousel中心的边距。
 它的默认值是CGSizeZero，意思是carousel items是居中的。
 改变这个属性的值来移动carousel items而不必改变他们的视觉。
 消失点随着carousel items移动，
 所以，如果你把carousel items移动到下边，
 如果你在carousel上向下看时他就不会出现。
 */
@property (nonatomic, assign) CGSize contentOffset;

/**
 这个属性用来调整相对于carousel items的 用户视点，
 它与调整contentOffset 效果相反。
 如果你向上移动视点，而carousel 显示是向下移动。
 与 contentOffset不同，移动视点也会改变和carousel items有关的视角消失点，
 所以如果你向上移动视点，他就会像你在carousel上向下看一样出现。
 */
@property (nonatomic, assign) CGSize viewpointOffset;

/**
 carousel中 items的数量（只读），要设置他的话，实现 numberOfItemsInCarousel:这个数据源方法。
 --***--注意，
 所有这些item views在一个给定的时间点将会被加载或者可见
 －carousel当它滚动的时候经要求加载item views。
 */
@property (nonatomic, readonly) NSInteger numberOfItems;

/**
 在carousel中展示的占位视图的数量（只读）。
 要设置他，实现一下numberOfPlaceholdersInCarousel:这个数据源方法。
 */
@property (nonatomic, readonly) NSInteger numberOfPlaceholders;

/**
 当前carousel中居中的item 的索引，
 设置这个属性相当于调用scrollToItemAtIndex:animated:方法时将 animated参数设置为no。
 */
@property (nonatomic, assign) NSInteger currentItemIndex;

/**
 当前carousel中居中的item view。
 这个视图的索引与currentItemIndex匹配。
 */
@property (nonatomic, strong, readonly) UIView * __nullable currentItemView;

/**
 一个包含了所有当前加载的和在carousel中可见的item views的索引，
 包括占位视图的数组，这个数组包含NSNumber的对象，他们的整数值与视图的索引匹配。
 这些item views的索引从0开始且与加载视图时数据源传递的索引匹配，
 然而，任何占位视图的索引将是负数或者大于等于numberOfItems。
 数组中的placeholder views 的索引并不等于数据源中使用的占位视图的索引。
 */
@property (nonatomic, strong, readonly) NSArray *indexesForVisibleItems;

/**
 同时显示在屏幕上的carousel itemviews的最大数量（只读）。
 这个属性对执行最优化很重要，且是基于carousel的样式和视图的frame被自动计算的。
 如果你想重写这个默认值，
 实现一下 carousel:valueForOption:withDefault:
 这个代理方法且给iCarouselOptionVisibleItems返回一个值。
 */
@property (nonatomic, readonly) NSInteger numberOfVisibleItems;

/**
 一个存放当前carousel中展示的所有item views的 数组（只读），
 它包括任何可见的占位视图。
 这个数组中视图的索引并不与item的索引匹配，
 然而，这些视图的顺序与visibleItemIndexes数组属性中的顺序匹配，
 你可以通过从visibleItemIndexes 数组中去掉对应的对象来在这个数组中获取一个指定视图的索引
 （或者，你可以仅仅用indexOfItemView:方法，这个会更简单）
 */
@property (nonatomic, strong, readonly) NSArray *visibleItemViews;

/**
 carousel中展示的items的宽度（只读）。
 这是自动从使用carousel:viewForItemAtIndex:reusingView:数据源方法第一个传到carousel中的视图中继承来的。
 你也可以使用carouselItemWidth:代理方法重写这个值，
 这个方法会改变分配给carousel items的空间（但是不会对这些item views重写设置大小或规模）。
 */
@property (nonatomic, readonly) CGFloat itemWidth;

/**
 包含carousel item views的视图。
 你可以增加子视图如果你想用这些carousel items散置这些视图。
 如果你想让一个视图出现在所有carouselitems的前边或者后边，
 你应该直接添加它到iCarousel view本身来替代。
 --***--注意，
 在contentView中视图的顺序是受当app执行时的频率和未标注的变化决定的。
 任何添加到contentView中的视图
 应该将他们的 userInteractionEnabled属性设置为no,
 来防止和iCarousel的触摸时间处理放生冲突。
 */
@property (nonatomic, strong, readonly) UIView *contentView;

/**
 这个属性用于iCarouselTypeCoverFlow2的carousel变换。
 它是被暴露的以便于你可以使用
 carousel:itemTransformForOffset:baseTransform:
 代理方法实现自己的CoverFlow2样式变量。
 */
@property (nonatomic, readonly) CGFloat toggle;

/**
 自动滚动，滚动时间间隔1/60,每次自动滚动的距离，正向右，负向左
 */
@property (nonatomic, assign) CGFloat autoscroll;

/**
 默认情况下，carousel被轻击时会停在一个准确的item边界。
 如果你设置这个值为no，他会自然停止
 然后－如果scrollToItemBoundary被设置为yes－滚回或者向前滚动到最接近的边界
 */
@property (nonatomic, assign) BOOL stopAtItemBoundary;

/**
 默认情况下，不管carousel何时停止移动，
 他会自动滚动到最近的item 边界。
 如果你设置这个属性为no，
 carousel停止后将不会滚动且不管在哪儿他都会停下来，
 即使他不是正好对准当前的索引。
 有一个特例，如果打包效果被禁止且bounces被设置为yes，
 然后，不管这个设置是什么，carousel会自动滚回第一个或者最后一个索引，
 如果它停下来时超出了carousel的底部。
 */
@property (nonatomic, assign) BOOL scrollToItemBoundary;

/**
 如果为yes,carousel将会忽略垂直于carousel方向的切换手势。
 目前，一个水平的carousel，垂直切换将不会被拦截。
 这就意味着你可以获得一个在carouselitem view里的垂直滚动的scrollView切它依然会正确工作。
 默认值为yes。
 */
@property (nonatomic, assign) BOOL ignorePerpendicularSwipes;

/**
 当设置为yes时，
 点击任何在carousel 中的item而不是那个匹配currentItemIndex 的视图，
 将会使平滑动画移动到居中位置。
 点击当前被选中的item将没有效果。默认值是yes。
 */
@property (nonatomic, assign) BOOL centerItemWhenSelected;
@property (nonatomic, readonly, getter = isDragging) BOOL dragging;
@property (nonatomic, readonly, getter = isDecelerating) BOOL decelerating;
@property (nonatomic, readonly, getter = isScrolling) BOOL scrolling;

/**
 这个方法作用与scrollByNumberOfItems:方法一样，
 但是允许你滚动到一个微小数量的items。
 如果你想达到一个非常准确的动画效果时可能有用。
 --***--注意，
 如果scrollToItemBoundary属性被设置为yes，
 在你调用这个方法后carousel无论如何会自动滚动到最近一个item索引。
 */
- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration;

/**
 这个方法工作起来和 scrollToItemAtIndex:方法一样，但是允许你移动到一个微小的偏移。
 如果你想达到一个非常准确的动画效果时这个可能有用。
 --***--注意，
 如果scrollToItemBoundary属性被设置为yes，
 当你调用这个方法之后carousel会自动滚动到最近的item索引。
 */
- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration;

/**
 这个方法允许你使用一个固定的距离滚动carousel，以carousel的item宽度来衡量。
 整数或负数可能由itemCount来具体确定，取决于你希望滚动的方向。
 iCarousel很好的处理了边界问题，
 所以如果你指定了一个大于carousel中items数量的值，
 滚动或者在到达carousel底部时被夹紧（如果打包被禁止），或者无停顿地包裹。
 */
- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;

/*
 这个方法允许你来控制carousel使用 多长时间来滚动到特定的索引。
 */
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;

/*
 这个方法会使carousel居中在一个特定的item，
 立即或者使用一个平滑的动画。
 对于打包的carousels，
 carousel将会自动决定滚动的最短（直线会或者包着的）距离。
 如果你需要控制这个滚动的方向，
 或者想滚动多于一个分辨率，使用scrollByNumberOfItems这个方法。
 */
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

/*
 返回带有指定索引的可见的item视图。
 --***---注意，
 这个索引和carousel的位置有关，
 且不是在visibleItemViews数组中的位置，这可能是不一样的。
 传递一个赋值或者一个大于等于numberOfItems的整数来取回占位视图。
 这个方法只有在是可见视图且情况下才工作，
 且如果这个在指定索引处的视图还没被加载时，
 或者这个索引超出范围时，将返回空。
 */
- (nullable UIView *)itemViewAtIndex:(NSInteger)index;

/*
 这个是carousel中指定item view的索引。
 对item views和placeholder views起作用，
 但是，placeholder view索引并不和数据源中的索引匹配，且有可能是负值。
 （查看上面indexesForVisibleItems属性介绍的细节）。
 这个方法只对可见的item views起作用且对目前没有加载的视图会返回NSNotFound。
 对于一列所有加载的视图，使用visibleItemViews属性。
 */
- (NSInteger)indexOfItemView:(UIView *)view;

/*
 这个方法给你或者是传递的视图或者是包含有作为参数的视图的视图的item索引。
 它通过以传递进来的视图为开始，向上遍历视图层级，直到找到一个itemview并返回他在carousel中的索引。
 如果没有找到当前加载的item view，它会返回NSNotFound。
 这个方法对处理一个item view内嵌的事件控制极其有用。
 它允许你绑定你的在控制器中控制单一行为方法的item，且会找出控制触发相关行为的item。
 你可以看一下在Controls Demo example工程中这个技术的例子。
 */
- (NSInteger)indexOfItemViewOrSubview:(UIView *)view;

/*
 返回以itemWidth整数倍来记的指定的item索引处的偏移量.
 这是用于计算视图变换和alpha的相同值，
 可以用于根据carousel的位置自定义项目视图。
 每当调用carouselDidScroll：delegate方法时，这个值都可以改变。
 */
- (CGFloat)offsetForItemAtIndex:(NSInteger)index;
- (nullable UIView *)itemViewAtPoint:(CGPoint)point;

/*
 这会从carousel移除一个item,剩下的项目将滑过来填补空位。
 --***--注意，
 当该方法被指定时，数据源不会自动更新，
 因此后续调用reloadData将恢复已删除的项目。
 */
- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;

/*
 这将一个项目插入轮播。
 新的item将从数据源中请求，
 因此，在调用此方法之前，请确保已将新项目添加到数据源数据，
 否则将在转盘中获得重复项目或其他奇怪值。
 */
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;

/*
 此方法将重新加载指定的项目视图。
 新项目将从数据源请求。
 如果 animated 参数为YES，则会从旧到新的项目视图交叉淡化，否则会立即交换。
 */
- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated;

/*
 这个方法重新从数据源加载carousel视图并刷新carousel的显示。
 */
- (void)reloadData;

@end


@protocol iCarouselDataSource <NSObject>

/*
 返回carousel中界面的数量
 */
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel;

/*
 返回一个在carousel中要在指定索引处显示的视图，
 reusingView参数的作用就像UIPickerView，
 之前在carousel中展示过的界面被传递到方法中来循环使用。
 如果这个参数不是空，
 你可以设置它的属性并返回它而不是创建一个新的视图实例，这样可以稍改善性能。
 与UITableView不同，这里没有重用id来区分不同的carousel界面类型。
 所以如果你的carousel包含多个不同的视图类型，
 那么每次这个方法被调用的时候，你应该只是忽略这个参数并返回一个新的视图。
 你应该确认carousel:viewForItemAtIndex:reusingView:方法每次被调用时，
 它要么返回重用的视图，要么返回一个新的视图实例而不是保留你自己的循环视图池，
 因为不同的carousel界面索引返回多个相同视图的复制品可能造成显示问题。
 */
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view;

@optional

/*
 返回在carousel中展示的占位视图。
 占位视图用来当carousel中界面太少而不能填满carousel的宽度，
 并且你希望在空白的地方显示一些东西时使用。
 它们随着carousel移动并且像其他carousel界面一样运行，
 但是它们不占numberOfItems数量，且不能被设置为当前选中的界面。
 当打包属性被使能时占位视图被隐藏。占位视图或者显示在carousel界面的任何一方。
 对于n个占位视图，前n/2个界面将会出现在界面视图的左边，下一个n/2个界面会出现在右边。
 你可以有奇数个占位视图，这种情况下carousel会是不对称的。
 */
- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel;

/*
 返回一个视图作为占位符视图。
 工作方式与carousel:viewForItemAtIndex:reusingView:相同.
 reusingView的占位视图存储在单独的池中，用于常规轮播的重用视图，
 因此如果您的占位符视图与项目视图不同，则不会出现问题。
 */
- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(nullable UIView *)view;

@end


@protocol iCarouselDelegate <NSObject>
@optional

/*
 只要carousel开始动画，就会调用此方法。
 在用户滚动carousel后，可以编程或自动触发，因为轮播重新对齐本身。
 */
- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel;

/*
 当carousel结束动画时，会调用此方法
 */
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel;

/*
 无论何时滚动都会调用此方法。
 无论轮播是以编程方式滚动还是通过用户交互来调用它。
 */
- (void)carouselDidScroll:(iCarousel *)carousel;

/*
 当carousel滚动导致currentItemIndex属性更改足够大时，就会调用此方法。
 无论item 的 index 是按程序更新还是通过用户交互来调用。
 */
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel;

/*
 当用户开始拖动carousel，会调用此方法。
 如果用户点击carousel，或者如果carousel以编程方式滚动，则不会触发。
 */
- (void)carouselWillBeginDragging:(iCarousel *)carousel;

/*
 当用户停止拖动轮播时，会调用此方法。
 willDecelerate参数指示carousel是否足够快地行进，
 以便在停止之前需要减速（即当前的索引不一定是它将停止的），或者它将停止在哪里。
 --***--注意，
 即使willDecelerate为NO，轮播仍将自动滚动，直到它完全对准当前索引。
 如果您需要知道何时完全停止移动，请使用carouselDidEndScrollingAnimation委托方法。
 */
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate;

/*
 当 carousel 开始减速时，会调用此方法。
 通常会在 carouselDidEndDragging：willDecelerate：方法之后立即调用，
 如果 willDecelerate为 YES。
 */
- (void)carouselWillBeginDecelerating:(iCarousel *)carousel;

/*
 当carousel完成减速时，会调用此方法，
 您可以理解为此时的currentItemIndex是最终的停止值。
 与以前的版本不同，在大多数情况下，carousel现在将停止在最终的索引位置。
 唯一的例外是启用弹跳的非包装carousel，
 其中，如果最终停止位置超出carousel的终点，则carousel将自动滚动，直到其完全对准结束索引。
 为了向后兼容，carousel将始终调用scrollToItemAtIndex：animated：在完成减速后。
 如果您需要知道carousel全停止移动的时间，请使用carouselDidEndScrollingAnimation委托方法。
 */
- (void)carouselDidEndDecelerating:(iCarousel *)carousel;

/*
 如果用户点击任何轮播项目视图（不包括占位符视图），
 包括当前选定的视图，此方法将触发。
 方法的目的是忽略旋转木马上的轻拍(tap)事件。
 如果返回YES或不实现，则tap将按照正常的方式进行处理，
 而转盘：didSelectItemAtIndex：方法将被调用。
 如果返回NO，轮播将忽略轻拍(tap)事件，它将继续传播到下一视图层级。
 这是防止carousel终止由另一种视图进行处理的轻拍(tap)事件的好方法。
 */
- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index;

/*
 如果用户点击任何轮播项目视图（不包括占位符视图），包括当前选定的视图，此方法将触发。
 如果用户点击当前所选视图中的控件（即作为UIControl的子类的任何视图），此方法将不会触发。
 */
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;

/*
 返回carousel中每个项目的宽度 - 即每个项目视图的间距。
 如果方法未实现，
 则默认为由轮播返回的第一个项目视图的宽度：
 viewForItemAtIndex：reusingView：的dataSource方法。
 如果从carousel返回的视图：viewForItemAtIndex：reusingView：不正确
 （例如，如果视图的大小不同，或者在其背景图像中包含影响其影子的阴影或外部辉光，
 则此方法仅应用于裁剪或填充项目视图 size）
 - 如果你只想放大视图，那么最好使用iCarouselOptionSpacing值。
 */
- (CGFloat)carouselItemWidth:(iCarousel *)carousel;

/*
 此方法可用于为每个carousel视图提供自定义变换。
 offset是视图与传送带中间的距离。
 当前中心的item视图的offset为0.0，右边的offset为1.0，左侧的offset为-1.0，依此类推。
 为了实现线性轮播样式，因此,您只需将offset乘以项宽，并将其用作变换的x值即可。
 仅当轮播类型为iCarouselTypeCustom时，才会调用此方法。
 */
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform;

/*
 此方法用于定制标准carousel的参数类型。
 通过实现这种方法，您可以调整选项，
 例如圆形转盘中显示的项目数量或封面流转盘中的倾斜量，以及转盘是否换行，以及是否应在最终淡出等。
 对于任何选项，您对调整不感满意，只需返回默认值即可。
 这些选项的含义列在下面的iCarouselOption值下。
 在Options Demo中查看该方法的高级用法。
 */
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop

