//
//  NSObject+M6Model.h
//  M6Model
//
//  Created by chenms on 16/10/7.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (M6Model)
+ (instancetype)m6_modelFromJSON:(id)json;
- (NSDictionary *)m6_toJSON;
@end

@interface NSArray (M6Model)
+ (NSArray *)m6_modelArrayOfClass:(Class)clas fromJSON:(id)json;
- (NSArray *)m6_toJSON;
@end
