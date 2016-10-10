//
//  M6ClassInfo.h
//  M6Model
//
//  Created by chenms on 16/10/7.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface M6ClassInfo : NSObject

@end

typedef NS_ENUM(NSUInteger, M6PropertyType) {
    M6PropertyTypeUnknown,
    M6PropertyTypePrimitive,
    M6PropertyTypeFoundationObject,
    M6PropertyTypeCustomObject,
};

@interface M6Property : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic) M6PropertyType type;
@property (nonatomic) Class cls;

+ (instancetype)propertyFromObjcProperty:(objc_property_t)objcProperty;

@end
