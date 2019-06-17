//
//  ViewController.m
//  UITextView+@符号
//
//  Created by mx-QS on 2019/4/26.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyTextView.h"
#import "FlyTextManager.h"

@interface ViewController ()

@property (nonatomic, copy) NSString   *   mx_oriTextStr;

@property (nonatomic, strong) NSMutableDictionary  *   mx_oriBlockRangDic; //块字符 rang arr
@property (nonatomic, strong) NSMutableDictionary  *   mx_showBlockRangDic;//块字符 rang arr
@property (nonatomic, strong) NSAttributedString   *   mx_attributeString;//要显示的文本样式

@property (nonatomic, strong) FlyTextView   *   textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mx_oriTextStr = @"电费凉快围殴23哦IP单身快乐就烦死了快敬爱的分手快嘻嘻哈哈西欧局水电费凉快围殴23哦IP单身快乐就烦死了快敬爱的分手快乐的；安静了会计师的风口浪尖沙坡尾而POI";
    
    NSAttributedString * attri = [[NSAttributedString alloc] initWithString:self.mx_oriTextStr attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    FlyTextView * textView = [[FlyTextView alloc] initWithFrame:CGRectMake(40.f, 300, FLyScreenWidth - 80.f, 80.f) textContainer:[self textContainer]];
    [textView setBackgroundColor:[UIColor cyanColor]];
    textView.layer.cornerRadius = 8.f;
    [textView.layer setMasksToBounds:YES];
    textView.attributedText = attri;
    [self.view addSubview:textView];
    _textView = textView;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSAttributedString * attri = [[NSAttributedString alloc] initWithString:self.mx_oriTextStr attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    _textView.attributedText = attri;
}

- (NSTextContainer *)textContainer
{
    
    NSTextStorage * textStorage = [[NSTextStorage alloc] init];
    
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    
    [textStorage addLayoutManager:layoutManager];
    
    NSTextContainer * container = [[NSTextContainer alloc] initWithSize:CGSizeMake(0.f, 0.f)];
    
//    layoutManager.textContainers = @[container];
    [layoutManager addTextContainer:container];
    
    return nil;
}


@end
