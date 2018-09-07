//
//  ViewController.m
//  3132helper
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "ViewController.h"
#import "LXCalender.h"
#import "ScheduleListViewController.h"
#import "OperationProgressListView.h"

@interface ViewController ()<OperationProgressListViewDelegate,ScheduleListViewControllerDelegate>
@property(nonatomic,strong)LXCalendarView *calenderView;

@property (nonatomic, strong)ScheduleListViewController *slVC;
@property (nonatomic, strong)ScheduleObject *scheduleObj;
@property (nonatomic, strong)TDOperator *oper;

@property (nonatomic, strong)OperationProgressListView *opListView;
@end

@implementation ViewController

- (void)viewDidLoad {
    self.title = @"主页";
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.slVC = [[ScheduleListViewController alloc]init];
    self.slVC.delegate = self;
    self.opListView = [[OperationProgressListView alloc]init];
    self.opListView.delegate = self;
    
    ScheduleObject *cacheModel = [[ScheduleObject alloc]init];
    if (!self.oper) {
        self.oper = [TDOperator instanceWhithModel:cacheModel];
    }
    [self creatNavItem];
    [self creatCalenderView];
    
}

- (void)creatNavItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)creatCalenderView{
    self.view.backgroundColor =[UIColor whiteColor];
    
    
    self.calenderView =[[LXCalendarView alloc]initWithFrame:CGRectMake(20, 80, Device_Width - 40, 0)];
    
    self.calenderView.currentMonthTitleColor =[UIColor hexStringToColor:@"2c2c2c"];
    self.calenderView.lastMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    self.calenderView.nextMonthTitleColor =[UIColor hexStringToColor:@"8a8a8a"];
    
    self.calenderView.isHaveAnimation = YES;
    
    self.calenderView.isCanScroll = NO;
    
    self.calenderView.isShowLastAndNextBtn = YES;
    
    self.calenderView.isShowLastAndNextDate = YES;
    
    self.calenderView.todayTitleColor =[UIColor purpleColor];
    
    self.calenderView.selectBackColor =[UIColor blueColor];
    
    self.calenderView.backgroundColor =[UIColor whiteColor];
    
    
    [self.calenderView dealData];
    
    [self.view addSubview:self.calenderView];
    
    
    __block ViewController *this = self;
    self.calenderView.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%ld年 - %ld月 - %ld日",year,month,day);
        NSLog(@"%ld",year * 10000 + month * 100 + day);
        NSInteger dateIndex = year * 10000 + month * 100 + day;
        ScheduleObject* obj = (ScheduleObject *)[this.oper findOneWithPrimaryId:dateIndex];
        if (obj) {//去修改完成度的界面
            [this.opListView showViewWithData:obj];
        }else{//去选择日程的界面
            this.slVC.dateIndex = dateIndex;
            [this.navigationController pushViewController:this.slVC animated:YES];
        }
    };
}

- (void)refresh{
    NSArray *data = [self.oper returnAllData];
    for (ScheduleObject *obj in data) {
        NSLog(@"%d,%@,%@,%@",obj.ID,obj.key,obj.title,obj.affairJson);
    }
    
    [self.calenderView dealData];
}
- (void)rightItemClick{
    [self.navigationController pushViewController:self.slVC animated:YES];
}

@end
