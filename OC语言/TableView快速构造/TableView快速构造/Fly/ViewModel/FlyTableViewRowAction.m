//
//  FlyTableRowAction.m
//  TableView快速构造
//
//  Created by Walg on 2021/6/23.
//

#import "FlyTableViewRowAction.h"

@interface FlyRowActionsConfiguration ()

@property (nonatomic, copy, readwrite) NSArray<FlyTableViewRowAction *> *actions;

@end

@implementation FlyRowActionsConfiguration

+ (instancetype)configurationWithActions:(NSArray<FlyTableViewRowAction *> *)actions {
    
    FlyRowActionsConfiguration * config = [[FlyRowActionsConfiguration alloc] init];
    config.performsFirstActionWithFullSwipe = NO;
    config.actions = actions;
    return config;
}

@end

@interface FlyTableViewRowAction ()

@property (nonatomic, readwrite) FlyRowActionStyle style;
@property (nonatomic, copy, readwrite) FlyRowActionHandler handler;

@end

@implementation FlyTableViewRowAction

+ (instancetype)rowActionWithStyle:(FlyRowActionStyle)style title:(nullable NSString *)title handler:(FlyRowActionHandler)handler {
    
    FlyTableViewRowAction * rowAction = [[FlyTableViewRowAction alloc] init];
    rowAction.style   = style;
    rowAction.handler = handler;
    rowAction.title   = title;
    if (style == FlyRowActionStyle_Normal) {
//        rowAction.backgroundColor = FlyColorWithString(@"#FF953B");
    } else if (style == FlyRowActionStyle_Destructive) {
//        rowAction.backgroundColor = FlyColorWithString(@"#FA6400");
    }
    return rowAction;
}

@end
