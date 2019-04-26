//
//  ViewController.m
//  UITextView+@符号
//
//  Created by mx-QS on 2019/4/26.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyTextManager.h"

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, copy) NSString   *   mx_oriTextStr;

@property (nonatomic, strong) NSMutableDictionary  *   mx_oriBlockRangDic; //块字符 rang arr
@property (nonatomic, strong) NSMutableDictionary  *   mx_showBlockRangDic;//块字符 rang arr
@property (nonatomic, strong) NSAttributedString   *   mx_attributeString;//要显示的文本样式

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mx_oriTextStr = @"怎么呢？#v[001]哈哈哈哈#v[003]你呢#v[004]#v[005]";
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(40.f, 300, width - 80.f, 80.f)];
    textView.delegate = self;
    [textView setBackgroundColor:[UIColor cyanColor]];
    textView.layer.cornerRadius = 8.f;
    [textView.layer setMasksToBounds:YES];
    [textView setAttributedText:self.mx_attributeString];
    [self.view addSubview:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    self.mx_oriTextStr = [FlyTextManager stringWhenChangedWithOriText:self.mx_oriTextStr showText:[self.mx_attributeString string] oriRangeDic:self.mx_oriBlockRangDic showRangeDic:self.mx_showBlockRangDic replaceRange:range replaceText:text];
    [textView setAttributedText:self.mx_attributeString];
    return NO;
}


static NSArray * MXCreateTextSymbolConfig(void) {
    
    return @[@"#v[", @"]"];
}

static NSMutableDictionary * MXCreateTextAttributedConfig(void) {
    
    UIFont * normalFont   = [UIFont systemFontOfSize:14.f];
    UIFont * numberFont   = [UIFont systemFontOfSize:12.f];
    UIColor * normalColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIColor * numberColor = [UIColor blueColor];
    
    normalFont  = [UIFont systemFontOfSize:16.f];
    numberFont  = [UIFont systemFontOfSize:16.f];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if (normalFont) {
        [dict setObject:normalFont forKey:NSFontAttributeName];
    }
    if (normalColor) {
        [dict setObject:normalColor forKey:NSForegroundColorAttributeName];
    }
    if (numberFont) {
        [dict setObject:numberFont forKey:@"hightlight_font"];
    }
    if (numberColor) {
        [dict setObject:numberColor forKey:@"hightlight_color"];
    }
    
    return dict;
}

- (NSAttributedString *)mx_attributeString {
    
    if (!_mx_attributeString) {
        NSDictionary * oriDic = nil;
        NSDictionary * showDic = nil;
        _mx_attributeString = [FlyTextManager attributedStringWtihOriStr:self.mx_oriTextStr symbolArr:MXCreateTextSymbolConfig() configDict:MXCreateTextAttributedConfig() oriBlockDict:&(oriDic) showBlockDict:&(showDic)];
        self.mx_oriBlockRangDic  = [oriDic mutableCopy];
        self.mx_showBlockRangDic = [showDic mutableCopy];
    }
    return _mx_attributeString;
}

- (void)setMx_oriTextStr:(NSString *)mx_oriTextStr {
    
    _mx_oriTextStr = mx_oriTextStr;
    _mx_attributeString = nil;
}


@end
