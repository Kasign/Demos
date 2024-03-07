//
//  FlyNinthController.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/24.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyNinthController.h"
#import <FlyBaseTool/FlyRunloopTool.h>
#import "FlyPerformanceMonitor.h"

@interface FlyTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel       *label;
@property (nonatomic, strong) UIImageView   *imageView1;
@property (nonatomic, strong) UIImageView   *imageView2;
@property (nonatomic, strong) UIImageView   *imageView3;

@end

@implementation FlyTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.imageView1];
        [self.contentView addSubview:self.imageView2];
        [self.contentView addSubview:self.imageView3];
    }
    return self;
}

- (UILabel *)label {
    
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 30)];
        [_label setText:@"调函数的参数就是鼠标事件对象"];
    }
    return _label;
}

- (UIImageView *)imageView1 {
    
    if (_imageView1 == nil) {
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35, 100.f, 100.f)];
    }
    return _imageView1;
}

- (UIImageView *)imageView2 {
    
    if (_imageView2 == nil) {
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(105, 35, 100.f, 100.f)];
    }
    return _imageView2;
}


- (UIImageView *)imageView3 {
    
    if (_imageView3 == nil) {
        _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(210, 35, 100.f, 100.f)];
    }
    return _imageView3;
}

- (void)releaseMemory {
    
    self.imageView1.image = nil;
    self.imageView2.image = nil;
    self.imageView3.image = nil;
}


@end

@interface FlyNinthController ()<UITableViewDelegate, UITableViewDataSource, NSPortDelegate>

@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) FlyRunloopTool   *loopTool;

@property (nonatomic, strong) NSTimer   *timer;

@end

@implementation FlyNinthController

+ (NSString *)functionName {
    
    return @"runloop";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loopTool = [[FlyRunloopTool alloc] init];
    [_loopTool startObserver];
//    [FlyPerformanceMonitor beginMonitor];
    [self.view addSubview:self.tableView];
    
    _timer = [NSTimer timerWithTimeInterval:3 repeats:YES block:^(NSTimer *_Nonnull timer) {

        FLYLog(@"timer ++++");
    }];
//    [_timer fire];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 400;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[FlyTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    [self addImagesForCell:cell];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    FLYLog(@"scrollViewDidScroll");
}

- (void)addImagesForCell:(FlyTableViewCell *)cell {
    
    [cell releaseMemory];
    __weak typeof(self) weakSelf = self;
    [weakSelf.loopTool toolAddTask:^{
        __strong typeof(weakSelf) self = weakSelf;
        [self addImageForCell1:cell];
    }];
//    [weakSelf.loopTool toolAddTask:^{
//        __strong typeof(weakSelf) self = weakSelf;
//        [self addImageForCell2:cell];
//    }];
//    [weakSelf.loopTool toolAddTask:^{
//        __strong typeof(weakSelf) self = weakSelf;
//        [self addImageForCell3:cell];
//    }];
    
//    [self addImageForCell1:cell];
    [self addImageForCell2:cell];
    [self addImageForCell3:cell];
}

- (void)addImageForCell1:(FlyTableViewCell *)cell
{
    UIImage *image = [self loadImageWithName:@"1"];
    [cell.imageView1 setImage:image];
    FLYLog(@"加载第一张图片");
}

- (void)addImageForCell2:(FlyTableViewCell *)cell
{
    UIImage *image = [self loadImageWithName:@"2"];
    [cell.imageView2 setImage:image];
    FLYLog(@"加载第二张图片");
}

- (void)addImageForCell3:(FlyTableViewCell *)cell
{
    UIImage *image = [self loadImageWithName:@"3"];
    [cell.imageView3 setImage:image];
    FLYLog(@"加载第三张图片");
}

- (UIImage *)loadImageWithName:(NSString *)imageName {
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSString *fullName = [imageName stringByAppendingString:@".jpg"];
    UIImage  *image    = [UIImage imageNamed:fullName];
    return image;
}

- (void)dealloc
{
    [_loopTool stopTasks];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
//    [FlyPerformanceMonitor endMonitor];
    if (_timer) {
        [_timer invalidate];
    }
}

@end
