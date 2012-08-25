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



@interface NSNumber (ComparisonMethods)



/*!
Returns YES if this number is even (divisible by 2 with no remainder), else NO.
*/
- (BOOL)isEven;



/*!
Returns YES if this number is greater than the minimum number provided, else NO.
*/
- (BOOL)isGreaterThanNumber:(NSNumber *)minimum;



/*!
Returns YES if this number is greater than or equal to the minimum number provided, else NO.
*/
- (BOOL)isGreaterThanOrEqualToNumber:(NSNumber *)minimum;



/*!
Returns YES if this number is less than the maximum number provided, else NO.
*/
- (BOOL)isLessThanNumber:(NSNumber *)maximum;



/*!
Returns YES if this number is less than or equal to the maximum number provided, else NO.
*/
- (BOOL)isLessThanOrEqualToNumber:(NSNumber *)maximum;



/*!
Returns YES if this number is an integer, else NO.
*/
- (BOOL)isInteger;



/*!
Returns YES if this number is equal to the expected number provided, else NO.
*/
- (BOOL)isNotEqualToNumber:(NSNumber *)expected;



/*!
Returns YES if this number is odd (*not* divisible by 2 without remainder), else NO.
*/
- (BOOL)isOdd;



@end
