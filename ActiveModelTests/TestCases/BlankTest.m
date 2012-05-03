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



#import "BlankTest.h"


@implementation BlankTest



#pragma mark -
#pragma mark NSNull



- (void)testNSNullShouldAlwaysBeBlank
{
    STAssertTrue([[NSNull null] isBlank], @"NSNull -isBlank should always return YES, but returned NO.");
}



#pragma mark -
#pragma mark NSArray



- (void)testEmptyNSArrayShouldBeBlank
{
    STAssertTrue([[NSArray array] isBlank], @"NSArray -isBlank should return YES for an empty array, but returned NO.");
}



- (void)testNSArrayWithOneObjectShouldNotBeBlank
{
    STAssertFalse([[NSArray arrayWithObject:@"a"] isBlank], @"NSArray -isBlank should return NO for an array with one object, but returned YES.");
}



- (void)testNSArrayWithObjectsShouldNotBeBlank
{
    NSArray *array = [NSArray arrayWithObjects:@"a", @"b", @"c", nil];
    STAssertFalse([array isBlank], @"NSArray -isBlank should return NO for an array with objects, but returned YES.");
}



#pragma mark -
#pragma mark NSDictionary



- (void)testEmptyNSDictionaryShouldBeBlank
{
    STAssertTrue([[NSDictionary dictionary] isBlank], @"NSDictionary -isBlank should return YES for an empty dictionary, but returned NO.");
}



- (void)testNSDictionaryWithOneObjectShouldNotBeBlank
{
    STAssertFalse([[NSDictionary dictionaryWithObject:@"value" forKey:@"key"] isBlank], @"NSDictionary -isBlank should return NO for a dictionary with one object, but returned YES.");
}



- (void)testNSDictionaryWithObjectsShouldNotBeBlank
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"value A", @"keyA", @"value B", @"keyB", @"value C", @"keyC", nil];
    STAssertFalse([dictionary isBlank], @"NSDictionary -isBlank should return NO for a dictionary with objects, but returned YES.");
}



/*!
 * An  is blank if it is empty:
 *
 * [NSSet set] isBlank] => YES
 * [NSSet setWithObjects:@"a", @"b", @"c", nil] isBlank] => NO
 */

#pragma mark -
#pragma mark NSSet



- (void)testEmptyNSSetShouldBeBlank
{
    STAssertTrue([[NSSet set] isBlank], @"NSSet -isBlank should return YES for an empty set, but returned NO.");
}



- (void)testNSSetWithOneObjectShouldNotBeBlank
{
    STAssertFalse([[NSSet setWithObject:@"a"] isBlank], @"NSSet -isBlank should return NO for a set with one object, but returned YES.");
}



- (void)testNSSetWithObjectsShouldNotBeBlank
{
    NSSet *set = [NSSet setWithObjects:@"a", @"b", @"c", nil];
    STAssertFalse([set isBlank], @"NSSet -isBlank should return NO for a set with objects, but returned YES.");
}



#pragma mark -
#pragma mark NSString



- (void)testEmptyNSStringShouldBeBlank
{
    STAssertTrue([[NSString stringWithString:@""] isBlank], @"NSString -isBlank should return YES for empty string, but returned NO.");
}



- (void)testWhitespaceNSStringShouldBeBlank
{
    STAssertTrue([[NSString stringWithString:@"   "] isBlank], @"NSString -isBlank should return YES for a whitespace string, but returned NO.");
}



- (void)testNSStringWithNonWhitespaceCharactersShouldNotBeBlank
{
    STAssertFalse([[NSString stringWithString:@" some text"] isBlank], @"NSString -isBlank should return NO for a string containing non-whitespace characters, but returned YES.");
}




#pragma mark -
#pragma mark NSNumber



- (void)testNSNumberShouldNeverBeBlank
{
    NSString *message = @"NSNumber -isBlank should always return NO, but returned YES.";
    STAssertFalse([[NSNumber numberWithBool:0] isBlank], message);
    STAssertFalse([[NSNumber numberWithInt:0] isBlank], message);
    STAssertFalse([[NSNumber numberWithDouble:23.234223] isBlank], message);
    STAssertFalse([[NSNumber numberWithFloat:34.2] isBlank], message);
    STAssertFalse([[NSNumber numberWithInteger:-1] isBlank], message);
}



@end
