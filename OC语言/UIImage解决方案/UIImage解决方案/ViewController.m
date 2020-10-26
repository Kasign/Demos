//
//  ViewController.m
//  UIImage解决方案
//
//  Created by qiuShan on 2018/3/2.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "ViewController.h"
#import "SalDrawTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage * image = [UIImage imageNamed:@"1.jpg"];
    
    SalImageTask * imageTask = [SalImageTask imageTaskWithImage:image drawRect:CGRectMake(0, 0, 3600, 2025)];
    SalDrawTask * task = [SalDrawTask drawTaskWithSize:CGSizeMake(3600, 2025) backColor:nil alphaColor:nil drawTaskList:@[imageTask]];
    task.drawScale = 3;
    task.drawType  = SALDrawContentType_IMAGE;

    SalImageInfo * info = [SalDrawTool decodeImageInfoWithTask:task];
    UIImage * newImage  = [info getCurrentImage:NO];

    NSData * imageData = UIImagePNGRepresentation(newImage);
//    [imageData writeToFile:@"/Users/qiushan/Desktop/2.png" atomically:YES];

    NSString * path = NSHomeDirectoryForUser(@"qiushan");
    NSArray * arr = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSAllDomainsMask, YES);
    path = [[arr lastObject] stringByAppendingPathComponent:@"2.png"];
    NSError * error = nil;
    BOOL isSuccess = [imageData writeToFile:path options:NSDataWritingAtomic error:&error];
    NSLog(@"%@ \n%@", path, arr);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
