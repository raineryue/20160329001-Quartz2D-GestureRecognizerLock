//
//  LockView.m
//  20160329001-Quartz2D-GestureRecognizerLock
//
//  Created by Rainer on 16/3/29.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "LockView.h"

#define kButtonCount 9
#define kColCount 3
#define kRowCount 3
#define kButtonWH 74

@interface LockView ()

@property (nonatomic, strong) NSMutableArray *selectLockButtonArray;
@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation LockView

/**
 *  根据位置大小创建手势解锁按钮视图
 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 1.循环创建若干个按钮添加到视图上
        for (int i = 0; i < kButtonCount; i++) {
            // 1.1.创建自定义类型的按钮
            UIButton *lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            // 1.2.设置按钮属性
            [lockButton setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            [lockButton setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
            
            // 设置按钮不与用户交互
            lockButton.userInteractionEnabled = NO;
            lockButton.tag = i;
            
            // 1.3.将按钮添加到视图上
            [self addSubview:lockButton];
        }
        
        // 2.创建一个轻扫手势并且添加到本视图上
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        
        [self addGestureRecognizer:panGestureRecognizer];
    }
    
    return self;
}

/**
 *  轻扫手势处理事件
 */
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 1.获取当前滑动的点
    self.currentPoint = [panGestureRecognizer locationInView:self];
    
    // 2.循环判断当前点是否在子视图的按钮中并且是否已选中
    for (UIButton *lockButton in self.subviews) {
        // 2.1.如果当前点是否在子视图的按钮中就设置按钮的状态为选中状态
        if (CGRectContainsPoint(lockButton.frame, self.currentPoint) && !lockButton.selected) {
            // 2.2.设置按钮为选中状态
            lockButton.selected = YES;
            
            // 2.3.将选中的按钮纪录到数组中
            [self.selectLockButtonArray addObject:lockButton];
        }
    }
    
    // 3.判断手势是否结束
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // 3.1.取出设置的手势路径并且取消选中按钮
        NSMutableString *gesturePassword = [NSMutableString string];

        // 此方法在iOS9.3中不可用在此处
//        [self.selectLockButtonArray makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
        
        [self.selectLockButtonArray enumerateObjectsUsingBlock:^(UIButton *lockButton, NSUInteger idx, BOOL *stop) {
            [gesturePassword appendFormat:@"%ld", lockButton.tag ];
            
            lockButton.selected = NO;
        }];
        
        // 3.2.清除选择的线（即清空选中按钮）
        [self.selectLockButtonArray removeAllObjects];
        
        NSLog(@"password:%@", gesturePassword);
    }
    
    // 4.重绘手势拖线
    [self setNeedsDisplay];
}

/**
 *  在本方法中重新布局子视图
 */
- (void)layoutSubviews {
    // 1.获取所有子视图按钮
    NSArray *lockButtonArray = self.subviews;
    
    // 2.定义按钮的大小位置
    CGFloat lockButtonW = kButtonWH;
    CGFloat lockButtonH = kButtonWH;
    CGFloat lockButtonX = 0;
    CGFloat lockButtonY = 0;
    
    // 3.算出按钮的间距
    CGFloat buttonMargin = (self.bounds.size.width - lockButtonW * kColCount) / (kColCount + 1);
    
    // 4.循环设置按钮的大小位置
    for (int i = 0 ; i < lockButtonArray.count; i++) {
        // 4.1.算出当前按钮所处行和列
        int currentCol = i % kColCount;
        int currentRow = i / kRowCount;
        
        // 4.2.获取当前按钮
        UIButton *lockButton = lockButtonArray[i];
        
        // 4.3.计算出当前按钮所处的点
        lockButtonX = buttonMargin + (lockButtonW + buttonMargin) * currentCol;
        lockButtonY = buttonMargin + (lockButtonW + buttonMargin) * currentRow;
        
        // 4.4.重新设置按钮的位置
        lockButton.frame = CGRectMake(lockButtonX, lockButtonY, lockButtonW, lockButtonH);
    }
}

/**
 *  绘制手势滑动线条
 */
- (void)drawRect:(CGRect)rect {
    // 1.当没有选中按钮时不做连线操作
    if (0 == self.selectLockButtonArray.count) return;
    
    // 2.创建一个贝赛尔路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    // 3.如果有选中按钮则循环出所有选中按钮并有顺序的连线
    [self.selectLockButtonArray enumerateObjectsUsingBlock:^(UIButton *lockButton, NSUInteger idx, BOOL *stop) {
        // 3.1.假如当前索引为0的话就为第一个点
        if (0 == idx) {
            [bezierPath moveToPoint:lockButton.center];
        } else {
            // 3.2.其它的则添加连线
            [bezierPath addLineToPoint:lockButton.center];
        }
    }];
    
    [bezierPath addLineToPoint:self.currentPoint];
    
    // 4.设置路径属性
    [[UIColor greenColor] set];
    [bezierPath setLineWidth:3];
    [bezierPath setLineCapStyle:kCGLineCapRound];
    
    // 5.开始画线
    [bezierPath stroke];
}

/**
 *  懒加载初始化选中按钮数组
 */
- (NSMutableArray *)selectLockButtonArray {
    if (nil == _selectLockButtonArray) {
        _selectLockButtonArray = [NSMutableArray array];
    }
    
    return _selectLockButtonArray;
}

@end
