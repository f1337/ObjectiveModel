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



@interface OMActiveModel (OMPresenceValidator)
/*!
 * @param properties A string property name OR
 * a collection of string property names conforming to NSFastEnumeration.
 *
 * Validates that the specified attributes are not blank (as defined by NSObject+Blank). Example:
 *
 *   @interface Person : OMActiveModel
 *		@property (assign) NSString *firstName;
 *   @end
 *
 *   @interface Person
 *		@synthesize firstName;
 *
 *		+ (void)initialize
 *		{
 *	    	[self validatesPresenceOf:@"firstName" withOptions:nil];
 *		}
 *   @end
 *
 * The firstName property must be defined for the object and it cannot be nil or blank.
 *
 * Configuration options:
 * * <tt>"message"</tt> - A custom error message (default is: "can't be blank").
 * * TODO: <tt>"on"</tt> - Specifies when this validation is active. Runs in all
 *   validation contexts by default (+nil+), other options are <tt>"create"</tt>
 *   and <tt>"update"</tt>.
 * * TODO: <tt>"if"</tt> - Specifies a selector to call to determine if the validation should
 *   occur (e.g. <tt>"if" => @selector(allowValidation)</tt>. The selector should return YES or NO.
 * * TODO: <tt>"unless"</tt> - Specifies a selector to call to determine if the validation should
 *   not occur (e.g. <tt>"unless" => @selector(skipValidation)</tt>. The selector should return YES or NO.
 * * TODO: <tt>"strict"</tt> - YES or NO. Specifies whether the validator should throw a runtime exception
 *	 if the validation fails.
 */
+ (void)validatesPresenceOf:(NSObject *)properties withOptions:(NSDictionary *)options;
@end
