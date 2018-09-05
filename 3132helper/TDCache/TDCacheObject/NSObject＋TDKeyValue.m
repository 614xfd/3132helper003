//
//  NSObject＋TDKeyValue.m
//  TDCacheFMDB
//
//  Created by DAA on 16/3/24.
//  Copyright © 2016年 DAA. All rights reserved.
//

#import "NSObject＋TDKeyValue.h"
#import <objc/runtime.h>

@implementation NSObject(TDKeyValue)


- (NSDictionary *)objectClassInArray{
    return @{};
}



- (void)setAttributes:(NSDictionary *)dataDic obj:(id)object{
    NSDictionary *objectClassInDict =  (NSDictionary *)[object performSelector:NSSelectorFromString(@"objectClassInArray") withObject:nil];
    
    unsigned int outCount;
    objc_property_t *propertys = class_copyPropertyList([object class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        const char *char_f = property_getName(propertys[i]);
        NSString *properyName = [NSString stringWithUTF8String:char_f];
        
        objc_property_t property = propertys[i];
        const char *charProperty = property_getAttributes(property);
        NSString *propertyType = [NSString stringWithUTF8String:charProperty];
        
        
        
        if ([propertyType rangeOfString:@"NSString"].location != NSNotFound) {//设置字符串的默认值
            SEL setSel = [self creatSetWithPropertyName:properyName];
            [object performSelectorOnMainThread:setSel withObject:@"" waitUntilDone:YES];
            
        }
        
        
        [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:properyName] || [[NSString stringWithFormat:@"%@_mStr",key]isEqualToString:properyName]) {
                if ([[dataDic objectForKey:key] isKindOfClass:[NSDictionary class]]||[[dataDic objectForKey:key]isKindOfClass:[NSArray class]]) {
                    
                    if ([[dataDic objectForKey:key]isKindOfClass:[NSArray class]]){
                        
                        NSMutableArray *arr = [NSMutableArray array];
                        NSMutableArray *dataArr = [dataDic objectForKey:key];
                        NSString *classNameStr = [objectClassInDict objectForKey:key];
                        for (int i = 0 ; i < dataArr.count; i ++) {
                            
                            id objc = [[NSClassFromString(classNameStr) alloc]init];
                            if (!objc) {
                                break;
                            }
                            [arr addObject:objc];
                        }
                        
                        for (int i = 0; i < outCount; i++) {
                            
                            const char *char_f = property_getName(propertys[i]);
                            NSString *properyName = [NSString stringWithUTF8String:char_f];
                            
                            
                            if ([key isEqualToString:properyName]) {
                                
                                [object setValue:arr forKey:properyName];
                                [self dealWithObjArr:arr DataArr:dataArr];
                                
                                break;
                            }
                        }
                        
                        
                        
                    }else if ([[dataDic objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                        
                        id objc = [[NSClassFromString(key) alloc]init];
                        
                        
                        for (int i = 0; i < outCount; i++) {
                            
                            const char *char_f = property_getName(propertys[i]);
                            NSString *properyName = [NSString stringWithUTF8String:char_f];
                            
                            
                            if ([key isEqualToString:properyName]) {
                                
                                [object setValue:objc forKey:properyName];
                                [self setAttributes:[dataDic objectForKey:key] obj:objc];
                                
                                break;
                            }
                        }
                        
                        [object setValue:objc forKey:properyName];
                        [self setAttributes:[dataDic objectForKey:key] obj:objc];
                    }
                }else{
                    if ([dataDic objectForKey:key]) {
                        [object setValue:[dataDic objectForKey:key] forKey:properyName];
                        
                    }
                    
                    
                }
            }
            if ([properyName isEqualToString:@"ID"] && [key isEqualToString:@"id"]) {
                [object setValue:[dataDic objectForKey:key] forKey:properyName];
            }
            
        }];
    }
}
- (void)dealWithObjArr:(NSArray *)objs DataArr:(NSArray *)dataArr{
    
    for (int num = 0; num < objs.count; num ++) {
        id obj = [objs objectAtIndex:num];
        NSDictionary *dataDict = [dataArr objectAtIndex:num];
        [self setAttributes:dataDict obj:obj];
    }
}
+ (NSArray *)modelsWithList:(NSArray *)list{
    NSMutableArray *models = [NSMutableArray array];
    
    for (NSDictionary *infoDic in list) {
        id obj = [[[self class]alloc]init];
        [obj setAttributes:infoDic obj:obj];
        [models addObject:obj];
    }
    
    return models;
}
- (void) setAttributes:(NSDictionary *)dataDic{
    [self setAttributes:dataDic obj:self];
}



- (NSString *)getJson:(id)data{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:kNilOptions
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
}
- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(NSString *)base64String:(NSString *)str
{
    NSData *utf8encoding = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [NSObject base64StringFromData:utf8encoding];
}

+(NSString *)base64StringFromData:(NSData *)data
{
    NSString *encoding = nil;
    unsigned char *encodingBytes = NULL;
    @try {
        static char encodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        static NSUInteger paddingTable[] = {0,2,1};
        //                 Table 1: The Base 64 Alphabet
        //
        //    Value Encoding  Value Encoding  Value Encoding  Value Encoding
        //        0 A            17 R            34 i            51 z
        //        1 B            18 S            35 j            52 0
        //        2 C            19 T            36 k            53 1
        //        3 D            20 U            37 l            54 2
        //        4 E            21 V            38 m            55 3
        //        5 F            22 W            39 n            56 4
        //        6 G            23 X            40 o            57 5
        //        7 H            24 Y            41 p            58 6
        //        8 I            25 Z            42 q            59 7
        //        9 J            26 a            43 r            60 8
        //       10 K            27 b            44 s            61 9
        //       11 L            28 c            45 t            62 +
        //       12 M            29 d            46 u            63 /
        //       13 N            30 e            47 v
        //       14 O            31 f            48 w         (pad) =
        //       15 P            32 g            49 x
        //       16 Q            33 h            50 y
        
        NSUInteger dataLength = [data length];
        NSUInteger encodedBlocks = dataLength / 3;
        if( (encodedBlocks + 1) >= (NSUIntegerMax / 4) ) return nil; // NSUInteger overflow check
        NSUInteger padding = paddingTable[dataLength % 3];
        if( padding > 0 ) encodedBlocks++;
        NSUInteger encodedLength = encodedBlocks * 4;
        
        encodingBytes = malloc(encodedLength);
        if( encodingBytes != NULL ) {
            NSUInteger rawBytesToProcess = dataLength;
            NSUInteger rawBaseIndex = 0;
            NSUInteger encodingBaseIndex = 0;
            unsigned char *rawBytes = (unsigned char *)[data bytes];
            unsigned char rawByte1, rawByte2, rawByte3;
            while( rawBytesToProcess >= 3 ) {
                rawByte1 = rawBytes[rawBaseIndex];
                rawByte2 = rawBytes[rawBaseIndex+1];
                rawByte3 = rawBytes[rawBaseIndex+2];
                encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) | ((rawByte3 >> 6) & 0x03) ];
                encodingBytes[encodingBaseIndex+3] = encodingTable[(rawByte3 & 0x3F)];
                
                rawBaseIndex += 3;
                encodingBaseIndex += 4;
                rawBytesToProcess -= 3;
            }
            rawByte2 = 0;
            switch (dataLength-rawBaseIndex) {
                case 2:
                    rawByte2 = rawBytes[rawBaseIndex+1];
                case 1:
                    rawByte1 = rawBytes[rawBaseIndex];
                    encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                    encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                    encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) ];
                    // we can skip rawByte3 since we have a partial block it would always be 0
                    break;
            }
            // compute location from where to begin inserting padding, it may overwrite some bytes from the partial block encoding
            // if their value was 0 (cases 1-2).
            encodingBaseIndex = encodedLength - padding;
            while( padding-- > 0 ) {
                encodingBytes[encodingBaseIndex++] = '=';
            }
            encoding = [[NSString alloc] initWithBytes:encodingBytes length:encodedLength encoding:NSASCIIStringEncoding];
        }
    }
    @catch (NSException *exception) {
        encoding = nil;
        NSLog(@"WARNING: error occured while tring to encode base 32 data: %@", exception);
    }
    @finally {
        if( encodingBytes != NULL ) {
            free( encodingBytes );
        }
    }
    return encoding;
}
@end
