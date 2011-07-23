class Player < ActiveRecord::Base
  has_many :entrants
  has_many :games, :through => :entrants
  validates_uniqueness_of :name
  validates_uniqueness_of :nickname, :allow_blank => true

  def display_name
    @display_name ||= begin
      display_name = "#{name}"
      display_name << " (#{nickname})" unless nickname.blank?
      display_name
    end
  end
end
