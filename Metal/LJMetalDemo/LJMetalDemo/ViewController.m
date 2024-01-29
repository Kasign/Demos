//
//  ViewController.m
//  LJMetalDemo
//
//  Created by Walg on 2024/1/17.
//

#import "ViewController.h"
#import "LJBaseRender.h"
#import "LJTextureRender.h"
#import "LJ3DRotateRender.h"

@interface ViewController ()

@property (nonatomic, strong) LJBaseRender *render;
@property (nonatomic, strong) LJTextureRender *textureRender;
@property (nonatomic, strong) LJ3DRotateRender *rotateRender;
@property (nonatomic, strong) MTKView *mtkView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMTKView];
}

// 初始化MTKView
- (void)setupMTKView {
    
//    self.mtkView.delegate = self.textureRender;
    self.mtkView.delegate = self.rotateRender;
    [self.view insertSubview:self.mtkView atIndex:0];
}

- (MTKView *)mtkView {
    
    if (!_mtkView) {
        _mtkView = [[MTKView alloc] initWithFrame:self.view.bounds device:MTLCreateSystemDefaultDevice()];
    }
    return _mtkView;
}

- (LJTextureRender *)textureRender {
    
    if (!_textureRender) {
        _textureRender = [[LJTextureRender alloc] initWithMetalKitView:self.mtkView superView:self.view];
    }
    return _textureRender;
}

- (LJ3DRotateRender *)rotateRender {
    
    if (!_rotateRender) {
        _rotateRender = [[LJ3DRotateRender alloc] initWithMetalKitView:self.mtkView superView:self.view];
    }
    return _rotateRender;
}



@end
