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



#import "OMValidator.h"



@implementation OMValidator



@synthesize options = _options;



- (void)dealloc
{
    [message release];
    [_options release];
    [super dealloc];
}



- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ( (self = [super init]) )
    {
        // TODO: allowNil, allowBlank, and message should be read-only!
        allowBlank = [[dictionary objectForKey:@"allowBlank"] boolValue];
        allowNil = [[dictionary objectForKey:@"allowNil"] boolValue];
        message = [dictionary objectForKey:@"message"];

        // remove allowBlank, allowNil, and message from the options dictionary
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        NSMutableArray *keys = [NSMutableArray array];
        [keys addObject:@"allowBlank"];
        [keys addObject:@"allowNil"];
        [keys addObject:@"message"];
        [options removeObjectsForKeys:keys];
        [self setOptions:options];
    }

    NSLog(@"validator: %@ initWithDictionary: %@", self, dictionary);

    return self;
}



- (BOOL)validateValue:(id *)ioValue error:(NSError **)outError
{
    if (
        // skip validation if value is nil and allowNil is true
        ( allowNil && *ioValue == nil )
        || 
        // skip validation if value is blank and allowBlank is true
        ( allowBlank && [*ioValue isBlank] )
    )
    {
        NSLog(@"skipping validation for: %@", self);
        return YES;
    }
    else
    {
        NSLog(@"applying validation for: %@", self);
        return [self validateValue:ioValue];
    }
}



- (BOOL)validateValue:(id *)ioValue
{
    [NSException raise:@"Method not implemented" format:@"Method validateValue: should be implemented in Validator subclass."];
    return NO;
}



@end
