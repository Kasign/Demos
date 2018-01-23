//
//  FlyTrainStateModel.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyTrainStateModel.h"

@implementation FlyTrainStateModel


- (void)modelWithString:(NSString *)string
{
    /*
    |预订|24000Z401500|Z4015|BJP|HBB|BJP|CCT|08:20|19:26|11:06|N|flVM9Eae4OEIquzATgR23zNZ0AXVplk3So1ma%2FEqH%2FsVXQfT|20180211|3|PC|01|07|0|0||无||无|无||||||||||602040|624|0
                      21 23 24           35    36 37
    let paramStr = json.rawString()!
    let params = paramStr.components(separatedBy: "|")
    
    SecretStr = params[0]                  //标识符
    if SecretStr != nil{
        SecretStr = SecretStr!.removingPercentEncoding
    }
    buttonTextInfo = params[1]             //票务描述
    train_no = params[2]                   //车全号   24000Z401500
    TrainCode = params[3]                  //车号     Z4015
    start_station_telecode = params[4]     //始发站
    end_station_telecode = params[5]       //终点站
    FromStationCode = params[6]            //出发站
    ToStationCode = params[7]              //目的站
    start_time = params[8]                 //发车时间
    arrive_time = params[9]                //到达时间
    lishi = params[10]                     //历时时间
    canWebBuy = params[11]                 //是否能买 -> 系统维护时间
    yp_info = params[12]                   //flVM9Eae4OEIquzATgR23zNZ0AXVplk3So1ma%2FEqH%2FsVXQfT
    start_train_date = params[13]          //发车日期  20180211
    train_seat_feature = params[14]        //座位类型数 3
    location_code = params[15]             //PC
    from_station_no = params[16]           //01
    to_station_no = params[17]             //07
    is_support_card = params[18]           //0
    controlled_train_flag = params[19]     //0
    
    Gg_Num = params[20]     //观光
    Gr_Num = params[21]     //高级软卧
    Qt_Num = params[22]     //其他
    Rw_Num = params[23]     //软卧
    Rz_Num = params[24]     //软座
    Tz_Num = params[25]     //特等座
    Wz_Num = params[26]     //无座
    Yb_Num = params[27]     //迎宾
    Yw_Num = params[28]     //硬卧
    Yz_Num = params[29]     //硬座
    Ze_Num = params[30]     // 二等座
    Zy_Num = params[31]     //一等座
    Swz_Num = params[32]    //商务座
    
    yp_ex = params[33]
    seat_types = params[34]
    */

}


@end
