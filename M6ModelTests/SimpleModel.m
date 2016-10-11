//
//  SimpleModel.m
//  M6Model
//
//  Created by chenms on 16/10/10.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import "SimpleModel.h"

#pragma mark - SimpleModel
@implementation SimpleModel
- (NSString *)description {
    return [NSString stringWithFormat:@"SimpleModel[%ld, %f, %@, %@, %@, %@, %@]", self.i, self.d, self.b == YES ? @"YES" : @"NO", self.string, self.array, self.innerModel, self.innerModelArray];
}

+ (NSDictionary *)m6_containerPropertyElementClassMapping {
    return @{ @"innerModelArray": @"SimpleInnerModel" };
}

@end

#pragma mark - SimpleInnerModel
@implementation SimpleInnerModel
- (NSString *)description {
    return [NSString stringWithFormat:@"SimpleInnerModel[%ld, %@]", self.innerID, self.innerName];
}
@end

#pragma mark - SubSimpleModel
@implementation SubSimpleModel
- (NSString *)description {
    return [NSString stringWithFormat:@"SubSimpleModel[%@, %ld]", [super description], self.subID];
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
