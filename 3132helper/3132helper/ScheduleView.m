//
//  ScheduleView.m
//  3132helper
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "ScheduleView.h"


@implementation ScheduleView
- (id)init{
    if (self = [super init]) {
        self.cacheID = -1;
    }
    return self;
}

/**
 显示日程详情

 @param type 1、显示日程详情，2、新增日程详情
 @param data 界面数据   新增传nil 或空字典

 */
- (void)showViewWithType:(int)type data:(NSDictionary *)data{
    self.type = type;
    if (data) {
        self.data = [data mutableCopy];
    }else{
        self.data = [@{@"affair":@[]}mutableCopy];
    }
    [self creatView];
    [self showView];
    [self refreshViewWithType:type];
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
- (void)showView{
    self.dustView.hidden = NO;
    self.hidden = NO;
}
- (void)hiddenView{
    self.dustView.hidden = YES;
    self.hidden = YES;
}
- (void)refreshViewWithType:(int)type{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    
    
    
    UITextField *titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 20, self.frame.size.width - 50 * 2, 30)];
    titleTextField.tag = 1000;
    titleTextField.textAlignment = NSTextAlignmentCenter;
    titleTextField.placeholder = @"请输入日程标题";
    titleTextField.delegate = self;
    titleTextField.text = self.data[@"title"];
    [self addSubview:titleTextField];
    
    
    CGFloat fY = 0;
    NSArray *affair = self.data[@"affair"];
    
    
    NSDictionary *dic = affair.lastObject;
    NSString *name = dic[@"name"];
    BOOL isFinish = name.length >= 1?YES:NO || affair.count == 0;
    
    for (int i = 0; i < (type == 1 || !isFinish? affair.count:affair.count + 1); i ++) {
        NSDictionary *dict = @{};
        if (affair.count > i) {
            dict = affair[i];
        }
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 20 + 30 +20 + (30 + 10) * i, self.frame.size.width - 20 * 2 - 50, 30)];
        fY = textField.frame.origin.y;
        textField.tag = 100 + i;
        textField.delegate = self;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.placeholder = @"请输入事件标题";
        textField.text = dict[@"name"];
        [self addSubview:textField];
        
        UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        colorBtn.imageEdgeInsets = UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5);
        
        [colorBtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        colorBtn.frame = CGRectMake(textField.frame.size.width + textField.frame.origin.x + 10, textField.frame.origin.y, 30, 30);
        colorBtn.layer.cornerRadius = colorBtn.frame.size.width / 2.0;
        colorBtn.imageView.layer.cornerRadius = 7.5;
        if (affair.count > i) {
            [colorBtn setImage:[self createImageWithColor:ColorList[[dict[@"colour"] intValue]]] forState:UIControlStateNormal];
        }else{
            [colorBtn setImage:[self createImageWithColor:ColorList[i]] forState:UIControlStateNormal];
        }
        colorBtn.tag = 1000 + i;
        [self addSubview:colorBtn];
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
    
    CGFloat H = 20 + 30 + 20 + (30 + 10) * (type == 1 || !isFinish? affair.count:affair.count + 1) + 10 + 50;
    self.frame = CGRectMake(5, (Device_Height - H) / 2.0, self.frame.size.width, H);
}
- (UIImage*) createImageWithColor: (UIColor*) color
{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

- ( void )textFieldDidEndEditing:( UITextField *)textField{
    if (textField.tag == 1000) {//标题
        self.data[@"title"] = textField.text;
        return;
    }
    
    NSMutableArray *affair = [self.data[@"affair"] mutableCopy];
    if (textField.tag - 100 < affair.count) {
        NSMutableDictionary *dict = [affair[textField.tag - 100] mutableCopy];
        [dict setObject:textField.text forKey:@"name"];
        [affair setObject:dict atIndexedSubscript:textField.tag - 100];

        self.data[@"affair"] = affair;
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:textField.text forKey:@"name"];
        [dict setObject:@"0" forKey:@"completeness"];
        [dict setObject:[NSString stringWithFormat:@"%ld",textField.tag - 100] forKey:@"colour"];
        [affair addObject:dict];
        self.data[@"affair"] = affair;
        [self refreshViewWithType:2];
    }
    
}
- (void)colorBtnClick:(UIButton *)btn{
    self.selIndex = (int)btn.tag - 1000;
    [self showSelectColorView];
}
- (void)showSelectColorView{
    if (!self.selectColorView) {
        self.selectColorView = [[UIView alloc]initWithFrame:CGRectMake(Device_Width - 50, (Device_Height - 30 * ColorList.count) / 2.0, 40, 30 * ColorList.count)];
        for (int i = 0; i < ColorList.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = ColorList[i];
            btn.tag = 100 + i;
            btn.frame = CGRectMake(0, 30 * i, 40, 30);
            [btn addTarget:self action:@selector(selectColorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.selectColorView addSubview:btn];
            self.selectColorView.hidden = YES;
            
            UIView *v = [UIApplication sharedApplication].keyWindow;
            [v addSubview:self.selectColorView];
        }
    }
    self.selectColorView.hidden = NO;
}

- (void)selectColorBtnClick:(UIButton *)btn{
    NSMutableArray *affair = [self.data[@"affair"] mutableCopy];
    if (self.selIndex < affair.count) {
        NSMutableDictionary *dict = [affair[self.selIndex] mutableCopy];
        [dict setObject:[NSString stringWithFormat:@"%ld",btn.tag - 100] forKey:@"colour"];
        [affair setObject:dict atIndexedSubscript:self.selIndex];
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"" forKey:@"name"];
        [dict setObject:@"0" forKey:@"completeness"];
        [dict setObject:[NSString stringWithFormat:@"%ld",btn.tag - 100] forKey:@"colour"];
        [affair addObject:dict];
    }
    self.data[@"affair"] = affair;
    [self refreshViewWithType:2];
    self.selectColorView.hidden = YES;
//    self.selIndex = -1;
}

- (void)closeBtnClick{
    [self hiddenView];
}
- (void)checkBtnClick{
    NSArray *affair = self.data[@"affair"];
    if (affair.count < 1) {
        return;
    }
    
    if (self.type == 3) {
        UIAlertController* ui=[UIAlertController alertControllerWithTitle:@"提示" message:@"选定日程安排将无法更改，是否确定" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
            self.cacheID = -1;
        }];
        UIAlertAction* other=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
           
            //创建sqlite模型类
            ScheduleObject *cacheModel = [[ScheduleObject alloc]init];
            //通过模型生产操作者
            
            if (!self.sqOperator) {
                self.sqOperator = [TDOperator instanceWhithModel:cacheModel];
            }

            NSArray *affair = self.data[@"affair"];
            cacheModel.affairJson = [self getJson:affair];
            cacheModel.title = [NSString stringWithFormat:@"%ld月%ld号 -%ld",self.dateIndex % 10000 / 100,self.dateIndex % 100,self.dateIndex / 10000];
            cacheModel.key = ScheduleInfo;
            cacheModel.keyID = (int)self.dateIndex;
            
            [self.sqOperator insertWithModel:cacheModel];
            self.cacheID = -1;
            
            [self.delegate popViewController];
        }];
        
        
        [ui addAction:cancel];
        
        [ui addAction:other];
        
        [self.superVC presentViewController:ui animated:YES completion:nil];
        
        if (self.cacheID < 0) {
            [self finishSave];
        }
        
        [self hiddenView];
    }else{
        [self finishSave];
    }
}

- (void)finishSave{
    //创建sqlite模型类
    ScheduleObject *cacheModel = [[ScheduleObject alloc]init];
    //通过模型生产操作者
    
    if (!self.sqOperator) {
        self.sqOperator = [TDOperator instanceWhithModel:cacheModel];
    }
    NSArray *affair = self.data[@"affair"];
    cacheModel.affairJson = [self getJson:affair];
    cacheModel.title = self.data[@"title"];
    cacheModel.key = ScheduleList;
    if (self.cacheID >= 0) {
        [self.sqOperator deleteWithPrimary:self.cacheID];
        if (self.type == 1) {
            self.cacheID = -1;
        }
    }
    
    [self.sqOperator insertWithModel:cacheModel];

    
    [self hiddenView];
    [self.delegate refresh];
}


- (UIViewController *)viewControllerSupportView:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}




@end
