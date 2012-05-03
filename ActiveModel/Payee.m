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



#import "Payee.h"
#import "OMNumericalityValidator.h"
#import "OMPresenceValidator.h"



@implementation Payee



@synthesize three;
@synthesize two;
@synthesize name;
@synthesize ratio;



// this initialize method is invoked *after* its superclass initialize method
+ (void)initialize
{
    // setup validations
    // OMNumericalityValidator:
    // test multiple properties sharing constraints
    [self validatesNumericalityOf:[NSArray arrayWithObjects:@"two", @"three", @"ratio", nil]
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:1.1], @"greaterThan",
                                   [NSNumber numberWithInt:0], @"greaterThanOrEqualTo",
                                   [NSNumber numberWithInt:16], @"lessThan",
                                   [NSNumber numberWithInt:20.50], @"lessThanOrEqualTo",
                                   [NSNumber numberWithInt:25], @"notEqualTo",
                                   nil]];

    // test even integer contraints
    [self validatesNumericalityOf:@"two"
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:2], @"equalTo",
                                   [NSNumber numberWithBool:YES], @"even",
                                   [NSNumber numberWithInt:2], @"greaterThanOrEqualTo",
                                   [NSNumber numberWithBool:YES], @"integer",
                                   [NSNumber numberWithInt:2], @"lessThanOrEqualTo",
                                   nil]];

    // test odd integer contraints & allowNil
    [self validatesNumericalityOf:@"three"
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:3], @"equalTo",
                                   [NSNumber numberWithInt:3], @"greaterThanOrEqualTo",
                                   [NSNumber numberWithBool:YES], @"integer",
                                   [NSNumber numberWithInt:3], @"lessThanOrEqualTo",
                                   [NSNumber numberWithBool:YES], @"odd",
                                   nil]];

    // test float <=> integer constraints
    [self validatesNumericalityOf:@"ratio"
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:15.25], @"equalTo",
                                   [NSNumber numberWithFloat:15.25], @"greaterThanOrEqualTo",
                                   [NSNumber numberWithFloat:15.25], @"lessThanOrEqualTo",
                                   nil]];


    // OMPresenceValidator:
    [self validatesPresenceOf:@"name" withOptions:nil];
}



@end
