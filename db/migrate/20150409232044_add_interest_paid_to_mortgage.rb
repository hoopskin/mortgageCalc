class AddInterestPaidToMortgage < ActiveRecord::Migration
  def change
    add_column :mortgages, :interestPaid, :integer
  end
end
