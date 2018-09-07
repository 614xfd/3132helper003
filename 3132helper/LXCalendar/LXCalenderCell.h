//
//  LXCalenderCell.h
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXCalendarDayModel.h"
#import "ScheduleView.h"

@interface LXCalenderCell : UICollectionViewCell

@property(nonatomic,strong)LXCalendarDayModel *model;

@property(nonatomic,strong)ScheduleObject *scheduleObj;
@end
