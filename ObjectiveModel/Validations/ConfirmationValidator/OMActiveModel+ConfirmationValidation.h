/*
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/master/activemodel/lib/active_model/validations/confirmation.rb
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



#import "OMActiveModel.h"



@interface OMActiveModel (ConfirmationValidation)



/*!
Encapsulates the pattern of wanting to validate a password or email
address field with a confirmation.

    @implementation Person
        + (void)initialize
        {
            [self validatesConfirmationOf:[NSArray arrayWithObjects:@"userName", @"password", nil] withInitBlock:nil];
            [self validatesConfirmationOf:@"email" withInitBlock:^(OMValidator *validator)
            {
                [validator setMessage:@"should match confirmation"];
            }];
        }
    @end

NOTE: This check is performed only if `[person passwordConfirmation]` is not
`nil`. To require confirmation, make sure
to add a presence check for the confirmation attribute:

    [self validatesPresenceOf:@"passwordConfirmation" withInitBlock:^(OMValidator *validator)
    {
        [validator setShouldApplyValidationBlock:^BOOL (id person)
        {
            return [person hasChangedPassword];
        }];
    }];

@param properties A NSString property name OR an NSArray of string property names.
@param block An OMValidatorInitBlock for initializing the validator instance's properties.
*/
+ (void)validatesConfirmationOf:(NSObject *)properties withInitBlock:(OMValidatorInitBlock)block;



@end
