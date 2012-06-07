/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/test/cases/validations/presence_validation_test.rb
 * Ruby on Rails is Copyright © 2004-2012 David Heinemeier Hansson.
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



#import "PresenceValidationTest.h"
#import <ObjectiveModel/Validations.h>



@implementation PresenceValidationTest



#pragma mark - SETUP/TEARDOWN



- (void)setUp
{
    [super setUp];
    model = [[Person alloc] init];
}



- (void)tearDown
{
    [model release];
    [Person removeAllValidations];
    [super tearDown];
}



#pragma mark - TRANSLITERATED RoR TESTS



- (void)testAcceptsMultipleProperties
{
    // define validation
    [Person validatesPresenceOf:[NSArray arrayWithObjects:@"firstName", @"lastName", nil] withOptions:nil];

    // assert both properties invalid
    [self assertModelIsInvalid:model withErrorMessage:@"cannot be blank" forKeys:[NSArray arrayWithObjects:@"firstName", @"lastName", nil]];

    // assert one property invalid
    [model setFirstName:@"Robert"];
    [model setLastName:@"     "];
    [self assertModelIsInvalid:model withErrorMessage:@"cannot be blank" forKeys:[NSArray arrayWithObjects:@"lastName", nil]];

    // assert both properties valid
    [model setLastName:@"Tabula Rasa"];
    [self assertModelIsValid:model];
}



- (void)testAcceptsSingleProperty
{
    // define validation
    [Person validatesPresenceOf:@"firstName" withOptions:nil];

    // assert property is invalid
    [self assertModelIsInvalid:model withErrorMessage:@"cannot be blank" forKeys:[NSArray arrayWithObjects:@"firstName", nil]];

    // assert property is valid
    [model setFirstName:@"Yoda"];
    [self assertModelIsValid:model];
}



- (void)testAcceptsCustomErrorUsingQuotes
{
    // define custom message
    NSString *message = @"This string contains 'single' and \"double\" quotes";
    // define validation
    [Person validatesPresenceOf:@"firstName"
                    withOptions:[NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil]];
    
    // assert property is invalid
    [self assertModelIsInvalid:model withErrorMessage:message forKeys:[NSArray arrayWithObjects:@"firstName", nil]];
}



- (void)testIfValueIsNilItShouldBeInvalid
{
    [Person validatesPresenceOf:@"firstName" withOptions:nil];
    [model setFirstName:nil];
    [self assertPropertyIsInvalid:@"firstName" forModel:model withErrorMessage:@"cannot be blank"];
}



#pragma mark - TESTS



- (void)testIfValueIsEmptyStringItShouldBeInvalid
{
    [Person validatesPresenceOf:@"firstName" withOptions:nil];
    [model setFirstName:@""];
    [self assertPropertyIsInvalid:@"firstName" forModel:model withErrorMessage:@"cannot be blank"];
}



@end
