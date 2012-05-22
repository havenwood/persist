require_relative 'helper'

describe Persist do
  before do
    @db = Persist.db
    Persist[:author] = {first_name: 'Shannon', last_name: 'Skipper'}
  end
  
  describe "initializing the persistent store with Persist.db" do
    it "returns a PStore object" do
      assert_equal PStore, @db.class
    end
  end
  
  describe "getting a list of root keys with Persist.keys" do
    it "returns an Array" do
      assert_kind_of Array, Persist.keys
    end
  end
  
  describe "getting true or false if key exists with Persist.key?(:key)" do
    it "returns true if key exists" do
      assert Persist.key?(:author)
    end
    
    it "returns false if the key does't exist" do
      refute Persist.key?(:this_does_not_exist)
    end
  end
  
  describe "getting a particular key's value with Persist[:key]" do
    it "returns a value if the key exists" do
      assert_equal "Shannon", Persist[:author][:first_name]
    end
    
    it "returns nil if the key doesn't exist" do
      assert_nil Persist[:this_does_not_exist]
    end
  end
  
  describe "setting a perticular key's value with Persist[:key] = value" do
    before do
      Persist[:trees] = ['oak', 'pine', 'cedar']
    end
    
    it "should add the key to the persistent store" do
      assert Persist.key?(:trees)
    end
    
    it "should be set to the expected value" do
      assert_equal ["oak", "pine", "cedar"], Persist[:trees]
    end
  end
  
  describe "setting multiple key's values with Persist.transaction do ..." do
    it "blends" do
      assert true #TODO: test.
    end
  end
  
  describe "deleting a root key with Persist.delete(:key)" do
    before do
      Persist.delete :author
    end
    
    it "returns nil because the key no longer exists" do
      assert_nil Persist[:author]
    end
  end
  
  describe "check path with Persist.path" do
    it "returns a String" do
      assert_kind_of String, Persist.path
    end
    
    it "includes the data store file name" do
      assert_includes ".db.pstore", Persist.path
    end
  end
end