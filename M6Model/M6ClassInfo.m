//
//  M6ClassInfo.m
//  M6Model
//
//  Created by chenms on 16/10/7.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import "M6ClassInfo.h"

@implementation M6ClassInfo

@end

@implementation M6Property

+ (instancetype)propertyFromObjcProperty:(objc_property_t)objcProperty {
    M6Property *property = [M6Property new];
    property.name = [NSString stringWithUTF8String:property_getName(objcProperty)];

    unsigned int attributeCount = 0;
    objc_property_attribute_t *attributes = property_copyAttributeList(objcProperty, &attributeCount);
    for (unsigned int i = 0; i < attributeCount; i++) {
        objc_property_attribute_t attribute = attributes[i];
        if (*attribute.name == 'T') {
            Class cls = nil;
            property.type = [self typeFromAttributeValue:attribute.value cls:&cls];
            property.cls = cls;
            NSLog(@"%@: %ld: %@: %s", property.name, property.type, property.cls, attribute.value);
        }
    }
    free(attributes);
    
    return property;
}

+ (M6PropertyType)typeFromAttributeValue:(const char *)typeEncoding cls:(Class *)cls {
    M6PropertyType type = M6PropertyTypeUnknown;
    switch (*typeEncoding) {
        case 'v':
        case 'B':
        case 'c':
        case 'C':
        case 's':
        case 'S':
        case 'i':
        case 'I':
        case 'l':
        case 'L': 
        case 'q':
        case 'Q': 
        case 'f': 
        case 'd': 
        case 'D':
            type = M6PropertyTypePrimitive;
            break;
        case '@':
            type = [self typeFromObjectAttributeValue:typeEncoding cls:cls];
            break;
        default:
            break;
    }
    
    return type;
}

// 默认typeEncoding的length>0且以@开头
+ (M6PropertyType)typeFromObjectAttributeValue:(const char *)typeEncoding cls:(Class *)cls {
    NSString *typeString = [NSString stringWithUTF8String:typeEncoding];

    if (typeString.length <= 3) {
        return M6PropertyTypeUnknown;
    }
    
    // 暂不支持id<AProtocol, BProtocol>这样的属性；
    // 类似地，泛型类暂时也不支持；
    if ([typeString rangeOfString:@"<"].location != NSNotFound) {
        return M6PropertyTypeUnknown;
    }
    
    NSString *name = [typeString substringWithRange:NSMakeRange(2, typeString.length - 3)];
    *cls = NSClassFromString(name);
    
    // check
    if ([*cls isSubclassOfClass:[NSString class]]
        || [*cls isSubclassOfClass:[NSNumber class]]
        || [*cls isSubclassOfClass:[NSArray class]]
        || [*cls isSubclassOfClass:[NSDictionary class]]) {
        
        return M6PropertyTypeFoundationObject;
    }
    
    return M6PropertyTypeCustomObject;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %ld, %@", self.name, self.type, self.cls];
}

@end
