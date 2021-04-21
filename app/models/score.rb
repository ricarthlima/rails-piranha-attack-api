class Score
  include Mongoid::Document
  field :username, type: String
  field :score, type: Integer
end
