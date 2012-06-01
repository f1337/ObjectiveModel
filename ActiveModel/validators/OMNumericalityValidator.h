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
#import "OMActiveModel+OMNumericalityValidator.h"
#import "NSNumber+ComparisonMethods.h"



@interface OMNumericalityValidator : OMValidator
{
    NSDictionary *_filteredOptions;
}



/*!
 * A custom error message (default is: "is not a number").
 */
- (NSString *)message;



//* * <tt>"integer"</tt> - Specifies whether the value has to be an integer, e.g. an integral value (default is +false+).
//* * <tt>"greaterThan"</tt> - Specifies the value must be greater than the supplied value.
//* * <tt>"greaterThanOrEqualTo"</tt> - Specifies the value must be greater than or equal the supplied value.
//* * <tt>"equalTo"</tt> - Specifies the value must be equal to the supplied value.
//* * <tt>"notEqualTo"</tt> - Specifies the value must be other than the supplied value.
//* * <tt>"lessThan"</tt> - Specifies the value must be less than the supplied value.
//* * <tt>"lessThanOrEqualTo"</tt> - Specifies the value must be less than or equal the supplied value.
//* * <tt>"odd"</tt> - Specifies the value must be an odd number.
//* * <tt>"even"</tt> - Specifies the value must be an even number.



@end
