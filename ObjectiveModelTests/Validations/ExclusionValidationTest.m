/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/test/cases/validations/exclusion_validation_test.rb
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



#import "ExclusionValidationTest.h"
#import <ObjectiveModel/Validations.h>
#import <ObjectiveModel/OMCollection.h>



@implementation ExclusionValidationTest



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



- (void)testValidatesExclusionOf
{
    //Topic.validates_exclusion_of( :title, :in => %w( abe monkey ) )
    [Topic validatesExclusionOf:@"title" withOptions:nil andSet:[NSArray arrayWithObjects:@"abe", @"monkey", nil]];

    //assert Topic.new("title" => "something", "content" => "abc").valid?
    [_topic setTitle:@"something"];
    [_topic setContent:@"abc"];
    [self assertModelIsValid:_topic];
    //assert Topic.new("title" => "monkey", "content" => "abc").invalid?
    [_topic setTitle:@"monkey"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
}


- (void)testValidatesExclusionWithFormattedMessage
{
    //Topic.validates_exclusion_of( :title, :in => %w( abe monkey ), :message => "option %{value} is restricted" )
    [Topic validatesExclusionOf:@"title" withOptions:[NSDictionary dictionaryWithObject:@"option %{value} is restricted" forKey:@"message"] andSet:[NSArray arrayWithObjects:@"abe", @"monkey", nil]];

    //assert Topic.new("title" => "something", "content" => "abc")
    [_topic setTitle:@"something"];
    [_topic setContent:@"abc"];
    [self assertModelIsValid:_topic];

    //t = Topic.new("title" => "monkey")
    [_topic setTitle:@"monkey"];
    //assert t.invalid?
    //assert t.errors[:title].any?
    //assert_equal ["option monkey is restricted"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"option monkey is restricted" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesExclusionWithBlock
{
    //Topic.validates_exclusion_of :title, :in => lambda{ |topic| topic.author_name == "sikachu" ? %w( monkey elephant ) : %w( abe wasabi ) }
    [Topic validatesExclusionOf:@"title"
                    withOptions:nil
                       andBlock:^id<OMCollection>(id topic)
     {
         if ( [[topic authorName] isEqualToString:@"sikachu"] )
         {
             return [NSArray arrayWithObjects:@"monkey", @"elephant", nil];
         }
         else {
             return [NSArray arrayWithObjects:@"abe", @"wasabi", nil];
         }
     }
     ];

    //t = Topic.new
    //t.title = "elephant"
    [_topic setTitle:@"elephant"];
    //t.author_name = "sikachu"
    [_topic setAuthorName:@"sikachu"];
    //assert t.invalid?
    [self assertModelIsInvalid:_topic withErrorMessage:@"is reserved" forKeys:[NSArray arrayWithObject:@"title"]];

    //t.title = "wasabi"
    [_topic setTitle:@"wasabi"];
    //assert t.valid?
    [self assertModelIsValid:_topic];
}



@end
