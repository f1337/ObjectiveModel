/*
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



#import "OMActiveModel.h"
#import "OMValidator.h"



@class OMValidator;



typedef void (^ OMValidatorInitBlock) (OMValidator *validator);



/*!
Provides a full validation framework to your objects.
A minimal implementation could be:

    @implementation Person
        + (void)initialize
        {
            [self validatesEach:[NSArray arrayWithObjects:@"firstName", @"lastName", nil]
                      withBlock:^BOOL(OMBlockValidator *validator, OMActiveModel *model, NSObject *value)
            {
                NSString *stringValue = [value description];
                if ( [stringValue hasPrefix:@"z"] )
                {
                    [validator setMessage:@"starts with z."];
                    return NO;
                }
                else
                {
                    return YES;
                }
            }];
        }
    @end

Which provides you with the full standard validation stack:

    Person *person = [[Person alloc] init];
    NSError *error = nil;
    [person isValid:&error]; // => YES
    [person isInvalid:&error]; // => NO

    [person setFirstName:@"zoolander"];
    [person isValid:&error]; // => NO
    [person isInvalid:&error]; // => YES
    [[error userInfo]] objectForKey:NSValidationKeyErrorKey]; // => @"firstName"
    [error localizedDescription]; // => @"starts with z."
*/
@interface OMActiveModel (Validation)



/*!
 * Executes all validators defined for the model
 * and returns YES if any validation fails, else NO
 */
- (BOOL)isInvalid:(NSError **)errors;



/*!
 * Executes all validators defined for the model
 * and returns YES if all validations pass, else NO
 */
- (BOOL)isValid:(NSError **)errors;



/*!
 * Executes all validators defined for the model. See isValid.
 */
- (BOOL)validate:(NSError **)errors;



/*!
Instantiates a validator for each property, using the validator class provided,
then yields each instance to the init block for setup.

    @implementation Person
        + (void)initialize
        {
            [self validatesEach:[NSArray arrayWithObjects:@"termsOfService", @"EULA", nil] withClass:[OMAcceptanceValidator class] andInitBlock:nil];

            [self validatesEach:@"termsOfService" withClass:[OMAcceptanceValidator class] andInitBlock:^(OMValidator *validator)
            {
                OMAcceptanceValidator *acceptanceValidator = (OMAcceptanceValidator *)validator;
                [acceptanceValidator setAccept:@"I agree."];
                [acceptanceValidator setMessage:@"must be abided"];
            }];
        }
    @end

@param properties An NSString property name OR an NSArray of NSString property names
@param validationClass An OMValidator class to be instantiated for each property.
@param block An OMValidatorInitBlock for initializing the validator instance's properties.
*/
+ (void)validatesEach:(NSObject *)properties withClass:(Class)validationClass andInitBlock:(OMValidatorInitBlock)block;



+ (NSMutableDictionary *)validations;



@end
