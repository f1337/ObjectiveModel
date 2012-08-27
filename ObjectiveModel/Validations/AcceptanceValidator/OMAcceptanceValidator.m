/*
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were translated from Ruby on Rails,
 * Copyright © 2004-2012 David Heinemeier Hansson.
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/acceptance.rb
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



#import "OMAcceptanceValidator.h"



@implementation OMAcceptanceValidator



@synthesize accept = _accept;
@dynamic message;



#pragma mark - INIT & DEALLOC



- (void)dealloc
{
    [self setAccept:nil];
    [super dealloc];
}



- (instancetype)init
{
    if ( (self = [super init]) )
    {
        [self setMessage:@"must be accepted"];
    }
    
    return self;
}



#pragma mark - INSTANCE METHODS



- (BOOL)allowNil
{
    return YES;
}



- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError
{
    //unless value == options[:accept]
    NSString *stringValue = [value description];
    
    BOOL valid = (_accept ? [stringValue isEqualToString:_accept] : [[stringValue substringToIndex:1] boolValue]);

    if ( ! valid )
    {
        //record.errors.add(attribute, :accepted, options.except(:accept, :allow_nil))
        [self errorWithOriginalError:outError value:value forKey:inKey message:[self message]];
    }

    return valid;
}



@end
