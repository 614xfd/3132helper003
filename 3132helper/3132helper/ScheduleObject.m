//
//  ScheduleObject.m
//  3132helper
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 DAA. All rights reserved.
//

#import "ScheduleObject.h"

@implementation ScheduleObject

- (NSDictionary *)getTableInstance{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingString:@"/cache.sqlite"];
    
    
    return @{@"tableName":@"firstCache",@"tablePath":path};
}
@end
