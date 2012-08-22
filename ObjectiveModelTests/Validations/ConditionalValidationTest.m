/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/test/cases/validations/conditional_validation_test.rb
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



#import "ConditionalValidationTest.h"
#import <ObjectiveModel/Validations.h>



@implementation ConditionalValidationTest



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



- (void)testIfValidationUsingMethodTrue
{
    //Topic.validates_length_of( :title, :maximum => 5, :too_long => "hoo %{count}", :if => :condition_is_true )
    [Topic validatesLengthOf:@"title" withBlock:^(OMValidator *validator)
     {
         OMLengthValidator *myValidator = (OMLengthValidator *)validator;
         [myValidator setMaximum:[NSNumber numberWithInt:5]];
         [myValidator setTooLongMessage:@"hoo %{count}"];
         [myValidator setShouldValidate:^BOOL (id topic)
          {
              return [topic conditionIsTrue];
          }];
     }];

    //t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
    [_topic setTitle:@"uhohuhoh"];
    [_topic setContent:@"whatever"];
    //assert t.invalid?
    //assert t.errors[:title].any?
    //assert_equal ["hoo 5"], t.errors["title"]
    OMAssertModelIsInvalid(_topic, @"hoo 5", [NSArray arrayWithObject:@"title"]);
}



- (void)testIfValidationUsingMethodFalse
{
    //Topic.validates_length_of( :title, :maximum => 5, :too_long => "hoo %{count}", :if => :condition_is_true_but_its_not )
    [Topic validatesLengthOf:@"title" withBlock:^(OMValidator *validator)
     {
         OMLengthValidator *myValidator = (OMLengthValidator *)validator;
         [myValidator setMaximum:[NSNumber numberWithInt:5]];
         [myValidator setTooLongMessage:@"hoo %{count}"];
         [myValidator setShouldValidate:^BOOL (id topic)
          {
              return [topic conditionIsTrueButItsNot];
          }];
     }];

    //t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
    [_topic setTitle:@"uhohuhoh"];
    [_topic setContent:@"whatever"];
    //assert t.valid?
    //assert t.errors[:title].empty?
    OMAssertModelIsValid(_topic);
}



- (void)testIfValidationUsingBlockTrue
{
    //Topic.validates_length_of( :title, :maximum => 5, :too_long => "hoo %{count}",
    // :if => Proc.new { |r| r.content.size > 4 } )
    [Topic validatesLengthOf:@"title" withBlock:^(OMValidator *validator)
     {
         OMLengthValidator *myValidator = (OMLengthValidator *)validator;
         [myValidator setMaximum:[NSNumber numberWithInt:5]];
         [myValidator setTooLongMessage:@"hoo %{count}"];
         [myValidator setShouldValidate:^BOOL (id topic)
          {
              return ( [[topic content] length] > 4 );
          }];
     }];

    //t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
    [_topic setTitle:@"uhohuhoh"];
    [_topic setContent:@"whatever"];
    //assert t.invalid?
    //assert t.errors[:title].any?
    //assert_equal ["hoo 5"], t.errors["title"]
    OMAssertModelIsInvalid(_topic, @"hoo 5", [NSArray arrayWithObject:@"title"]);
}



- (void)testIfValidationUsingBlockFalse
{
    //Topic.validates_length_of( :title, :maximum => 5, :too_long => "hoo %{count}",
    // :if => Proc.new { |r| r.title != "uhohuhoh"} )
    [Topic validatesLengthOf:@"title" withBlock:^(OMValidator *validator)
     {
         OMLengthValidator *myValidator = (OMLengthValidator *)validator;
         [myValidator setMaximum:[NSNumber numberWithInt:5]];
         [myValidator setTooLongMessage:@"hoo %{count}"];
         [myValidator setShouldValidate:^BOOL (id topic)
          {
              return ( ! [[topic title] isEqualToString:@"uhohuhoh"]);
          }];
     }];
    
    //t = Topic.new("title" => "uhohuhoh", "content" => "whatever")
    [_topic setTitle:@"uhohuhoh"];
    [_topic setContent:@"whatever"];
    //assert t.valid?
    //assert t.errors[:title].empty?
    OMAssertModelIsValid(_topic);
}



@end
