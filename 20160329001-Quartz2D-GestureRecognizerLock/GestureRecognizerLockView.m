//
//  GestureRecognizerLockView.m
//  20160329001-Quartz2D-GestureRecognizerLock
//
//  Created by Rainer on 16/3/29.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "GestureRecognizerLockView.h"
#import "LockView.h"

@interface GestureRecognizerLockView ()

@property (nonatomic, weak) LockView *lockView;

@end

@implementation GestureRecognizerLockView

/**
 *  xib解析完成是调用本方法
 */
- (void)awakeFromNib {
    // 1.计算出手势按钮视图的位置大小
    CGFloat lockViewW = self.bounds.size.width;
    CGFloat lockViewH = 350;
    CGFloat lockViewX = 0;
    CGFloat lockViewY = (self.bounds.size.height - lockViewH) * 0.5;
    
    // 2.设置手势锁视图的位置大小
    self.lockView.frame = CGRectMake(lockViewX, lockViewY, lockViewW, lockViewH);
}

/**
 *  懒加载创建一个手势锁视图
 */
- (LockView *)lockView {
    if (nil == _lockView) {
        LockView *lockView = [[LockView alloc] init];
        
        lockView.backgroundColor = [UIColor clearColor];
        
        _lockView = lockView;
        
        [self addSubview:_lockView];
    }
    
    return _lockView;
}

- (void)drawRect:(CGRect)rect {
    UIImage *backgroundImage = [UIImage imageNamed:@"Home_refresh_bg"];
    
    [backgroundImage drawInRect:rect];
}

@end
