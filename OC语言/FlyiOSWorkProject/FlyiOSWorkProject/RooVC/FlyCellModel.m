//
//  FlyCellModel.m
//  ProgramCollection
//
//  Created by Walg on 2024/1/29.
//  Copyright © 2024 FLY. All rights reserved.
//

#import "FlyCellModel.h"

@implementation FlyCellModel

+ (instancetype)instanceWithIndex:(NSInteger)index {
    
    NSString *vcName = [self nameForIndex:index];
    Class vcClass = NSClassFromString(vcName);
    if (vcClass) {
        NSString *title = [vcClass performSelector:@selector(functionName)];
        FlyCellModel *model = [FlyCellModel new];
        model.vcClass = vcClass;
        model.cellTitle = [NSString stringWithFormat:@"%ld.%@", (long)(index + 1), title];
        model.vcTitle = [NSString stringWithFormat:@"%@+%@", vcClass, title];
        return model;
    }
    return nil;
}

+ (NSString *)nameForIndex:(NSInteger)index {
    
    NSString *vcNum = nil;
    switch (index) {
        case 0:
            vcNum = @"First";
            break;
        case 1:
            vcNum = @"Second";
            break;
        case 2:
            vcNum = @"Third";
            break;
        case 3:
            vcNum = @"Forth";
            break;
        case 4:
            vcNum = @"Fifth";
            break;
        case 5:
            vcNum = @"Sixth";
            break;
        case 6:
            vcNum = @"Seventh";
            break;
        case 7:
            vcNum = @"Eighth";
            break;
        case 8:
            vcNum = @"Ninth";
            break;
        case 9:
            vcNum = @"Tenth";
            break;
        case 10:
            vcNum = @"Eleventh";
            break;
        case 11:
            vcNum = @"Twelfth";
            break;
        case 12:
            vcNum = @"Thirteen";
            break;
        case 13:
            vcNum = @"Fourteen";
            break;
        case 14:
            vcNum = @"Fifteen";
            break;
        case 15:
            vcNum = @"Sixteen";
            break;
        case 16:
            vcNum = @"Seventeen";
            break;
            break;
        default:
            break;
    }
    if (!vcNum) {
        return [NSString stringWithFormat:@"Fly%ldController",(long)(index + 1)];
    }
    return [NSString stringWithFormat:@"Fly%@Controller", vcNum];
}

@end
