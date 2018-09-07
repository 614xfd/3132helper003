//
//  OperationProgressListView.h
//  3132helper
//
//  Created by mac on 2018/9/7.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleObject.h"
@protocol OperationProgressListViewDelegate <NSObject>

- (void)refresh;

@end

@interface OperationProgressListView : UIView
@property (nonatomic, assign)id delegate;


@property (nonatomic, strong)ScheduleObject *scheduleObj;
@property (nonatomic, strong)TDOperator *sqOperator;
@property (nonatomic, strong)NSMutableArray*dataList;

@property (nonatomic, strong)UIView *dustView;                  //蒙尘


- (void)showViewWithData:(ScheduleObject *)obj;
@end
