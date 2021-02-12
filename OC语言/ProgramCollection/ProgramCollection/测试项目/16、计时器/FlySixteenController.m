//
//  FlySeventeenController.m
//  ProgramCollection
//
//  Created by Walg on 2021/2/12.
//  Copyright © 2021 FLY. All rights reserved.
//

#import "FlySixteenController.h"

@interface FlySixteenController ()

@property (nonatomic, strong) CADisplayLink  *  displayLink;

@end


@implementation FlySixteenController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (_displayLink) {
        [_displayLink invalidate];
    }
}

- (void)update:(CADisplayLink *)link {
    
    NSLog(@"%@ %f %f %f", link, link.duration, link.timestamp, link.targetTimestamp);
}

- (void)dealloc {
    
//    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

@end
