//
//  FlyTrainStateModel.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyBaseModel.h"

@interface FlyTrainStateModel : FlyBaseModel

@property (nonatomic,copy) NSString * secretStr;            //标识符   0
@property (nonatomic,copy) NSString * buttonTextInfo;       //票务描述  1
@property (nonatomic,copy) NSString * trainNo;              //车全号  2 24000Z401500
@property (nonatomic,copy) NSString * trainCode;            //车号   3 Z4015
@property (nonatomic,copy) NSString * startStationCode;     //始发站    4
@property (nonatomic,copy) NSString * endStationCode;       //终点站    5
@property (nonatomic,copy) NSString * fromStationCode;      //出发站     6
@property (nonatomic,copy) NSString * toStationCode;        //目的站     7
@property (nonatomic,copy) NSString * startTime;            //发车时间   8
@property (nonatomic,copy) NSString * arriveTime;           //到达时间   9

@property (nonatomic,copy) NSString * totalTiem;            //历时时间    10
@property (nonatomic,copy) NSString * canWebBuy;            //是否购买时间    11
@property (nonatomic,copy) NSString * ypInfo;               // 12
@property (nonatomic,copy) NSString * startTrainDate;       //发车日期  20180211; 13
@property (nonatomic,copy) NSString * trainSeatFeature;     //座位类型数 3   14
@property (nonatomic,copy) NSString * locationCode;         //pc     15
@property (nonatomic,copy) NSString * fromStationNo;        // 0      16
@property (nonatomic,copy) NSString * toStationNo;          // 0      17
@property (nonatomic,copy) NSString * isSupportCard;        // 0   18
@property (nonatomic,copy) NSString * controlledTrainFlag;  // 0  19

@property (nonatomic,copy) NSString * ggNum;                //观光   20
@property (nonatomic,copy) NSString * grNum;                //高级软卧 21
@property (nonatomic,copy) NSString * qtNum;                //其他  22
@property (nonatomic,copy) NSString * rwNum;                //软卧  23
@property (nonatomic,copy) NSString * rzNum;                //软座  24
@property (nonatomic,copy) NSString * tzNum;                //特等座   25
@property (nonatomic,copy) NSString * wzNum;                //无座      26
@property (nonatomic,copy) NSString * ybNum;                //迎宾      27
@property (nonatomic,copy) NSString * ywNum;                //硬卧      28
@property (nonatomic,copy) NSString * yzNum;                //硬座      29

@property (nonatomic,copy) NSString * zeNum;                // 二等座   30
@property (nonatomic,copy) NSString * zyNum;                //一等座    31
@property (nonatomic,copy) NSString * swzNum;               //商务座    32
@property (nonatomic,copy) NSString * ypEx;                 //         33
@property (nonatomic,copy) NSString * seatTypes;            //         34

- (instancetype)initWithString:(NSString *)string;

@end
