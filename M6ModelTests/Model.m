//
//  SimpleModel.m
//  M6Model
//
//  Created by chenms on 16/10/10.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import "Model.h"

@implementation Model
@end

#pragma mark - SimpleModel
@implementation SimpleModel
- (NSString *)description {
    return [NSString stringWithFormat:@"SimpleModel[%ld, %f, %@, %@, %@]", self.i, self.d, self.b == YES ? @"YES" : @"NO", self.string, self.array];
}
@end

#pragma mark - SubSimpleModel
@implementation SubSimpleModel
- (NSString *)description {
    return [NSString stringWithFormat:@"SubSimpleModel[%@, %ld]", [super description], self.subID];
}
@end

#pragma mark - NestedModel
@implementation NestedModel
- (NSString *)description {
    return [NSString stringWithFormat:@"NestedModel[%ld, %@]", self.mID, self.innerModel];
}
@end

#pragma mark - InnerModel
@implementation InnerModel
- (NSString *)description {
    return [NSString stringWithFormat:@"InnerModel[%ld, %@]", self.mID, self.name];
}
@end

#pragma mark - NestedArrayModel
@implementation NestedArrayModel
- (NSString *)description {
    return [NSString stringWithFormat:@"NestedArrayModel[%ld, %@]", self.mID, self.innerModelArray];
}

+ (NSDictionary *)m6_containerPropertyElementClassMapping {
    return @{ @"innerModelArray": @"InnerModel" };
}
@end

#pragma mark - CustomPropertyMappingModel
@implementation CustomPropertyMappingModel

+ (NSDictionary *)m6_customPropertyJSONMapping {
    return @{ @"mID" : @"id" };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"CustomPropertyMappingModel[%ld, %@]", self.mID, self.name];
}

@end
