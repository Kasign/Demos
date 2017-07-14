//
//  main.cpp
//  c++test1
//
//  Created by Walg on 2017/6/21.
//  Copyright © 2017年 Walg. All rights reserved.
//

#include <iostream>

int conver(int);

void getData(){
    std::cout << "I have done!"<<std::endl;
}

int main(int argc, const char * argv[]) {
    
    
    int carrots;
    
    std::cout << "How many carrots do you have?"<<std::endl;
    std::cin>>carrots;
    std::cout<<"Here are two more.";
    int ponds = conver(carrots);
    std::cout<<"Now you have " << carrots << " carrots."<<std::endl;
    
    std::cout<<carrots<<" carrots=";
    std::cout<<ponds<<" ponds"<<std::endl;
    
    std::cout << "Hello, World!\n";
    getData();
    std::cout << std::endl;
    return 0;
}

int conver(int n){
    return n*14;
}
