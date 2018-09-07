//
//  ScheduleListViewController.h
//  3132helper
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleView.h"

@protocol ScheduleListViewControllerDelegate <NSObject>

- (void)refresh;

@end

@interface ScheduleListViewController : UIViewController
@property (nonatomic, assign)id delegate;

@property (nonatomic, assign)NSInteger dateIndex;

@end
