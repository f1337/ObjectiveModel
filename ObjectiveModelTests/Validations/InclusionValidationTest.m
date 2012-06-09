/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
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



#import "InclusionValidationTest.h"
#import <ObjectiveModel/Validations.h>
#import <ObjectiveModel/OMCollection.h>



@implementation InclusionValidationTest



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



- (void)testValidatesInclusionInDictionary
{
    //Topic.validates_inclusion_of( :title, :in => 'aaa'..'bbb' )
    [Topic validatesInclusionOf:@"title" withOptions:nil andSet:[NSDictionary dictionaryWithObjectsAndKeys:@"aaa", @"bbc", @"abc", @"aa", @"bbb", @"zz", nil]];
    //assert Topic.new("title" => "bbc", "content" => "abc").invalid?
    [_topic setTitle:@"bbc"];
    [_topic setContent:@"abc"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    //assert Topic.new("title" => "aa", "content" => "abc").invalid?
    [_topic setTitle:@"aa"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    //assert Topic.new("title" => "aaa", "content" => "abc").valid?
    [_topic setTitle:@"aaa"];
    [self assertModelIsValid:_topic];
    //assert Topic.new("title" => "abc", "content" => "abc").valid?
    [_topic setTitle:@"abc"];
    [self assertModelIsValid:_topic];
    //assert Topic.new("title" => "bbb", "content" => "abc").valid?
    [_topic setTitle:@"bbb"];
    [self assertModelIsValid:_topic];
}



- (void)testValidatesInclusionInSet
{
    //Topic.validates_inclusion_of( :title, :in => 'aaa'..'bbb' )
    [Topic validatesInclusionOf:@"title" withOptions:nil andSet:[NSSet setWithObjects:@"aaa", @"abc", @"bbb", nil]];
    //assert Topic.new("title" => "bbc", "content" => "abc").invalid?
    [_topic setTitle:@"bbc"];
    [_topic setContent:@"abc"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    //assert Topic.new("title" => "aa", "content" => "abc").invalid?
    [_topic setTitle:@"aa"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    //assert Topic.new("title" => "aaa", "content" => "abc").valid?
    [_topic setTitle:@"aaa"];
    [self assertModelIsValid:_topic];
    //assert Topic.new("title" => "abc", "content" => "abc").valid?
    [_topic setTitle:@"abc"];
    [self assertModelIsValid:_topic];
    //assert Topic.new("title" => "bbb", "content" => "abc").valid?
    [_topic setTitle:@"bbb"];
    [self assertModelIsValid:_topic];
}



- (void)testValidatesInclusionInString
{
    [Topic validatesInclusionOf:@"title" withOptions:nil andSet:[NSString stringWithString:@"hi!"]];

    [_topic setTitle:@"ghi"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];

    [_topic setTitle:@"hit"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    
    [_topic setTitle:@"hi"];
    [self assertModelIsValid:_topic];

    [_topic setTitle:@"i"];
    [self assertModelIsValid:_topic];

    [_topic setTitle:@"i!"];
    [self assertModelIsValid:_topic];

    [_topic setTitle:@"hi!"];
    [self assertModelIsValid:_topic];
}



- (void)testValidatesInclusionOf
{
    //Topic.validates_inclusion_of( :title, :in => %w( a b c d e f g ) )
    [Topic validatesInclusionOf:@"title" withOptions:nil andSet:[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", nil]];

    //assert Topic.new("title" => "a!", "content" => "abc").invalid?
    [_topic setTitle:@"a!"];
    [_topic setContent:@"abc"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    //assert Topic.new("title" => "a b", "content" => "abc").invalid?
    [_topic setTitle:@"a b"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    //assert Topic.new("title" => nil, "content" => "def").invalid?
    [_topic setTitle:nil];
    [_topic setContent:@"def"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];

    //t = Topic.new("title" => "a", "content" => "I know you are but what am I?")
    [_topic setTitle:@"a"];
    [_topic setContent:@"I know you are but what am I?"];
    //assert t.valid?
    [self assertModelIsValid:_topic];
    //t.title = "uhoh"
    [_topic setTitle:@"uhoh"];
    //assert t.invalid?
    //assert t.errors[:title].any?
    //assert_equal ["is not included in the list"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"is not included in the list" forKeys:[NSArray arrayWithObject:@"title"]];

    //assert_raise(ArgumentError) { Topic.validates_inclusion_of( :title, :in => nil ) }
    STAssertThrowsSpecificNamed([Topic validatesInclusionOf:@"title" withOptions:nil andSet:nil], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");
    //assert_raise(ArgumentError) { Topic.validates_inclusion_of( :title, :in => 0) }
    STAssertThrowsSpecificNamed([Topic validatesInclusionOf:@"title" withOptions:nil andSet:0], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");

    //assert_nothing_raised(ArgumentError) { Topic.validates_inclusion_of( :title, :in => "hi!" ) }
    STAssertNoThrow([Topic validatesInclusionOf:@"title" withOptions:nil andSet:[NSString stringWithString:@"hi!"]], @"An unexpected exception was raised!.");
    //assert_nothing_raised(ArgumentError) { Topic.validates_inclusion_of( :title, :in => {} ) }
    STAssertNoThrow([Topic validatesInclusionOf:@"title" withOptions:nil andSet:[NSSet set]], @"An unexpected exception was raised!.");
    STAssertNoThrow([Topic validatesInclusionOf:@"title" withOptions:nil andSet:[NSDictionary dictionary]], @"An unexpected exception was raised!.");
    //assert_nothing_raised(ArgumentError) { Topic.validates_inclusion_of( :title, :in => [] ) }
    STAssertNoThrow([Topic validatesInclusionOf:@"title" withOptions:nil andSet:[NSArray array]], @"An unexpected exception was raised!.");
}



- (void)testValidatesInclusionWithAllowNil
{
    //Topic.validates_inclusion_of( :title, :in => %w( a b c d e f g ), :allow_nil => true )
    [Topic validatesInclusionOf:@"title" withOptions:[NSDictionary dictionaryWithObject:@"Y" forKey:@"allowNil"] andSet:[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", nil]];

    //assert Topic.new("title" => "a!", "content" => "abc").invalid?
    [_topic setTitle:@"a!"];
    [_topic setContent:@"abc"];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    //assert Topic.new("title" => "",   "content" => "abc").invalid?
    [_topic setTitle:@""];
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];
    //assert Topic.new("title" => nil,  "content" => "abc").valid?
    [_topic setTitle:nil];
    [self assertModelIsValid:_topic];
}



- (void)testValidatesInclusionWithFormattedMessage
{
    //Topic.validates_inclusion_of( :title, :in => %w( a b c d e f g ), :message => "option %{value} is not in the list" )
    [Topic validatesInclusionOf:@"title" withOptions:[NSDictionary dictionaryWithObject:@"option %{value} is not in the list" forKey:@"message"] andSet:[NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", nil]];

    //assert Topic.new("title" => "a", "content" => "abc").valid?
    [_topic setTitle:@"a"];
    [_topic setContent:@"abc"];
    [self assertModelIsValid:_topic];
    //t = Topic.new("title" => "uhoh", "content" => "abc")
    [_topic setTitle:@"uhoh"];
    //assert t.invalid?
    //assert t.errors[:title].any?
    //assert_equal ["option uhoh is not in the list"], t.errors[:title]
    [self assertModelIsInvalid:_topic withErrorMessage:@"option uhoh is not in the list" forKeys:[NSArray arrayWithObject:@"title"]];
}



- (void)testValidatesInclusionWithBlock
{
    //Topic.validates_inclusion_of :title, :in => lambda{ |topic| topic.author_name == "sikachu" ? %w( monkey elephant ) : %w( abe wasabi ) }
    [Topic validatesInclusionOf:@"title"
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
    //t.title = "wasabi"
    [_topic setTitle:@"wasabi"];
    //t.author_name = "sikachu"
    [_topic setAuthorName:@"sikachu"];
    //assert t.invalid?
    [self assertModelIsInvalid:_topic withErrorMessage:nil forKeys:[NSArray arrayWithObject:@"title"]];

    //t.title = "elephant"
    [_topic setTitle:@"elephant"];
    //assert t.valid?
    [self assertModelIsValid:_topic];
}



@end
