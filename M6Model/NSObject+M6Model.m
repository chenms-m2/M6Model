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

#pragma mark - public
+ (instancetype)m6_modelFromJSON:(id)json {
    NSDictionary *dict = [self m6_dictionaryWithJSON:json];
    
    return (dict ? [self m6_modelFromDictionary:dict] : nil);
}

- (NSDictionary *)m6_toJSON {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    NSArray *properties = [self.class allProperties];
    
    [properties enumerateObjectsUsingBlock:^(M6Property * _Nonnull property, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[self.class m6_customPropertyJSONMapping] objectForKey:property.name] ?: property.name;
        NSObject *value = [self valueForKey:property.name];
        if (value) {
            if (property.type == M6PropertyTypeCustomObject) {
                NSDictionary *innerJSON = [value m6_toJSON];
                [json setObject:innerJSON forKey:key];
            } else if ([value isKindOfClass:[NSArray class]]) {
                NSDictionary *dict = [self.class m6_containerPropertyElementClassMapping];
                Class elementClass = nil;
                id obj = [dict objectForKey:property.name];
                Class meta = object_getClass(obj);
                if (meta && class_isMetaClass(meta)) {
                    elementClass = obj;
                } else if ([obj isKindOfClass:[NSString class]]) {
                    elementClass = NSClassFromString(obj);
                }
                
                if(elementClass) {
                    NSArray *srcArray = (NSArray *)value;
                    NSMutableArray *destArray = [NSMutableArray array];
                    [srcArray enumerateObjectsUsingBlock:^(id  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                        // TODO: elementClass为Foundition中类没有处理
                        NSDictionary *json = [model m6_toJSON];
                        if (json) {
                            [destArray addObject:json];
                        }
                    }];
                    if ([destArray count] == 0) {
                        destArray = nil;
                    }
                    [json setObject:destArray forKey:key];
                } else {
                    [json setObject:value forKey:key];
                }
            } else {
                [json setObject:value forKey:key];
            }
        }
    }];
    
    return json;
}

#pragma mark - need override
+ (NSDictionary *)m6_containerPropertyElementClassMapping {
    return nil;
}

+ (NSDictionary *)m6_customPropertyJSONMapping {
    return nil;
}

#pragma mark - other
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
//    NSLog(@"properties: %@", properties);
//    NSLog(@"dict: %@", dictionary);
    
    // loop
    [properties enumerateObjectsUsingBlock:^(M6Property * _Nonnull property, NSUInteger idx, BOOL * _Nonnull stop) {
        // getValue
        
        NSString *key = property.name;
        NSString *jsonKey = ([[self m6_customPropertyJSONMapping] objectForKey:property.name] ?: property.name);
        NSObject *value = [dictionary objectForKey: jsonKey];
        
        if (value) {
            if (property.type == M6PropertyTypePrimitive && [value isKindOfClass:[NSNumber class]]) {
                [model setValue:value forKey:key];
            } else if (property.type == M6PropertyTypeCustomObject) {
                NSObject *innerModel = [property.cls m6_modelFromJSON:value];
                [model setValue:innerModel forKey:key];
            } else if (property.type == M6PropertyTypeFoundationObject && [value isKindOfClass:property.cls]) {
                if ([value isKindOfClass:[NSArray class]]) {
                    NSDictionary *dict = [self m6_containerPropertyElementClassMapping];
                    Class elementClass = nil;
                    id obj = [dict objectForKey:property.name];
                    Class meta = object_getClass(obj);
                    if (meta && class_isMetaClass(meta)) {
                        elementClass = obj;
                    } else if ([obj isKindOfClass:[NSString class]]) {
                        elementClass = NSClassFromString(obj);
                    }
                    
                    if(elementClass) {
                        NSArray *srcArray = (NSArray *)value;
                        NSMutableArray *destArray = [NSMutableArray array];
                        [srcArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            // TODO: elementClass为Foundition中类没有处理
                            NSObject *model = [elementClass m6_modelFromJSON:obj];
                            if (model) {
                                [destArray addObject:model];
                            }
                        }];
                        if ([destArray count] == 0) {
                            destArray = nil;
                        }
                        [model setValue:destArray forKey:key];
                    } else {
                        [model setValue:value forKey:key];
                    }
                } else {
                    [model setValue:value forKey:key];
                }
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
