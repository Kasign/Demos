//
//  main.m
//  算法+++C
//
//  Created by Walg on 2020/8/18.
//  Copyright © 2020 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

// Definition for singly-linked list.
struct ListNode {
    int val;
    struct ListNode *next;
};


//  Definition for a binary tree node.
struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

struct TreeNode * initNode();
struct TreeNode* sortedList(struct ListNode *head, int n);
struct TreeNode* sortedToBST(struct ListNode * list, int start, int end);
struct TreeNode* sortedListToBST(struct ListNode* head);

struct TreeNode* sortedListToBST(struct ListNode* head){
    
    struct ListNode * node = head;
    int n = 0;
    while (node != NULL) {
        n ++;
        node = node->next;
    }
    printf("总个数 -> %d\n", n);
    struct TreeNode * treeNode = sortedList(head, n);
    
    return treeNode;
}


struct TreeNode* sortedToBST(struct ListNode * list, int start, int end) {
    
    if (start > end) return NULL;
    
    int mid = start + (end - start) / 2;
    printf("当前0 %d start %d end %d mid %d\n", list->val, start, end, mid);
    struct TreeNode * leftChild = sortedToBST(list, start, mid-1);
    struct TreeNode * parent    = initNode();
    
    struct ListNode * midNode = list;
    for(int i = mid - 1 ; i >= 0 ; i --) {
        if (midNode->next == NULL) {
            break;
        }
        midNode = midNode->next;
    }
    parent->val  = midNode->val;
    parent->left = leftChild;
//    list = list->next;
    parent->right = sortedToBST(list, mid+1, end);
    printf("当前1 %d start %d end %d\n", parent->val, start, end);
    return parent;
}

struct TreeNode * initNode() {
    
    struct TreeNode * tree = malloc(sizeof(struct TreeNode));
    return tree;
}

struct TreeNode* sortedList(struct ListNode *head, int n) {
    return sortedToBST(head, 0, n-1);
}

struct ListNode * listNode(struct ListNode * preNode, int val) {
    
    struct ListNode * node = malloc(sizeof(struct ListNode));
    node->val  = val;
    node->next = NULL;
    if (preNode != NULL) {
        preNode->next = node;
    }
    return node;
}

//int main(int argc, const char * argv[]) {
//    @autoreleasepool {
//
//        struct ListNode * header = NULL;
//        struct ListNode * node = NULL;
//        int i = -9;
//        while (i < 10) {
//            node = listNode(node, i);
//            if (header == NULL) {
//                header = node;
//            }
//            i += 3;
//        }
//
//        struct TreeNode * treeNode = sortedListToBST(header);
//        printf("12312");
//
//    }
//    return 0;
//}


int getMaxLen(int* nums, int numsSize){
   
    int l = 0;
    int s = 0;
    int f = 0;
    int count = 0;
    int t = 0;
    
    for(int i = 0; i < numsSize;i ++) {
      
        if (nums[i] < 0) {
            count ++;
            f = i;
            if (count % 2 == 0) {
                l = i - s + 1;
            }
        } else if (nums[i] == 0) {
            s = i + 1;
            if (count % 2 != 0) {
                l = l - i + f + 1 > i - f ? l - i + f + 1 : i - f;
            }
            t = t >=l ? t : l;
            count = 0;
            l = 0;
        } else {
            l ++;
        }
    }
    t = t >=l ? t : l;
    return t;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        int l = 8;
        int * nums = malloc(sizeof(int) * l);
        nums[0] = -16;
        nums[1] = 0;
        nums[2] = -3;
        nums[3] = 4;
        nums[4] = 4;
        nums[5] = -2;
        nums[6] = 8;
        nums[7] = 8;
        
        int t = getMaxLen(nums, l);
        printf("结果 %d\n", t);
        printf("12312");
        
    }
    return 0;
}

