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



#import "OMValidator.h"
#import "OMActiveModel+LengthValidation.h"
#import "NSNumber+ComparisonMethods.h"



@interface OMLengthValidator : OMValidator



/*!
 * The exact size of the attribute.
 */
@property (nonatomic, copy) NSNumber *equals;



/*!
 * The maximum size of the attribute.
 */
@property (nonatomic, copy) NSNumber *maximum;



/*!  
 * The error message to use for a minimum, maximum, or equals violation.
 * An alias of the tooLongMessage, tooShortMessage, and wrongLengthMessage.
 */
- (NSString *)message;



/*!
 * The minimum size of the attribute.
 */
@property (nonatomic, copy) NSNumber *minimum;



/*!
 * The error message if the attribute goes over the maximum
 * (default is: "is too long (maximum is %{count} characters)").
 */
@property (copy) NSString *tooLongMessage;
                                          
                                          
                                          
/*!
 * The error message if the attribute goes under the minimum
 * (default is: "is too short (minimum is %{count} characters)").
 */
@property (copy) NSString *tooShortMessage;
                                          
                                          
                                          
/*!
 * Specifies how to split up the attribute string, e.g.:
 *
 * [Topic validatesLengthOf:@"content"
 *              withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                           [NSNumber numberWithInt:5], @"minimum",
 *                           @"Your essay must be at least %{count} words.", @"tooShortMessage",
 *                           nil]
 *                 andBlock:^NSArray *(NSObject *value)
 *  {
 *      NSString *stringValue = [value description];
 *      NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:@"\\w+" options:0 error:nil];
 *      return [pattern matchesInString:stringValue options:NSMatchingReportCompletion range:NSMakeRange(0, [stringValue length])];
 *  }];
 *
 * ...to count words as in above example.
 * Defaults to counting individual characters.
 */
@property (copy) OMLengthValidatorTokenizerBlock tokenizer;



/*!
 * The error message if using @"equals" and the attribute is the wrong size
 * (default is: "is the wrong length (should be is %{count} characters)").
 */
@property (copy) NSString *wrongLengthMessage;



@end
