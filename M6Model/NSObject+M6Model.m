//
//  NSObject+M6Model.m
//  M6Model
//
//  Created by chenms on 16/10/7.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import "NSObject+M6Model.h"
#import <objc/runtime.h>
#import "M6ClassInfo.h"

@implementation NSObject (M6Model)
//
+ (instancetype)m6_modelFromJSON:(id)json {
    NSDictionary *dict = [self m6_dictionaryWithJSON:json];
    
    return [self m6_modelFromDictionary:dict];
}

- (NSDictionary *)m6_toJSON {
    return nil;
}

+ (NSDictionary *)m6_dictionaryWithJSON:(id)json {
    if (!json || json == [NSNull null]) return nil;
    
    if ([json isKindOfClass:[NSDictionary class]]) return json;
    
    NSData *data = nil;
    if ([json isKindOfClass:[NSData class]]) {
        data = json;
    } else if ([json isKindOfClass: [NSString class]]) {
        data = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (!data) return nil;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    
    return dict;
}

+ (instancetype)m6_modelFromDictionary:(NSDictionary *)dictionary {
    // all property
    NSObject *model = [self new];
    NSArray *properties = [self allProperties];
    NSLog(@"properties: %@", properties);
    NSLog(@"dict: %@", dictionary);
    
    // loop
    [properties enumerateObjectsUsingBlock:^(M6Property * _Nonnull property, NSUInteger idx, BOOL * _Nonnull stop) {
        // getValue
        NSObject *value = [dictionary objectForKey:property.name];
        if (value) {
            if ([value isKindOfClass:[NSNumber class]] && property.type == M6PropertyTypePrimitive) {
                [model setValue:value forKey:property.name];
            } else if ([value isKindOfClass:property.cls]) {
                [model setValue:value forKey:property.name];
            } else {
                [self injectNullValueIntoModel:model property:property];
            }
        } else {
            [self injectNullValueIntoModel:model property:property];
        }
    }];
 
    return model;
}

+ (void)injectNullValueIntoModel:(NSObject *)model property:(M6Property *)property {
    switch(property.type) {
        case M6PropertyTypePrimitive:
            [model setValue:@0 forKey:property.name];
            break;
        case M6PropertyTypeFoundationObject:
        case M6PropertyTypeCustomObject:
            [model setValue:nil forKey:property.name];
            break;
        default:
            break;
    }
}

+ (NSArray *)allProperties {
    NSMutableArray *properties = [NSMutableArray array];
    
    Class curCls = self;
    while (curCls && curCls != [NSObject class]) {
        unsigned int propertyCount = 0;
        objc_property_t *objcProperties = class_copyPropertyList(curCls, &propertyCount);
        for (unsigned int i = 0; i < propertyCount; i++) {
            objc_property_t objcProperty = objcProperties[i];
            M6Property *property = [M6Property propertyFromObjcProperty:objcProperty];
            [properties addObject:property];
        }
        free(objcProperties);
        
        curCls = class_getSuperclass(curCls);
    }
    
    return (properties.count > 0 ? [properties copy] : nil);
}

@end


@implementation NSArray (M6Model)

+ (NSArray *)m6_modelArrayOfClass:(Class)clas fromJSON:(id)json {
    return nil;
}
- (NSArray *)m6_toJSON {
    return nil;
}

@end
