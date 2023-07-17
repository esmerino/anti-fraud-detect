class TransactionsController < ApplicationController
  def index
    @transaction = Transaction.last
  end
end
