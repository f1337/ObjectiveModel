/*
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validator.rb
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



@class OMBlockValidator;



typedef BOOL (^ OMBlockValidatorValidationBlock) (OMBlockValidator *validator, OMActiveModel *model, NSObject *value);



@interface OMActiveModel (BlockValidation)



/*!
Validates each property against the provided block.

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

@param properties A NSString property name OR an NSArray of string property names.
@param block An OMBlockValidatorValidationBlock against which to validate the properties.
*/
+ (void)validatesEach:(NSObject *)properties withBlock:(OMBlockValidatorValidationBlock)block;



@end
