//
//  ScheduleObject.h
//  3132helper
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleObject : NSObject


@property(nonatomic,strong)NSString *affairJson;    //事件数组Json
@property(nonatomic,strong)NSString *title;         //日程安排名称
@property(nonatomic,strong)NSString *key;           //日程安排数据列表时传@“Schedule”，关联时间与日程安排时传日程缓存id
@property(nonatomic,assign)int ID;                  //日程安排时可以不传，关联时间与日程安排时传选择日期例：20180808

@end
