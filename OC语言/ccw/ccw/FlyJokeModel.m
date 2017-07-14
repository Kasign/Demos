//
//  FlyJokeModel.m
//  ccw
//
//  Created by Walg on 2017/6/25.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyJokeModel.h"

@implementation FlyJokeModel
-(instancetype)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        for (NSString *key in dic.allKeys) {
            if ([key isEqualToString:@"title"]) {
                _title = [dic objectForKey:key];
            }
            if ([key isEqualToString:@"content"]) {
                _content = [dic objectForKey:key];
                if ([_content containsString:@"<br/><br/>"]) {
                 _content = [_content stringByReplacingOccurrencesOfString:@"<br/><br/>" withString:@"\n\n"];
                }
            }

            if ([key isEqualToString:@"poster"]) {
                _poster = [dic objectForKey:key];
            }
            if ([key isEqualToString:@"sourceurl"]) {
                _sourceurl = [dic objectForKey:key];
            }

        }
    }
    return self;
}

-(instancetype)initWithBmobObject:(BmobObject *)object{
    self = [super init];
    if (self) {
        
        _title = [object objectForKey:@"title"];
        
        _content = [object objectForKey:@"content"];
        if ([_content containsString:@"<br/><br/>"]) {
            _content = [_content stringByReplacingOccurrencesOfString:@"<br/><br/>" withString:@"\n\n"];
        }
        
        _poster = [object objectForKey:@"poster"];
        
        _sourceurl = [object objectForKey:@"pic"];
        
        
    }
    return self;
}
@end
