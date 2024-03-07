//
//  FlyThirteenController.m
//  算法+链表
//
//  Created by Walg on 2020/10/24.
//  Copyright © 2020 Fly. All rights reserved.
//

#import "FlyThirteenController.h"

@interface FlyThirteenController ()

@end

@implementation FlyThirteenController

+ (NSString *)functionName {
    
    return @"类簇";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testNumberClassName];
    [self testArrayClassName];
    [self testStringClassName];
    [self testDictionaryClassName];
}

- (void)testNumberClassName
{
    FLYClearLog(@"============Number=============");
    char a = 1;
    NSNumber *nChar = [NSNumber numberWithChar:a];
    NSNumber *nInt  = [NSNumber numberWithInt:4];
    NSNumber *n = [NSNumber alloc];
    NSNumber *c = [n init];
    FLYClearLog(@"\n%@ \n%@ \n%@ \n%@", [n class], [c class], [nChar class], [nInt class]);
    FLYClearLog(@"============Number=============");
}

- (void)testArrayClassName
{
    FLYClearLog(@"============Array=============");
    
    NSArray *aArray = [NSArray alloc];
    NSMutableArray *aMArray = [NSMutableArray alloc];
    
    NSArray *bArray = [aArray init];
    NSMutableArray *bMArray = [aMArray init];
    
    NSArray *cArray = [NSArray array];
    NSMutableArray *cMArray = [NSMutableArray array];
    NSArray *dArray = @[@"1"];
    NSMutableArray *dMArray = [bArray mutableCopy];
    
    NSArray *eArray = @[@"1", @"a"];
    NSArray *fArray = @[@1];
    
    NSMutableArray *eMArray = [@[@"1", @"a"] mutableCopy];
    NSMutableArray *fMArray = [@[@1] mutableCopy];
    
    FLYClearLog(@"\na  %@ \naM %@ \nb  %@ \nbM %@ \nc  %@ \ncM %@ \nd  %@ \ndM %@ \ne  %@ \nf  %@ \neM %@ \nfM %@",
                [aArray class],
                [aMArray class],
                [bArray class],
                [bMArray class],
                [cArray class],
                [cMArray class],
                [dArray class],
                [dMArray class],
                [eArray class],
                [fArray class],
                [eMArray class],
                [fMArray class]);
    FLYClearLog(@"============Array=============");
}

- (void)testStringClassName
{
    FLYClearLog(@"============String=============");
    NSString *aStr = [NSString alloc];
    NSMutableString *aMStr = [NSMutableString alloc];
    
    NSString *bStr = @"abc";
    NSMutableString *bMStr = [bStr mutableCopy];
    
    NSString *cStr = [[NSString alloc] initWithString:@"abvadf"];
    NSMutableString *cMStr = [[NSMutableString alloc] initWithString:@"afssdf"];
    
    NSString *dStr = [aStr init];
    NSMutableString *dMStr = [aMStr init];
    
    NSString *eStr = @"";
    NSString *fStr = @"l";
    
    FLYClearLog(@"\n%@ \n%@ \n%@ \n%@ \n%@ \n%@ \n%@ \n%@ \n%@ \n%@",
                [aStr class],
                [aMStr class],
                [bStr class],
                [bMStr class],
                [cStr class],
                [cMStr class],
                [dStr class],
                [dMStr class],
                [eStr class],
                [fStr class]);
    FLYClearLog(@"============String=============");
}

- (void)testDictionaryClassName
{
    FLYClearLog(@"============Dictionary=============");
    NSDictionary *aDic = [NSDictionary alloc];
    NSMutableDictionary *aMDic = [NSMutableDictionary alloc];
    
    NSDictionary *bDic = [aDic init];
    NSMutableDictionary *bMDic = [aMDic init];
    
    NSDictionary *cDic = [[NSDictionary alloc] initWithDictionary:nil];
    NSMutableDictionary *cMDic = [[NSMutableDictionary alloc] initWithDictionary:bDic];
    
    NSDictionary *dDic = [NSDictionary dictionaryWithObject:@"adfs" forKey:@"adfs"];
    NSMutableDictionary *dMDic = [NSMutableDictionary dictionaryWithObject:@"adfs" forKey:@"adfs"];
    
    FLYClearLog(@"\n%@ \n%@ \n%@ \n%@ \n%@ \n%@", [aDic class], [aMDic class], [bDic class], [bMDic class], [dDic class], [dMDic class]);
    FLYClearLog(@"============Dictionary=============");
}


@end
