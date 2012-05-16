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



#import "OMValidatorTest.h"



@implementation OMValidatorTest



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



- (void)testAnUnsetValueForAllowNilShouldBeValid
{
    [self assertPropertyIsValid:@"allowNil" forModel:model];
}



- (void)testANilValueForAllowNilShouldBeValid
{
    [model setAllowNil:nil];
    [self assertPropertyIsValid:@"allowNil" forModel:model];
}



- (void)testAnUnsetValueForAllowBlankShouldBeInvalid
{
    [self assertPropertyIsInvalid:@"allowBlank" forModel:model withErrorMessage:@"is invalid"];
}



- (void)testANilValueForAllowBlankShouldBeInvalid
{
    [model setAllowBlank:nil];
    [self assertPropertyIsInvalid:@"allowBlank" forModel:model withErrorMessage:@"is invalid"];
}



- (void)testABlankValueForAllowBlankShouldBeValid
{
    [model setAllowBlank:@""];
    [self assertPropertyIsValid:@"allowBlank" forModel:model];
}



- (void)testAnUnsetValueForAllowNilAndBlankShouldBeValid
{
    [self assertPropertyIsValid:@"allowNilAndBlank" forModel:model];
}



- (void)testANilValueForAllowNilAndBlankShouldBeValid
{
    [model setAllowNil:nil];
    [self assertPropertyIsValid:@"allowNilAndBlank" forModel:model];
}



- (void)testABlankValueForAllowNilAndBlankShouldBeValid
{
    [model setAllowBlank:@""];
    [self assertPropertyIsValid:@"allowNilAndBlank" forModel:model];
}



@end
