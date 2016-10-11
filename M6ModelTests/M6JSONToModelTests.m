//
//  M6SimpleModelTests.m
//  M6Model
//
//  Created by chenms on 16/10/10.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SimpleModel.h"
#import "M6Model.h"

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
    NSString *json = @"{\"i\": 123, \"d\": 123.3, \"b\": true, \"string\": \"string\", \"array\":[0, 1, 2]}";
    SimpleModel *model = [SimpleModel m6_modelFromJSON:json];
//    NSLog(@"%s, %@", __func__, model);
    
    XCTAssertEqual(model.i, 123);
    XCTAssertEqual(model.d, 123.3);
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
    NSString *json = @"{\"i\": 123, \"d\": 123.3, \"b\": true, \"string\": \"string\", \"array\":[0, 1, 2], \"innerModel\": {\"innerID\": 6666, \"innerName\": \"innerName\"}}";
    SimpleModel *model = [SimpleModel m6_modelFromJSON:json];
//    NSLog(@"%s, %@", __func__, model);
    
    XCTAssertEqual(model.innerModel.innerID, 6666);
    XCTAssert([model.innerModel.innerName isEqualToString:@"innerName"]);
}

- (void)testArrayModel {
   NSString *json = @"{\"i\": 123, \"d\": 123.3, \"b\": true, \"string\": \"string\", \"array\":[0, 1, 2], \"innerModelArray\": [{\"innerID\": 6666, \"innerName\": \"innerName6666\"}, {\"innerID\": 7777, \"innerName\": \"innerName7777\"}]}";
    
    SimpleModel *model = [SimpleModel m6_modelFromJSON:json];
//    NSLog(@"%s, %@", __func__, model);
    
    XCTAssertEqual(((SimpleInnerModel *)(model.innerModelArray[0])).innerID, 6666);
    XCTAssert([((SimpleInnerModel *)(model.innerModelArray[0])).innerName isEqualToString:@"innerName6666"]);
    XCTAssertEqual(((SimpleInnerModel *)(model.innerModelArray[1])).innerID, 7777);
    XCTAssert([((SimpleInnerModel *)(model.innerModelArray[1])).innerName isEqualToString:@"innerName7777"]);
}

- (void)testCustomPropertyMappingModel {
    NSString *json = @"{\"id\": 123, \"name\": \"name\"}";
    CustomPropertyMappingModel *model = [CustomPropertyMappingModel m6_modelFromJSON:json];
    NSLog(@"%s, %@", __func__, model);
    
    XCTAssertEqual(model.mID, 123);
    XCTAssert([model.name isEqualToString:@"name"]);
}

@end

