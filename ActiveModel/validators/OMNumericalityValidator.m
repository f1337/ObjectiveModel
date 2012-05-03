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



@interface OMNumericalityValidator (Private)



-(SEL)selectorFromOption:(NSString *)option;



@end



@implementation OMNumericalityValidator



- (id)initWithProperties:(NSArray *)p andOptions:(NSDictionary *)options
{
    if ( (self = [super initWithProperties:p andOptions:options]) )
    {
        if ( ! message )
        {
            message = @"is not a valid number.";
        }

        // verify options input
        for (NSString *key in options)
        {
            // option key must be a valid NSNumber selector
            if ( [self selectorFromOption:key] )
            {
                id value = [options objectForKey:key];

                // value must be an NSNumber, or a selector
                if ( [value isKindOfClass:[NSNumber class]] || (strcmp([value objCType], @encode(SEL)) == 0) )
                {
                    
                }
                else
                {
                    [NSException raise:NSInvalidArgumentException format:@"NumericalityValidator option (%@) value (%@) is not an NSNumber or selector.", key, value];
                }
            }
            else
            {
                [NSException raise:NSInvalidArgumentException format:@"NumericalityValidator option (%@) is not a valid NSNumber selector.", key];
            }
        }
    }
    
    return self;
}



/*!
 * Returns the selector for the given option constraint,
 * e.g. [self selectorFromOption:@"odd"] => @selector(isOdd)
 */
-(SEL)selectorFromOption:(NSString *)option
{
    NSMutableString *selectorName = [NSMutableString stringWithFormat:@"is%@%@", [[option substringToIndex:1] uppercaseString], [option substringFromIndex:1]];
    SEL selector = NSSelectorFromString(selectorName);

    if ( ! [NSNumber instancesRespondToSelector:selector] )
    {
        [selectorName appendString:@":"];
        selector = NSSelectorFromString(selectorName);

        if ( ! [NSNumber instancesRespondToSelector:selector] )
        {
            return nil;
        }
    }

    return selector;
}



- (void)validate:(OMActiveModel *)record withProperty:(NSString *)property andValue:(NSObject *)value
{
    // if allowNil and value is nil, skip validation
    if ( allowNil && value == nil )
    {
        return;
    }

    // if value isn't a number, raise an error
    NSNumber *numericValue = (NSNumber *)value;
    if ( ! numericValue )
    {
        [[record errors] setObject:[NSString stringWithFormat:@"%@ %@", property, message] forKey:property];
        return;
    }

    for (NSString *option in [self options])
    {
        // convert "odd" constraint to @selector(isOdd)
        SEL selector = [self selectorFromOption:option];
        if ( selector )
        {
            BOOL valid = YES;
            id value = [[self options] objectForKey:option];
            NSString *selectorString = NSStringFromSelector(selector);
            if ( [selectorString hasSuffix:@":"] )
            {
                valid = (BOOL)[numericValue performSelector:selector withObject:value];
            }
            else
            {
                valid = (BOOL)[numericValue performSelector:selector];
            }

            if ( ! valid )
            {
                [[record errors] setObject:[NSString stringWithFormat:@"%@ %@", property, message] forKey:property];
                return;
            }
        }
    }
}



@end
