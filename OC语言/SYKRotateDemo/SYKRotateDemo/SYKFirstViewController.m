//
//  SYKFirstViewController.m
//  SYKRotateDemo
//
//  Created by Walg on 2021/8/11.
//

#import "SYKFirstViewController.h"
#import "UIDevice+Rotate.h"

@interface SYKFirstViewController ()

@end

@implementation SYKFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (![UIDevice supportRotate]) {
        [UIDevice changeRotateSwitch:YES];
        NSLog(@"已开启");
    } else {
        [UIDevice changeRotateSwitch:NO];
        NSLog(@"已关闭");
    }
}

- (BOOL)shouldAutorotate {
    
    return [UIDevice supportRotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
