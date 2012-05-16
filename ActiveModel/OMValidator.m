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
#import <CoreData/CoreData.h>



@implementation OMValidator



@synthesize options = _options;



- (void)dealloc
{
    [_message release];
    [_options release];
    [super dealloc];
}



- (id)init
{
    if ( (self = [super init]) )
    {
        // set the default message
        _message = @"is invalid";
    }
    
    return self;
}


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ( (self = [self init]) )
    {
        [self setOptions:dictionary];
    }

    return self;
}



- (NSString *)message
{
    return _message;
}



- (void)setOptions:(NSDictionary *)options
{
    if ( _options != options )
    {
        [_options release];
        _options = options;
        [_options retain];

        // TODO: allowNil, allowBlank, and message should be read-only!
        allowBlank = [[_options objectForKey:@"allowBlank"] boolValue];
        allowNil = [[_options objectForKey:@"allowNil"] boolValue];
        if ( [_options objectForKey:@"message"] )
        {
            _message = [_options objectForKey:@"message"];
        }
    }
}



- (BOOL)validateValue:(NSObject *)value error:(NSError **)outError
{
    if (
        // skip validation if value is nil or NSNull and allowNil is true
        ( allowNil && (value == nil || [value isKindOfClass:[NSNull class]]) )
        || 
        // skip validation if value is blank and allowBlank is true
        ( allowBlank && [value isBlank] )
    )
    {
        NSLog(@"skipping validation for: %@", self);
        return YES;
    }
    else
    {
        return [self validateValue:value];
    }
}



- (BOOL)validateValue:(NSObject *)value
{
    [NSException raise:@"Method not implemented" format:@"Method validateValue: should be implemented in Validator subclass."];
    return NO;
}



@end
