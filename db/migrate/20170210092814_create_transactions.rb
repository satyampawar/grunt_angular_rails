class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|

      t.integer :bank_account_id
      t.string :username
      t.decimal :amount
      t.string :account_number
      t.string :transaction_type

      t.timestamps
    end
  end
end
