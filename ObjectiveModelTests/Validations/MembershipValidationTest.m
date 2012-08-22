/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/test/cases/validations/exclusion_validation_test.rb
 * https://github.com/rails/rails/blob/master/activemodel/test/cases/validations/inclusion_validation_test.rb
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



#import "MembershipValidationTest.h"
#import <ObjectiveModel/Validations.h>
#import <ObjectiveModel/OMCollection.h>



@implementation MembershipValidationTest



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
    [Topic validatesExclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMExclusionValidator *myValidator = (OMExclusionValidator *)validator;
        [myValidator setCollection:[NSArray arrayWithObjects:@"abe", @"monkey", nil]];
    }];
    
    //assert Topic.new("title" => "something", "content" => "abc").valid?
    [_topic setTitle:@"something"];
    [_topic setContent:@"abc"];
    OMAssertModelIsValid(_topic);
    //assert Topic.new("title" => "monkey", "content" => "abc").invalid?
    [_topic setTitle:@"monkey"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);
}



- (void)testValidatesExclusionWithFormattedMessage
{
    //Topic.validates_exclusion_of( :title, :in => %w( abe monkey ), :message => "option %{value} is restricted" )
    [Topic validatesExclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMExclusionValidator *myValidator = (OMExclusionValidator *)validator;
        [myValidator setCollection:[NSArray arrayWithObjects:@"abe", @"monkey", nil]];
        [myValidator setMessage:@"option %{value} is restricted"];
    }];
    
    //assert Topic.new("title" => "something", "content" => "abc")
    [_topic setTitle:@"something"];
    [_topic setContent:@"abc"];
    OMAssertModelIsValid(_topic);

    //t = Topic.new("title" => "monkey")
    [_topic setTitle:@"monkey"];
    //assert t.invalid?
    //assert t.errors[:title].any?
    //assert_equal ["option monkey is restricted"], t.errors[:title]
    OMAssertModelIsInvalid(_topic, @"option monkey is restricted", [NSArray arrayWithObject:@"title"]);
}



- (void)testValidatesExclusionWithBlock
{
    //Topic.validates_exclusion_of :title, :in => lambda{ |topic| topic.author_name == "sikachu" ? %w( monkey elephant ) : %w( abe wasabi ) }
    [Topic validatesExclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMExclusionValidator *myValidator = (OMExclusionValidator *)validator;
        [myValidator setCollectionBlock:^id<OMCollection>(id topic)
         {
             if ( [[topic authorName] isEqualToString:@"sikachu"] )
             {
                 return [NSArray arrayWithObjects:@"monkey", @"elephant", nil];
             }
             else {
                 return [NSArray arrayWithObjects:@"abe", @"wasabi", nil];
             }
         }];
    }];

    //t = Topic.new
    //t.title = "elephant"
    [_topic setTitle:@"elephant"];
    //t.author_name = "sikachu"
    [_topic setAuthorName:@"sikachu"];
    //assert t.invalid?
    OMAssertModelIsInvalid(_topic, @"is reserved", [NSArray arrayWithObject:@"title"]);
    
    //t.title = "wasabi"
    [_topic setTitle:@"wasabi"];
    //assert t.valid?
    OMAssertModelIsValid(_topic);
}



- (void)testValidatesInclusionInDictionary
{
    //Topic.validates_inclusion_of( :title, :in => 'aaa'..'bbb' )
    [Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setCollection:[NSDictionary dictionaryWithObjectsAndKeys:@"aaa", @"bbc", @"abc", @"aa", @"bbb", @"zz", nil]];
    }];

    //assert Topic.new("title" => "bbc", "content" => "abc").invalid?
    [_topic setTitle:@"bbc"];
    [_topic setContent:@"abc"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);
    //assert Topic.new("title" => "aa", "content" => "abc").invalid?
    [_topic setTitle:@"aa"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);
    //assert Topic.new("title" => "aaa", "content" => "abc").valid?
    [_topic setTitle:@"aaa"];
    OMAssertModelIsValid(_topic);
    //assert Topic.new("title" => "abc", "content" => "abc").valid?
    [_topic setTitle:@"abc"];
    OMAssertModelIsValid(_topic);
    //assert Topic.new("title" => "bbb", "content" => "abc").valid?
    [_topic setTitle:@"bbb"];
    OMAssertModelIsValid(_topic);
}



- (void)testValidatesInclusionInSet
{
    //Topic.validates_inclusion_of( :title, :in => 'aaa'..'bbb' )
    [Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setCollection:[NSSet setWithObjects:@"aaa", @"abc", @"bbb", nil]];
    }];

    //assert Topic.new("title" => "bbc", "content" => "abc").invalid?
    [_topic setTitle:@"bbc"];
    [_topic setContent:@"abc"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);
    //assert Topic.new("title" => "aa", "content" => "abc").invalid?
    [_topic setTitle:@"aa"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);
    //assert Topic.new("title" => "aaa", "content" => "abc").valid?
    [_topic setTitle:@"aaa"];
    OMAssertModelIsValid(_topic);
    //assert Topic.new("title" => "abc", "content" => "abc").valid?
    [_topic setTitle:@"abc"];
    OMAssertModelIsValid(_topic);
    //assert Topic.new("title" => "bbb", "content" => "abc").valid?
    [_topic setTitle:@"bbb"];
    OMAssertModelIsValid(_topic);
}



- (void)testValidatesInclusionInString
{
    [Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setCollection:[NSString stringWithFormat:@"hi!"]];
    }];

    [_topic setTitle:@"ghi"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);

    [_topic setTitle:@"hit"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);
    
    [_topic setTitle:@"hi"];
    OMAssertModelIsValid(_topic);

    [_topic setTitle:@"i"];
    OMAssertModelIsValid(_topic);

    [_topic setTitle:@"i!"];
    OMAssertModelIsValid(_topic);

    [_topic setTitle:@"hi!"];
    OMAssertModelIsValid(_topic);
}



- (void)testValidatesInclusionOf
{
    //Topic.validates_inclusion_of( :title, :in => %w( a b c d e f g ) )
    [Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setCollection:[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", nil]];
    }];

    //assert Topic.new("title" => "a!", "content" => "abc").invalid?
    [_topic setTitle:@"a!"];
    [_topic setContent:@"abc"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);
    //assert Topic.new("title" => "a b", "content" => "abc").invalid?
    [_topic setTitle:@"a b"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);
    //assert Topic.new("title" => nil, "content" => "def").invalid?
    [_topic setTitle:nil];
    [_topic setContent:@"def"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);

    //t = Topic.new("title" => "a", "content" => "I know you are but what am I?")
    [_topic setTitle:@"a"];
    [_topic setContent:@"I know you are but what am I?"];
    //assert t.valid?
    OMAssertModelIsValid(_topic);
    //t.title = "uhoh"
    [_topic setTitle:@"uhoh"];
    //assert t.invalid?
    //assert t.errors[:title].any?
    //assert_equal ["is not included in the list"], t.errors[:title]
    OMAssertModelIsInvalid(_topic, @"is not included in the list", [NSArray arrayWithObject:@"title"]);

    //assert_nothing_raised(ArgumentError) { Topic.validates_inclusion_of( :title, :in => "hi!" ) }
    STAssertNoThrow([Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setCollection:[NSString stringWithFormat:@"hi!"]];
    }], @"An unexpected exception was raised!.");
    //assert_nothing_raised(ArgumentError) { Topic.validates_inclusion_of( :title, :in => {} ) }
    STAssertNoThrow([Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setCollection:[NSSet set]];
    }], @"An unexpected exception was raised!.");
    STAssertNoThrow([Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setCollection:[NSDictionary dictionary]];
    }], @"An unexpected exception was raised!.");
    //assert_nothing_raised(ArgumentError) { Topic.validates_inclusion_of( :title, :in => [] ) }
    STAssertNoThrow([Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setCollection:[NSArray array]];
    }], @"An unexpected exception was raised!.");
}



- (void)testValidatesInclusionWithAllowNil
{
    //Topic.validates_inclusion_of( :title, :in => %w( a b c d e f g ), :allow_nil => true )
    [Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setAllowNil:YES];
        [myValidator setCollection:[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", nil]];
    }];

    //assert Topic.new("title" => "a!", "content" => "abc").invalid?
    [_topic setTitle:@"a!"];
    [_topic setContent:@"abc"];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);
    //assert Topic.new("title" => "",   "content" => "abc").invalid?
    [_topic setTitle:@""];
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);
    //assert Topic.new("title" => nil,  "content" => "abc").valid?
    [_topic setTitle:nil];
    OMAssertModelIsValid(_topic);
}



- (void)testValidatesInclusionWithFormattedMessage
{
    //Topic.validates_inclusion_of( :title, :in => %w( a b c d e f g ), :message => "option %{value} is not in the list" )
    [Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setCollection:[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", nil]];
        [myValidator setMessage:@"option %{value} is not in the list"];
    }];

    //assert Topic.new("title" => "a", "content" => "abc").valid?
    [_topic setTitle:@"a"];
    [_topic setContent:@"abc"];
    OMAssertModelIsValid(_topic);
    //t = Topic.new("title" => "uhoh", "content" => "abc")
    [_topic setTitle:@"uhoh"];
    //assert t.invalid?
    //assert t.errors[:title].any?
    //assert_equal ["option uhoh is not in the list"], t.errors[:title]
    OMAssertModelIsInvalid(_topic, @"option uhoh is not in the list", [NSArray arrayWithObject:@"title"]);
}



- (void)testValidatesInclusionWithBlock
{
    //Topic.validates_inclusion_of :title, :in => lambda{ |topic| topic.author_name == "sikachu" ? %w( monkey elephant ) : %w( abe wasabi ) }
    [Topic validatesInclusionOf:@"title" withBlock:^(OMValidator *validator) {
        OMMembershipValidator *myValidator = (OMMembershipValidator *)validator;
        [myValidator setCollectionBlock:^id<OMCollection>(id topic)
         {
             if ( [[topic authorName] isEqualToString:@"sikachu"] )
             {
                 return [NSArray arrayWithObjects:@"monkey", @"elephant", nil];
             }
             else {
                 return [NSArray arrayWithObjects:@"abe", @"wasabi", nil];
             }
         }];
    }];

    //t = Topic.new
    //t.title = "wasabi"
    [_topic setTitle:@"wasabi"];
    //t.author_name = "sikachu"
    [_topic setAuthorName:@"sikachu"];
    //assert t.invalid?
    OMAssertModelIsInvalid(_topic, @"", [NSArray arrayWithObject:@"title"]);

    //t.title = "elephant"
    [_topic setTitle:@"elephant"];
    //assert t.valid?
    OMAssertModelIsValid(_topic);
}



@end
