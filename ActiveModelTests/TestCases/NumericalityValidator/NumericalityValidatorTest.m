/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "NumericalityValidatorTest.h"
#import "OMActiveModel+OMNumericalityValidator.h"



@implementation NumericalityValidatorTest



#pragma mark - SETUP/TEARDOWN



- (void)setUp
{
    [super setUp];
    model = [[Person alloc] init];
}



- (void)tearDown
{
    [model release];
//    [Person removeAllValidations];
    [super tearDown];
}



#pragma mark - TESTS



- (void)testAnUnsetOrNilValueForTwoShouldBeInvalid
{
//    [Person validatesNumericalityOf:@"two" withOptions:nil];
    [self assertPropertyIsInvalid:@"two" forModel:model withErrorMessage:@"is not a valid number"];
}



- (void)testIfTwoEquals0ItShouldBeInvalid
{
    [model setTwo:[NSNumber numberWithInt:0]];
    [self assertPropertyIsInvalid:@"two" forModel:model withErrorMessage:@"is not a valid number"];
}



- (void)testIfTwoEquals2ItShouldBeValid
{
    [model setTwo:[NSNumber numberWithInt:2]];
    [self assertPropertyIsValid:@"two" forModel:model];
}



- (void)testIfTwoEquals15ItShouldBeInvalid
{
    [model setTwo:[NSNumber numberWithInt:15]];
    [self assertPropertyIsInvalid:@"two" forModel:model withErrorMessage:@"is not a valid number"];
}



- (void)testIfThreeEquals1ItShouldBeInvalid
{
    [model setThree:[NSNumber numberWithInt:1]];
    [self assertPropertyIsInvalid:@"three" forModel:model withErrorMessage:@"is not a valid number"];
}



- (void)testIfThreeEquals3ItShouldBeValid
{
    [model setThree:[NSNumber numberWithInt:3]];
    [self assertPropertyIsValid:@"three" forModel:model];
}



- (void)testIfThreeEquals15ItShouldBeInvalid
{
    [model setThree:[NSNumber numberWithInt:15]];
    [self assertPropertyIsInvalid:@"three" forModel:model withErrorMessage:@"is not a valid number"];
}



@end
