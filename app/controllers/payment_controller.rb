class PaymentController < ApplicationController

	def welcome

	end

	def new_payment
		if params[:amount].empty? and not params[:description].empty?
			flash[:notice] = "Amount can not be blank"
			# redirect_to root_path
			render :action => 'welcome'
		elsif params[:description].empty? and not params[:amount].empty?
			flash[:notice] = "Write your bitcoin address"
			# redirect_to root_path
			render :action => 'welcome'
		elsif params[:amount].empty? and params[:description].empty?
			flash[:notice] = "Amount and BTC address can not be blank"
			render :action => 'welcome'
			# redirect_to root_path
		elsif params[:amount].to_f <= 99
			flash[:notice] = "Minimum to spend is 100 € or equivalent"
			render :action => 'welcome'
		else
			flash[:amount] = params[:amount]
			flash.keep(:amount)
			flash[:description] = params[:description]
			flash.keep(:description)
		end
	end

	def create_payment
		 # Amount in cents
		@amount = flash[:amount]
		@amount = @amount+"00"
		@description = flash[:description]

		customer = Stripe::Customer.create(
		:email => params[:stripeEmail],
		:card  => params[:stripeToken]
		)

		charge = Stripe::Charge.create(
		:customer    => customer.id,
		:amount      => @amount,
		:description => @description,
		:currency    => 'eur',
		:metadata	 => {'receipt_email' => params[:stripeEmail]}
		)

		rescue Stripe::CardError => e
		flash[:error] = e.message
		redirect_to payment_path
	end
end
