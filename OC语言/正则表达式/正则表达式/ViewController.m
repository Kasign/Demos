//
//  ViewController.m
//  正则表达式
//
//  Created by mx-QS on 2019/5/27.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField   *   textField;

@property (nonatomic, strong) NSString   *   stringA;
@property (nonatomic, strong) NSMutableString   *   stringB;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField * field  = [[UITextField alloc] initWithFrame:CGRectMake(100, 270, 200, 40)];
//    [field setText:@"噟😀噟😀袭击发生刻录机😀"];
//    [field setText:@"噟"];
    [field setText:@"1嘻23【1h哈】嘻嘻"];
    field.layer.borderColor = [UIColor redColor].CGColor;
    field.layer.borderWidth = 1;
    [field.layer setMasksToBounds:YES];
//    field.delegate = self;
    _textField = field;
    [self.view addSubview:field];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(120, 200, 60, 40)];
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.4]];
    [self.view addSubview:button];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

- (void)textDidChange:(id<UITextInput>)textInput {
    
    
}

- (void)selectionDidChange:(nullable id<UITextInput>)textInput {
    
}


- (void)selectionWillChange:(nullable id<UITextInput>)textInput {
    
}


- (void)textWillChange:(nullable id<UITextInput>)textInput {
    
}

- (void)clickAction {
    
    [self isMatched:self.textField.text];
//    [self test];
}

- (void)test {
    
    
    NSString * a = @"";
    
    NSString * b = @"";
    
    a = @"嘻嘻哈哈哈呵呵呵";
    
    b = @"嘻嘻哈哈哈呵呵呵";
    
    b = [a copy];
    
    b = [a mutableCopy];
    
    b = [b stringByAppendingString:@"hahah"];
    
    b = [a mutableCopy];
    
    _stringA = [a copy];
    _stringB = [b copy];
    
    _stringA = @"a";
    
    _stringA = a;
    
    _stringA = @"abcd";
    
    a = @"";
    
    b = @"";
    
    a = @"a";
    
    b = @"a";
    
    a = @"b";
    
    b = @"b";
    
    a = @"";
    
    b = @"";
    
    a = @"a";
    
    b = @"a";
}

- (BOOL)isMatched:(NSString *)text {
    
    NSString * regStr = @"";
    
//    regStr = @"(.|\n)*[😀-🙏]+?(.|\n)*";
//
//    regStr = @"(.|\n)*[\\u1F601-\\u1F64F]+?(.|\n)*";
//
//    regStr = @"a";

    regStr = @"[【]{1}(\\d|\\D)+[】]{1}";
    regStr = @"[【]{1}(.|\\n|\\r)+[】]{1}";
//    regStr = @"\\d";
    
    NSPredicate * regStrTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regStr];
//
    BOOL is = [regStrTest evaluateWithObject:text];
//
//    [self disable_emoji:text];
    
    [self stringByMatchesWithRegularRule:regStr withStr:text];
    
    return is;
}

- (NSString *)disable_emoji:(NSString *)text
{
    
    NSString * regStr = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    regStr = @"(.|\n)*[😀-🙏]+?(.|\n)*";
    regStr = @"[😀-🙏]";
    NSError * error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regStr options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:NSMatchingReportCompletion
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

- (NSString *)stringByMatchesWithRegularRule:(NSString *)ruleStr withStr:(NSString *)text {
    
    NSError * error;
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:ruleStr options:NSRegularExpressionAnchorsMatchLines error:&error];
    
    [regex enumerateMatchesInString:text options:kNilOptions range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        NSLog(@"%@",result);
    }];
    
   NSTextCheckingResult * result = [regex firstMatchInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    
    NSArray * resultArr = [regex matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length)];
    
    return @"";
}

@end
