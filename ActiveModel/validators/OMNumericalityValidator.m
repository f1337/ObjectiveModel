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



+ (NSNumberFormatter *)numberFormatter;



- (NSString *)messageForSelectorString:(NSString *)selectorString withNumber:(NSNumber *)number;
- (SEL)selectorFromOption:(NSString *)option;



@end



@implementation OMNumericalityValidator



+ (NSNumberFormatter *)numberFormatter
{
    static NSNumberFormatter *numberFormatter = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    });

    return numberFormatter;
}



- (NSString *)message
{
    return ( [[super message] length] ? [super message] : @"is not a valid number" );
}



- (NSString *)messageForSelectorString:(NSString *)selectorString withNumber:(NSNumber *)number
{
    NSString *message = nil;

    // only construct a specific default message if a custom message has not been defined
    if ( [[super message] length] )
    {
        message = [super message];
    }
    else
    {
        // insert spaces before capitals
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([a-z])([A-Z])" options:0 error:NULL];
        message = [regexp stringByReplacingMatchesInString:selectorString options:0 range:NSMakeRange(0, [selectorString length]) withTemplate:@"$1 $2"];
        
        // lowercase
        message = [message lowercaseString];
        
        // replace "is" with "must be"
        NSRegularExpression *regexp2 = [NSRegularExpression regularExpressionWithPattern:@"\\Ais " options:0 error:NULL];
        message = [regexp2 stringByReplacingMatchesInString:message options:0 range:NSMakeRange(0, [message length]) withTemplate:@"must be "];
        
        // replace "must be not" with "must not be"
        message = [message stringByReplacingOccurrencesOfString:@" be not " withString:@" not be "];
        
        // replace "must be integer" with "must be an integer"
        message = [message stringByReplacingOccurrencesOfString:@" be integer" withString:@" be an integer"];
        
        // replace "number" with option value (if present)
        NSRegularExpression *regexp3 = [NSRegularExpression regularExpressionWithPattern:@" number:\\Z" options:0 error:NULL];
        message = [regexp3 stringByReplacingMatchesInString:message options:0 range:NSMakeRange(0, [message length]) withTemplate:@" %{count}"];
    }
    
    // replace "%{count}" with numeric value (if present)
    if ( number )
    {
        message = [message stringByReplacingOccurrencesOfString:@"%{count}" withString:[number stringValue]];
    }

    return message;
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

            // value must be an NSNumber, a block, or a selector string
            if (
                [value isKindOfClass:[NSNumber class]]
                ||
                [value isKindOfClass:NSClassFromString(@"NSBlock")]
                ||
                ( [value isKindOfClass:[NSValue class]] && [value pointerValue] && strcmp([value objCType], @encode(SEL)) == 0)
            )
            {
                // all is well
            }
            else
            {
                [NSException raise:NSInvalidArgumentException format:@"NumericalityValidator option (%@) value (%@) is not an NSNumber, block, or selector.", key, value];
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
        [selectorName appendString:@"Number:"];
        selector = NSSelectorFromString(selectorName);

        if ( ! [NSNumber instancesRespondToSelector:selector] )
        {
            return nil;
        }
    }

    return selector;
}



- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError
{
    // the superclass' validation will return YES if validation is to be skipped
    if ( [self shouldSkipValidationForValue:value] )
    {
        return YES;
    }


    NSString *message = [self message];
    // sanitize value: should be a number or string
    NSNumber *numericValue = nil;
    NSString *stringValue = nil;
    BOOL valid = YES;

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
        NSNumberFormatter * f = [[self class] numberFormatter];
        numericValue = [f numberFromString:stringValue];

        // if NSNumberFormatter failed to convert, numericValue will be nil
        if ( ! numericValue )
        {
            valid = NO;
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
    }
    // if value isn't a number or string, fail validation
    else
    {
        valid = NO;
    }

    for (NSString *option in _filteredOptions)
    {
        NSNumber *optionValue;

        // convert "odd" constraint to @selector(isOdd)
        SEL selector = [self selectorFromOption:option];
        if ( selector )
        {
            NSString *selectorString = NSStringFromSelector(selector);

            if ( [selectorString hasSuffix:@":"] )
            {
                optionValue = [_filteredOptions objectForKey:option];

                // if optionValue is a block, invoke block and expect NSNumber result
                if ( [optionValue isKindOfClass:NSClassFromString(@"NSBlock")] )
                {
                    OMNumericalityValidatorNumberBlock block = [_filteredOptions objectForKey:option];
                    optionValue = (NSNumber *)block(model);
                }
                // if optionValue is an NSValue (but not an NSNumber), invoke the wrapped selector
                else if ( (! [optionValue isKindOfClass:[NSNumber class]]) && [optionValue isKindOfClass:[NSValue class]] )
                {
                    SEL optionValueSelector;
                    NSValue *optionValueWrapper = [_filteredOptions objectForKey:option];
                    [optionValueWrapper getValue:&optionValueSelector];

                    if ( optionValueSelector && [model respondsToSelector:optionValueSelector] )
                    {
                        optionValue = (NSNumber *)[model performSelector:optionValueSelector];
                    }
                    else
                    {
                        optionValue = nil;
                    }
                }

                valid = (BOOL)[numericValue performSelector:selector withObject:optionValue];
            }
            else
            {
                optionValue = nil;
                valid = (BOOL)[numericValue performSelector:selector];
            }

            if ( ! valid )
            {
                message = [self messageForSelectorString:selectorString withNumber:optionValue];
                break;
            }
        }
    }

    if ( ! valid )
    {
        [self errorWithOriginalError:outError value:value forKey:inKey message:message];
    }

    return valid;
}



@end
