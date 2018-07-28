//
//  RRFPSBar.m
//
//  Created by Rolandas Razma on 07/03/2013.
//  Copyright 2013 Rolandas Razma. All rights reserved.
//
//

#import "RRFPSBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation RRFPSBar {
    CADisplayLink          *_displayLink;
    NSUInteger              _historyDTLength;
    NSUInteger              _maxHistoryDTLength;
    CFTimeInterval          *_historyDT;
    CFTimeInterval          _displayLinkTickTimeLast;
    CFTimeInterval          _lastUIUpdateTime;
    
    CATextLayer            *_fpsTextLayer;
    CAShapeLayer           *_linesLayer;
    CAShapeLayer           *_chartLayer;
    
    BOOL                    _showsAverage;
}

- (void)dealloc
{
    [_displayLink setPaused:YES];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    free(_historyDT);
}

- (id)init
{
    CGRect frame = [[UIApplication sharedApplication] statusBarFrame];
    if((self = [super initWithFrame:frame])){
        _maxHistoryDTLength = (NSInteger)CGRectGetWidth(self.bounds);
        _historyDT = malloc(sizeof(CFTimeInterval) * _maxHistoryDTLength);
        _historyDTLength        = 0;
        _displayLinkTickTimeLast= CACurrentMediaTime();
        
        [self setWindowLevel: UIWindowLevelStatusBar + 1.0f];
        [self setBackgroundColor:[UIColor blackColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];

        // Track FPS using display link
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
        [_displayLink setPaused:YES];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        // Lines Layer
        _linesLayer = [CAShapeLayer layer];
        [_linesLayer setFrame: self.bounds];
        [_linesLayer setStrokeColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f].CGColor];
        [_linesLayer setContentsScale: [UIScreen mainScreen].scale];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(self.frame.size.width, 0.0f)];
        [path moveToPoint:CGPointMake(0.0f, 10.0f)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, 10.0f)];
        [path closePath];
        
        [_linesLayer setPath:path.CGPath];

        [self.layer addSublayer:_linesLayer];

        // Chart Layer
        _chartLayer = [CAShapeLayer layer];
        [_chartLayer setFrame: self.bounds];
        [_chartLayer setStrokeColor: [UIColor redColor].CGColor];
        [_chartLayer setContentsScale: [UIScreen mainScreen].scale];
        [self.layer addSublayer:_chartLayer];

        // Info Layer
        _fpsTextLayer = [CATextLayer layer];
        [_fpsTextLayer setFrame: CGRectMake(5.0f, self.bounds.size.height - 14.0f, 100.0f, 14.0f)];
        [_fpsTextLayer setFontSize: 12.0f];
        [_fpsTextLayer setForegroundColor: [UIColor redColor].CGColor];
        [_fpsTextLayer setContentsScale: [UIScreen mainScreen].scale];
        [self.layer addSublayer:_fpsTextLayer];
        
        // Draw asynchronously on iOS6+
        if( [_chartLayer respondsToSelector:@selector(setDrawsAsynchronously:)] ){
            [_linesLayer setDrawsAsynchronously:YES];
            [_chartLayer setDrawsAsynchronously:YES];
            [_fpsTextLayer setDrawsAsynchronously:YES];
        }
        
        [self setDesiredChartUpdateInterval: 1.0f /60.0f];
    }
    return self;
}


#pragma mark -
#pragma mark RRFPSBar


+ (RRFPSBar *)sharedInstance
{
    static RRFPSBar *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RRFPSBar alloc] init];
        if([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
        {
            _sharedInstance.rootViewController = [UIViewController new]; // iOS 9 requires rootViewController for any window
        }
    });
    return _sharedInstance;
}

- (void)applicationDidBecomeActiveNotification {
    [_displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification {
    [_displayLink setPaused:YES];
}

- (void)becomeKeyWindow {
    //prevent self to be key window
    [self setHidden: YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setHidden: NO];
    });
}

- (void)displayLinkTick
{
    // Shift up the buffer
    for (NSUInteger i = _historyDTLength; i >= 1; i-- ) {
        _historyDT[i] = _historyDT[i -1];
    }
    
    // Store new state
    _historyDT[0] = _displayLink.timestamp -_displayLinkTickTimeLast;

    // Update length if there is more place
    if ( _historyDTLength < _maxHistoryDTLength - 1)
    {
        _historyDTLength++;
    }
    
    // Store last timestamp
    _displayLinkTickTimeLast = _displayLink.timestamp;
    
    // Update UI
    CFTimeInterval timeSinceLastUIUpdate = _displayLinkTickTimeLast -_lastUIUpdateTime;
    if( _historyDT[0] < 0.1f && timeSinceLastUIUpdate >= _desiredChartUpdateInterval ){
        [self updateChartAndText];
    }
}


- (void)updateChartAndText
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];

    CFTimeInterval maxDT = CGFLOAT_MIN;
    CFTimeInterval avgDT = 0.0f;
        
    for( NSUInteger i=0; i<=_historyDTLength; i++ ){
        maxDT = MAX(maxDT, _historyDT[i]);
        avgDT += _historyDT[i];
        CGFloat fraction =  roundf(1.0f /(float)_historyDT[i]) /60.0f;
        CGFloat y = _chartLayer.frame.size.height -_chartLayer.frame.size.height *fraction;
        y = MAX(0.0f, MIN(_chartLayer.frame.size.height, y));
        [path addLineToPoint:CGPointMake(i +1.0f, y)];
    }
    
    [path addLineToPoint:CGPointMake(_historyDTLength, 0)];

    avgDT /= _historyDTLength;
    _chartLayer.path = path.CGPath;
    
    CFTimeInterval minFPS = roundf(1.0f /(float)maxDT);
    CFTimeInterval avgFPS = roundf(1.0f /(float)avgDT);

    NSString *text;
    if( _showsAverage ) {
        text = [NSString stringWithFormat:@"low: %.f | avg: %.f", minFPS, avgFPS];
    } else {
        text = [NSString stringWithFormat:@"low %.f", minFPS];
    }
    
    [_fpsTextLayer setString: text];
    
    _lastUIUpdateTime = _displayLinkTickTimeLast;
}


@end
