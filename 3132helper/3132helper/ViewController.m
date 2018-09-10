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

@interface ViewController ()<OperationProgressListViewDelegate,ScheduleListViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)LXCalendarView *calenderView;

@property (nonatomic, strong)ScheduleListViewController *slVC;
@property (nonatomic, strong)ScheduleObject *scheduleObj;
@property (nonatomic, strong)TDOperator *oper;

@property (nonatomic, strong)OperationProgressListView *opListView;


@property (nonatomic, strong)UITableView *calendarTableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
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
    [self creatTabView];
}

- (void)creatNavItem{
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"leftItem"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)creatTabView{
    
    NSArray *allData = [self.oper returnAllData];
    for (ScheduleObject *obj in allData) {
        NSLog(@"%@ -- %d",obj.key,obj.ID);
    }
    
    self.dataArr = [[self.oper findOneWithValue:ScheduleInfo forKey:@"key"] mutableCopy];
    
    self.calendarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height) style:UITableViewStylePlain];
    self.calendarTableView.delegate = self;
    self.calendarTableView.dataSource = self;
    self.calendarTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.calendarTableView];
    self.calendarTableView.hidden = YES;
    
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
        ScheduleObject* obj = (ScheduleObject *)[this.oper findOneWithValue:[NSString stringWithFormat:@"%ld",dateIndex] forKey:@"keyID"].firstObject;
        
        
        if (obj) {//去修改完成度的界面
            [this.opListView showViewWithData:obj];
        }else{//去选择日程的界面
            this.slVC.dateIndex = dateIndex;
            [this.navigationController pushViewController:this.slVC animated:YES];
        }
    };
}

#pragma - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    
    ScheduleObject *obj = self.dataArr[indexPath.row];
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 23)];
    timeLab.text = obj.title;
    [cell.contentView addSubview:timeLab];
    
    CGFloat completeness = 0.0;
    NSString *rcInfo = @"日程安排：";
    NSArray *data = [self stringToJSON:obj.affairJson];
    for (NSDictionary *dic in data) {
        completeness += ([dic[@"completeness"] floatValue] + 0.005) / data.count;
        if (rcInfo.length == 5) {
            rcInfo = [NSString stringWithFormat:@"%@%@",rcInfo,dic[@"name"]];
        }else{
            rcInfo = [NSString stringWithFormat:@"%@、%@",rcInfo,dic[@"name"]];
        }
    }
    
    UILabel *completenessLab = [[UILabel alloc]initWithFrame:CGRectMake(Device_Width - 140, 10, 130, 23)];
    completenessLab.text = [NSString stringWithFormat:@"完成度:%d%@",(int)(completeness * 100),@"%"];
    completenessLab.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:completenessLab];
    
    
    UILabel *infoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + 23 + 10, Device_Width - 10 * 2, 23)];
    infoLab.text = rcInfo;
    [cell.contentView addSubview:infoLab];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScheduleObject *obj = self.dataArr[indexPath.row];
    [self.opListView showViewWithData:obj];
}


- (void)refresh{
    self.dataArr = [[self.oper findOneWithValue:ScheduleInfo forKey:@"key"] mutableCopy];
    [self.calendarTableView reloadData];
    [self.calenderView dealData];
}
- (void)rightItemClick{
    self.slVC.dateIndex = -1;
    [self.navigationController pushViewController:self.slVC animated:YES];
}
- (void)leftItemClick{
    if (self.calendarTableView.isHidden == YES) {
        self.calenderView.hidden = YES;
        self.calendarTableView.hidden = NO;
    }else{
        self.calenderView.hidden = NO;
        self.calendarTableView.hidden = YES;
    }
}



@end
