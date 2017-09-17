//
//  main.cpp
//  时间c++
//
//  Created by Walg on 2017/9/1.
//  Copyright © 2017年 Walg. All rights reserved.
//

#include <iostream>
#include <ctime>

int main(int argc, const char * argv[]) {
    // 基于当前系统的当前日期/时间
    time_t now = time(0);
    
    
    std::cout<<now<<std::endl;
    
    // 把 now 转换为字符串形式
    char* dt = ctime(&now);
    
    std::cout << "本地日期和时间：" << dt << std::endl;

    tm *localTime = localtime(&now);
    
    dt = asctime(localTime);
    
    std::cout << "local=本地日期和时间：" << dt << std::endl;
    
    // 把 now 转换为 tm 结构
    tm *gmtm = gmtime(&now);
    
    dt = asctime(gmtm);
    
    
    
    
    std::cout << "UTC 日期和时间："<< dt << std::endl;
    
    
    
    std::cout << "Hello, World!\n";
    return 0;
}
