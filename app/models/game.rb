# frozen_string_literal: true

class Game < ApplicationRecord
  validates :name, :move, presence: true
  validates :move, inclusion: { in: %w[rock paper scissors] }
end
