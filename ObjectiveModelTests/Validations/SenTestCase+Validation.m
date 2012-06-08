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



#import "SenTestCase+Validation.h"
#import <CoreData/CoreData.h>



@implementation SenTestCase (ValidationTests)



#pragma mark - CUSTOM ASSERTIONS



- (void)assertModelIsInvalid:(OMActiveModel *)model withErrorMessage:(NSString *)message forKeys:(NSArray *)keys
{
    NSError *error = nil;
    
    // perform validation
    STAssertTrue([model isInvalid:&error], @"Model (%@) expected to be invalid, but returned valid.", model);
    STAssertNotNil(error, @"Error expected to be non-nil.");
    
    // handle multiple errors
    if ( [error code] == NSValidationMultipleErrorsError )
    {
        NSArray *errors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        STAssertTrue([errors count], @"Expected a non-empty errors array");

        for (NSString *key in keys)
        {
            NSUInteger index = NSNotFound;
            NSError *subError;

            // ensure the expected key exists in the errors array
            for (NSUInteger i = 0; i < [errors count]; i++)
            {
                subError = [errors objectAtIndex:i];
                if ( [[[subError userInfo] objectForKey:NSValidationKeyErrorKey] isEqualToString:key] )
                {
                    index = i;
                    break;
                }
            }

            if ( index == NSNotFound )
            {
                STFail(@"Unable to locate NSValidationKeyErrorKey value in errors array: %@", key);
            }
            else if ( message )
            {
                subError = [errors objectAtIndex:index];
                STAssertTrue([[subError localizedDescription] isEqualToString:message], @"Unexpected error message from model! Expected: '%@', received: '%@'", message, [subError localizedDescription]);
            }
        }
    }
    // handle single error
    else
    {
        STAssertTrue([[[error userInfo] objectForKey:NSValidationKeyErrorKey] isEqualToString:[keys objectAtIndex:0]], @"Unexpected NSValidationErrorKey value. Expected: %@. Received: %@.", [keys objectAtIndex:0], [[error userInfo] objectForKey:NSValidationKeyErrorKey]);
        if ( message )
        {
            STAssertTrue([[error localizedDescription] isEqualToString:message], @"Unexpected error message from model! Expected: '%@', received: '%@'", message, [error localizedDescription]);
        }
    }
}



- (void)assertModelIsValid:(OMActiveModel *)model
{
    NSError *error = nil;
    
    // perform validation
    STAssertTrue([model isValid:&error], @"Model (%@) expected to be valid, but returned invalid. Error: %@", model, error);
    STAssertNil(error, @"Error expected to be nil.");
}



- (void)assertPropertyIsValid:(NSString *)property forModel:(OMActiveModel *)model
{
    id value = [model valueForKey:property];
    NSError *error = nil;
    STAssertTrue([model validateValue:&value forKey:property error:&error], @"Model property '%@' is invalid, but expected to be valid. Error: %@.", property, error);
}



- (void)assertPropertyIsInvalid:(NSString *)property forModel:(OMActiveModel *)model
{
    id value = [model valueForKey:property];
    STAssertFalse([model validateValue:&value forKey:property error:NULL], @"Model property '%@' is valid, but expected to be invalid.", property);
}



- (void)assertPropertyIsInvalid:(NSString *)property forModel:(OMActiveModel *)model withErrorMessage:(NSString *)message
{
    id value = [model valueForKey:property];
    NSError *error = nil;
    STAssertFalse([model validateValue:&value forKey:property error:&error], @"Model property '%@' is valid, but expected to be invalid.", property);
    STAssertNotNil(error, @"Error expected to be non-nil.");
    
    // handle multiple errors
    if ( [error code] == NSValidationMultipleErrorsError )
    {
        NSArray *errors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        STAssertTrue([errors count], @"Expected a non-empty errors array");
        
        for (NSUInteger i = 0; i < [errors count]; i++)
        {
            NSError *subError = [errors objectAtIndex:i];
            STAssertTrue([[[subError userInfo] objectForKey:NSValidationKeyErrorKey] isEqualToString:property], @"Unexpected NSValidationErrorKey value: %@", [[subError userInfo] objectForKey:NSValidationKeyErrorKey]);
            STAssertTrue([[subError localizedDescription] isEqualToString:message], @"Unexpected error message from model: %@", error);
        }
    }
    // handle single error
    else
    {
        STAssertTrue([[[error userInfo] objectForKey:NSValidationKeyErrorKey] isEqualToString:property], @"Unexpected NSValidationErrorKey value: %@", [[error userInfo] objectForKey:NSValidationKeyErrorKey]);
        STAssertTrue([[error localizedDescription] isEqualToString:message], @"Unexpected error message from model: %@", error);
    }
}



@end



@implementation OMActiveModel (ValidationTests)



+ (void)removeAllValidations
{
    [[self validations] setObject:[NSMutableDictionary dictionary] forKey:self];
}



@end
