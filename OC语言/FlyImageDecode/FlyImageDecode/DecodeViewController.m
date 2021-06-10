//
//  DecodeViewController.m
//  FlyImageDecode
//
//  Created by Walg on 2021/5/10.
//

#import "DecodeViewController.h"
#import "FlyRenderer.h"
#import "FlyContext.h"
#import "FlyImageIO.h"
#import "FlyCIImage.h"
#import "FlyvImage.h"

@interface DecodeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"↓↓↓↓↓↓↓↓↓↓ <%@> ↓↓↓↓↓↓↓↓↓↓", [self classWithType:_type]);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"↑↑↑↑↑↑↑↑↑↑ <%@> ↑↑↑↑↑↑↑↑↑↑", [self classWithType:_type]);
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(200, 200);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"abcd"];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"abcd" forIndexPath:indexPath];
    
    UIImageView * imageView = [cell.contentView viewWithTag:100];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [cell.contentView addSubview:imageView];
    }
    
    [self imageWithIndex:(int)(indexPath.row) + 1 block:^(UIImage *image) {
        imageView.image = image;
    }];
    
    return cell;
}

- (void)imageWithIndex:(int)index block:(void(^)(UIImage * image))block {
    
    NSString * path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", index] ofType:@"jpeg"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CFTimeInterval begin = CACurrentMediaTime();
        UIImage *decodeImage = [self decodeImageWithPath:path size:CGSizeMake(200, 200)];
        CFTimeInterval end = CACurrentMediaTime();
        NSLog(@"%d %f", index, end - begin);
//        NSLog(@"\n%d\n%f\n%@",index, decodeImage.scale, decodeImage);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (block) {
                block(decodeImage);
            }
        });
    });
}

- (UIImage *)decodeImageWithPath:(NSString *)imagePath size:(CGSize)size {
    
    switch (_type) {
        case 0:
            return [FlyImageDecode imageWithContentsOfFile:imagePath];
            break;
        case 1:
            return [FlyRenderer decodeImageWithPath:imagePath size:size];
            break;
        case 2:
            return [FlyContext decodeImageWithPath:imagePath size:size];
            break;
        case 3:
            return [FlyImageIO decodeImageWithPath:imagePath size:size];
            break;
        case 4:
            return [FlyCIImage decodeImageWithPath:imagePath size:size];
            break;
        case 5:
            return [FlyvImage decodeImageWithPath:imagePath size:size];
            break;
        default:
            break;
    }
    return nil;
}

- (__kindof Class)classWithType:(NSInteger)type {
    
    switch (type) {
        case 0:
            return [FlyImageDecode class];
            break;
        case 1:
            return [FlyRenderer class];
            break;
        case 2:
            return [FlyContext class];
            break;
        case 3:
            return [FlyImageIO class];
            break;
        case 4:
            return [FlyCIImage class];
            break;
        case 5:
            return [FlyvImage class];
            break;
        default:
            break;
    }
    return nil;
}

@end
