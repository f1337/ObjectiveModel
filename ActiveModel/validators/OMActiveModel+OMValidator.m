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



@implementation OMActiveModel (OMValidator)



static NSMutableDictionary *validations = nil;



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
        // create the validations array for this class
        if ( ! [validations objectForKey:self] )
        {
            [validations setObject:[NSMutableArray array] forKey:self];
        }
        
        // add the validators to the validations array for this class
        for (Class validator in validators)
        {
            [[validations objectForKey:self] addObject:[[validator alloc] initWithProperties:propertySet andOptions:options]];
        }
        NSLog(@"validations for %@: %@", self, [validations objectForKey:self]);
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Expected properties (%@) to be NSString or implement the NSFastEnumeration protocol.", properties];
    }
}



// TODO: use swizzling to override init & dealloc?
- (id)init
{
    if ( (self = [super init]) )
    {
        // create an empty dictionary for storing validation errors
        errors = [[NSMutableDictionary alloc] init];
        
        // use KVO to receive property change notifications
        NSArray *validators = [validations objectForKey:[self class]];
        NSLog(@"validators for me: %@", validators);
        for (OMValidator *validator in validators)
        {
            NSLog(@"validator properties: %@", [validator properties]);
            for (NSString *property in [validator properties])
            {
                NSLog(@"added KVO to %@.%@ for validator: %@", self, property, validator);
                [self addObserver:self
                       forKeyPath:property
                          options:NSKeyValueObservingOptionNew
                          context:validator];
            }
        }
    }
    
    return self;
}



- (void)dealloc
{
    // remove KVO
    NSArray *validators = [validations objectForKey:[self class]];
    NSLog(@"validators for me: %@", validators);
    for (OMValidator *validator in validators)
    {
        NSLog(@"validator properties: %@", [validator properties]);
        for (NSString *property in [validator properties])
        {
            // iOS 5+:
            //            NSLog(@"removed KVO from %@.%@ for validator: %@", self, property, validator);
            //            [self removeObserver:self forKeyPath:property context:validator];
            // iOS 2+:
            NSLog(@"removed KVO from %@.%@", self, property);
            [self removeObserver:self forKeyPath:property];
        }
    }
    
    
    [errors release];
    
    [super dealloc];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"observeValueForKeyPath: %@ ofObject: %@ change: %@ context: %@", keyPath, object, change, context);
    // EXPERIMENTAL: auto-validate changed property
    // FIXME:
    // removeObjectForKey:keyPath causes collisions for keyPaths with multiple validators
    [errors removeObjectForKey:keyPath];
    // execute validator
    OMValidator *validator = (OMValidator *)context;
    [validator validate:self withProperty:keyPath andValue:[self valueForKeyPath:keyPath]];
    NSLog(@"[%@ validate:%@ withProperty:%@ andValue:%@]", validator, self, keyPath, [self valueForKeyPath:keyPath]);
    NSLog(@"errors for keypath: %@", [errors objectForKey:keyPath]);
}



- (void)validate
{
    // empty errors dictionary
    [errors removeAllObjects];
    
    NSLog(@"validations for %@: %@", self, [validations objectForKey:[self class]]);
    
    // iterate through validations for this model
    for (OMValidator *validator in [validations objectForKey:[self class]])
    {
        [validator validate:self];
    }
    
}



- (BOOL)isInvalid
{
    [self validate];
    return ([errors count] ? YES : NO);
}



- (BOOL)isValid
{
    return (! [self isInvalid]);
}



@end
