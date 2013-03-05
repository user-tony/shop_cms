# Load the rails application
require File.expand_path('../application', __FILE__)
# Initialize the rails application
Mangocms::Application.initialize!
#
ActionMailer::Base.delivery_method =:smtp
ActionMailer::Base.smtp_settings = {
  :address =>        "smtp.163.com",
  :port =>           25,
  :domain =>         "smtp.163.com",
  :authentication => :login,
  :user_name =>      "cms_error@163.com",
  :password =>       "netcenter"
}
