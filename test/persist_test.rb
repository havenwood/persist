require_relative 'helper'

describe Persist do
  before do
    @store = Persist.new
  end

  describe "getting a list of root keys with Persist.keys" do
    it "returns an Array" do
      assert_kind_of Array, @store.keys
    end
  end

  describe "getting true or false if key exists with Persist.key?" do
    it "returns true if key exists" do
      @store[:author] = {first_name: 'Shannon', last_name: 'Skipper'}
      assert @store.key?(:author)
    end

    it "returns false if the key doesn't exist" do
      refute @store.key?(:this_does_not_exist)
    end
  end

  describe "getting a particular key's value with Persist.[]" do
    it "returns a value if the key exists" do
      @store[:author] = {first_name: 'Shannon', last_name: 'Skipper'}
      assert_equal "Shannon", @store[:author][:first_name]
    end

    it "returns nil if the key doesn't exist" do
      assert_nil @store[:this_does_not_exist]
    end
  end

  describe "getting a particular key or default value with Persist.fetch" do
    it "returns a value if the key exists" do
      @store[:author] = {first_name: 'Shannon', last_name: 'Skipper'}
      assert_equal "Shannon", @store.fetch(:author)[:first_name]
    end

    it "returns nil if the key doesn't exist and no default is given" do
      assert_nil @store.fetch(:this_does_not_exist)
    end

    it "returns the default value if the key doesn't exist" do
      default = @store.fetch(:this_does_not_exist, "default value")
      assert_equal "default value", default
    end
  end

  describe "setting a particular key's value with Persist.[]=" do
    before do
      @store[:trees] = ['oak', 'pine', 'cedar']
    end

    it "should add the key to the persistent @store" do
      assert @store.key?(:trees)
    end

    it "should be set to the expected value" do
      assert_equal ["oak", "pine", "cedar"], @store[:trees]
    end
  end

  describe "a Persist.transaction do" do
    it "sets multiple keys when commited" do
      @store.transaction do |db|
        db[:one] = 'first'
        db[:two] = 'second'
      end
      assert_equal 'first', @store[:one]
      assert_equal 'second', @store[:two]
    end

    it "sets no keys when aborted" do
      @store.transaction do |db|
        db[:pre] = 'before'
        db.abort
        db[:post] = 'after'
      end
      assert_nil @store[:pre]
      assert_nil @store[:post]
    end
  end

  describe "deleting a root key with Persist.delete" do
    before do
      @store.delete :author
    end
    
    it "returns nil because the key no longer exists" do
      assert_nil @store[:author]
    end
  end

  describe "check path with Persist.path" do
    it "returns a String" do
      assert_kind_of String, @store.path
    end

    it "includes the data @store file name" do
      assert_includes ".db.pstore", @store.path
    end
  end
end