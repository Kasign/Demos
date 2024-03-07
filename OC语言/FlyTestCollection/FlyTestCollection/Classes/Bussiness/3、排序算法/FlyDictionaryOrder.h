//
//  FlyDictionaryOrder.h
//  FlyTestCollection
//
//  Created by Walg on 2024/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyDictionaryOrder : NSObject

/**
 有两个数字n和m，都是非负数，n > m, 按字典序输出所有1 - n中m个数字的组合
 eg:
 输入：
 3 2
 输出：
 1 2
 1 3
 2 3
 */
void outPutNums(int n, int m);

@end

NS_ASSUME_NONNULL_END
