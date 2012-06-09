/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/exclusion.rb
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/inclusion.rb
 * Ruby on Rails is Copyright © 2004-2012 David Heinemeier Hansson.
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



#import "OMMembershipValidator.h"



@implementation OMMembershipValidator



@synthesize block = _block;
@synthesize collection = _collection;
@dynamic message;
@synthesize mode = _mode;



- (void)dealloc
{
    [self setBlock:nil];
    [self setCollection:nil];
    [super dealloc];
}



- (instancetype)init
{
    if ( (self = [super init]) )
    {
        [self setMode:OMMembershipValidationInclusion];
    }

    return self;
}



- (NSString *)message
{
    NSString *message = [super message];

    if ( ! [message length] )
    {
        if ( _mode == OMMembershipValidationExclusion )
        {
            message = @"is reserved";
        }
        else if ( _mode == OMMembershipValidationInclusion )
        {
            message = @"is not included in the list";
        }
    }

    return message;
}



- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError
{
    id <OMCollection> set;

    if ( _block )
    {
        set = _block(model);
    }
    else
    {
        set = _collection;
    }

    // unless include?(record, value)
    BOOL valid = [set containsObject:value];

    if ( _mode == OMMembershipValidationExclusion )
    {
        valid = (! valid);
    }

    if ( ! valid )
    {
        // record.errors.add(attribute, :inclusion, options.except(:in).merge!(:value => value))
        [self errorWithOriginalError:outError value:value forKey:inKey message:[self message]];
    }

    return valid;
}



@end
