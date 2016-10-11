//
//  SimpleModel.h
//  M6Model
//
//  Created by chenms on 16/10/10.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InnerModel;

@interface Model : NSObject
@end

@interface SimpleModel : NSObject
@property (nonatomic) NSInteger i;
@property (nonatomic) double d;
@property (nonatomic) BOOL b;
@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) NSArray *array;
@end

@interface SubSimpleModel : SimpleModel
@property (nonatomic) NSInteger subID;
@end

@interface NestedModel : NSObject
@property (nonatomic) NSInteger mID;
@property (nonatomic) InnerModel *innerModel;
@end

@interface InnerModel : NSObject
@property (nonatomic) NSInteger mID;
@property (nonatomic, copy) NSString *name;
@end

@interface NestedArrayModel : NSObject
@property (nonatomic) NSInteger mID;
@property (nonatomic) NSArray *innerModelArray;
@end

@interface CustomPropertyMappingModel : NSObject
@property (nonatomic) NSInteger mID;
@property (nonatomic, copy) NSString *name;
@end
