//
//  M6ModelToJSONTests.m
//  M6Model
//
//  Created by chenms on 16/10/11.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "M6Model.h"
#import "Model.h"

@interface M6ModelToJSONTests : XCTestCase

@end

@implementation M6ModelToJSONTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimpleModel {
    SimpleModel *model = [SimpleModel new];
    model.i = 123;
    model.d = 123.4;
    model.b = YES;
    model.string = @"string";
    model.array = @[@0, @1, @2];
    
    NSDictionary *json = [model m6_toJSON];
//    NSLog(@"%s, %@", __func__, json);
    
 
    XCTAssertEqual(((NSNumber *)(json[@"i"])).integerValue, 123);
    XCTAssertEqual(((NSNumber *)(json[@"d"])).doubleValue, 123.4);
    XCTAssertEqual(((NSNumber *)(json[@"b"])).boolValue, YES);
    XCTAssert([json[@"string"] isEqualToString:@"string"]);
    NSArray *array = @[@0, @1, @2];
    XCTAssert([json[@"array"] isEqualToArray:array]);
}

- (void)testSubModel {
    SubSimpleModel *model = [SubSimpleModel new];
    model.i = 123;
    model.d = 123.4;
    model.b = YES;
    model.string = @"string";
    model.array = @[@0, @1, @2];
    model.subID = 1024;
    
    NSDictionary *json = [model m6_toJSON];
//    NSLog(@"%s, %@", __func__, json);
    
    XCTAssertEqual(((NSNumber *)(json[@"subID"])).integerValue, 1024);
}

- (void)testNestedModel {
    NestedModel *model = [NestedModel new];
    model.mID = 123;
    InnerModel *innerModel = [InnerModel new];
    innerModel.mID = 1024;
    innerModel.name = @"name";
    model.innerModel = innerModel;
    
    NSDictionary *json = [model m6_toJSON];
//    NSLog(@"%s, %@", __func__, json);
    
    XCTAssertEqual(((NSNumber *)(json[@"innerModel"][@"mID"])).integerValue, 1024);
    XCTAssert([json[@"innerModel"][@"name"] isEqualToString:@"name"]);
}

- (void)testNestedArrayModel {
    NestedArrayModel *model = [NestedArrayModel new];
    model.mID = 123;
    
    InnerModel *innerModel0 = [InnerModel new];
    innerModel0.mID = 6666;
    innerModel0.name = @"name6666";
    
    InnerModel *innerModel1 = [InnerModel new];
    innerModel1.mID = 7777;
    innerModel1.name = @"name7777";
    
    model.innerModelArray = @[innerModel0, innerModel1];
    
    NSDictionary *json = [model m6_toJSON];
//    NSLog(@"%s, %@", __func__, json);

    XCTAssertEqual(((NSNumber *)(json[@"innerModelArray"][0][@"mID"])).integerValue, 6666);
    XCTAssert([json[@"innerModelArray"][0][@"name"] isEqualToString:@"name6666"]);
    XCTAssertEqual(((NSNumber *)(json[@"innerModelArray"][1][@"mID"])).integerValue, 7777);
    XCTAssert([json[@"innerModelArray"][1][@"name"] isEqualToString:@"name7777"]);
}

- (void)testCustomPropertyMappingModel {
    CustomPropertyMappingModel *model = [CustomPropertyMappingModel new];
    model.mID = 123;
    model.name = @"name";
    
    NSDictionary *json = [model m6_toJSON];
//    NSLog(@"%s, %@", __func__, json);
    
    XCTAssertEqual(((NSNumber *)(json[@"id"])).integerValue, 123);
    XCTAssert([json[@"name"] isEqualToString:@"name"]);
}
@end
