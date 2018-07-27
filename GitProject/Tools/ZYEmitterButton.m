//
//  ZYEmitterButton.m
//  boom
//
//  Created by 张毅 on 2018/7/27.
//  Copyright © 2018年 ZY All rights reserved.
//

#import "ZYEmitterButton.h"

@interface ZYEmitterButton ()

/** weak类型 粒子发射器 */
@property (nonatomic, weak)  CAEmitterLayer *emitterLayer;

@end

@implementation ZYEmitterButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"emitterCell1"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"emitterCell2"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [self configLayer];
    }
    return self;
}

- (void)touchUpInside
{
    self.selected = ! self.selected;
    
    [self touchDownAnimate];
    [self stopFire];
}

- (void)touchDown
{
    // 粒子发射器 发射
    [self startFire];
}

- (void)configLayer
{
    NSMutableArray *cellArr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i ++) {
        
        NSString *cellName = [NSString stringWithFormat:@"zyEmitterCell%d",i];
        
        // 粒子使用CAEmitterCell初始化
        CAEmitterCell *emitterCell   = [CAEmitterCell emitterCell];
        // 粒子的名字,在设置喷射个数的时候会用到
        emitterCell.name             = cellName;
        // 粒子的生命周期和生命周期范围
        emitterCell.lifetime         = 0.7;
        emitterCell.lifetimeRange    = 0.3;
        // 粒子的发射速度和速度的范围
        emitterCell.velocity         = 300.00;
        emitterCell.velocityRange    = 400.00;
        // 粒子的缩放比例和缩放比例的范围
        emitterCell.scale            = 1;//0.1
        emitterCell.scaleRange       = .5;//0.02
        //粒子在发射点可以发射的角度
//        emitterCell.emissionLatitude = - M_PI_2 ;//z轴 
        emitterCell.emissionLongitude = 5 * M_PI_4;//xy轴 北方为 3 * M_PI_2
        emitterCell.emissionRange = M_PI_2 * (1.2);
        // 粒子透明度改变范围
        emitterCell.alphaRange       = 0.10;
        // 粒子透明度在生命周期中改变的速度
        emitterCell.alphaSpeed       = -1.0;
        // 设置粒子的图片
        emitterCell.contents         = (id)[UIImage imageNamed:[NSString stringWithFormat:@"emitterCell%d",i]].CGImage;
        
        [cellArr addObject:emitterCell];
    }
    
    /// 初始化粒子发射器
    CAEmitterLayer *layer        = [CAEmitterLayer layer];
    // 粒子发射器的 名称
    layer.name                   = @"emitterLayer";
    // 粒子发射器的 形状(可以想象成打仗时,你需要的使用的炮的形状)
    //kCAEmitterLayerPoint 点的形状，粒子从一个点发出
    //kCAEmitterLayerLine 线的形状，粒子从一条线发出
    //kCAEmitterLayerRectangle 矩形形状，粒子从一个矩形中发出
    //kCAEmitterLayerCuboid 立方体形状，会影响z平面的效果
    //kCAEmitterLayerCircle 圆形，粒子会在圆形范围发射
    //kCAEmitterLayerSphere 球形
//    layer.emitterShape           = kCAEmitterLayerCircle;
    
    // 粒子发射器 发射的模式
    //kCAEmitterLayerPoints 从发射器中发出
    //kCAEmitterLayerOutline 从发射器边缘发出
    //kCAEmitterLayerSurface 从发射器表面发出
    //kCAEmitterLayerVolumen 从发射器中点发出
    layer.emitterMode            = kCAEmitterLayerOutline;
    // 粒子发射器 中的粒子 (炮要使用的炮弹)
    layer.emitterCells           = cellArr;
    // 定义粒子细胞是如何被呈现到layer中的
    layer.renderMode             = kCAEmitterLayerOldestFirst;
    // 不要修剪layer的边界
    layer.masksToBounds          = NO;
    // z 轴的相对坐标 设置为-1 可以让粒子发射器layer在self.layer下面
    layer.zPosition              = -1;
    
    layer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    // 添加layer
    [self.layer addSublayer:layer];
    _emitterLayer = layer;
}

- (void)touchDownAnimate
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    if (self.selected) {
        animation.values = @[@1.5 ,@0.8, @1.0,@1.2,@1.0];
        animation.duration = 0.5;
    } else {
        animation.values = @[@0.8, @1.0];
        animation.duration = 0.4;
    }
    // 动画模式
    animation.calculationMode = kCAAnimationCubic;
    [self.imageView.layer addAnimation:animation forKey:@"transform.scale"];
}

- (void)startFire
{
    for (int i = 0; i < self.emitterLayer.emitterCells.count; i++) {
        NSString *keyPath = [NSString stringWithFormat:@"emitterCells.zyEmitterCell%d.birthRate",i];
        // 每秒喷射的80个
        [self.emitterLayer setValue:@50 forKeyPath:keyPath];
    }
    
    // 开始
    self.emitterLayer.beginTime = CACurrentMediaTime();
    // 执行停止
    //    [self performSelector:@selector(stopFire) withObject:nil afterDelay:0.1];
    
}

- (void)stopFire
{
    //每秒喷射的个数0个 就意味着关闭了
    for (int i = 0; i < self.emitterLayer.emitterCells.count; i++) {
        NSString *keyPath = [NSString stringWithFormat:@"emitterCells.zyEmitterCell%d.birthRate",i];
        // 每秒喷射的80个
        [self.emitterLayer setValue:@0 forKeyPath:keyPath];
    }
}

//- (void)configLayer
//{
//    // 粒子使用CAEmitterCell初始化
//    CAEmitterCell *emitterCell   = [CAEmitterCell emitterCell];
//    // 粒子的名字,在设置喷射个数的时候会用到
//    emitterCell.name             = @"zyEmitterCell";
//    // 粒子的生命周期和生命周期范围
//    emitterCell.lifetime         = 0.7;
//    emitterCell.lifetimeRange    = 0.3;
//    // 粒子的发射速度和速度的范围
//    emitterCell.velocity         = 300.00;
//    emitterCell.velocityRange    = 400.00;
//    // 粒子的缩放比例和缩放比例的范围
//    emitterCell.scale            = 1;//0.1
//    emitterCell.scaleRange       = .5;//0.02
//
//    // 粒子透明度改变范围
//    emitterCell.alphaRange       = 0.10;
//    // 粒子透明度在生命周期中改变的速度
//    emitterCell.alphaSpeed       = -1.0;
//    // 设置粒子的图片
//    emitterCell.contents         = (id)[UIImage imageNamed:@"1"].CGImage;
//
//    /// 初始化粒子发射器
//    CAEmitterLayer *layer        = [CAEmitterLayer layer];
//    // 粒子发射器的 名称
//    layer.name                   = @"emitterLayer";
//    // 粒子发射器的 形状(可以想象成打仗时,你需要的使用的炮的形状)
//    layer.emitterShape           = kCAEmitterLayerCircle;//
//    // 粒子发射器 发射的模式
//    layer.emitterMode            = kCAEmitterLayerOutline;
//    // 粒子发射器 中的粒子 (炮要使用的炮弹)
//    layer.emitterCells           = @[emitterCell];
//    // 定义粒子细胞是如何被呈现到layer中的
//    layer.renderMode             = kCAEmitterLayerOldestFirst;
//    // 不要修剪layer的边界
//    layer.masksToBounds          = NO;
//    // z 轴的相对坐标 设置为-1 可以让粒子发射器layer在self.layer下面
//    layer.zPosition              = -1;
//
//    layer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
//
//    // 添加layer
//    [self.layer addSublayer:layer];
//    _emitterLayer = layer;
//}
//
//- (void)startFire
//{
//    // 每秒喷射的80个
//    [self.emitterLayer setValue:@1000 forKeyPath:@"emitterCells.zyEmitterCell.birthRate"];
//    // 开始
//    self.emitterLayer.beginTime = CACurrentMediaTime();
//    // 执行停止
//    //    [self performSelector:@selector(stopFire) withObject:nil afterDelay:0.1];
//
//}
//
//- (void)stopFire
//{
//    //每秒喷射的个数0个 就意味着关闭了
//    [self.emitterLayer setValue:@0 forKeyPath:@"emitterCells.zyEmitterCell.birthRate"];
//}



@end
