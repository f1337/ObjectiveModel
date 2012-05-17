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
//    // this is the only semi-sane way to determine if NSNumber was initialized
//    // with an int or not
//    return ( (strcmp([self objCType], @encode(int)) == 0) ? YES : NO );
    if (strcmp([self objCType], @encode(int)) == 0)
    {
        NSLog(@"NSNumber: %@ is an int", self);
        return YES;
    }
    else if (strcmp([self objCType], @encode(uint)) == 0)
    {
        NSLog(@"NSNumber: %@ is a uint", self);
        return YES;
    }
    else if (strcmp([self objCType], @encode(NSInteger)) == 0)
    {
        NSLog(@"NSNumber: %@ is an NSInteger", self);
        return YES;
    }
    else if (strcmp([self objCType], @encode(NSUInteger)) == 0)
    {
        NSLog(@"NSNumber: %@ is an NSUInteger", self);
        return YES;
    }
    else if (strcmp([self objCType], @encode(float)) == 0)
    {
        NSLog(@"NSNumber: %@ is a float", self);
    }
    else if (strcmp([self objCType], @encode(double)) == 0)
    {
    }
    else if (strcmp([self objCType], @encode(BOOL)) == 0)
    {
        NSLog(@"NSNumber: %@ is a BOOL", self);
    }
    else
    {
        NSLog(@"NSNumber: %@ is some other type: %s", self, [self objCType]);
    }

    return NO;

//    // fix to handle "negative zero"
//    NSString *stringValue = [self stringValue];
//    if ( [stringValue isEqualToString:@"-0"] )
//    {
//        stringValue = @"0";
//    }
//    
//    BOOL indeed = ([[NSString stringWithFormat:@"%d", [self integerValue]] isEqualToString:stringValue] ? YES : NO);
//    NSLog(@"NSNumber self: %@", self);
//    NSLog(@"NSNumber stringValue: %@", stringValue);
//    NSLog(@"NSNumber isInteger: %@", [NSNumber numberWithBool:indeed]);
////    NSLog(@"NSNumber decimalValue: %@", [self decimalValue]);
//    NSLog(@"NSNumber intValue: %d", [self intValue]);
//    NSLog(@"NSNumber integerValue: %d", [self integerValue]);
//    NSLog(@"NSNumber doubleValue: %f", [self doubleValue]);
//    NSLog(@"NSNumber floatValue: %f", [self floatValue]);
//
//    return indeed;
}
/*
 - (BOOL)isInteger
 {
 // fix to handle "negative zero"
 // not sure if we really want to support "negative zero"
 // if support is removed, unit test should be updated
 NSString *stringValue = [self stringValue];
 if ( [stringValue isEqualToString:@"-0"] )
 {
 stringValue = @"0";
 }
 
 return ([[NSString stringWithFormat:@"%d", [self integerValue]] isEqualToString:stringValue] ? YES : NO);
 }
 */


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
