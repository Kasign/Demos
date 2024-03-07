//
//  FlySecondController.m
//  算法+链表
//
//  Created by mx-QS on 2019/8/16.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlySecondController.h"
#import "FlyNode.h"

@interface FlySecondController ()
@property (nonatomic, strong) FlyNode   *headerNode;
@end

@implementation FlySecondController

+ (NSString *)functionName {
    
    return @"链表";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *pointStr = @"";
    _headerNode  = [[FlyNode alloc] init];
    FlyNode *currentNode = _headerNode;
    pointStr = [pointStr stringByAppendingFormat:@"%p->", currentNode];
    for (NSInteger i = 0; i < 5; i ++) {
        FlyNode *node = [[FlyNode alloc] init];
        currentNode.next = node;
        pointStr = [pointStr stringByAppendingFormat:@"%p->", currentNode.next];
        currentNode = node;
    }
    pointStr = [pointStr stringByAppendingFormat:@"%p", currentNode.next];
    FLYLog(@"转换前：%@",pointStr);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    FLYLog(@"-=-=-=-=-=-=-=-=-=-");
    _headerNode = [self resverNode:_headerNode];
}

- (FlyNode *)resverNode:(FlyNode *)headerNode {
    
    FlyNode *currentNode = headerNode;
    FlyNode *prevNode    = nil;
    NSString *pointStr   = @"";
    pointStr = [pointStr stringByAppendingFormat:@"%p<-", prevNode];
    while(currentNode.next != nil)
    {
        FlyNode *nextNode = currentNode.next;
        currentNode.next  = prevNode;
        prevNode    = currentNode;
        currentNode = nextNode;
        pointStr = [pointStr stringByAppendingFormat:@"%p<-", prevNode];
    }
    currentNode.next = prevNode;
    pointStr = [pointStr stringByAppendingFormat:@"%p", currentNode];
    FLYLog(@"转换后：%@", pointStr);
    return currentNode;
}

@end
