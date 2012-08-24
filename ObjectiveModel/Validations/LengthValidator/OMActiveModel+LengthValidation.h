/*
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/length.rb
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



typedef NSArray *(^ OMLengthValidatorTokenizerBlock) (NSObject *value);



/*!
 * @class OMActiveModel
 * @discussion Validates that the specified property or properties matches the length restrictions supplied.
 *
 * <pre>
 * @textblock
 * @implementation Person
 * + (void)initialize
 * {
 *     [self validatesLengthOf:@"firstName"
 *                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                              [NSNumber numberWithInt:30], @"maximum",
 *                              nil]
 *     ];
 *     
 *     [self validatesLengthOf:@"lastName"
 *                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                              [NSNumber numberWithInt:30], @"maximum",
 *                              @"less than %{count} if you don't mind", @"message",
 *                              nil]
 *     ];
 *     
 *     [self validatesLengthOf:@"fax"
 *                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                              [NSNumber numberWithInt:7], @"minimum",
 *                              [NSNumber numberWithInt:32], @"maximum",
 *                              @"Y", @"allowNil",
 *                              nil]
 *     ];
 *     
 *     [self validatesLengthOf:@"phone"
 *                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                              [NSNumber numberWithInt:7], @"minimum",
 *                              [NSNumber numberWithInt:32], @"maximum",
 *                              @"Y", @"allowBlank",
 *                              nil]
 *     ];
 *     
 *     [self validatesLengthOf:@"userName"
 *                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                              [NSNumber numberWithInt:6], @"minimum",
 *                              [NSNumber numberWithInt:20], @"maximum",
 *                              @"pick a shorter name", @"tooLongMessage",
 *                              @"pick a longer name", @"tooShortMessage",
 *                              nil]
 *     ];
 *     
 *     [self validatesLengthOf:@"zipCode"
 *                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                              [NSNumber numberWithInt:5], @"minimum",
 *                              @"please enter at least %{count} characters", @"tooShortMessage",
 *                              nil]
 *     ];
 *     
 *     [self validatesLengthOf:@"smurfLeader"
 *                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                              [NSNumber numberWithInt:4], @"equals",
 *                              @"papa is spelled with 4 characters... don't play me.", @"wrongLengthMessage",
 *                              nil]
 *     ];
 *     
 *     [self validatesLengthOf:@"essay"
 *                 withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                              [NSNumber numberWithInt:100], @"minimum",
 *                              @"Your essay must be at least %{count} words.", @"tooShortMessage",
 *                              nil]
 *                    andBlock:^(NSObject *)value
 *      {
 *          NSString *stringValue = [value description];
 *          return [stringValue componentsSeparatedByString:@" "];
 *      }
 *     ];
 * }
 * @end
 * @/textblock
 * </pre>
 */
@interface OMActiveModel (LengthValidation)



/*!
 * @brief Validates that the specified property or properties matches the length restrictions supplied.
 */
+ (void)validatesLengthOf:(NSObject *)properties withInitBlock:(OMValidatorInitBlock)block;



/*!
 * @brief Alias of validatesLengthOf:withBlock:.
 */
+ (void)validatesSizeOf:(NSObject *)properties withInitBlock:(OMValidatorInitBlock)block;



@end
