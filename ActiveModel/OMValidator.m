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
@synthesize properties = _properties;



- (void)dealloc
{
    [_options release];
    [_properties release];
    
    [super dealloc];
}



- (id)initWithProperties:(NSArray *)properties andOptions:(NSDictionary *)options
{
    if ( (self = [super init]) )
    {
        [self setOptions:options];
        [self setProperties:properties];

        allowBlank = [[options objectForKey:@"allowBlank"] boolValue];
        allowNil = [[options objectForKey:@"allowNil"] boolValue];
        message = [options objectForKey:@"message"];
    }

    NSLog(@"validator init self: %@, properties: %@, options: %@", self, _properties, _options);

    return self;
}



- (void)validate:(OMActiveModel *)record
{
    NSLog(@"validate properties: %@", _properties);
    NSObject *value;
    for (NSString *property in _properties)
    {
        value = [record valueForKey:property];
        NSLog(@"validate: %@, for value: %@", property, value);
        NSLog(@"value == nil %d", (value == nil));
        NSLog(@"allowNil: %d", allowNil);
        if (
            // skip validation if value is nil and allowNil is true
            (value == nil && allowNil) || 
            // skip validation if value is blank and allowBlank is true
            ([value isBlank] && allowBlank)
        )
        {
            NSLog(@"validation skipping for: %@", property);
            continue;
        }
        [self validate:record withProperty:property andValue:value];
    }
}



- (void)validate:(OMActiveModel *)record withProperty:(NSString *)property andValue:(NSObject *)value;
{
    [NSException raise:@"Method not implemented" format:@"Method validate:withProperty:andValue should be implemented in Validator subclass."];
}



@end
