//
//  main.cpp
//  c++test1
//
//  Created by Walg on 2017/6/21.
//  Copyright © 2017年 Walg. All rights reserved.
//

#include <iostream>


int main(int argc, const char * argv[]) {
    std::cout << "Hello, World!\n";
    int a = 1;
    std::cout <<long(a)<<std::endl;
    std::cout <<static_cast<long>(a)<<std::endl;
    
    int months[12] = {1,2,3,4,5,6,7,8,9,10,11,12};
    std::cout<<"month 11 is "<<months[10]<<std::endl;
    
    char dog[8] {'a','b','c','d','e','f','r','x'};
    char cat[8] {'e','d','v','y','p','o','i','\0'};
    char pig[] = "Buddles";
    
    std::cout << dog <<std::endl;
    std::cout << cat <<std::endl;
    std::cout << pig <<std::endl;
    
    
    return 0;
}
