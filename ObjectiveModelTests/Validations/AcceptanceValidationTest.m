/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/test/cases/validations/acceptance_validation_test.rb
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



#import "AcceptanceValidationTest.h"
#import <ObjectiveModel/Validations.h>



@implementation AcceptanceValidationTest



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



- (void)testTermsOfServiceAgreementNotAccepted
{
    //Topic.validates_acceptance_of(:terms_of_service)
    [Topic validatesAcceptanceOf:@"termsOfService" withOptions:nil];

    //t = Topic.new("title" => "We should not be confirmed")
    [_topic setTitle:@"We should not be confirmed"];
    //assert t.valid?
    [self assertModelIsValid:_topic];
}



-(void)testTermsOfServiceAgreement
{
    //Topic.validates_acceptance_of(:terms_of_service)
    [Topic validatesAcceptanceOf:@"termsOfService" withOptions:nil];

    //t = Topic.new("title" => "We should be confirmed","terms_of_service" => "")
    [_topic setTitle:@"We should be confirmed"];
    [_topic setTermsOfService:@""];
    //assert t.invalid?
    //assert_equal ["must be accepted"], t.errors[:terms_of_service]
    [self assertModelIsInvalid:_topic withErrorMessage:@"must be accepted" forKeys:[NSArray arrayWithObject:@"termsOfService"]];

    //t.terms_of_service = "1"
    [_topic setTermsOfService:@"Y"];
    //assert t.valid?
    [self assertModelIsValid:_topic];
}



-(void)testEULA
{
    //Topic.validates_acceptance_of(:eula, :message => "must be abided")
    [Topic validatesAcceptanceOf:@"EULA" withOptions:[NSDictionary dictionaryWithObject:@"must be abided" forKey:@"message"]];

    //t = Topic.new("title" => "We should be confirmed","eula" => "")
    [_topic setTitle:@"We should be confirmed"];
    [_topic setEULA:[NSNumber numberWithBool:NO]];
    //assert t.invalid?
    //assert_equal ["must be abided"], t.errors[:eula]
    [self assertModelIsInvalid:_topic withErrorMessage:@"must be abided" forKeys:[NSArray arrayWithObject:@"EULA"]];

    //t.eula = "1"
    [_topic setEULA:[NSNumber numberWithBool:YES]];
    //assert t.valid?
    [self assertModelIsValid:_topic];
}



- (void)testTermsOfServiceAgreementWithAcceptValue
{
    //Topic.validates_acceptance_of(:terms_of_service, :accept => "I agree.")
    [Topic validatesAcceptanceOf:@"termsOfService" withOptions:[NSDictionary dictionaryWithObject:@"I agree." forKey:@"accept"]];

    //t = Topic.new("title" => "We should be confirmed", "terms_of_service" => "")
    [_topic setTitle:@"We should be confirmed"];
    [_topic setTermsOfService:@""];
    //assert t.invalid?
    //assert_equal ["must be accepted"], t.errors[:terms_of_service]
    [self assertModelIsInvalid:_topic withErrorMessage:@"must be accepted" forKeys:[NSArray arrayWithObject:@"termsOfService"]];

    //t.terms_of_service = "I agree."
    [_topic setTermsOfService:@"I agree."];
    //assert t.valid?
    [self assertModelIsValid:_topic];
}



@end

