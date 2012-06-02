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



typedef NSArray *(^ OMLengthValidatorTokenizerBlock) (NSObject *);



@interface OMActiveModel (LengthValidation)



/*!
 * Validates that the specified attribute matches the length restrictions supplied.
 *
 *   @implementation Person
 *		+ (void)initialize
 *		{
 *          [self validatesLengthOf:@"firstName"
 *                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                                      [NSNumber numberWithInt:30], @"maximum",
 *                                      nil]
 *          ];
 *
 *          [self validatesLengthOf:@"lastName"
 *                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                                      [NSNumber numberWithInt:30], @"maximum",
 *                                      @"less than %{count} if you don't mind", @"message",
 *                                      nil]
 *          ];
 *
 *          [self validatesLengthOf:@"fax"
 *                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                                      [NSNumber numberWithInt:7], @"minimum",
 *                                      [NSNumber numberWithInt:32], @"maximum",
 *                                      @"Y", @"allowNil",
 *                                      nil]
 *          ];
 *
 *          [self validatesLengthOf:@"phone"
 *                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                                      [NSNumber numberWithInt:7], @"minimum",
 *                                      [NSNumber numberWithInt:32], @"maximum",
 *                                      @"Y", @"allowBlank",
 *                                      nil]
 *          ];
 *
 *          [self validatesLengthOf:@"userName"
 *                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                                      [NSNumber numberWithInt:6], @"minimum",
 *                                      [NSNumber numberWithInt:20], @"maximum",
 *                                      @"pick a shorter name", @"tooLongMessage",
 *                                      @"pick a longer name", @"tooShortMessage",
 *                                      nil]
 *          ];
 *
 *          [self validatesLengthOf:@"zipCode"
 *                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                                      [NSNumber numberWithInt:5], @"minimum",
 *                                      @"please enter at least %{count} characters", @"tooShortMessage",
 *                                      nil]
 *          ];
 *
 *          [self validatesLengthOf:@"smurfLeader"
 *                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                                      [NSNumber numberWithInt:4], @"equals",
 *                                      @"papa is spelled with 4 characters... don't play me.", @"wrongLengthMessage",
 *                                      nil]
 *          ];
 *
 *	    	[self validatesLengthOf:@"essay"
 *                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
 *                                      [NSNumber numberWithInt:100], @"minimum",
 *                                      @"Your essay must be at least %{count} words.", @"tooShortMessage",
 *                                      nil]
 *                      andBlock:^(id)value
 *                      {
 *                          NSString *stringValue = [value description];
 *                          return [stringValue componentsSeparatedByString:@" "];
 *                      }
 *          ];
 *		}
 *   @end
 */
+ (void)validatesLengthOf:(NSObject *)properties withOptions:(NSDictionary *)options;
+ (void)validatesLengthOf:(NSObject *)properties withOptions:(NSDictionary *)options andBlock:(OMLengthValidatorTokenizerBlock)block;
// aliases:
+ (void)validatesSizeOf:(NSObject *)properties withOptions:(NSDictionary *)options;
+ (void)validatesSizeOf:(NSObject *)properties withOptions:(NSDictionary *)options andBlock:(OMLengthValidatorTokenizerBlock)block;



@end
