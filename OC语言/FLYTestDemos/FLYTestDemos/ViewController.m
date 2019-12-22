//
//  ViewController.m
//  FLYTestDemos
//
//  Created by Walg on 2019/10/25.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES3/gl.h>

#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES3/glext.h>

@interface ViewController ()

@property (nonatomic, assign) int c;
@property (nonatomic, copy) void(^blockProterty)(void) ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int b = 10;
    void (^block)(int a) = ^(int a) {
        //        NSLog(@"%d", b);
    };
    
    NSArray *arr = [[NSArray alloc] initWithObjects:^{NSLog(@"blk0:%d",b);},
                    ^{NSLog(@"blk1:%d",b);},
                    ^{NSLog(@"blk2:%d",b);},nil];
    
    id blocka = ^(int b) {
        
    };
    
    _blockProterty = ^() {
        NSLog(@"%d", self.c);
    };
    
    NSLog(@"%@", block);
    NSLog(@"%@", _blockProterty);
    NSLog(@"%@", blocka);
    NSLog(@"%@", arr);
    
    void (^blockArr)(void) = arr[1];
    blockArr();
    NSLog(@"%@", blockArr);

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
}

//- (void)getCurrent {
//
////    （1）创建顶点缓存，
//    CGFloat frameWidth = 100;
//    CGFloat frameHeight = 100;
//    GLuint readBuffer;
//    glGenBuffers(1, &readBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, readBuffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * frameWidth * frameHeight * 3, NULL, GL_DYNAMIC_DRAW);
//    glBindBuffer(GL_ARRAY_BUFFER, 0);
////    （2）把帧缓存数据读取到顶点缓冲readBuffer
//    //缓存绑定
//    glBindBuffer(GL_PIXEL_PACK_BUFFER, readBuffer);
//    //输出到readBuffer上
//    glReadPixels(0, 0, frameWidth, frameHeight, GL_RGB, GL_FLOAT, NULL);
////    （3）把readBuffer中的数据映射到内存中
//    //映射
//    float *data = (float *)glMapBuffer(GL_PIXEL_PACK_BUFFER, GL_READ_ONLY);
//    //完成后解除映射
//    glUnmapBuffer(GL_PIXEL_PACK_BUFFER);
//}

@end
