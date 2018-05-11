//
//  ViewController.m
//  国际化语言测试
//
//  Created by Q on 2018/5/7.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ViewController.h"

#define OrgLocalizedStr(string) [ViewController localizeStringWithString:string]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews
{
    UILabel * label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setFrame:CGRectMake(100, 100, 200, 60)];
    [label setTextColor:[UIColor blackColor]];
    [label setText:OrgLocalizedStr(@"点击")];
    [self.view addSubview:label];
    
    NSLog(@" ******result:%@",[ViewController localizeStringWithString:@"加载失败啦~/(ㄒoㄒ)/~试试点击橙娘哦~"]);
}

+ (NSString *)localizeStringWithString:(NSString *)string
{
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *currentLanguage = languages.firstObject;//en zh-Hant-US zh-Hans-US
    NSLog(@"%@",currentLanguage);
    
    NSString * resultString = @"";
    for (int i = 0; i < string.length; i ++) {
        NSString * subString = [string substringWithRange:NSMakeRange(i, 1)];
        resultString = [resultString stringByAppendingString:NSLocalizedString(subString, subString)];
    }
    
    return resultString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
