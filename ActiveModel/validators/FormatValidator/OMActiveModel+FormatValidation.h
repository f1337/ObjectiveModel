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
 *	    	[self validatesFormatOf:@"email" withOptions:[NSDictionary dictionaryWithObjectsAndKeys:@"NO", @"shouldMatchPattern", nil] andPattern:@"NOSPAM"];
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
 */
+ (void)validatesFormatOf:(NSObject *)properties withOptions:(NSDictionary *)options andBlock:(OMFormatValidatorRegularExpressionBlock)block;
+ (void)validatesFormatOf:(NSObject *)properties withOptions:(NSDictionary *)options andPattern:(NSString *)pattern;
+ (void)validatesFormatOf:(NSObject *)properties withOptions:(NSDictionary *)options andRegularExpression:(NSRegularExpression *)regularExpression;



@end

