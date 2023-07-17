class AntiFraudsController < ApplicationController
  protect_from_forgery with: :null_session

  def index; end
  
  def create
    anti_fraud = AntiFraudService.new.recommendation(params_transactions)

    render json: { data: anti_fraud }, status: :ok
  rescue StandardError => e
    render json: { error: e }, status: :unprocessable_entity
  end

  def params_transactions
    params.permit(transactions: [:transaction_id, :merchant_id, :user_id, 
                                 :card_number, :transaction_date, :transaction_amount, 
                                 :device_id]).require(:transactions)
  end
end
