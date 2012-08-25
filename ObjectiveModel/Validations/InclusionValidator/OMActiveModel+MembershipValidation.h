/*
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



#import "OMActiveModel.h"
#import "OMCollection.h"



typedef id <OMCollection>(^ OMMembershipValidatorCollectionBlock) (OMActiveModel *model);



@interface OMActiveModel (MembershipValidation)


/*!
Validates that the value of the specified attribute is *not* in a
particular enumerable object.

    @implementation Person
        + (void)initialize
        {
            [self validatesExclusionOf:@"username" withInitBlock:^(OMValidator *validator)
            {
                OMExclusionValidator *exclusionValidator = (OMExclusionValidator *)validator;
                [exclusionValidator setMessage:@"You don't belong here"];
                [exclusionValidator setCollection:[NSArray arrayWithObjects:@"admin", @"superuser", nil]];
            }];

            [self validatesExclusionOf:@"format" withInitBlock:^(OMValidator *validator)
            {
                OMExclusionValidator *exclusionValidator = (OMExclusionValidator *)validator;
                [exclusionValidator setMessage:@"extension %{value} is not allowed"];
                [exclusionValidator setCollection:[NSArray arrayWithObjects:@"mov", @"avi", nil]];
            }];

            [self validatesExclusionOf:@"password" withInitBlock:^(OMValidator *validator)
            {
                OMExclusionValidator *exclusionValidator = (OMExclusionValidator *)validator;
                [exclusionValidator setMessage:@"should not be the same as your username or first name"];
                [exclusionValidator setCollectionBlock:^id<OMCollection>(id person)
                {
                    return [NSArray arrayWithObjects:[person username], [person firstName], nil];
                }];
            }];

        }
    @end

@param properties A NSString property name OR an NSArray of string property names.
@param block An OMValidatorInitBlock for initializing the validator instance's properties.
*/
+ (void)validatesExclusionOf:(NSObject *)properties withInitBlock:(OMValidatorInitBlock)block;


/*!
Validates whether the value of the specified attribute is available in a
particular enumerable object.

    @implementation Person
        + (void)initialize
        {
            [self validatesInclusionOf:@"gender" withInitBlock:^(OMValidator *validator)
            {
                OMInclusionValidator *inclusionValidator = (OMInclusionValidator *)validator;
                [inclusionValidator setCollection:[NSArray arrayWithObjects:@"m", @"f", nil]];
            }];

            [self validatesInclusionOf:@"format" withInitBlock:^(OMValidator *validator)
            {
                OMInclusionValidator *inclusionValidator = (OMInclusionValidator *)validator;
                [inclusionValidator setMessage:@"extension %{value} is not supported"];
                [inclusionValidator setCollection:[NSArray arrayWithObjects:@"jpg", @"gif", @"png", nil]];
            }];

            [self validatesInclusionOf:@"states" withInitBlock:^(OMValidator *validator)
            {
                OMInclusionValidator *inclusionValidator = (OMInclusionValidator *)validator;
                [inclusionValidator setCollectionBlock:^id<OMCollection>(id person)
                {
                    return [NSArray arrayWithObjects:@"CA", @"NY", @"OH", nil];
                }];
            }];

        }
    @end

@param properties A NSString property name OR an NSArray of string property names.
@param block An OMValidatorInitBlock for initializing the validator instance's properties.
*/
+ (void)validatesInclusionOf:(NSObject *)properties withInitBlock:(OMValidatorInitBlock)block;



@end
