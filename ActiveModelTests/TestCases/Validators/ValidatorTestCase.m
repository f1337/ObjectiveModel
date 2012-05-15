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



#import "ValidatorTestCase.h"



@implementation ValidatorTestCase



#pragma mark - CUSTOM ASSERTIONS



- (void)assertPropertyIsValid:(NSString *)property forModel:(OMActiveModel *)model
{
    id value = [model valueForKey:property];
    NSError *error = nil;
    STAssertTrue([model validateValue:&value forKey:property error:&error], @"Model property '%@' is invalid, but expected to be valid. Error: %@.", property, error);
}



- (void)assertPropertyIsInvalid:(NSString *)property forModel:(OMActiveModel *)model
{
    id value = [model valueForKey:property];
    NSError *error = nil;
    STAssertFalse([model validateValue:&value forKey:property error:&error], @"Model property '%@' is valid, but expected to be invalid.", property);
    NSLog(@"assertPropertyIsInvalid error: %@", error);
}



@end
