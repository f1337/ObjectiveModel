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



#import "OMValidator.h"
#import "OMActiveModel+FormatValidation.h"



@interface OMFormatValidator : OMValidator



/*!
 * If set to YES, then if the attribute matches the pattern it will result in a
 * successful validation. If set to NO, then if the attribute does not match the
 * pattern it will result in a successful validation.
 */
@property (assign) BOOL shouldMatchPattern;



/*!
 * A regular expression to apply to the attribute value.
 */
@property (copy) NSRegularExpression *regularExpression;



/*!
 * An OMFormatValidatorRegularExpressionBlock for generating the
 * regular expression to apply to the attribute value.
 * Supersedes the regularExpression property.
 */
@property (copy) OMFormatValidatorRegularExpressionBlock regularExpressionBlock;



/*!
 * A string to be converted to a regular expression and applied to the attribute
 * value.
 * Updates the regularExpression property.
 */
- (void)setPattern:(NSString *)pattern;



@end
