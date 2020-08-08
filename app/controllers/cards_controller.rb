class CardsController < ApplicationController

  require "payjp"

  def new
    @card = Card.new
    gon.PAYJP_KEY = ENV['PAYJP_KEY']
  end

  def create
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    customer = Payjp::Customer.create(card: params[:payjpToken])
    @card = Card.new(user: current_user, customer_id: customer.id, card_token: params[:payjpToken])
    if @card.save
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def pay       #payjpとcardのデータベース作成
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    if params['payjpToken'].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(
        card: params['payjpToken'],
      )
      @card = Card.new(user: current_user.id, customer_id: customer.id, card_token: customer.default_card)
      if @card.save
        redirect_to action: "show"
      else
        redirect_to action: "pay"
      end
    end
  end



  def show        #cardのデータをpayjpに送り、情報を取り出す
    @card = Card.where(user: current_user.id).first
    if @card.blank?
      redirect_to action: "new"
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @default_card_information = customer.cards.retrieve(customer.default_card)
      # 表示文字数変更処理
      @last4 = @default_card_information.last4
      @exp_month = @default_card_information.exp_month.to_s.rjust(2, '0')
      @exp_year = @default_card_information.exp_year.to_s.slice(2, 2)
    end
  end

  def delete      #payjpとcardデータベースを削除
    @card = Card.where(user: current_user.id).first
    if @card.blank?
      redirect_to action: "new"
    else
      # payjpから顧客情報削除処理
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(@card.customer_id)
      customer.delete
      # データベースからのカード情報削除処理
      @card.delete
      # 削除完了時にマイページへ遷移
      redirect_to user_path
    end
  end

  def confirm
  end

end