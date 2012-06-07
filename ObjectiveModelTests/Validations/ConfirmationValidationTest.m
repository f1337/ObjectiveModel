/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/master/activemodel/test/cases/validations/confirmation_validation_test.rb
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



#import "ConfirmationValidationTest.h"
#import <ObjectiveModel/Validations.h>



@implementation ConfirmationValidationTest



@synthesize topic = _topic;



#pragma mark - SETUP/TEARDOWN



- (void)setUp
{
    [super setUp];
    [self setTopic:[[Topic alloc] init]];
}



- (void)tearDown
{
    [self setTopic:nil];
    [Topic removeAllValidations];
    [super tearDown];
}



#pragma mark - TRANSLITERATED RoR TESTS



- (void)testNoTitleConfirmation
{
    //Topic.validates_confirmation_of(:title)
    [Topic validatesConfirmationOf:@"title" withOptions:nil];

    //t = Topic.new(:author_name => "Plutarch")
    [_topic setAuthorName:@"Plutarch"];
    //assert t.valid?
    [self assertModelIsValid:_topic];

    //t.title_confirmation = "Parallel Lives"
    [_topic setTitleConfirmation:@"Parallel Lives"];
    //assert t.invalid?
    [self assertModelIsInvalid:_topic withErrorMessage:@"does not match confirmation" forKeys:[NSArray arrayWithObject:@"title"]];

    //t.title_confirmation = nil
    [_topic setTitleConfirmation:nil];
    //t.title = "Parallel Lives"
    [_topic setTitle:@"Parallel Lives"];
    //assert t.valid?
    [self assertModelIsValid:_topic];

    //t.title_confirmation = "Parallel Lives"
    [_topic setTitleConfirmation:@"Parallel Lives"];
    //assert t.valid?
    [self assertModelIsValid:_topic];
}



- (void)testTitleConfirmation
{
    //Topic.validates_confirmation_of(:title)
    [Topic validatesConfirmationOf:@"title" withOptions:[NSDictionary dictionaryWithObject:@"and confirmation do not match" forKey:@"message"]];;

    //t = Topic.new("title" => "We should be confirmed","title_confirmation" => "")
    [_topic setTitle:@"We should be confirmed"];
    [_topic setTitleConfirmation:@""];
    //assert t.invalid?
    [self assertModelIsInvalid:_topic withErrorMessage:@"and confirmation do not match" forKeys:[NSArray arrayWithObject:@"title"]];

    //t.title_confirmation = "We should be confirmed"
    [_topic setTitleConfirmation:@"We should be confirmed"];
    //assert t.valid?
    [self assertModelIsValid:_topic];
}



@end
