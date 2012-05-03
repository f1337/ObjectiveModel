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



#import <Foundation/Foundation.h>



/*!
 * An object is blank if it is false, empty, or a whitespace string.
 * For example, @“”, @“ ”, nil, [], and {} are all blank.
 *
 *
 * NSNull is always blank:
 *
 * [[NSNull null] isBlank] => YES
 *
 *
 * An NSArray is blank if it is empty:
 *
 * [[NSArray array] isBlank] => YES
 * [[NSArray arrayWithObjects:@"a", @"b", @"c", nil] isBlank] => NO
 *
 *
 * An NSDictionary is blank if it is empty:
 *
 * [[NSDictionary dictionary] isBlank] => YES
 * [[NSDictionary dictionaryWithObjectsAndKeys:@"value", @"key", nil] isBlank] => NO
 *
 *
 * An NSSet is blank if it is empty:
 *
 * [[NSSet set] isBlank] => YES
 * [[NSSet setWithObjects:@"a", @"b", @"c", nil] isBlank] => NO
 *
 *
 * An NSString is blank if it is empty or contains only whitespace:
 *
 * [[NSString stringWithString:@""] isBlank] => YES
 * [[NSString stringWithString:@"   "] isBlank] => YES
 * [[NSString stringWithString:@" some text"] isBlank] => NO
 *
 *
 * An NSNumber is never blank:
 *
 * [[NSNumber numberWithBool:0] isBlank] => NO
 * [[NSNumber numberWithInt:0] isBlank] => NO
 * [[NSNumber numberWithInteger:1] isBlank] => NO
 */
@interface NSObject (Blank)
- (BOOL)isBlank;
@end
