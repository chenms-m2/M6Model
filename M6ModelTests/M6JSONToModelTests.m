//
//  M6SimpleModelTests.m
//  M6Model
//
//  Created by chenms on 16/10/10.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "M6Model.h"
#import "Model.h"

@interface M6JSONToModelTests : XCTestCase

@end

@implementation M6JSONToModelTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimpleModel {
    NSString *json = @"{\"i\": 123, \"d\": 123.4, \"b\": true, \"string\": \"string\", \"array\":[0, 1, 2]}";
    SimpleModel *model = [SimpleModel m6_modelFromJSON:json];
//    NSLog(@"%s, %@", __func__, model);
    
    XCTAssertEqual(model.i, 123);
    XCTAssertEqual(model.d, 123.4);
    XCTAssertEqual(model.b, YES);
    XCTAssert([model.string isEqualToString:@"string"]);
    NSArray *array = @[@0, @1, @2];
    XCTAssert([model.array isEqualToArray:array]);
}

- (void)testSubModel {
    NSString *json = @"{\"i\": 123, \"d\": 123.3, \"b\": true, \"string\": \"string\", \"array\":[0, 1, 2], \"subID\": 1024}";
    SubSimpleModel *model = [SubSimpleModel m6_modelFromJSON:json];
//    NSLog(@"%s, %@", __func__, model);
    
    XCTAssertEqual(model.subID, 1024);
}

- (void)testNestedModel {
    NSString *json = @"{\"mID\": 123, \"innerModel\": {\"mID\": 1024, \"name\": \"name\"}}";
    NestedModel *model = [NestedModel m6_modelFromJSON:json];
//    NSLog(@"%s, %@", __func__, model);
    
    XCTAssertEqual(model.innerModel.mID, 1024);
    XCTAssert([model.innerModel.name isEqualToString:@"name"]);
}

- (void)testNestedArrayModel {
   NSString *json = @"{\"mID\": 123, \"innerModelArray\": [{\"mID\": 6666, \"name\": \"name6666\"}, {\"mID\": 7777, \"name\": \"name7777\"}]}";

    NestedArrayModel *model = [NestedArrayModel m6_modelFromJSON:json];
//    NSLog(@"%s, %@", __func__, model);
    
    XCTAssertEqual(((InnerModel *)(model.innerModelArray[0])).mID, 6666);
    XCTAssert([((InnerModel *)(model.innerModelArray[0])).name isEqualToString:@"name6666"]);
    XCTAssertEqual(((InnerModel *)(model.innerModelArray[1])).mID, 7777);
    XCTAssert([((InnerModel *)(model.innerModelArray[1])).name isEqualToString:@"name7777"]);
}

- (void)testCustomPropertyMappingModel {
    NSString *json = @"{\"id\": 123, \"name\": \"name\"}";
    CustomPropertyMappingModel *model = [CustomPropertyMappingModel m6_modelFromJSON:json];
//    NSLog(@"%s, %@", __func__, model);
    
    XCTAssertEqual(model.mID, 123);
    XCTAssert([model.name isEqualToString:@"name"]);
}

@end

