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



@synthesize model = _model;



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

    [self setModel:[[Person alloc] init]];
}



- (void)tearDown
{
    [self setModel:nil];
    [Person removeAllValidations];
    [super tearDown];
}



#pragma mark - TESTS



- (void)testAnUnsetValueForFirstNameShouldBeValid
{
    OMAssertPropertyIsValid(@"firstName", _model);
}



- (void)testANilValueForFirstNameShouldBeValid
{
    [_model setFirstName:nil];
    OMAssertPropertyIsValid(@"firstName", _model);
}



- (void)testABlankValueForLastNameShouldBeValid
{
    [_model setLastName:@""];
    OMAssertPropertyIsValid(@"lastName", _model);
}



- (void)testAnUnsetValueForTitleShouldBeValid
{
    OMAssertPropertyIsValid(@"title", _model);
}



- (void)testANilValueForTitleShouldBeValid
{
    [_model setTitle:nil];
    OMAssertPropertyIsValid(@"title", _model);
}



- (void)testABlankValueForTitleShouldBeValid
{
    [_model setTitle:@""];
    OMAssertPropertyIsValid(@"title", _model);
}



@end
