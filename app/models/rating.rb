# frozen_string_literal: true

# The ratings/attributes that the Hunter has
# determines their capability to do something
class Rating < ApplicationRecord
  belongs_to :playbook
end
