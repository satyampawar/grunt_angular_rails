class CreateBankAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_accounts do |t|

      t.string :user_name
      t.string :account_number
      t.decimal :avail_balance

      t.timestamps
    end
  end
end
