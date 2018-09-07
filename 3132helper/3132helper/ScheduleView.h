//
//  ScheduleView.h
//  3132helper
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleObject.h"

@protocol ScheduleViewDelegate <NSObject>

- (void)refresh;

- (void)popViewController;
@end

@interface ScheduleView : UIView<UITextFieldDelegate>

@property (nonatomic, strong)UIViewController *superVC;

@property (nonatomic, assign)id delegate;

@property (nonatomic, strong)TDOperator *sqOperator;            //数据库操作者
@property (nonatomic, assign)int cacheID;                       //缓存id
@property (nonatomic, assign)NSInteger dateIndex;               //当未指定日期选择日程安排时需要 （20180907）

@property (nonatomic, strong)UIView *dustView;                  //蒙尘

@property (nonatomic, strong)UIView *selectColorView;           //选择标记颜色视图
@property (nonatomic, assign)int selIndex;                      //标记选择颜色的事件下标

@property (nonatomic, assign)int type;                          //界面类型 1、显示详情 2、新增  3、为指定日期选定日程安排
@property (nonatomic, strong)NSMutableDictionary *data;         //界面数据  {@"title":"工作日安排（周一）",@"affair":[@{@"name":"舞蹈班",@"completeness":@"0.3",@"colour":@"1"},@{@"name":"舞蹈班",@"completeness":@"0.5",@"colour":@"1"}]}


- (id)init;
/**
 显示日程详情
 
 @param type 1、显示日程详情，2、新增日程详情
 @param data 界面数据   新增传nil 或空字典
 
 */
- (void)showViewWithType:(int)type data:(NSDictionary *)data;
@end
