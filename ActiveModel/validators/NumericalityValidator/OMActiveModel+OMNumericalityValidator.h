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



#import "OMActiveModel.h"



typedef NSNumber *(^ OMNumericalityValidatorNumberBlock) (id);



@interface OMActiveModel (OMNumericalityValidator)



/*!
 * Validates whether the value of the specified property is numeric by trying to convert it to
 * an NSNumber.
 *
 *   @interface Person : OMActiveModel
 *		@property (assign) NSNumber *age;
 *   @end
 *
 *   @interface Person
 *		@synthesize firstName;
 *
 *		+ (void)initialize
 *		{
 *	    	[self validatesNumericalityOf:@"age" withOptions:nil];
 *		}
 *   @end
 *
 * Configuration options:
 * * <tt>"message"</tt> - A custom error message (default is: "is not a number").
 * * <tt>"on"</tt> - Specifies when this validation is active. Runs in all
 *   validation contexts by default (+nil+), other options are <tt>"create"</tt>
 *   and <tt>"update"</tt>.
 * * <tt>"integer"</tt> - Specifies whether the value has to be an integer, e.g. an integral value (default is +false+).
 * * <tt>"allowNil"</tt> - Skip validation if attribute is +nil+ (default is +false+). Notice that for fixnum and float columns empty strings are converted to +nil+.
 * * <tt>"greaterThan"</tt> - Specifies the value must be greater than the supplied value.
 * * <tt>"greaterThanOrEqualTo"</tt> - Specifies the value must be greater than or equal the supplied value.
 * * <tt>"equalTo"</tt> - Specifies the value must be equal to the supplied value.
 * * <tt>"notEqualTo"</tt> - Specifies the value must be other than the supplied value.
 * * <tt>"lessThan"</tt> - Specifies the value must be less than the supplied value.
 * * <tt>"lessThanOrEqualTo"</tt> - Specifies the value must be less than or equal the supplied value.
 * * <tt>"odd"</tt> - Specifies the value must be an odd number.
 * * <tt>"even"</tt> - Specifies the value must be an even number.
 * * <tt>"if"</tt> - Specifies a selector to call to determine if the validation should
 *   occur (e.g. <tt>"if" => "allowValidation"</tt>. The selector should return YES or NO.
 * * <tt>"unless"</tt> - Specifies a selector to call to determine if the validation should
 *   not occur (e.g. <tt>"unless" => "skipValidation"</tt>. The selector should return YES or NO.
 * * <tt>"strict"</tt> - YES or NO. Specifies whether the validator should throw a runtime exception
 *	 if the validation fails.
 *
 * The following options can also be supplied with a selector:
 * * <tt>"greaterThan"</tt>
 * * <tt>"greaterThanOrEqualTo"</tt>
 * * <tt>"equalTo"</tt>
 * * <tt>"lessThan"</tt>
 * * <tt>"lessThanOrEqualTo"</tt>
 */
+ (void)validatesNumericalityOf:(NSObject *)properties withOptions:(NSDictionary *)options;



@end
