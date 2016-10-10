//
//  SimpleModel.m
//  M6Model
//
//  Created by chenms on 16/10/10.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import "SimpleModel.h"

@implementation SimpleModel

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld, %f, %@, %@, %@, %@", self.i, self.d, self.b == YES ? @"YES" : @"NO", self.string, self.array, self.innerModel];
}

@end

@implementation SimpleInnerModel

@end

@implementation SubSimpleModel
- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %ld", [super description], self.subID];
}

@end
