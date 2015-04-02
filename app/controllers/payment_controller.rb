class PaymentController < ApplicationController

	def welcome_payment

	end

	def new_payment
		if not params[:amount].nil? and not params[:description].nil?
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
		:currency    => 'usd'
		)

		rescue Stripe::CardError => e
		flash[:error] = e.message
		redirect_to payment_path
	end
end
