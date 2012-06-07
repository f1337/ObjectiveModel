/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/master/activemodel/lib/active_model/validations/confirmation.rb
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



#import "OMConfirmationValidator.h"



@implementation OMConfirmationValidator



- (NSString *)message
{
    return ( [[super message] length] ? [super message] : @"does not match confirmation" );
}



- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError
{
    //if (confirmed = record.send("#{attribute}_confirmation")) && (value != confirmed)
    NSString *stringValue = (NSString *)value;
    NSString *confirmedValue = [model valueForKey:[NSString stringWithFormat:@"%@Confirmation", inKey]];
    BOOL valid = (confirmedValue ? [stringValue isEqualToString:confirmedValue] : YES);
    if ( ! valid )
    {
        //human_attribute_name = record.class.human_attribute_name(attribute)
        //record.errors.add(:"#{attribute}_confirmation", :confirmation, options.merge(:attribute => human_attribute_name))
        [self errorWithOriginalError:outError value:value forKey:inKey message:[self message]];
    }

    return valid;
}



@end
