//
//  ViewController.m
//  SYKRotateDemo
//
//  Created by Walg on 2021/8/11.
//

#import "ViewController.h"
#import "UIDevice+Rotate.h"
#import "SYKFirstViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIDevice changeRotateSwitch:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    SYKFirstViewController *vc = [[SYKFirstViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
