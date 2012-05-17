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
            
            // value must be an NSNumber, or a selector
            if ( [value isKindOfClass:[NSNumber class]] || (strcmp([value objCType], @encode(SEL)) == 0) )
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
            [NSException raise:NSInvalidArgumentException format:@"NumericalityValidator option (%@) is not a valid NSNumber selector.", key];
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

    NSLog(@"prefrack");

    // sanitize value: should be a number or string
    NSNumber *numericValue = nil;
    NSString *stringValue = nil;

    // if value is already an NSDecimalNumber, don't convert it
    if ( [value isKindOfClass:[NSDecimalNumber class]] )
    {
        numericValue = (NSDecimalNumber *)value;
        NSLog(@"numeric value set from NSDecimalNumber. in: %@, out: %@", value, numericValue);
    }
    // if value is already an NSNumber, don't convert it
    else if ( [value isKindOfClass:[NSNumber class]] )
    {
        numericValue = (NSNumber *)value;
        NSLog(@"numeric value set from NSNumber. in: %@, out: %@", value, numericValue);
    }
    // convert NSString value to NSDecimalNumber or NSNumber
    else if ( [value isKindOfClass:[NSString class]] )
    {
        stringValue = (NSString *)value;


        // first, see if NSNumberFormatter returns null, indicating bad input:
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        numericValue = [f numberFromString:stringValue];

        if ( ! numericValue )
        {
            return  NO;
        }
        // NSNumberFormatter returned a value
        // now try a more precise method, preserving original double/integer type
        else
        {
            NSRange separatorRange = [stringValue rangeOfString:[f decimalSeparator] options:NSLiteralSearch];

            // decimal separator not found
            if ( separatorRange.location == NSNotFound )
            {
                // we have an integer, so create an NSNumber from the string's integerValue
                // do NOT use the formatter's conversion, as it casts all values to double
                numericValue = [NSNumber numberWithInteger:[stringValue integerValue]];
                NSLog(@"number is an integer. no further conversion necessary. in: %@, out: %@", stringValue, numericValue);
            }
            // decimal separator found
            else
            {
                // perform add'l conversion to prevent decimal stripping!
                NSLog(@"number is not an integer. in: %@, formatter converted to: %@", stringValue, numericValue);

                // we have a float/double, so create an NSDecimalNumber from the
                // string's doubleValue
                numericValue = [NSDecimalNumber numberWithDouble:[stringValue doubleValue]];

                // log inconsistencies
                if ( ! [stringValue isEqualToString:[numericValue stringValue]] )
                {
                    NSLog(@"INCONSISTENT!");

                    // log result
                    NSLog(@"add'l conversion applied. in: %@, converted to: %@", stringValue, numericValue);
                }
            }
        }
        [f release];
        NSLog(@"FINAL number in: %@, number out: %@", stringValue, numericValue);
    }
    // if value isn't a number or string, fail validation
    else
    {
        return NO;
    }

    // extra sanity check, in case casting to numericValue ends in nil
    // in theory, the app should never reach this code,
    // but in testing it does, and i'm not sure why yet. ~mrf
    if ( ! numericValue )
    {
        NSAssert(@"UNREACHABLE!", @"Shouldn't get here!");
        return NO;
    }

    NSLog(@"postfrack");

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
