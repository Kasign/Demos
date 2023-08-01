//
//  ViewController.m
//  testAvc
//
//  Created by 秋山 on 2017/9/6.
//  Copyright © 2017年 秋山. All rights reserved.
//

#import "ViewController.h"
#import "ManagerTool.h"
#import "SecondViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSDictionary *dictionaryD;

@property (nonatomic, strong) ManagerTool *manager;
@property (nonatomic, strong) UILabel  *showLabel;
@property (nonatomic, copy) NSString  *stringSS;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [[ManagerTool alloc] initWithDic:self.dictionaryD];
    
    UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 60)];
    _showLabel = label;
    
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:label];
    
    
    _stringSS = @"其中包括同时任国务院总理温家宝的会谈，还有与时任国家主席胡锦涛、时任全国人大常委会委员长吴邦国和时任全国政协主席贾庆林的会见";
    
    NSLog(@"%ld",_stringSS.length);
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    NSLog(@"%@",[_manager description]);
    
//    static float a = 0.80;
//
//    static const float b = 5.0;
//
//    NSLog(@"a = %f b = %f",a,b);
//
//    a  = a + 0.10f;
//
//    float result = b  *a;
//
//    NSLog(@"conver >>>>>>>>>>>>>>>%@",[self converFloat:result]);
//
//    NSLog(@"caculate >>>>>>>>>>>>>>>%@",[self calculateFloatA:a floatB:b]);
//
//
//    [self.showLabel setText:[NSString stringWithFormat:@"%f",result]];
//
//
//    [self.showLabel setText:[self calculateFloatA:a floatB:b]];
    
    
    SecondViewController  *vc = [[SecondViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
//    [self refreshLabel];
    
}

-(void)refreshLabel{
    
    NSString  *remoteTime  =  @"2017-05-05 18:15:19";
    
    NSDate  *now = [NSDate date];
    
    NSString  *nowTime ;
    NSString  *oldTime ;
    NSString *result;
    
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate  *old = [formatter dateFromString:remoteTime];
    
    [formatter setDateFormat:@"yyyy"];
    
     nowTime = [formatter stringFromDate:now];
     oldTime = [formatter stringFromDate:old];
    
    NSComparisonResult compareResult = [nowTime compare:oldTime options:NSNumericSearch range:NSMakeRange(0, 4)];
    
    if (compareResult == NSOrderedDescending) {
        result = @"去年";
    } else if(compareResult == NSOrderedSame) {
        
    }
    
    
    [self.showLabel setText:result];
}


-(NSDictionary *)dictionaryD {
    if (!_dictionaryD) {
        _dictionaryD =@{@"age":@"12",@"name":@"xiaohei",@"sex":@"man",@"height":@"16"};
    }
    return _dictionaryD;
}

-(NSString*)converFloat:(CGFloat)floatValue{

    NSString  *floatStr = [NSString stringWithFormat:@"%f",floatValue];
    
    const char  *floatChars = [floatStr UTF8String];
    
    int strLength = (int)floatStr.length;
    
    int zeroCount = 0;
    
    for (int i = strLength-1; i>=0; i--) {
        if (floatChars[i] == '0' || floatChars[i] == '.') {
            zeroCount++;
            if (floatChars[i] == '.') {
                break;
            }
        }else{
            break;
        }
    }
  
    return [floatStr substringToIndex:strLength-zeroCount];
}

-(NSString*)calculateFloatA:(CGFloat)a floatB:(CGFloat)b{
    
    NSString *strA = [NSString stringWithFormat:@"%f",a];
    NSString *strB = [NSString stringWithFormat:@"%f",b];
    
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:strA];
    NSDecimalNumber *numberB = [NSDecimalNumber decimalNumberWithString:strB];
    
    /// 这里不仅包含Multiply还有加 减 除。
    NSDecimalNumber *numResult = [numberA decimalNumberByMultiplyingBy:numberB];
    
    NSString *strResult = [numResult stringValue];
    
    NSLog(@"NSDecimalNumber method  unrounding = %@",strResult);
    
    return strResult;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
