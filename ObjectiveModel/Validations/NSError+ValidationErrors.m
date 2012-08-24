/*
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



#import "NSError+ValidationErrors.h"
#import <CoreData/CoreData.h>



@implementation NSError (ValidationErrors)



+ (id)errorWithOriginalError:(NSError *)originalError
                      domain:(NSString *)domain
                        code:(NSInteger)code
                    userInfo:(NSDictionary *)dict
{
    NSError *error = [[[NSError alloc] initWithDomain:domain
                                                 code:code
                                             userInfo:dict] autorelease];

    // if there was no previous error, return the new error
    if ( originalError == nil )
    {
        return error;
    }
    // if there was a previous error, combine it with the existing one
    // per CoreData guidelines:
    // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/Articles/cdValidation.html#//apple_ref/doc/uid/TP40004807-SW4            
    else
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        NSMutableArray *errors = [NSMutableArray arrayWithObject:error];
        
        if ( [originalError code] == NSValidationMultipleErrorsError )
        {
            
            [userInfo addEntriesFromDictionary:[originalError userInfo]];
            [errors addObjectsFromArray:[userInfo objectForKey:NSDetailedErrorsKey]];
        }
        else
        {
            [errors addObject:originalError];
        }
        
        [userInfo setObject:errors forKey:NSDetailedErrorsKey];
        
        return [NSError errorWithDomain:NSCocoaErrorDomain
                                   code:NSValidationMultipleErrorsError
                               userInfo:userInfo];
    }
}


@end
