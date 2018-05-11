//
//  SecondViewController.m
//  3D效果
//
//  Created by Q on 2018/5/8.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (nonatomic, strong) UIImageView   *   imageView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc] init];
    
    [_imageView setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)/2.0, 200, 300, 200)];
    [_imageView setBackgroundColor:[UIColor cyanColor]];
    [_imageView setImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:_imageView];
//    [self setAnchorPoint:CGPointMake(1.0, 0.5) forView:_imageView];
    //    [_imageView.layer setAnchorPoint:CGPointMake(0, 0.5)];
    //    _imageView.layer.transform = CATransform3DMakeRotation(30*M_PI/180, 0, -1.0, 0);
    
    
    __block typeof(_imageView) blockImageView = _imageView;
    [UIView animateWithDuration:1.6 animations:^{
        CATransform3D trans = CATransform3DIdentity;
//        trans.m34 = -1/200.0;
        trans = CATransform3DRotate(trans, 20*M_PI/180.f, 1, 1, 0);
        //        trans = CATransform3DTranslate (trans, 20.f, 10.f, 15.f);
        //        trans = CATransform3DScale (trans, 1.2, 1.3, 1.4);
        
      CATransform3D transForm = CATransform3DMakeRotation(0.32, 1, 1, 1);
//        trans.m11 = 1;
//        trans.m22 = 1;
//        trans.m33 = 1;
        //        trans.m41 = 0;
        //        trans.m42 = 0;
        //        trans.m43 = 0;
        //        blockImageView.layer.anchorPoint = CGPointMake(1.0, 0.5);
        
        blockImageView.layer.transform   = CATransform3DConcat(trans, transForm);
    }];
    
    //    CATransform3DRotate(trans, M_PI/90.f, 0, 1, 0) CATransform3D t, CGFloat angle, CGFloat x, CGFloat y, CGFloat z
    //    (m11 = 1, m12 = 0, m13 = -0.034, m14 = 0.00034,
    //     m21 = 0, m22 = 1, m23 = 0, m24 = 0,
    //     m31 = 0.034, m32 = 0, m33 = 1, m34 = -0.01,
    //     m41 = 0, m42 = 0, m43 = 0, m44 = 1)
    
    //    (m11 = 1, m12 = 0, m13 = -0.034, m14 = 0,
    //     m21 = 0, m22 = 1, m23 = 0, m24 = 0,
    //     m31 = 0.034, m32 = 0, m33 = 1, m34 = 0,
    //     m41 = 0, m42 = 0, m43 = 0, m44 = 1)
    
    //    CATransform3DRotate(trans, M_PI/90.f, 0, 0, 1);
    //    (m11 = 1, m12 = 0.034, m13 = 0,  m14 = 0,
    //     m21 = -0.034, m22 = 1, m23 = 0, m24 = 0,
    //     m31 = 0, m32 = 0, m33 = 1,      m34 = 0,
    //     m41 = 0, m42 = 0, m43 = 0,      m44 = 1)
    
    //    (m11 = 1, m12 = 0, m13 = 0, m14 = 0,
    //     m21 = 0, m22 = 1, m23 = 0.034, m24 = 0,
    //     m31 = 0, m32 = -0.034, m33 = 1, m34 = 0,
    //     m41 = 0, m42 = 0, m43 = 0, m44 = 1)
    
    //    CATransform3DTranslate (trans, 20.f,10.f, 15.f) CATransform3D t, CGFloat tx, CGFloat ty, CGFloat tz
    //    (m11 = 1, m12 = 0, m13 = 0, m14 = 0,
    //     m21 = 0, m22 = 1, m23 = 0, m24 = 0,
    //     m31 = 0, m32 = 0, m33 = 1, m34 = -0.01,
    //     m41 = 20, m42 = 10, m43 = 15, m44 = 0.85)
    
    //    CATransform3DScale (trans, 1.2, 1.3, 1.4) CATransform3D t, CGFloat sx, CGFloat sy, CGFloat sz
    //    (m11 = 1.2, m12 = 0, m13 = 0, m14 = 0,
    //     m21 = 0, m22 = 1.3, m23 = 0, m24 = 0,
    //     m31 = 0, m32 = 0, m33 = 1.4, m34 = -0.014,
    //     m41 = 0, m42 = 0, m43 = 0, m44 = 1)
    
    //    CATransform3DRotate(trans, 20*M_PI/180.f, 1, 1, 0)  M_PI/9.0 = 0.348
    //    (m11 = 0.96984631039295421,  m12 = 0.030153689607045779, m13 = -0.24184476264797522, m14 = 0,
    //     m21 = 0.030153689607045779, m22 = 0.96984631039295421,  m23 = 0.24184476264797522, m24 = 0,
    //     m31 = 0.24184476264797522,  m32 = -0.24184476264797522, m33 = 0.93969262078590842, m34 = 0,
    //     m41 = 0, m42 = 0, m43 = 0, m44 = 1)
    
    
    //    (m11 = 0.96615694538829389, m12 = 0.1985366157556234, m13 = -0.16469356114391728, m14 = 0,
    //     m21 = -0.16469356114391728, m22 = 0.96615694538829389, m23 = 0.1985366157556234, m24 = 0,
    //     m31 = 0.1985366157556234, m32 = -0.16469356114391728, m33 = 0.96615694538829389, m34 = 0,
    //     m41 = 0, m42 = 0, m43 = 0, m44 = 1)
    
    //    struct CATransform3D
    //    {
    //        CGFloat m11 = sx,         m12 = angle * z,   m13 = angle * - y,  m14 = 0;
    //        CGFloat m21 = angle * -z, m22 = sy,          m23 = angle * x,    m24 = 0;
    //        CGFloat m31 = angle * y,  m32 = angle * -x,  m33 = sz,           m34 = 0;
    //        CGFloat m41 = tx,         m42 = ty,          m43 = tz,           m44 = 1;
    //    };
    //
    
    //    struct CATransform3D
    //    {
    //        CGFloat m11, m12, m13, m14;
    //        CGFloat m21, m22, m23, m24;
    //        CGFloat m31, m32, m33, m34;
    //        CGFloat m41, m42, m43, m44;
    //    };
    
    //    sin(A+B) = sinAcosB + cosAsinB
    //    sin(A-B) = sinAcosB - cosAsinB
    //    cos(A+B) = cosAcosB - sinAsinB
    //    cos(A-B) = cosAcosB + sinAsinB
    
    
    //    从m11到m44定义的含义如下：
    //
    //    m11：x轴方向进行缩放
    //    m12：和m21一起决定z轴的旋转
    //    m13:和m31一起决定y轴的旋转
    //    m14:
    
    //    m21:和m12一起决定z轴的旋转
    //    m22:y轴方向进行缩放
    //    m23:和m32一起决定x轴的旋转
    //    m24:
    
    //    m31:和m13一起决定y轴的旋转
    //    m32:和m23一起决定x轴的旋转
    //    m33:z轴方向进行缩放
    //    m34:透视效果m34= -1/D，D越小，透视效果越明显，必须在有旋转效果的前提下，才会看到透视效果
    
    //   m41:x轴方向进行平移
    //   m42:y轴方向进行平移
    //   m43:z轴方向进行平移
    //   m44:初始为1
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGRect oldFrame = view.frame;
    view.layer.anchorPoint = anchorPoint;
    view.center = CGPointMake(oldFrame.origin.x + oldFrame.size.width * anchorPoint.x, oldFrame.origin.y + oldFrame.size.height * anchorPoint.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
