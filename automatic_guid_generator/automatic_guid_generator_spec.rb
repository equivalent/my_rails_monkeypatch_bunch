require 'spec_helper'

def clear_database
  Message.destroy_all
end

describe AutomaticGuidGenerator, 'generate_random_string' do
   it 'should genereate string' do 
      Message.generate_random_string(4).should be_kind_of String
   end
   it "the length should be at least few chars" do
      Message.generate_random_string(4).length.should > 3
   end
end
 
describe AutomaticGuidGenerator, 'generate_random_guid' do
   before :each do
    clear_database
    @message = Factory.build :message
   end

   it 'should genereate string' do 
      @message.generate_random_guid
      @message.guid.should_not be_nil
      @message.guid.should be_kind_of String
   end

   it 'should genereate string of length 10 chars' do 
      @message.generate_random_guid
      @message.guid.length.should == 10
   end

    it 'should genereate unique string' do 
      #have no bether ide how I can test this
      @message.generate_random_guid
      @message.save!.should be_true # must be saved sucessfully 

      @message2 = Message.new
      10.times do
        @message.guid.should_not == @user2.generate_random_guid
      end 
   end 

     it "should keep pregenerated guid after save" do
       @message.generate_random_guid
       @message.save!

       Message.last.guid.should be_kind_of String
       Message.last.guid.length.should ==10 
     end
end
 


describe AutomaticGuidGenerator, 'pre_generate_guid_automaticly' do
   before :each do
    @message = Factory.build :message
    @message.pre_generate_guid_automaticly

    @role = Role.new 
   end

   context "when table have guid" do
      #message is table that has guid

     it 'should respond to guid' do
       @message.respond_to?(:guid).should be_true   
     end

     it 'should pregenerate guid' do
       @message.guid.should be_kind_of String
       @message.guid.length.should == 10
     end

   end

   context "when table haven't got guid" do
      #role is table that will never have guid, ...I hope

     it 'should not respond to guid' do
       @role.respond_to?(:guid).should be_false  
     end

     it 'should throw exception when trying to call guid' do
        lambda{@role.guid}.should raise_error
     end
   end
end





describe AutomaticGuidGenerator, 'before_create for method pre_generate_guid_automaticly' do
   before :each do
     clear_database
   end

   it "should be automaticly trigered" do
     @message = Factory.build :message
     @message.save

     @message.guid.should be_kind_of String
     @message.guid.length > 5 #it realy doesn't matter what is the length, above tests are careing of that 
   end

   it "should not be trigered when updating the model" do
     @message = Factory.build :message
     @message.save

     previouse_guid = @message.guid

     @message.save #(again)
     @message.guid.should == previouse_guid
   end
end




