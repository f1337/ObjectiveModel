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



typedef NSRegularExpression *(^ OMFormatValidatorRegularExpressionBlock) (id);



@interface OMActiveModel (FormatValidation)



/*!
 * Validates whether the value of the specified attribute is of the correct
 * form, going by the regular expression provided.You can require that the
 * attribute matches the regular expression:
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
 *	    	[self validatesFormatOf:@"email" withOptions:nil andPattern:@"\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z"];
 *		}
 *   @end
 *
 * Alternatively, you can require that the specified attribute does _not_
 * match the regular expression:
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
 *	    	[self validatesFormatOf:@"email" withOptions:[NSDictionary dictionaryWithObjectsAndKeys:@"NO", @"matchesPattern", nil] andPattern:@"NOSPAM"];
 *		}
 *   @end
 *
 * You can also provide a block which will determine the regular
 * expression that will be used to validate the attribute.
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
 *	    	[self validatesFormatOf:@"nickName" withOptions:nil andBlock:^(id)person
 *          {
 *              NSString *pattern;
 *
 *              if ( [person isAdmin] )
 *              {
 *                  pattern = @"\A[a-z0-9][a-z0-9_\-]*\Z";
 *              }
 *              else
 *              {
 *                  pattern = @"\A[a-z][a-z0-9_\-]*\Z";
 *              }
 *
 *              return [NSRegularExpression regularExpressionWithPattern:pattern
 *                                                               options:NSRegularExpressionCaseInsensitive
 *                                                                 error:nil];
 *          }];
 *		}
 *   @end
 *
 * Note: use <tt>\A</tt> and <tt>\Z</tt> to match the start and end of the
 * string, <tt>^</tt> and <tt>$</tt> match the start/end of a line.
 * http://developer.apple.com/library/ios/documentation/Foundation/Reference/NSRegularExpression_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40009708-CH1-SW53
 * 
 * Configuration options:
 * * <tt>message</tt> - A custom error message (default is: "is invalid").
 * * <tt>allowNil</tt> - If set to true, skips this validation if the attribute
 *   is +nil+ (default is +false+).
 * * <tt>allow_blank</tt> - If set to true, skips this validation if the
 *   attribute is blank (default is +false+).
 * * <tt>matchesPattern</tt> - If set to YES, then if the attribute matches the
 *   pattern it will result in a successful validation. If set to NO, then if
 *   the attribute does not match the pattern it will result in a successful
 *   validation.
 * * <tt>on</tt> - Specifies when this validation is active. Runs in all
 *   validation contexts by default (+nil+), other options are <tt>create</tt>
 *   and <tt>update</tt>.
 * * <tt>if</tt> - Specifies a method, proc or string to call to determine
 *   if the validation should occur (e.g. <tt>if => @selector(allowValidation)</tt>, or
 *   <tt>if => Proc.new { |user| user.signup_step > 2 }</tt>). The method, proc
 *   or string should return or evaluate to a true or false value.
 * * <tt>unless</tt> - Specifies a method, proc or string to call to determine
 *   if the validation should not occur (e.g. <tt>unless => @selector(skipValidation)</tt>,
 *   or <tt>unless => Proc.new { |user| user.signup_step <= 2 }</tt>). The
 *   method, proc or string should return or evaluate to a true or false value.
 * * <tt>strict</tt> - Specifies whether validation should be strict. 
 *   See <tt>ActiveModel::Validation#validates!</tt> for more information.
 */
+ (void)validatesFormatOf:(NSObject *)properties withOptions:(NSDictionary *)options andBlock:(OMFormatValidatorRegularExpressionBlock)block;
+ (void)validatesFormatOf:(NSObject *)properties withOptions:(NSDictionary *)options andPattern:(NSString *)pattern;
+ (void)validatesFormatOf:(NSObject *)properties withOptions:(NSDictionary *)options andRegularExpression:(NSRegularExpression *)regularExpression;



@end

