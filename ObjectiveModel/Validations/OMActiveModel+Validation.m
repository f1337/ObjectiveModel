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



#import "OMActiveModel+Validation.h"
#import "NSError+ValidationErrors.h"




@interface OMActiveModel (Private)
+ (NSMutableArray *)validatorsForKey:(NSString *)key;
+ (NSMutableDictionary *)validatorsForSelf;
@end



@implementation OMActiveModel (Validation)



#pragma mark - CLASS METHODS



+ (NSMutableDictionary *)validations
{
    static NSMutableDictionary *validations = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validations = [[NSMutableDictionary alloc] init];
    });

    return validations;
}



/*!
 * TODO?: This method signature doesn't conform to Obj-C conventions. Consider
 * replacing w/ one method for each possible object type
 * (NSString, NSArray, NSDictionary) for "properties".
 */
+ (void)validates:(NSObject *)properties withValidators:(NSArray *)validators andOptions:(NSDictionary *)options;
{
    if ( [validators isBlank] )
    {
        [NSException raise:NSInvalidArgumentException format:@"You must provide at least one validator to apply."];
    }
    
    NSArray *propertySet = nil;
    
    if ( [properties isBlank] )
    {
        [NSException raise:NSInvalidArgumentException format:@"You must provide at least one property to validate."];
    }
    else if ( [properties isKindOfClass:[NSString class]] )
    {
        propertySet = [NSArray arrayWithObject:properties];
    }
    else if ( [properties isKindOfClass:[NSArray class]] )
    {
        propertySet = (NSArray *) properties;
    }
    
    if ( propertySet )
    {
        // add the validators to the validations array for this class
        for (Class validator in validators)
        {
            for (NSString *property in propertySet)
            {
                OMValidator *myValidator = [[validator alloc] initWithDictionary:options];
                NSMutableArray *validationsForKey = [self validatorsForKey:property];
                [validationsForKey addObject:myValidator];
                [myValidator release];
            }
        }
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Expected properties (%@) to be NSString or implement the NSFastEnumeration protocol.", properties];
    }
}



/*!
 * Validators are stored in a nested dictionary + array structure like so:
 * {
 *      classA:
 *      {
 *          propertyA:
 *          [
 *              OMValidator,
 *              OMValidator,
 *              OMValidator
 *          ],
 *          propertyB:
 *          [
 *              OMValidator,
 *              OMValidator,
 *              OMValidator
 *          ]
 *      },
 *
 *      classB:
 *      {
 *          propertyA:
 *          [
 *              OMValidator,
 *              OMValidator,
 *              OMValidator
 *          ],
 *          propertyB:
 *          [
 *              OMValidator,
 *              OMValidator,
 *              OMValidator
 *          ]
 *      }
 * }
 */
+ (NSMutableArray *)validatorsForKey:(NSString *)key
{
    NSMutableDictionary *validationsForSelf = [self validatorsForSelf];
    NSMutableArray *validationsForKey = [validationsForSelf objectForKey:key];
    
    // auto-create the validations array for the key
    if ( ! validationsForKey )
    {
        validationsForKey = [NSMutableArray array];
        [validationsForSelf setObject:validationsForKey forKey:key];
    }
    
    return validationsForKey;
}



+ (NSMutableDictionary *)validatorsForSelf
{
    NSMutableDictionary *validationsForSelf = [[self validations] objectForKey:self];
    
    // auto-create the validations hash for this class
    if ( ! validationsForSelf )
    {
        validationsForSelf = [NSMutableDictionary dictionary];
        [[self validations] setObject:validationsForSelf forKey:self];
    }
    
    return validationsForSelf;
}



#pragma mark - INSTANCE METHODS



- (BOOL)isInvalid:(NSError **)errors
{
    return (! [self isValid:errors]);
}



- (BOOL)isValid:(NSError **)errors
{
    return [self validate:errors];
}



- (BOOL)validate:(NSError **)errors
{
    BOOL valid = YES;

    // iterate through validations for this model
    NSDictionary *validationsForSelf = [[self class] validatorsForSelf];
    for (NSString *key in validationsForSelf)
    {
        NSObject *value = [self valueForKey:key];

        if ( ! [self validateValue:&value forKey:key error:errors] )
        {
            valid = NO;
        }
    }

    return valid;
}



#pragma mark - NSKeyValueCoding



/*!
 * To implement custom validation methods on a model,
 * Per Apple's "Core Data Programming Guide":
 * "If you want to implement logic in addition to the constraints you provide in
 * the managed object model, you should not override validateValue:forKey:error:.
 * Instead you should implement methods of the form validate<Key>:error:.
 * https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/Articles/cdValidation.html#//apple_ref/doc/uid/TP40004807-SW2
 *
 * Per Apple's "Key-Value Coding Programming Guide":
 * "Key-value coding does not perform validation automatically. It is, in
 * general, your application’s responsibility to invoke the validation methods."
 * https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/Validation.html#//apple_ref/doc/uid/20002173-SW1
 */
- (BOOL)validateValue:(id *)ioValue forKey:(NSString *)inKey error:(NSError **)outError
{
    // invoke the superclass validateValue:forKey:error:, to take advantage
    // of built-in subsequent invocation of validate<Key>:error: methods
    BOOL valid = [super validateValue:ioValue forKey:inKey error:outError];

    // skip custom validation if superclass validation failed
    if ( valid )
    {
        NSArray *validators = [[self class] validatorsForKey:inKey];

        for (OMValidator *validator in validators)
        {
            // skip validation?
            if ( ! [validator shouldSkipValidationForValue:*ioValue] )
            {
                if ( ! [validator validateModel:self withValue:*ioValue forKey:inKey error:outError] )
                {
                    // don't return immediately, or we won't get all the errors
                    valid = NO;
                }
            }
        }
    }

    return valid;
}



@end
