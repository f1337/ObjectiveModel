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
#import <CoreData/CoreData.h>
#import "NSError+ValidationErrors.h"



@implementation OMValidator



@synthesize options = _options;



- (void)dealloc
{
    [_message release];
    [_options release];
    [super dealloc];
}



- (instancetype)init
{
    if ( (self = [super init]) )
    {
        // set the default message
        _message = @"is invalid";
    }
    
    return self;
}



- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if ( (self = [self init]) )
    {
        [self setOptions:dictionary];
    }

    return self;
}



- (void)errorWithOriginalError:(NSError **)originalError
                         value:(NSObject *)value
                        forKey:(NSString *)inKey
                       message:(NSString *)message
{
    if ( originalError != NULL )
    {
        // Error structured per CoreData guidelines:
        // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/Articles/cdValidation.html#//apple_ref/doc/uid/TP40004807-SW2
        // don't create an error if none was requested
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  // the property name that failed validation
                                  inKey, NSValidationKeyErrorKey,
                                  // wrap the ioValue in NSValue in order to
                                  // safely handle scalars and objects alike
                                  [NSValue valueWithPointer:value], NSValidationValueErrorKey,
                                  // a reference to this model
                                  self, NSValidationObjectErrorKey,
                                  // the validation error message
                                  message, NSLocalizedDescriptionKey,
                                  nil];
        
        *originalError = [NSError errorWithOriginalError:*originalError
                                                  domain:@"OMValidator" 
                                                    code:NSManagedObjectValidationError 
                                                userInfo:userInfo];
    }
}



- (NSString *)message
{
    return _message;
}



- (void)setOptions:(NSDictionary *)options
{
    if ( _options != options )
    {
        [_options release];
        _options = options;
        [_options retain];

        // TODO: allowNil, allowBlank, and message should be read-only!
        allowBlank = [[_options objectForKey:@"allowBlank"] boolValue];
        allowNil = [[_options objectForKey:@"allowNil"] boolValue];
        if ( [_options objectForKey:@"message"] )
        {
            _message = [_options objectForKey:@"message"];
        }
    }
}



- (BOOL)shouldSkipValidationForValue:(NSObject *)value
{
    if (
        // skip validation if value is nil or NSNull and allowNil is true
        ( allowNil && (value == nil || [value isKindOfClass:[NSNull class]]) )
        || 
        // skip validation if value is blank and allowBlank is true
        ( allowBlank && (value == nil || [value isBlank]) )
        )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError
{
    if ( [self shouldSkipValidationForValue:value] )
    {
        return YES;
    }
    else
    {
        [self errorWithOriginalError:outError value:value forKey:inKey message:_message];
        return NO;
    }
}



@end
