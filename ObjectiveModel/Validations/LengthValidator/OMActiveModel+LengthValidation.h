/*
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were translated from Ruby on Rails,
 * Copyright © 2004-2012 David Heinemeier Hansson.
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/length.rb
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



typedef NSArray *(^ OMLengthValidatorTokenizerBlock) (NSObject *value);



@interface OMActiveModel (LengthValidation)



/*!
Validates that the specified property or properties matches the length restrictions supplied.

    @implementation Person
        + (void)initialize
        {
            [self validatesLengthOf:@"firstName" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setMaximum:[NSNumber numberWithInt:30]];
            }];

            [self validatesLengthOf:@"lastName" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setMaximum:[NSNumber numberWithInt:30]];
                [lengthValidator setMessage:@"less than %{count} if you don't mind"]
            }];

            [self validatesLengthOf:@"fax" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setAllowNil:YES];
                [lengthValidator setMinimum:[NSNumber numberWithInt:7]];
                [lengthValidator setMaximum:[NSNumber numberWithInt:32]];
            }];

            [self validatesLengthOf:@"phone" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setAllowBlank:YES];
                [lengthValidator setMinimum:[NSNumber numberWithInt:7]];
                [lengthValidator setMaximum:[NSNumber numberWithInt:32]];
            }];

            [self validatesLengthOf:@"userName" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setMinimum:[NSNumber numberWithInt:6]];
                [lengthValidator setTooShortMessage:@"pick a longer name"];
                [lengthValidator setMaximum:[NSNumber numberWithInt:20]];
                [lengthValidator setTooLongMessage:@"pick a shorter name"];
            }];

            [self validatesLengthOf:@"zipCode" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setMinimum:[NSNumber numberWithInt:5]];
                [lengthValidator setTooShortMessage:@"please enter at least %{count} characters"];
            }];

            [self validatesLengthOf:@"smurfLeader" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setEquals:[NSNumber numberWithInt:4]];
                [lengthValidator setWrongLengthMessage:@"papa is spelled with 4 characters... don't play me."];
            }];

            [self validatesLengthOf:@"essay" withInitBlock:^(OMValidator *validator)
            {
                OMLengthValidator *lengthValidator = (OMLengthValidator *)validator;
                [lengthValidator setMinimum:[NSNumber numberWithInt:100]];
                [lengthValidator setTooShortMessage:@"Your essay must be at least %{count} words."];
                [lengthValidator setTokenizer:^NSArray *(NSObject *value)
                {
                    NSString *stringValue = [value description];
                    return [stringValue componentsSeparatedByString:@" "];
                }];
            }];
        }
    @end

@param properties A NSString property name OR an NSArray of string property names.
@param block An OMValidatorInitBlock for initializing the validator instance's properties.
*/
+ (void)validatesLengthOf:(NSObject *)properties withInitBlock:(OMValidatorInitBlock)block;



/*!
 * Alias of validatesLengthOf:withInitBlock:.
 */
+ (void)validatesSizeOf:(NSObject *)properties withInitBlock:(OMValidatorInitBlock)block;



@end
