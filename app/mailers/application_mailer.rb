# frozen_string_literal: true

# Base-level mailer for others to inheret from
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
