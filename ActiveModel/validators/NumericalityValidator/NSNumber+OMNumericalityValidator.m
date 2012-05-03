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



#import "OMNumericalityValidator.h"



@implementation NSNumber (OMNumericalityValidator)



- (BOOL)isEqualTo:(NSNumber *)expected
{
    return [self isEqualToNumber:expected];
}



- (BOOL)isEven
{
    return ([self isInteger] && ([self intValue] % 2 == 0));
}



- (BOOL)isGreaterThan:(NSNumber *)minimum
{
    return ( ([minimum compare:self] == NSOrderedAscending) ? YES : NO );
}



- (BOOL)isGreaterThanOrEqualTo:(NSNumber *)minimum
{
    NSComparisonResult result = [minimum compare:self];
    return ( (result == NSOrderedAscending || result == NSOrderedSame) ? YES : NO );
}



- (BOOL)isInteger
{
    return ([[NSString stringWithFormat:@"%d", [self integerValue]] isEqualToString:[self stringValue]] ? YES : NO);
}



- (BOOL)isLessThan:(NSNumber *)maximum
{
    return ( ([maximum compare:self] == NSOrderedDescending) ? YES : NO );
}



- (BOOL)isLessThanOrEqualTo:(NSNumber *)maximum
{
    NSComparisonResult result = [maximum compare:self];
    return ( (result == NSOrderedDescending || result == NSOrderedSame) ? YES : NO );
}



- (BOOL)isNotEqualTo:(NSNumber *)expected
{
    return (! [self isEqualToNumber:expected]);
}



- (BOOL)isOdd
{
    return ([self isInteger] && ([self intValue] % 2 == 1));
}



@end
