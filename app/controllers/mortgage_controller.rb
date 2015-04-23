class MortgageController < ApplicationController
  def home
  end

  def edit

  end

  def clone
  	redirect_to :action => "addMortgage"
  end

  def addMortgage
  	#Data Validation
  	@errorMsgs = ""

  	#All Req'd feilds are filled in
	if params[:name].length == 0 || params[:custName].length == 0 || params[:custContact].length == 0 || params[:amt].length == 0 || params[:downPymt].length == 0 || params[:interestRate].length == 0 || (params[:yearsDuration].length == 0 && params[:monthsDuration].length == 0)
		@errorMsgs += "One or more required fields were not filled!"
  	end

  	if params[:yearsDuration] == "0" && params[:monthsDuration] == "0"
  		@errorMsgs += "Total duration is zero. Please fix!"
  	end

  	if @errorMsgs.length > 0
  		flash[:error] = @errorMsgs
  	else
  		if(Mortgage.find_by_name(params[:name]).nil?)
  			@m = Mortgage.new
  		else
  			@m = Mortgage.find_by_name(params[:name])
  		end
		@m.name = params[:name]
		@m.custName = params[:custName]
		@m.custContact = params[:custContact]
		@amt = params[:amt].to_i
		@m.amt = @amt
		@downPymt = params[:downPymt].to_i
		@m.downPymt = @downPymt
		@interestRate = params[:interestRate].to_i
		@m.interestRate = @interestRate
		@m.monthsDuration = ((params[:yearsDuration].to_i*12) + params[:monthsDuration].to_i)
		@addlMonthlyPymt = params[:addlMonthlyPymt].to_i
		@addlYearlyPymt = params[:addlYearlyPymt].to_i
		@m.addlMonthlyPymt = @addlMonthlyPymt
		@m.addlYearlyPymt = @addlYearlyPymt

		#monthly Payment
		@r = @interestRate.to_f/100/12
		@P = @amt - @downPymt
		@N = @m.monthsDuration
		
		#  Pr(1+r)^N
		#-------------
		# ((1+r)^N)-1
		
		@numerator = @P*@r*((1+@r)**@N)
		@denominator = ((1+@r)**@N)-1
		@m.monthlyPymt = @numerator/@denominator

		@interestPaid = 0
		@amtLeft = @P
		@count = 0
		while @amtLeft > 0
			@interestPaid += (@amtLeft*@r).to_i
			
			#Plus Equals because monthlyPymt is negative
			@amtLeft -= @m.monthlyPymt.abs
			@amtLeft += (@amtLeft*@r)
			@amtLeft = @amtLeft.to_i
			@count += 1
		end

		@m.interestPaid = @interestPaid.to_i

		if @addlMonthlyPymt > 0 || @addlYearlyPymt > 0
			@amtLeft = @P
			@pymtCount = 0
			@interestPaid = 0

			while @amtLeft > 0
				@pymt = @m.monthlyPymt
				if @pymtCount%12 == 0
					@pymt += @addlYearlyPymt
				else
					@pymt += @addlMonthlyPymt
				end

				@interestPaid += (@amtLeft*@r).to_i
				@amtLeft *= (1+@r)
				@amtLeft -= @pymt
				@amtLeft = @amtLeft.to_i

				@pymtCount += 1
			end

			@m.monthsSaved = @m.monthsDuration - @pymtCount
			@m.interestSaved = @m.interestPaid - @interestPaid
		end

		@m.save
		flash[:success] = "Mortgage added!"
  	end
  	redirect_to :action => "home"
  end

  def deleteMortgage
  	Mortgage.find_by_name(params[:commit][7,params[:commit].length]).delete
  	redirect_to :action => "home"
  end

  def amortization
  	@m = Mortgage.find_by_name(params[:commit][9,params[:commit].length])
  	@amtLeft = @m.amt - @m.downPymt
  	@r = @m.interestRate.to_f/100/12

  	@pymtArray = []
  	@principlePymtArray = []
  	@interestPymtArray = []
  	@amtLeftArray = []

  	@pymtCount = 0

  	while @amtLeft > 0
  		@pymt = @m.monthlyPymt
		if @pymtCount%12 == 0
			@pymt += @m.addlYearlyPymt
		else
			@pymt += @m.addlMonthlyPymt
		end

		if @pymt > @amtLeft
			@pymt = @amtLeft
		end

		@pymtArray.push(@pymt)
		@interestPymtArray.push(@amtLeft * @r)
		@principlePymtArray.push(@pymt-@interestPymtArray.last)

		if @pymt == @amtLeft
			@amtLeft = 0
		else
			@amtLeft *= (1+@r)
			@amtLeft -= @pymt
			@amtLeft = @amtLeft.to_i
		end

		@amtLeftArray.push([@amtLeft,0].max)

		@pymtCount += 1
  	end

  	@totalArray = []
  	@count = 0
  	while @count < @pymtArray.length
  		@totalArray.push([@pymtArray[@count],@principlePymtArray[@count].to_i,@interestPymtArray[@count].to_i,@amtLeftArray[@count]])
  		@count+=1
  	end
  end
end
