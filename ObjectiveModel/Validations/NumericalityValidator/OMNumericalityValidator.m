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



+ (NSDictionary *)constraints;
+ (NSNumberFormatter *)numberFormatter;



- (BOOL)checkArgumentValidityForValue:(id)value;
- (NSString *)messageForSelectorString:(NSString *)selectorString withNumber:(NSNumber *)number;



@end



@implementation OMNumericalityValidator



@synthesize even = _even;
@synthesize equalTo = _equalTo;
@synthesize greaterThan = _greaterThan;
@synthesize greaterThanOrEqualTo = _greaterThanOrEqualTo;
@synthesize integer = _integer;
@synthesize lessThan = _lessThan;
@synthesize lessThanOrEqualTo = _lessThanOrEqualTo;
@synthesize notEqualTo = _notEqualTo;
@synthesize odd = _odd;



#pragma mark - INIT & DEALLOC



- (void)dealloc
{
    [self setEven:nil];
    [self setEqualTo:nil];
    [self setGreaterThan:nil];
    [self setGreaterThanOrEqualTo:nil];
    [self setInteger:nil];
    [self setLessThan:nil];
    [self setLessThanOrEqualTo:nil];
    [self setNotEqualTo:nil];
    [self setOdd:nil];
    [super dealloc];
}



#pragma mark - STATIC METHODS



+ (NSDictionary *)constraints
{
    static NSDictionary *constraints;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        constraints = [NSDictionary dictionaryWithObjectsAndKeys:
                       @"isEven", @"even",
                       @"isEqualToNumber:", @"equalTo",
                       @"isGreaterThanNumber:", @"greaterThan",
                       @"isGreaterThanOrEqualToNumber:", @"greaterThanOrEqualTo",
                       @"isInteger", @"integer",
                       @"isLessThanNumber:", @"lessThan",
                       @"isLessThanOrEqualToNumber:", @"lessThanOrEqualTo",
                       @"isNotEqualToNumber:", @"notEqualTo",
                       @"isOdd", @"odd",
                       nil];
        [constraints retain];
    });
    
    return constraints;
}



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



#pragma mark - INSTANCE METHODS



- (BOOL)checkArgumentValidityForValue:(id)value
{
    if ( value == nil )
    {
        return YES;
    }
    // value must be an NSNumber or an OMNumericalityValidatorNumberBlock
    else if (
        [value isKindOfClass:[NSNumber class]]
        ||
        [value isKindOfClass:NSClassFromString(@"NSBlock")]
    )
    {
        return YES;
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"%@ Invalid Argument! Value (%@) is not an NSNumber or an OMNumericalityValidatorNumberBlock.", NSStringFromClass([self class]), value, nil];
        return NO;
    }
}



- (void)setEqualTo:(id)equalTo
{
    if ( [self checkArgumentValidityForValue:equalTo] )
    {
        _equalTo = equalTo;
    }
}



- (void)setGreaterThan:(id)greaterThan
{
    if ( [self checkArgumentValidityForValue:greaterThan] )
    {
        _greaterThan = greaterThan;
    }
}



- (void)setGreaterThanOrEqualTo:(id)greaterThanOrEqualTo
{
    if ( [self checkArgumentValidityForValue:greaterThanOrEqualTo] )
    {
        _greaterThanOrEqualTo = greaterThanOrEqualTo;
    }
}



- (void)setLessThan:(id)lessThan
{
    if ( [self checkArgumentValidityForValue:lessThan] )
    {
        _lessThan = lessThan;
    }
}



- (void)setLessThanOrEqualTo:(id)lessThanOrEqualTo
{
    if ( [self checkArgumentValidityForValue:lessThanOrEqualTo] )
    {
        _lessThanOrEqualTo = lessThanOrEqualTo;
    }
}



- (NSString *)message
{
    return ( [[super message] length] ? [super message] : @"is not a number" );
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



- (void)setNotEqualTo:(id)notEqualTo
{
    if ( [self checkArgumentValidityForValue:notEqualTo] )
    {
        _notEqualTo = notEqualTo;
    }
}



- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError
{
    // the superclass' validation will return YES if validation is to be skipped
    if ( [self shouldSkipValidationForValue:value] )
    {
        return YES;
    }


    // >>> PART I: Sanitize value
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


    // >>> PART II: Apply constraints
    NSDictionary *constraints = [[self class] constraints];

    for (NSString *option in constraints)
    {
        NSNumber *optionValue;

        // skip constraint if it wasn't set by user
        if ( [self valueForKey:option] == nil)
        {
            continue;
        }

        // convert "odd" constraint to @selector(isOdd)
        SEL selector = NSSelectorFromString([constraints objectForKey:option]);
        if ( selector )
        {
            NSString *selectorString = NSStringFromSelector(selector);

            if ( [selectorString hasSuffix:@":"] )
            {
                optionValue = [self valueForKey:option];

                // if optionValue is a block, invoke block and expect NSNumber result
                if ( [optionValue isKindOfClass:NSClassFromString(@"NSBlock")] )
                {
                    OMNumericalityValidatorNumberBlock block = [self valueForKey:option];
                    optionValue = (NSNumber *)block(model);
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
