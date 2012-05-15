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



#import "OMActiveModel+OMValidator.h"



@interface OMActiveModel (Private)
+ (NSMutableArray *)validatorsForKey:(NSString *)key;
+ (NSMutableDictionary *)validatorsForSelf;
@end



@implementation OMActiveModel (OMValidator)



static NSMutableDictionary *validations = nil;



#pragma mark - CLASS METHODS



// this initialize method is invoked *before* any subclass initialize method
+ (void)initialize
{
    NSLog(@"OMActiveModel.initialize! self: %@", self);
    
    if (self == [OMActiveModel class])
    {
        validations = [[NSMutableDictionary alloc] init];
    }
}



/*!
 * TODO: This method signature doesn't conform to Obj-C conventions. Consider
 * replacing w/ one method for each possible object type
 * (NSString, NSArray, NSDictionary) for "properties".
 */
+ (void)validates:(NSObject *)properties withValidators:(NSArray *)validators andOptions:(NSDictionary *)options;
{
    //    NSString *log = [NSString stringWithFormat:@"%@ validates %@ of %@ withOptions: %@", self, constraint, properties, options];
    //    NSLog(@"%@", log);
    //    NSLog(@"isMemberOfClass NSString?: %d", [properties isMemberOfClass:[NSString class]]);
    //    NSLog(@"conformsToProtocol NSFastEnumeration?: %d", [[properties class] conformsToProtocol:@protocol(NSFastEnumeration)]);
    
    if ( [validators isBlank] )
    {
        [NSException raise:NSInvalidArgumentException format:@"You must provide at least one validator to apply."];
    }
    
    NSArray *propertySet;
    
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
    
    if (propertySet)
    {
        // add the validators to the validations array for this class
        for (Class validator in validators)
        {
            for (NSString *property in propertySet)
            {
                OMValidator *myValidator = [[validator alloc] initWithDictionary:options];
                NSMutableArray *validationsForKey = [self validatorsForKey:property];

                [validationsForKey addObject:myValidator];

            }
        }

        NSLog(@"validations for %@: %@", self, [self validatorsForSelf]);
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
    NSMutableDictionary *validationsForSelf = [validations objectForKey:self];
    
    // auto-create the validations hash for this class
    if ( ! validationsForSelf )
    {
        validationsForSelf = [NSMutableDictionary dictionary];
        [validations setObject:validationsForSelf forKey:self];
    }
    
    return validationsForSelf;
}



#pragma mark - INSTANCE METHODS



- (BOOL)isInvalid
{
    return (! [self isValid]);
}



- (BOOL)isValid
{
    return [self validate];
}



// TODO: move into isValid?
- (BOOL)validate
{
    // iterate through validations for this model
    NSDictionary *validationsForSelf = [[self class] validatorsForSelf];

    for (NSString *key in validationsForSelf)
    {
        NSError *error;// = [NSError errorWithDomain:@"dotcom" code:0 userInfo:nil];
        NSObject *value = [self valueForKey:key];

        if ( ! [self validateValue:&value forKey:key error:&error] )
        {
            return NO;
        }
    }

    return YES;
}



#pragma mark - NSKeyValueCoding



/*!
 * Per Apple's "Key-Value Coding Programming Guide":
 * "Key-value coding does not perform validation automatically. It is, in
 * general, your application’s responsibility to invoke the validation methods."
 * (https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/KeyValueCoding/Articles/Validation.html#//apple_ref/doc/uid/20002173-SW1)
 */
- (BOOL)validateValue:(id *)ioValue forKey:(NSString *)inKey error:(NSError **)outError
{
    // invoke the superclass validateValue:forKey:error:, to take advantage
    // of built-in subsequent invocation of validate<Key>:error: methods
    BOOL valid = [super validateValue:ioValue forKey:inKey error:outError];
    NSArray *validators = [[self class] validatorsForKey:inKey];

    for (OMValidator *validator in validators)
    {
        if ( ! [validator validateValue:ioValue error:outError] )
        {
            valid = NO;
            // TODO: build up error(s) structure per KVV guidelines
        }
    }

    return valid;
}



@end
