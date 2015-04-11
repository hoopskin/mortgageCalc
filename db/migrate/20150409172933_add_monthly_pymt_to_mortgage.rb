class AddMonthlyPymtToMortgage < ActiveRecord::Migration
  def change
    add_column :mortgages, :monthlyPymt, :integer
  end
end
