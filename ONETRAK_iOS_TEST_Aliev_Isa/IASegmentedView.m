//
//  IASegmentedView.m
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import "IASegmentedView.h"
#import "Constants.h"

double const leftMargin = 8;
double const topMargin = 4;
double const separationWidth = 4;

@interface IASegmentedView ()

@property (strong, nonatomic) CAShapeLayer* maskLayer;
@property (assign, nonatomic) BOOL isRevealed;

@end

@implementation IASegmentedView

#pragma mark Drawing
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (_percentageArray) {
        
        // Определеяем толщину линий
        double lineHeight = CGRectGetHeight(rect)-topMargin*2;
        
        // Создаем массив точек, первым элементом которого ставим верхнюю левую точку первого прямоугольника
        CGPoint initialPoint = CGPointMake(leftMargin, topMargin);
        NSMutableArray* points = [NSMutableArray array];
        [points addObject:[NSValue valueWithCGPoint:initialPoint]];
        
        // Определяем "чистую" ширину, которую будем распрделять между прямоугольниками в соответствии с процентами
        double netWidth = rect.size.width - 2*leftMargin - (self.percentageArray.count-1)*separationWidth;
        
        // Запускаем цикл для определения верхних левых точек каждого следующего прямоугольника и заполняем массив
        for (int i = 0; i < self.percentageArray.count - 1; i++) {
            NSNumber* joint = [self.percentageArray objectAtIndex:i];
            double singleLineWidth = netWidth*joint.doubleValue;
            CGPoint lastPoint = ((NSValue*)points.lastObject).CGPointValue;
            CGPoint newPoint = CGPointMake(lastPoint.x+singleLineWidth+separationWidth, lastPoint.y);
            [points addObject:[NSValue valueWithCGPoint:newPoint]];
        }
        
        // Добавляем последнюю точку, являющейся правой верхней точкой последнего прямоугольника
        CGPoint lastPoint = CGPointMake(CGRectGetMaxX(rect)-leftMargin, topMargin);
        [points addObject:[NSValue valueWithCGPoint:lastPoint]];
        
        // Циклично рисуем каждый прямоугольник
        for (int i = 0; i < points.count-1; i++) {
            
            CGPoint startPoint = ((NSValue*)[points objectAtIndex:i]).CGPointValue;
            CGPoint endPoint = ((NSValue*)[points objectAtIndex:i+1]).CGPointValue;
            CGPoint correctedPoint = CGPointMake(endPoint.x-separationWidth, endPoint.y);
            
            UIRectCorner corners = 0;
            
            // Если прямоугольник первый или последний - закругляем соответсвующие углы
            if (i == 0) {
                corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            } else if (i == points.count-2) {
                corners = UIRectCornerTopRight | UIRectCornerBottomRight;
            }
            
            CGRect rect = CGRectMake(startPoint.x, startPoint.y, correctedPoint.x-startPoint.x, lineHeight);
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(lineHeight/2, lineHeight/2)];
            UIColor* fillColor = [self.colors objectAtIndex:i];
            
            [fillColor setFill];
            [rectanglePath fill];
            
        }
    }
    
}

#pragma mark LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isRevealed = NO;
        self.colors = @[walkColor, aerobicColor, runColor];
        [self configure];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.maskLayer.path =  _isRevealed ? [self maskRevealedPath].CGPath : [self maskUnrevealedRectanglePath].CGPath;
    
}

-(void)configure{
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    
    self.layer.mask = maskLayer;
    self.maskLayer = maskLayer;
    
}

#pragma mark Setters

// При изменении этих полей, перерисовываем view
-(void)setPercentageArray:(NSArray *)percentageArray {
    _percentageArray = percentageArray;
    [self setNeedsDisplay];
}

-(void)setColors:(NSArray *)colors{
    _colors = colors;
    [self setNeedsDisplay];
}

#pragma mark Animation

- (void)revealAnimated:(BOOL)animated {
    
    UIBezierPath* toPath = [self maskRevealedPath];
    
    if (animated) {
    
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"path"];
        
        animation.duration = SegmentedViewRevealAnimationDuration;
        animation.fromValue = (__bridge id _Nullable)([self maskUnrevealedRectanglePath].CGPath);
        animation.toValue = (__bridge id _Nullable)(toPath.CGPath);
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.maskLayer.path = toPath.CGPath;
        [CATransaction commit];
        
        [self.maskLayer addAnimation:animation forKey:@"anime"];

    } else {
        
        self.maskLayer.path = toPath.CGPath;
        
    }
    
    self.isRevealed = YES;
}

-(UIBezierPath*)maskUnrevealedRectanglePath {
    return  [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds))];
}

-(UIBezierPath*)maskRevealedPath {
    return  [UIBezierPath bezierPathWithRect:self.bounds];
}


@end
