class Api::BankAccountsController < ApplicationController
  include ApplicationHelper
  
  before_action :set_bank_account, only: [:show, :edit, :update, :destroy]

  # GET /bank_accounts
  # GET /bank_accounts.json
  def index
    @bank_accounts = BankAccount.all
    render :json => @bank_accounts.to_json
  end

  # GET /bank_accounts/1
  # GET /bank_accounts/1.json
  def show
  end

  # GET /bank_accounts/new
  def new

    @bank_account = BankAccount.new
  end

  # GET /bank_accounts/1/edit
  def edit
  end

  def debit

    payee_account_number = params[:bank_account][:account_number]
    payee_amount = params[:bank_account][:amount]
    user =  BankAccount.find(params[:id])
    payee = BankAccount.find_by_account_number(payee_account_number)
    if (is_number?(payee_account_number)&&(user.avail_balance.to_f >= payee_amount.to_f && payee_account_number != user.account_number))
      payee.update_attributes(avail_balance: payee.avail_balance.to_f+payee_amount.to_f)
      Transaction.create(bank_account_id: payee.id, amount: payee_amount.to_f, transaction_type: 'credit' ,account_number: user.account_number)
      user.update_attributes(avail_balance: user.avail_balance.to_f-payee_amount.to_f)
      Transaction.create(bank_account_id: user.id, amount: payee_amount.to_f, transaction_type: 'debit',account_number: payee_account_number )
    else
     render :json => { :errors => "Some thing went wrong" }
    end
  end

  def transaction_views
    @transactions = BankAccount.find(params[:id]).transactions
    render :json => @transactions.to_json
    # .collect{|k| {transaction_type: k.transaction_type, amount: k.amount.to_f}}
  end

  def deposite
    bank = BankAccount.find(params[:id])
    bank.update_attributes(avail_balance: (bank.avail_balance.to_f + params["bank_account"]["amount"].to_f))
    Transaction.create(bank_account_id: params[:id], amount: params["bank_account"]["amount"].to_f, transaction_type: 'credit')
  end

  def withdraw
    bank = BankAccount.find(params[:id])
    bank.update_attributes(avail_balance: (bank.avail_balance.to_f - params["bank_account"]["amount"].to_f)) unless (bank.avail_balance.to_f < params["bank_account"]["amount"].to_f)
    Transaction.create(bank_account_id: params[:id], amount: params["bank_account"]["amount"].to_f, transaction_type: 'debit') unless (bank.avail_balance.to_f < params["bank_account"]["amount"].to_f)
    render :json => { :errors => "Some thing went wrong" }  if bank.avail_balance.to_f < params["bank_account"]["amount"].to_f 
  end

  def credit
    bank =  BankAccount.find(params[:id])
  end

  # POST /bank_accounts
  # POST /bank_accounts.json
  def create
    @bank_account = BankAccount.new(bank_account_params)
      if is_number?(params[:bank_account][:account_number]) && @bank_account.save  
         render :json => @bank_account 
      else
        render :json => @bank_account.errors, status: :unprocessable_entity 
      end
  end

  # PATCH/PUT /bank_accounts/1
  # PATCH/PUT /bank_accounts/1.json
  def update
  end

  # DELETE /bank_accounts/1
  # DELETE /bank_accounts/1.json
  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_account
      @bank_account = BankAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_account_params
      params.require(:bank_account).permit(:user_name,:account_number,:avail_balance)
    end
end
