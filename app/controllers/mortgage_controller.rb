class MortgageController < ApplicationController
  def home
  end

  def addMortgage
  	#Data Validation
  	@errorMsgs = ""

  	#All Req'd feilds are filled in
	if params[:name].length == 0 || params[:custName].length == 0 || params[:custContact].length == 0 || params[:amt].length == 0 || params[:downPymt].length == 0 || params[:interestRate].length == 0 || params[:yearsDuration].length == 0 || params[:monthsDuration].length == 0
		@errorMsgs += "One or more required fields were not filled!"
  	end


  	if @errorMsgs.length > 0
  		flash[:error] = @errorMsgs
  	else
  		@m = Mortgage.new
		@m.name = params[:name]
		@m.custName = params[:custName]
		@m.custContact = params[:custContact]
		@m.amt = params[:amt].to_i
		@m.downPymt = params[:downPymt].to_i
		@m.interestRate = params[:interestRate].to_i
		@m.monthsDuration = ((params[:yearsDuration].to_i*12) + params[:monthsDuration].to_i)
		@m.addlMonthlyPymt = params[:addlMonthlyPymt].to_i
		@m.addlYearlyPymt = params[:addlYearlyPymt].to_i
		@m.save
		flash[:success] = "Mortgage added!"
  	end
  	redirect_to :action => "home"
  end

  def amortization
  end
end
