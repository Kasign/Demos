//
//  FlyDictionaryOrder.m
//  FlyTestCollection
//
//  Created by Walg on 2024/3/7.
//

#import "FlyDictionaryOrder.h"

@implementation FlyDictionaryOrder

//处理进位为题
void arrList(int list[], int i, int max) {
    
    if (list[i] > max && i > 0) {
        list[i - 1] = list[i - 1] + 1;
        arrList(list, i - 1, max - 1);
        list[i] = list[i - 1] + 1;
    }
}

//打印
void printArr(int arr[], int count) {
    
    for (int k = 0; k < count; k ++) {
        if (k == count - 1) {
            printf("%d\n", arr[k]);
        } else {
            printf("%d ", arr[k]);
        }
    }
}

void outPutNums(int n, int m) {
    
    if (m > 0 && n >= m) {
        if (m == 1) {
            for (int i = 1; i <= n ; i ++) {
                printf ("%d\n", i);
            }
        } else {
            int * arr = malloc(m * sizeof(int));
            for (int j = 0; j < m; j ++) {
                arr[j] = j + 1;
            }
            while (arr[0] <= n - m + 1) {
                for (int j = arr[m - 1]; j <= n; j ++) {
                    printArr(arr, m);
                    arr[m - 1] = arr[m - 1] + 1;
                }
                //处理进位的问题
                arrList(arr, m - 1, n);
            }
            free(arr);
        }
    }
}


@end
