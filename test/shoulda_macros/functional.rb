class Test::Unit::TestCase

  def self.should_be_logged_in
    should "check that the user session exist" do
      current_user_session = UserSession.find
      assert_not_nil(current_user_session)
    end
  end
  
  def self.should_not_be_logged_in
    should "check that the user session doesn't exist" do
      current_user_session = UserSession.find
      assert_nil(current_user_session)
    end
  end
  
  def self.should_set_the_flash(level = nil, val = :any)
    val = /.*/i if val == :any
    return should_set_the_flash_to(val) unless level
    if val.blank?
      should "have nothing in the #{level} flash" do
        assert(flash[level].blank?, "but had: #{flash[level].inspect}")
      end
    else
      should "have something in the #{level} flash" do
        assert(!flash[level].blank?, "No value set of given flash level: #{level}")
      end
      should "have #{val.inspect} in the #{level} flash" do
        assert_match(val, flash[level], "Flash: #{flash[level].inspect}")
      end
    end
  end
  
end