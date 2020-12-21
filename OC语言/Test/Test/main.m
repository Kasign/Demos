//
//  main.m
//  Test
//
//  Created by Walg on 2020/1/15.
//  Copyright © 2020 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#include <stdio.h>
#include <stdlib.h>

void arrlist(int list[], int i, int max) {
    
    if (list[i] >= max) {
        list[i - 1] = list[i - 1] + 1;
        list[i] = list[i - 1] + 1;
    }
}

void outPutNums(int n, int m) {
    
    if (m > 0 && n >= m && n <= 10) {
        if (m == 1) {
            for (int i = 1; i <= n ; i ++) {
                printf ("%d\n", i);
            }
        } else {
            int * arr = malloc((m - 1) * sizeof(int));
            for (int i = 1 ; i <= n - m + 1; i ++) {
                for (int j = 0; j < m - 1;j ++) {
                    arr[j] = j + 1;
                }
                while (arr[0] + i <= n) {
                    for (int j = i + arr[m - 2]; j <= n; j ++) {
                        
                        if (arr[m - 2] > n) {
                           break;
                        }
                        //输出
                        for (int k = 0; k < m; k ++) {
                            if (k == 0) {
                                printf ("%d ", i);
                            } else if (k == m - 1) {
                                printf("%d\n", i + arr[k - 1]);
                            } else {
                                printf("%d ", i + arr[k - 1]);
                            }
                        }
                        arr[m - 2] = arr[m - 2] + 1;
                    }
                    
                    for (int k = 0; k < m - 1; k ++) {
                        arrlist(arr, k, n - m + k + 2);
                    }
                }
            }
        }
    }
}

int main(int argc, char * argv[]) {
    
    outPutNums(6, 3);
    return 0;
}
