//
//  OperationProgressListView.m
//  3132helper
//
//  Created by mac on 2018/9/7.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "OperationProgressListView.h"

@implementation OperationProgressListView


- (void)showViewWithData:(ScheduleObject *)obj{
    self.scheduleObj = obj;
    self.dataList = [[self stringToJSON:obj.affairJson] mutableCopy];
    [self creatView];
    [self refreshView];
    [self showView];
}

- (void)creatView{
    if (!self.dustView) {
        UIView *v = [UIApplication sharedApplication].keyWindow;
        
        
        self.dustView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height)];
        self.dustView.backgroundColor = [UIColor blackColor];
        self.dustView.alpha = 0.4;
        self.dustView.hidden = YES;
        [v addSubview:self.dustView];
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(5, (Device_Height - 200) / 2.0, Device_Width - 5 * 2, 200);
        self.hidden = YES;
        [v addSubview:self];
    }
}
- (void)refreshView{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, self.frame.size.width - 50 * 2, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = self.scheduleObj.title;
    [self addSubview:titleLab];
    
    
    CGFloat fY = 0;
    NSArray *affair = self.dataList;
    
    
    
    
    for (int i = 0; i < affair.count; i ++) {
        NSDictionary *dict = affair[i];
        CGRect rc = CGRectMake(20, titleLab.frame.size.height + titleLab.frame.origin.y + 20 + (10 + 30) * i, self.frame.size.width - 20 * 2, 30);
        
        
        UIView *bView = [[UIView alloc]initWithFrame:rc];
        bView.tag = 1000 + i;
        bView.clipsToBounds = YES;
        bView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        bView.layer.cornerRadius = bView.frame.size.height / 2.0;
        [self addSubview:bView];
        fY = bView.frame.origin.y;
        
        
        UIView *scheduleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rc.size.width * [dict[@"completeness"] floatValue], rc.size.height)];
        scheduleView.tag = 123;
        scheduleView.clipsToBounds = YES;
        scheduleView.backgroundColor = ColorList[[dict[@"colour"] intValue]];
        [bView addSubview:scheduleView];
        
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rc.size.width, rc.size.height)];
        lab.clipsToBounds = YES;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = dict[@"name"];
        lab.textColor = [UIColor grayColor];
        [bView addSubview:lab];
        
        
        
        
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(self.frame.size.width - 40 , 0, 40, 40);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    checkBtn.frame = CGRectMake(( self.frame.size.width - 50) / 2.0, fY + 30 + 10, 50, 50);
    [self addSubview:checkBtn];
    
    CGFloat H = 20 + 30 + 20 + (30 + 10) *  affair.count + 10 + 50;
    self.frame = CGRectMake(5, (Device_Height - H) / 2.0, self.frame.size.width, H);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    for (int i = 0; i < self.dataList.count; i++) {
        NSMutableDictionary *dic = [self.dataList[i] mutableCopy];
        UIView *v = [self viewWithTag:1000 + i];
        if (CGRectContainsPoint(v.frame, point)) {
            UIView *scheduleView = [v viewWithTag:123];
            CGPoint point1 = [[touches anyObject] locationInView:v];
            [UIView animateWithDuration:0.1 animations:^{
                scheduleView.frame = CGRectMake(scheduleView.frame.origin.x, scheduleView.frame.origin.y, point1.x, scheduleView.frame.size.height);
            }];
            dic[@"completeness"] = [NSString stringWithFormat:@"%f",point1.x /v.frame.size.width];
            [self.dataList replaceObjectAtIndex:i withObject:dic];
            return;
        }
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    for (int i = 0; i < self.dataList.count; i++) {
        NSMutableDictionary *dic = [self.dataList[i] mutableCopy];
        UIView *v = [self viewWithTag:1000 + i];
        if (CGRectContainsPoint(v.frame, point)) {
            
            UIView *scheduleView = [v viewWithTag:123];
            CGPoint point1 = [[touches anyObject] locationInView:v];
            scheduleView.frame = CGRectMake(scheduleView.frame.origin.x, scheduleView.frame.origin.y, point1.x, scheduleView.frame.size.height);
            dic[@"completeness"] = [NSString stringWithFormat:@"%f",point1.x / v.frame.size.width];
            [self.dataList replaceObjectAtIndex:i withObject:dic];
            return;
        }
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    for (int i = 0; i < self.dataList.count; i++) {
        NSMutableDictionary *dic = [self.dataList[i] mutableCopy];
        UIView *v = [self viewWithTag:1000 + i];
        if (CGRectContainsPoint(v.frame, point)) {
            CGPoint point1 = [[touches anyObject] locationInView:v];
            dic[@"completeness"] = [NSString stringWithFormat:@"%f",point1.x / v.frame.size.width];
            [self.dataList replaceObjectAtIndex:i withObject:dic];
            return;
        }
    }
}



- (void)showView{
    self.dustView.hidden = NO;
    self.hidden = NO;
}
- (void)hiddenView{
    self.dustView.hidden = YES;
    self.hidden = YES;
}
- (void)closeBtnClick{
  [self hiddenView];
}
- (void)checkBtnClick{
    [self hiddenView];
    
    if (!self.sqOperator) {
        self.sqOperator = [TDOperator instanceWhithModel:self.scheduleObj];
    }
    
    self.scheduleObj.affairJson = [self getJson:self.dataList];
    [self.sqOperator deleteWithPrimary:self.scheduleObj.ID];
    [self.sqOperator insertWithModel:self.scheduleObj];
    [self.delegate refresh];
}


@end
