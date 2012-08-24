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



@synthesize model = _model;



#pragma mark - SETUP/TEARDOWN



- (void)setUp
{
    [super setUp];
    [self setModel:[[Person alloc] init]];
}



- (void)tearDown
{
    [self setModel:nil];
    [Person removeAllValidations];
    [super tearDown];
}



#pragma mark - TRANSLITERATED RoR TESTS



- (void)testAcceptsMultipleProperties
{
    // define validation
    [Person validatesPresenceOf:[NSArray arrayWithObjects:@"firstName", @"lastName", nil] withInitBlock:nil];

    // assert both properties invalid
    OMAssertModelIsInvalid(_model, @"cannot be blank", ([NSArray arrayWithObjects:@"firstName", @"lastName", nil]));

    // assert one property invalid
    [_model setFirstName:@"Robert"];
    [_model setLastName:@"     "];
    OMAssertModelIsInvalid(_model, @"cannot be blank", [NSArray arrayWithObject:@"lastName"]);

    // assert both properties valid
    [_model setLastName:@"Tabula Rasa"];
    OMAssertModelIsValid(_model);
}



- (void)testAcceptsSingleProperty
{
    // define validation
    [Person validatesPresenceOf:@"firstName" withInitBlock:nil];

    // assert property is invalid
    OMAssertModelIsInvalid(_model, @"cannot be blank", [NSArray arrayWithObject:@"firstName"]);

    // assert property is valid
    [_model setFirstName:@"Yoda"];
    OMAssertModelIsValid(_model);
}



- (void)testAcceptsCustomErrorUsingQuotes
{
    // define custom message
    NSString *message = @"This string contains 'single' and \"double\" quotes";
    // define validation
    [Person validatesPresenceOf:@"firstName" withInitBlock:^(OMValidator *validator) {
        [validator setMessage:message];
    }];
    
    // assert property is invalid
    OMAssertModelIsInvalid(_model, @"This string contains 'single' and \"double\" quotes", [NSArray arrayWithObject:@"firstName"]);
}



- (void)testIfValueIsNilItShouldBeInvalid
{
    [Person validatesPresenceOf:@"firstName" withInitBlock:nil];
    [_model setFirstName:nil];
    OMAssertModelIsInvalid(_model, @"cannot be blank", [NSArray arrayWithObject:@"firstName"]);
}



#pragma mark - TESTS



- (void)testIfValueIsEmptyStringItShouldBeInvalid
{
    [Person validatesPresenceOf:@"firstName" withInitBlock:nil];
    [_model setFirstName:@""];
    OMAssertModelIsInvalid(_model, @"cannot be blank", [NSArray arrayWithObject:@"firstName"]);
}



@end
