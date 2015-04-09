class CreateMortgages < ActiveRecord::Migration
  def change
    create_table :mortgages do |t|
      t.string :name
      t.string :custName
      t.string :custContact
      t.integer :amt
      t.integer :downPymt
      t.float :interestRate
      t.integer :monthsDuration
      t.integer :addlMonthlyPymt
      t.integer :addlYearlyPymt
      t.integer :interestSaved
      t.integer :monthsSaved

      t.timestamps null: false
    end
  end
end
