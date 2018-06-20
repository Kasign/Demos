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
        //        CATransform3D trans = CATransform3DIdentity;
        //        trans.m34 = -1/500.0;
        //        CGFloat angle = 0.2;
        //        trans = CATransform3DRotate(trans, angle, 1, 0, 0);
        //        CATransform3D transForm = CATransform3DMakeRotation(angle, 0, 1, 0);
        //        blockImageView.layer.transform   = CATransform3DConcat(trans, transForm);
        
        CGAffineTransform transform = CGAffineTransformMake(1,1,1,1,1,1);
        blockImageView.transform = transform;
        
        transform = CGAffineTransformMakeRotation(0.22);//绕z旋转
        blockImageView.transform = transform;
    }];
    
    
    
    //    CATransform3DMakeRotation(0.22, 1, 1, 1)
    //    (m11 = 0.9839316328870702,   m12 = 0.1340291151873553,   m13 = -0.11796074807442565, m14 = 0,
    //     m21 = -0.11796074807442565, m22 = 0.9839316328870702,   m23 = 0.1340291151873553,   m24 = 0,
    //     m31 = 0.1340291151873553,   m32 = -0.11796074807442565, m33 = 0.9839316328870702,   m34 = 0,
    //     m41 = 0,                    m42 = 0,                    m43 = 0,                    m44 = 1)
  
    //    CATransform3DMakeRotation(0.22, 1, 1, 0);
    //    (m11 = 0.9879487246653027,   m12 = 0.012051275334697239, m13 = -0.15431164633626698, m14 = 0,
    //     m21 = 0.012051275334697239, m22 = 0.9879487246653027,   m23 = 0.15431164633626698,  m24 = 0,
    //     m31 = 0.15431164633626698,  m32 = -0.15431164633626698, m33 = 0.97589744933060551,  m34 = 0,
    //     m41 = 0,                    m42 = 0,                    m43 = 0,                    m44 = 1)
    
    //    CATransform3DMakeRotation(0.22, 0, 1, 0)
    //    (m11 = 0.97589744933060551, m12 = 0, m13 = -0.21822962308086932, m14 = 0,
    //     m21 = 0,                   m22 = 1, m23 = 0,                    m24 = 0,
    //     m31 = 0.21822962308086932, m32 = 0, m33 = 0.97589744933060551,  m34 = 0,
    //     m41 = 0,                   m42 = 0, m43 = 0,                    m44 = 1)
    
    
    
    //    CATransform3DMakeRotation(0.22, 1, 0, 0)
    //    (m11 = 1, m12 = 0,                    m13 = 0,                   m14 = 0,
    //     m21 = 0, m22 = 0.97589744933060551,  m23 = 0.21822962308086932, m24 = 0,
    //     m31 = 0, m32 = -0.21822962308086932, m33 = 0.97589744933060551, m34 = 0,
    //     m41 = 0, m42 = 0,                    m43 = 0,                   m44 = 1)
    
    //    CATransform3DMakeRotation(0.22, 0, 0, 1);
    //    (m11 = 0.97589744933060551,  m12 = 0.21822962308086932, m13 = 0, m14 = 0,
    //     m21 = -0.21822962308086932, m22 = 0.97589744933060551, m23 = 0, m24 = 0,
    //     m31 = 0,                    m32 = 0,                   m33 = 1, m34 = 0,
    //     m41 = 0,                    m42 = 0,                   m43 = 0, m44 = 1)

    
    //    CATransform3DMakeRotation(0.22, 1, 0, 1);
    //    (m11 = 0.9879487246653027,   m12 = 0.15431164633626698,  m13 = 0.012051275334697239, m14 = 0,
    //     m21 = -0.15431164633626698, m22 = 0.97589744933060551,  m23 = 0.15431164633626698,  m24 = 0,
    //     m31 = 0.012051275334697239, m32 = -0.15431164633626698, m33 = 0.9879487246653027,   m34 = 0,
    //     m41 = 0,                    m42 = 0,                    m43 = 0,                    m44 = 1)
    
    
    
    //    cos(0.22) = 0.97589744933060551
    //    tan(0.22) = 0.22361942151868408
    //    sin(0.22) = 0.21822962308086932
    
    //    sqrt(a) 开平方
    //    pow(a, b) a的b次幂
    
    //    确定版
    //    float u = x/sqrt(x*x + y*y + z*z)//sqrt为开方
    //    falot v = y/sqrt(x*x + y*y + z*z)
    //    float w = z/sqrt(x*x + y*y + z*z)
    //    float θ = angle
    
    //    struct CATransform3D
    //    {
    //        CGFloat m11 = u²+(1-u²)*cosθ,         m12 = uv*(1-cosθ)-w*sinθ,     m13 = uw*(1-cosθ)+v*sinθ,    m14 = 0;
    //        CGFloat m21 = uv*(1-cosθ)+w*sinθ,     m22 = v²+(1-v²)*cosθ,         m23 = vw*(1-cosθ)-u*sinθ,    m24 = 0;
    //        CGFloat m31 = uw*(1-cosθ)-v*sinθ,     m32 = vw*(1-cosθ)+u*sinθ,     m33 = w²+(1-w²)*cosθ,        m34 = 0;
    //        CGFloat m41 = 0,                      m42 = 0,                      m43 = 0,                     m44 = 1;
    //    };
    
    
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
    //    m11: x轴方向进行缩放
    //    m12: 影响x、y、z的切变
    //    m13: 影响x、y、z的切变
    //    m14:
    
    //    m21: 影响x、y、z的切变
    //    m22: y轴方向进行缩放
    //    m23: 影响x、y、z的切变
    //    m24:
    
    //    m31: 影响x、y、z的切变
    //    m32: 影响x、y、z的切变
    //    m33: z轴方向进行缩放
    //    m34: 透视效果m34= -1/D，D越小，透视效果越明显，必须在有旋转效果的前提下，才会看到透视效果
    
    //   m41: x轴方向进行平移
    //   m42: y轴方向进行平移
    //   m43: z轴方向进行平移
    //   m44: 初始为1
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGRect oldFrame = view.frame;
    view.layer.anchorPoint = anchorPoint;
    view.center = CGPointMake(oldFrame.origin.x + oldFrame.size.width * anchorPoint.x, oldFrame.origin.y + oldFrame.size.height * anchorPoint.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
