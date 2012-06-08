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
#import <ObjectiveModel/Validations.h>



@implementation OMValidatorTest



// TODO: This test class should be removed once RoR tests have all been imported.

#pragma mark - SETUP/TEARDOWN



- (void)setUp
{
    [super setUp];
    [Person validatesNumericalityOf:@"firstName"
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"Y", @"allowNil",
                                   nil]];
    
    // test allowBlank constraint
    [Person validatesNumericalityOf:@"lastName"
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"1", @"allowBlank",
                                   nil]];
    
    // test allowNil & allowBlank constraints
    [Person validatesNumericalityOf:@"title"
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"y", @"allowNil",
                                   @"T", @"allowBlank",
                                   nil]];

    model = [[Person alloc] init];
}



- (void)tearDown
{
    [model release];
    [Person removeAllValidations];
    [super tearDown];
}



#pragma mark - TESTS



- (void)testAnUnsetValueForFirstNameShouldBeValid
{
    [self assertPropertyIsValid:@"firstName" forModel:model];
}



- (void)testANilValueForFirstNameShouldBeValid
{
    [model setFirstName:nil];
    [self assertPropertyIsValid:@"firstName" forModel:model];
}



- (void)testABlankValueForLastNameShouldBeValid
{
    [model setLastName:@""];
    [self assertPropertyIsValid:@"lastName" forModel:model];
}



- (void)testAnUnsetValueForTitleShouldBeValid
{
    [self assertPropertyIsValid:@"title" forModel:model];
}



- (void)testANilValueForTitleShouldBeValid
{
    [model setTitle:nil];
    [self assertPropertyIsValid:@"title" forModel:model];
}



- (void)testABlankValueForTitleShouldBeValid
{
    [model setTitle:@""];
    [self assertPropertyIsValid:@"title" forModel:model];
}



@end
