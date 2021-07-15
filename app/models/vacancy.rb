# frozen_string_literal: true

class Vacancy < ApplicationRecord
  include StateConcern
  extend Enumerize
  include VacancyRepository
  include VacancyPresenter

  acts_as_taggable_on :technologies
  enumerize :employment_type, in: EMPLOYMENT_TYPES, default: 'full-time', predicates: true, scope: true
  # enumerize :programming_language, in: PROGRAMMING_LANGAUGES, default: 'full-time', predicates: true, scope: true
  # enumerize :country_name, in: COUNTRIES, default: :user, predicates: true, scope: true

  validates :title, presence: true
  validates :company_name, presence: true
  validates :description, presence: true
  validates :site, presence: true
  # validates :programming_language, presence: true

  belongs_to :creator, class_name: 'User'
  belongs_to :country, optional: true

  aasm :state, column: :state do
    state :idle
    state :on_moderate
    state :published
    state :archived

    event :publish do
      transitions to: :published
    end

    event :send_to_moderate do
      transitions from: :idle, to: :on_moderate
    end

    event :archive do
      transitions to: :archived
    end
  end

  def salary?
    salary_from? || salary_to?
  end

  def to_s
    title
  end
end
