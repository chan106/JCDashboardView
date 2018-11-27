//
//  JCDashboardView.m
//  DashboardView
//
//  Created by Chan on 2018/10/19.
//  Copyright © 2018 Chan. All rights reserved.
//

#import "JCDashboardView.h"

@interface JCDashboardView ()

@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *shapeLayers;
@property (nonatomic, strong) CAShapeLayer *pointLayer;
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, assign) CGFloat arc;

@end

@implementation JCDashboardView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)draw{
    for (CAShapeLayer *layer in self.shapeLayers) {
        [layer removeFromSuperlayer];
    }
    [self.shapeLayers removeAllObjects];
    [self drawLine:0];
    [self drawPointLayer];
}

- (void)drawLine:(NSInteger) index{
    __block NSInteger t = index;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addLineWithIndex:index];
        t++;
        if (index < 36) {
            [self drawLine:t];
        }else{
        }
    });
}

- (void)addLineWithIndex:(NSInteger ) index{
    CGFloat boldRadio = 0.86;//【大刻度 粗线】 线的起点到坐标原点的距离 / 线长
    CGFloat thinRadio = 0.95;//【小刻度 细线】 线的起点到坐标原点的距离 / 线长
    CGFloat L = self.frame.size.width * 0.5 - 10;
    CGFloat arc = 5*(index / 180.0 * M_PI);
    CGFloat sinA = sin(arc);
    CGFloat cosA = cos(arc);
    CGFloat startY = sinA * L * ((index%2)?thinRadio:boldRadio);
    CGFloat startX = cosA * L * ((index%2)?thinRadio:boldRadio);
    CGFloat endY = sinA * L;
    CGFloat endX = cosA * L;
    CGPoint startPoint = CGPointMake(0.5 * self.frame.size.width - startX, 0.5 * self.frame.size.height - startY);
    CGPoint endPoint = CGPointMake(0.5 * self.frame.size.width - endX, 0.5 * self.frame.size.height - endY);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path closePath];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineWidth = ((index%2)?1:3);
    shapeLayer.strokeColor = [UIColor colorWithRed:0.5 green:0.3 blue:index/36.0*1 alpha:1].CGColor;
    shapeLayer.path = path.CGPath;
    shapeLayer.lineCap = kCALineCapSquare;
    [self.layer addSublayer:shapeLayer];
    [self.shapeLayers addObject:shapeLayer];
}

- (void)drawPointLayer{
    _pointView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 5, 0, 10, self.frame.size.height)];
    _pointView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    [self addSubview:_pointView];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(_pointView.frame.size.width * 0.5, _pointView.frame.size.height)
                    radius:10
                startAngle:0
                  endAngle:2 * M_PI
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(_pointView.frame.size.width * 0.5, _pointView.frame.size.height * 0.5 + 35)];
    [path addLineToPoint:CGPointMake(_pointView.frame.size.width * 0.5 - 10, _pointView.frame.size.height)];
//    [path closePath];
    _pointLayer = [[CAShapeLayer alloc] init];
    _pointLayer.lineWidth = 3;
    _pointLayer.strokeColor = [UIColor whiteColor].CGColor;
    _pointLayer.path = path.CGPath;
    _pointLayer.lineCap = kCALineCapSquare;
    [_pointView.layer addSublayer:_pointLayer];
    _pointView.layer.anchorPoint = CGPointMake(0.5, 1);
    _arc = -0.5 * M_PI;
    self.pointView.transform = CGAffineTransformRotate(self.pointView.transform, _arc);
}

- (void)setProgress:(CGFloat)progress{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1;
    animation.repeatCount = 1;
    animation.fromValue = [NSNumber numberWithFloat:_arc];
    _arc += (progress - _progress) * M_PI;
    animation.toValue = [NSNumber numberWithFloat:_arc];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_pointView.layer addAnimation:animation forKey:@"rotate-layer"];
    _progress = progress;
}

#pragma mark - Setter & Getter
- (NSMutableArray<CAShapeLayer *> *)shapeLayers{
    if (_shapeLayers == nil) {
        _shapeLayers = [NSMutableArray array];
    }
    return _shapeLayers;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
