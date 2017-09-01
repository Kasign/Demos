//
//  main.cpp
//  String_test
//
//  Created by walg on 2017/8/21.
//  Copyright © 2017年 walg. All rights reserved.
//

#include <iostream>
int count;
extern void write_cpp();
extern void exchange_int(int &x,int &y);
extern void exchange_point(int *x,int *y);
extern void exchange_value(int x,int y);


struct Person
{
    int age;
    std::string name;
    float height;
    int weight;
};

void print_int(int str){
    std::cout<<str<<std::endl;
};

void print_str(std::string str){
    std::cout<<str<<std::endl;
};

int main(int argc, const char * argv[]) {
    // insert code here...
    
//    //字符串拼接
//    std::string s1 = "abcd";
//    std::string s2 = "bndma";
//    std::string s3;
//    s3 = s1 + s2;
//    std::cout << s3 << std::endl;
    
//    //结构体
//    Person(hong) = {
//        12,
//        "xiaohei",
//        173.9,
//        67123,
//    };
    
//    Person xiaochao  {122,"xiaochao",178,18};
//    
//    std::cout<<hong.name<<std::endl;
//    std::cout<<xiaochao.weight<<std::endl;
//    
//    //auto的使用，自动判断类型，但是只能是一种类型
//    auto f = 3.145;
//    auto s("hello");
//    auto z = new auto(8);
//    
//    print_int(*z);
//    print_int(f);
//    print_str(s);
//    
//    std::cout<<f<<std::endl;
//    std::cout<<s<<std::endl;
//    
//    register_t regist_int = 15555;
  
    count = 12;
    
    write_cpp();
    
    int i = 10;
    int j = 20;
    
//    i = i^j;
//    
//    print_int(i);
    
    
    std::cout<<"更换前i:"<<i<<std::endl;
    std::cout<<"更换前j:"<<j<<std::endl;
//    exchange_int(i, j);
    exchange_point(&i, &j);
//    exchange_value(i, j);
    std::cout<<"更换后i:"<<i<<std::endl;
    std::cout<<"更换后j:"<<j<<std::endl;
    
    std::cout << "Hello, World!\n";
    return 0;
}


