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



#import <ObjectiveModel/Validations.h>
#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>



#define OMAssertModelIsInvalid(m, e, k) \
do { \
    @try { \
        OMActiveModel *model = m; \
        NSString *message = e; \
        NSArray *keys = k; \
        NSError *error = nil; \
        STAssertTrue([model isInvalid:&error], @"Model (%@) expected to be invalid, but returned valid.", model); \
        STAssertNotNil(error, @"Error expected to be non-nil."); \
        if ( [error code] == NSValidationMultipleErrorsError ) \
        { \
            NSArray *errors = [[error userInfo] objectForKey:NSDetailedErrorsKey]; \
            STAssertTrue([errors count], @"Expected a non-empty errors array"); \
            for (NSString *key in keys) \
            { \
                NSUInteger index = NSNotFound; \
                NSError *subError; \
                for (NSUInteger i = 0; i < [errors count]; i++) \
                { \
                    subError = [errors objectAtIndex:i]; \
                    if ( [[[subError userInfo] objectForKey:NSValidationKeyErrorKey] isEqualToString:key] ) \
                    { \
                        index = i; \
                        break; \
                    } \
                } \
                if ( index == NSNotFound ) \
                { \
                    STFail(@"Unable to locate NSValidationKeyErrorKey value in errors array: %@", key); \
                } \
                else if ( [message length] ) \
                { \
                    subError = [errors objectAtIndex:index]; \
                    STAssertTrue([[subError localizedDescription] isEqualToString:message], @"Unexpected error message from model! Expected: '%@', received: '%@'", message, [subError localizedDescription]); \
                } \
            } \
        } \
        else \
        { \
            STAssertTrue([[[error userInfo] objectForKey:NSValidationKeyErrorKey] isEqualToString:[keys objectAtIndex:0]], @"Unexpected NSValidationErrorKey value. Expected: %@. Received: %@.", [keys objectAtIndex:0], [[error userInfo] objectForKey:NSValidationKeyErrorKey]); \
            if ( [message length] ) \
            { \
                STAssertTrue([[error localizedDescription] isEqualToString:message], @"Unexpected error message from model! Expected: '%@', received: '%@'", message, [error localizedDescription]); \
            } \
        } \
    } \
    @catch (id anythingElse) {\
        ; \
    }\
} while (0)



#define OMAssertModelIsValid(m) \
do { \
    @try { \
        OMActiveModel *model = m; \
        NSError *error = nil; \
        STAssertTrue([model isValid:&error], @"Model (%@) expected to be valid, but returned invalid. Error: %@", model, error); \
        STAssertNil(error, @"Error expected to be nil."); \
    } \
    @catch (id anythingElse) {\
        ; \
    }\
} while (0)



#define OMAssertPropertyIsValid(p, m) \
do { \
    @try { \
        NSString *property = p; \
        OMActiveModel *model = m; \
        id value = [model valueForKey:property]; \
        NSError *error = nil; \
        STAssertTrue([model validateValue:&value forKey:property error:&error], @"Model property '%@' is invalid, but expected to be valid. Error: %@.", property, error); \
    } \
    @catch (id anythingElse) {\
        ; \
    }\
} while (0)



@interface OMActiveModel (ValidationTests)



/*!
 * Removes all validators defined for the model.
 */
+ (void)removeAllValidations;



@end
