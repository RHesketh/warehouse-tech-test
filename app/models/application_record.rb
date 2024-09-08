# frozen_string_literal: true

# Base-level model for others to inheret from
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
