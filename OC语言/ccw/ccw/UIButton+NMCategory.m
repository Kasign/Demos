//
//  UIButton+NMCategory.m
//  DragButtonDemo
//
//  Created by Aster0id on 14-5-16.
//
//

#import "UIButton+NMCategory.h"
#import <objc/runtime.h>
static NSInteger PADDING   =  -14;
static void *DragEnableKey = &DragEnableKey;
static void *AdsorbEnableKey = &AdsorbEnableKey;

@implementation UIButton (NMCategory)


-(void)setDragEnable:(BOOL)dragEnable
{
    objc_setAssociatedObject(self, DragEnableKey,@(dragEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isDragEnable
{
    return [objc_getAssociatedObject(self, DragEnableKey) boolValue];
}

-(void)setAdsorbEnable:(BOOL)adsorbEnable
{
    objc_setAssociatedObject(self, AdsorbEnableKey,@(adsorbEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isAdsorbEnable
{
    return [objc_getAssociatedObject(self, AdsorbEnableKey) boolValue];
}

CGPoint beginPoint;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.highlighted) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        self.highlighted = NO;
    }
    
    if (self.superview && [objc_getAssociatedObject(self,AdsorbEnableKey) boolValue] ) {
        float marginLeft = self.frame.origin.x;
        float marginRight = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
        [UIView animateWithDuration:0.125 animations:^(void){
            self.frame = CGRectMake(marginLeft<marginRight?PADDING:self.superview.frame.size.width - self.frame.size.width-PADDING,
                                    self.frame.origin.y<self.superview.frame.size.height-80?self.frame.origin.y<64?64:self.frame.origin.y:self.superview.frame.size.height-100,
                                    self.frame.size.width,
                                    self.frame.size.height);
        }];
        
    }
}


@end
