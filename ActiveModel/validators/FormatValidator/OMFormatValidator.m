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



#import "OMFormatValidator.h"



@implementation OMFormatValidator



@synthesize block = _block;
@synthesize shouldMatchPattern = _shouldMatchPattern;
@synthesize regularExpression = _regularExpression;



- (void)dealloc
{
    [self setBlock:nil];
    [self setRegularExpression:nil];
    [super dealloc];
}



- (void)setOptions:(NSDictionary *)options
{
    // "shouldMatchPattern" value should be a string "YES"/"NO"
    // or a numberWithBool.
    id shouldMatchPattern = [options objectForKey:@"shouldMatchPattern"];
    if ( [shouldMatchPattern respondsToSelector:@selector(boolValue)] )
    {
        _shouldMatchPattern = [shouldMatchPattern boolValue];
    }
    else
    {
        _shouldMatchPattern = YES;
    }

    // filter out "shouldMatchPattern"
    NSMutableDictionary *filteredOptions = [NSMutableDictionary dictionaryWithDictionary:options];
    [filteredOptions removeObjectsForKeys:[NSMutableArray arrayWithObjects:@"shouldMatchPattern", nil]];
    // and hit the superclass for handling allowNil, allowBlank, and message
    [super setOptions:filteredOptions];
}



- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError
{
    NSRegularExpression *regularExpression;
    NSString *stringValue = (NSString *)value;
    // if value doesn't convert to string, fail validation
    BOOL valid = ( [stringValue length] > 0 );

    if ( valid )
    {
        // is there a block to apply?
        if ( _block )
        {
            regularExpression = _block(model);
        }
        else
        {
            regularExpression = _regularExpression;
        }
        
        // does the value match the pattern?
        NSRange matchRange = [regularExpression rangeOfFirstMatchInString:stringValue options:0 range:NSMakeRange(0, [stringValue length])];
        
        // if we expect a match:
        if ( _shouldMatchPattern )
        {
            valid = ( matchRange.location != NSNotFound );
        }
        // we don't expect a match:
        else
        {
            valid = ( matchRange.location == NSNotFound );
        }
    }

    if ( ! valid )
    {
        [self errorWithOriginalError:outError value:value forKey:inKey message:[self message]];
    }

    return valid;
}



@end
