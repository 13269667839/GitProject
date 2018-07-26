//
//  ZYPraiseButton.m
//  SouFun
//
//  Created by 张毅 on 2018/7/25.
//

#import "ZYPraiseButton.h"

double const douFangPraiseButton_animateDuration = 1.0f;

double const douFangPraiseButton_ringLayer_beginTime = 0.14f;
double const douFangPraiseButton_ringLayer_animateDuration = 0.3f;
double const douFangPraiseButton_ringLayer_gapDuration = 0.14f;

double const douFangPraiseButton_praise_beginTime = 0.3f;
double const douFangPraiseButton_praise_animateDuration = 0.1f;


//double const douFangPraiseButton_animateDuration = 3.0f;
//double const douFangPraiseButton_ringLayer_animateDuration = 1.5f;
//double const douFangPraiseButton_ringLayer_gapDuration = 0.75f;

double const douFangPraiseButton_ringLayer_radius = 20.0f;

@interface ZYPraiseButton()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *ringLayer;
@property (nonatomic, strong) CAShapeLayer *sRingLayer;

@property (nonatomic, strong) CAShapeLayer *normalPraiseLayer;
@property (nonatomic, strong) CAShapeLayer *praisedLayer;
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *smallBallLayers;

@end

@implementation ZYPraiseButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}



- (void)setUp
{
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.smallBallLayers = [NSMutableArray array];
    [self setImage:[UIImage imageNamed:@"douFang_detail_praise_icon.png"] forState:UIControlStateHighlighted];
    [self configLayer];
}

- (void)configLayer
{
    //环 外圈
    CAShapeLayer *sringLayer = [[CAShapeLayer alloc] init];
    self.sRingLayer = sringLayer;
    
    sringLayer.lineWidth = 0;
    sringLayer.strokeColor = [UIColor clearColor].CGColor;
    sringLayer.fillColor = [UIColor greenColor].CGColor;
    sringLayer.anchorPoint = CGPointMake(0.5, 0.5);
    sringLayer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
    
    UIBezierPath *spath = [UIBezierPath bezierPathWithArcCenter:[self getSelfCenter] radius:douFangPraiseButton_ringLayer_radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    sringLayer.path = [spath CGPath];
    
    [self.layer addSublayer:sringLayer];
    
    //环 里圈
    CAShapeLayer *ringLayer = [[CAShapeLayer alloc] init];
    self.ringLayer = ringLayer;
    
    ringLayer.lineWidth = 0;
    ringLayer.strokeColor = [UIColor clearColor].CGColor;
    ringLayer.fillColor = [UIColor whiteColor].CGColor;
    ringLayer.anchorPoint = CGPointMake(0.5, 0.5);
    ringLayer.transform = CATransform3DMakeScale(0.01, 0.01, 1);

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:[self getSelfCenter] radius:douFangPraiseButton_ringLayer_radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    ringLayer.path = [path CGPath];
    
    [self.layer addSublayer:ringLayer];
 
    //空心赞
    CAShapeLayer *normalPraiseLayer = [[CAShapeLayer alloc] init];
    self.normalPraiseLayer = normalPraiseLayer;
    
    //douFang_detail_praise_icon.png
    normalPraiseLayer.contents = (__bridge id)([UIImage imageNamed:@"esf_xqCollection_btn_n.png"].CGImage);
    normalPraiseLayer.position = [self getSelfCenter];
    normalPraiseLayer.bounds = self.bounds;//CGRectMake(0, 0, CGRectGetWidth(self.bounds) / screenScale, CGRectGetHeight(self.bounds) / screenScale)

    [self.layer addSublayer:normalPraiseLayer];
    
    //实心赞
    CAShapeLayer *praisedLayer = [[CAShapeLayer alloc] init];
    self.praisedLayer = praisedLayer;
    
    praisedLayer.contents = (__bridge id)([UIImage imageNamed:@"esf_xqAlreadyCollection_btn_n.png"].CGImage);
    praisedLayer.position = [self getSelfCenter];
    praisedLayer.bounds = self.bounds;
    praisedLayer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
    
    [self.layer addSublayer:praisedLayer];
    
    //放射小球
    [self.smallBallLayers removeAllObjects];
    for (int i = 0 ; i < 6; i++) {
        CAShapeLayer *smallBallLayer = [[CAShapeLayer alloc] init];
        
        [self.smallBallLayers addObject:smallBallLayer];
        
        double currentAngle = M_PI / 3.0f * (i + 1);
        double anchorPointOffset = CGRectGetWidth(self.bounds) / 2.0f;
       
        smallBallLayer.contents = (__bridge id)([UIImage imageNamed:@"esf_xqAlreadyCollection_btn_n.png"].CGImage);
        smallBallLayer.position = CGPointMake(15 * cos(currentAngle) + anchorPointOffset, 15 * sin(currentAngle) + anchorPointOffset);//[self getSelfCenter];
        smallBallLayer.bounds = CGRectMake(0, 0, 10, 10);
        smallBallLayer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        
        [self.layer addSublayer:smallBallLayer];
    }
}



- (void)animation
{
    double ringBeginTimeOffset = douFangPraiseButton_ringLayer_beginTime;
    double gap = douFangPraiseButton_ringLayer_gapDuration;
    
    //里圈圆
    CABasicAnimation *scale1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale1.fromValue = @0.0f;
    scale1.toValue = @1.0f;
    scale1.duration = douFangPraiseButton_ringLayer_animateDuration - gap;
    scale1.beginTime = CACurrentMediaTime() + gap + ringBeginTimeOffset;
    
    [self.ringLayer addAnimation:scale1 forKey:@"scale1"];
    
    
    CABasicAnimation *position1 = [CABasicAnimation animationWithKeyPath:@"position"];
    
    position1.fromValue=[NSValue valueWithCGPoint:[self getSelfCenter]];
    position1.toValue=[NSValue valueWithCGPoint:CGPointMake(0,0)];
    position1.duration = douFangPraiseButton_ringLayer_animateDuration - gap;
    position1.beginTime = CACurrentMediaTime() + gap + ringBeginTimeOffset;
    
    [self.ringLayer addAnimation:position1 forKey:@"move1"];
    
    
    //外圈圆
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @0.0f;
    scale.toValue = @1.0f;
    scale.duration = douFangPraiseButton_ringLayer_animateDuration;
    scale.beginTime = CACurrentMediaTime() + ringBeginTimeOffset;
    
    [self.sRingLayer addAnimation:scale forKey:@"scale"];
    
    
    CABasicAnimation *position=[CABasicAnimation animationWithKeyPath:@"position"];
    
    position.fromValue=[NSValue valueWithCGPoint:[self getSelfCenter]];
    position.toValue=[NSValue valueWithCGPoint:CGPointMake(0,0)];
    position.duration=douFangPraiseButton_ringLayer_animateDuration;
    position.beginTime = CACurrentMediaTime() + ringBeginTimeOffset;
    
    [self.sRingLayer addAnimation:position forKey:@"move"];
    
    //空心赞变小
    CABasicAnimation *scale2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale2.fromValue = @1.0f;
    scale2.toValue = @0.0f;
    scale2.duration = ringBeginTimeOffset;
    scale2.removedOnCompletion = NO;
    scale2.fillMode = kCAFillModeForwards;
    
    [self.normalPraiseLayer addAnimation:scale2 forKey:@"scale2"];
    
//    CABasicAnimation *position2=[CABasicAnimation animationWithKeyPath:@"position"];
//
//    position2.fromValue=[NSValue valueWithCGPoint:[self getSelfCenter]];
//    position2.toValue=[NSValue valueWithCGPoint:[self getSelfCenter]];
//    position2.duration = ringBeginTimeOffset;
//    position2.removedOnCompletion = NO;
//    position2.fillMode = kCAFillModeForwards;
//
//    [self.normalPraiseLayer addAnimation:position2 forKey:@"move2"];
    

    
    //实心赞变大
    CABasicAnimation *scale3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale3.fromValue = @0.0f;
    scale3.toValue = @1.0f;
    scale3.duration = douFangPraiseButton_praise_animateDuration;
    scale3.beginTime = CACurrentMediaTime() + douFangPraiseButton_praise_beginTime;
    scale3.removedOnCompletion = NO;
    scale3.fillMode = kCAFillModeForwards;
    scale3.delegate = self;
    
    [self.praisedLayer addAnimation:scale3 forKey:@"scale3"];
    
//    CABasicAnimation *position3=[CABasicAnimation animationWithKeyPath:@"position"];
//
//    position3.fromValue=[NSValue valueWithCGPoint:[self getSelfCenter]];
//    position3.toValue=[NSValue valueWithCGPoint:[self getSelfCenter]];
//    position3.duration = douFangPraiseButton_praise_animateDuration;
//    position3.beginTime = CACurrentMediaTime() + douFangPraiseButton_praise_beginTime;
//    position3.removedOnCompletion = NO;
//    position3.fillMode = kCAFillModeForwards;
//
//    [self.praisedLayer addAnimation:position3 forKey:@"move3"];
    
    CFTimeInterval currentMediaTime = CACurrentMediaTime();
    
    //放射小球
    for (int i = 0; i < self.smallBallLayers.count; i ++) {
#warning 时间
        CAShapeLayer *layer = [self.smallBallLayers objectAtIndex:i];
        
        double currentAngle = M_PI / 3.0f * (i + 1);
        double anchorPointOffset = CGRectGetWidth(self.bounds) / 2.0f;
        
        CABasicAnimation *tempPosition=[CABasicAnimation animationWithKeyPath:@"position"];
        
        tempPosition.fromValue=[NSValue valueWithCGPoint:CGPointMake(15 * cos(currentAngle) + anchorPointOffset, 15 * sin(currentAngle) + anchorPointOffset)];
        tempPosition.toValue=[NSValue valueWithCGPoint:CGPointMake(20 * cos(currentAngle) + anchorPointOffset, 20 * sin(currentAngle) + anchorPointOffset)];
        tempPosition.duration = 0.2;
        tempPosition.beginTime = currentMediaTime + douFangPraiseButton_praise_beginTime;
        tempPosition.removedOnCompletion = NO;
        tempPosition.fillMode = kCAFillModeForwards;
        
        [layer addAnimation:tempPosition forKey:@"tempPosition"];
        
//        CABasicAnimation *temprotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//
//        temprotation.fromValue = @(currentAngle);
//        temprotation.toValue = @(currentAngle);
//        temprotation.duration = 0.2;
//        temprotation.beginTime = CACurrentMediaTime() + douFangPraiseButton_praise_beginTime;
//        temprotation.removedOnCompletion = NO;
//        temprotation.fillMode = kCAFillModeForwards;
//        [layer addAnimation:temprotation forKey:@"temprotation"];
        
        CABasicAnimation *tempScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        tempScale.fromValue = @1.0f;
        tempScale.toValue = @0.0f;
        tempScale.duration = 0.1;
        tempScale.beginTime = currentMediaTime + douFangPraiseButton_praise_beginTime + 0.1;
        tempScale.removedOnCompletion = NO;
        tempScale.fillMode = kCAFillModeForwards;
        
        [layer addAnimation:tempScale forKey:@"tempScale"];
    }
    
    
    
    
    //    CAKeyframeAnimation *pathAnimation = [[CAKeyframeAnimation animation] init];
    //CATransform3DMakeScale(0, 0, 0)
    
//    self.ringLayer.transform = CATransform3DMakeScale(0, 1, 1);
    
//    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
//    animation1.fromValue = @(0);
//    animation1.toValue = @(40);
//    animation1.duration = 1.5;
//
//    [self.ringLayer addAnimation:animation1 forKey:@"lineWidth1"];
//
//    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
//    animation2.fromValue = @(40);
//    animation2.toValue = @(0);
//    animation2.duration = 1.5;
//    animation2.timeOffset = 1.5f;
//
//    [self.ringLayer addAnimation:animation2 forKey:@"lineWidth2"];
    
    /*
     [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
     [NSValue valueWithCATransform3D:CATransform3DIdentity]
     */
    

//    CABasicAnimation *smoveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.position"];
//    smoveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-10, -10)];
//    smoveAnimation.toValue = [NSValue valueWithCGPoint:CGPointZero];
//    smoveAnimation.duration = 3;
//    [self.sRingLayer addAnimation:smoveAnimation forKey:@"transform.position"];
    
    
//    CAKeyframeAnimation *spopAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    spopAnimation.duration = 3;
//    spopAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
//                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
//                             [NSValue valueWithCATransform3D:CATransform3DIdentity]];
//    spopAnimation.keyTimes = @[@0.0f,
//                               @0.5f,
//                               @1.0f];
//    spopAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [self.sRingLayer addAnimation:spopAnimation forKey:nil];

//    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    popAnimation.duration = 3;
//    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
//                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
//                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
//    popAnimation.keyTimes = @[@0.0f,
//                              @0.7f,
//                              @1.0f];
//    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
//                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [self.ringLayer addAnimation:popAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
#warning 时间
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.layer.transform = CATransform3DMakeScale(1, 1, 1);
            } completion:^(BOOL finished) {

            }];
        }];
    }];
}

- (CGPoint)getSelfCenter
{
    return CGPointMake(CGRectGetWidth(self.bounds) / 2.0f, CGRectGetHeight(self.bounds) / 2.0f);
}

- (void)onClick
{
    [self animation];
    
//    self.transform = CGAffineTransformIdentity;
//    [UIView animateKeyframesWithDuration:douFangPraiseButton_animateDuration delay:0 options:0 animations: ^{
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
//            self.transform = CGAffineTransformMakeScale(2.0f, 2.0f); // 放大
//        }];
//        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
//            self.transform = CGAffineTransformMakeScale(0.8f, 0.8f); // 放小
//        }];
//        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
//            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
//        }];
//    } completion:nil];
}

@end
