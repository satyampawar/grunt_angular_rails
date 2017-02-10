class BankAccount < ApplicationRecord
	has_many :transactions
	validates_presence_of :account_number
	validates_uniqueness_of :account_number
	validates_length_of :account_number, :minimum => 11, :maximum => 17, :allow_blank => true
end
