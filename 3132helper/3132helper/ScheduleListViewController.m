//
//  ScheduleListViewController.m
//  3132helper
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "ScheduleListViewController.h"



@interface ScheduleListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tabView;
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)ScheduleView *scheduleView;
@property (nonatomic, strong)TDOperator *oper;
@end

@implementation ScheduleListViewController

- (void)viewDidLoad {
    self.title = @"日程列表";
    [super viewDidLoad];
    //创建sqlite模型类
    ScheduleObject *cacheModel = [[ScheduleObject alloc]init];
    if (!self.oper) {
        self.oper = [TDOperator instanceWhithModel:cacheModel];
    }

    
    // Do any additional setup after loading the view from its nib.
    self.scheduleView = [[ScheduleView alloc]init];
    self.scheduleView.superVC = self;
    self.scheduleView.delegate = self;
    [self creatTabView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataArr = [[self.oper findOneWithValue:ScheduleList forKey:@"key"] mutableCopy];
    self.scheduleView.dateIndex = self.dateIndex;
    [self.tabView reloadData];
}
- (void)refresh{
    self.dataArr = [[self.oper findOneWithValue:ScheduleList forKey:@"key"] mutableCopy];
    [self.tabView reloadData];
}

- (void)creatTabView{
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Device_Width, Device_Height) style:UITableViewStylePlain];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.tableFooterView = [UIView new];
    [self.view addSubview:self.tabView];
}

#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row < self.dataArr.count) {
        ScheduleObject *cacheModel = self.dataArr[indexPath.row];
        cell.textLabel.text = cacheModel.title;
    }else{
        cell.textLabel.text = @"新建日程";
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataArr.count) {
        ScheduleObject *cacheModel = self.dataArr[indexPath.row];
        NSDictionary *dict = @{@"title":cacheModel.title,@"affair":[NSObject dictionaryWithJsonString:cacheModel.affairJson]};
        self.scheduleView.cacheID = cacheModel.ID;
        [self.scheduleView showViewWithType:self.dateIndex > 1 ? 3 : 1 data:dict];
    }else{
        [self.scheduleView showViewWithType:self.dateIndex > 1 ? 3 : 2 data:nil];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.dataArr.count > indexPath.row) {
            ScheduleObject *cacheModel = self.dataArr[indexPath.row];
            [self.oper deleteWithPrimary:cacheModel.ID];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.tabView reloadData];
        }
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)popViewController{
    [self.delegate refresh];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc{
    NSLog(@"dealloc");
}


@end
