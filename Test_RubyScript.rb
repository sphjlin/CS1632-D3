require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "Localhost4567Ilovecats" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://www.katalon.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_localhost4567_ilovecats" do
    @driver.get "http://localhost:4567/ilovecats"
    (@driver.find_element(:link, "Back to main").text).should == "Back to main"
    (@driver.find_element(:xpath, "(.//*[normalize-space(text()) and normalize-space(.)='ERROR'])[1]/following::h2[1]").text).should == "Invalid address."
    (@driver.find_element(:xpath, "(.//*[normalize-space(text()) and normalize-space(.)='Invalid address.'])[1]/following::p[1]").text).should == "404. This page does not exist"
  end
  
  def element_present?(how, what)
    ${receiver}.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    ${receiver}.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = ${receiver}.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
