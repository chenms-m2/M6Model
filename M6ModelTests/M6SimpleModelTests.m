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

@interface M6SimpleModelTests : XCTestCase

@end

@implementation M6SimpleModelTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSimpleModel {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSString *json = @"{\"i\": 123, \"d\": 123.3, \"b\": true, \"string\": \"string\", \"array\":[0, 1, 2], \"subID\": 1024}";
    SubSimpleModel *model = [SubSimpleModel m6_modelFromJSON:json];
    
    NSLog(@"%@", model);
}

@end
