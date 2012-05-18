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



- (id)init
{
    if ( (self = [super init]) )
    {
        // set the default message
        _message = @"is not a valid number";
    }

    return self;
}



- (void)setOptions:(NSDictionary *)options
{
    NSMutableDictionary *filteredOptions = [NSMutableDictionary dictionaryWithDictionary:options];
    NSMutableArray *keys = [NSMutableArray array];
    [keys addObject:@"allowBlank"];
    [keys addObject:@"allowNil"];
    [keys addObject:@"message"];
    [filteredOptions removeObjectsForKeys:keys];


    // verify options input
    for (NSString *key in filteredOptions)
    {
        // option key must be a valid NSNumber selector
        if ( [self selectorFromOption:key] )
        {
            id value = [filteredOptions objectForKey:key];

            // value must be an NSNumber, or an NSNumber selector
            if (
                [value isKindOfClass:[NSNumber class]]
                ||
                ( [value respondsToSelector:@selector(objCType)] && strcmp([value objCType], @encode(SEL)) == 0)
            )
            {
                // all is well
            }
            else
            {
                [NSException raise:NSInvalidArgumentException format:@"NumericalityValidator option (%@) value (%@) is not an NSNumber or selector.", key, value];
            }
        }
        else
        {
            [NSException raise:NSInvalidArgumentException format:@"NumericalityValidator option (%@) is not a valid NSNumber constraint.", key];
        }
    }

    
    // store the filtered options for use in validation methods
    [_filteredOptions release];
    _filteredOptions = filteredOptions;
    [_filteredOptions retain];

    
    // we still want to retain the unfiltered options hash
    [super setOptions:options];
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



- (BOOL)validateValue:(NSObject *)value
{
    // if allowNil and value is nil, skip validation
    if ( allowNil && (value == nil) )
    {
        [NSException raise:@"UNREACHABLE" format:@"This code should be unreachable, by virtue of superclass' nil/blank checks."];
        return YES;
    }

    // sanitize value: should be a number or string
    NSNumber *numericValue = nil;
    NSString *stringValue = nil;

    // if value is already an NSDecimalNumber, don't convert it
    if ( [value isKindOfClass:[NSDecimalNumber class]] )
    {
        numericValue = (NSDecimalNumber *)value;
    }
    // if value is already an NSNumber, don't convert it
    else if ( [value isKindOfClass:[NSNumber class]] )
    {
        numericValue = (NSNumber *)value;
    }
    // convert NSString value to NSDecimalNumber or NSNumber
    else if ( [value isKindOfClass:[NSString class]] )
    {
        stringValue = (NSString *)value;


        // first, see if NSNumberFormatter returns null, indicating bad input:
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        numericValue = [f numberFromString:stringValue];

        // if NSNumberFormatter failed to convert, numericValue will be nil
        if ( ! numericValue )
        {
            return  NO;
        }
        // NSNumberFormatter returned a value
        // now try a more precise method, preserving original double/integer type
        else
        {
            // is there a decimal separator in the string?
            NSRange separatorRange = [stringValue rangeOfString:[f decimalSeparator] options:NSLiteralSearch];

            // decimal separator not found
            if ( separatorRange.location == NSNotFound )
            {
                // we have an integer, so create an NSNumber from the string's integerValue
                // do NOT use the formatter's conversion, as it casts all values to double
                numericValue = [NSNumber numberWithInteger:[stringValue integerValue]];
            }
            // decimal separator found
            else
            {
                // we have a float/double, so create an NSDecimalNumber from the
                // string's doubleValue
                numericValue = [NSDecimalNumber numberWithDouble:[stringValue doubleValue]];
            }
        }
        [f release];
    }
    // if value isn't a number or string, fail validation
    else
    {
        return NO;
    }

    for (NSString *option in _filteredOptions)
    {
        // convert "odd" constraint to @selector(isOdd)
        SEL selector = [self selectorFromOption:option];
        if ( selector )
        {
            BOOL valid = YES;
            NSString *selectorString = NSStringFromSelector(selector);

            if ( [selectorString hasSuffix:@":"] )
            {
                id value = [_filteredOptions objectForKey:option];
                valid = (BOOL)[numericValue performSelector:selector withObject:value];
            }
            else
            {
                valid = (BOOL)[numericValue performSelector:selector];
            }

            if ( ! valid )
            {
                return NO;
            }
        }
    }

    return YES;
}



@end
