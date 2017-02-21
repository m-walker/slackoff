class Api::SubscriptionsController < ApplicationController
  def create
    @existing_subscription = Subscription.find_by(user_id: current_user.id,
                                                  channel_id: sub_params[:channel_id])

    # debugger

    if @existing_subscription
      @channel = Channel.includes(:messages).find(@existing_subscription.channel_id)
      @messages = @channel.messages.order(:created_at).reverse

      render 'api/channels/show'
      return
    end

    @subscription = current_user.subscriptions.new(sub_params)

    if @subscription.save
      @channel = Channel.includes(:messages).find(@subscription.channel_id)
      @messages = @channel.messages.order(:created_at).reverse

      render 'api/channels/show'
    else
      render json: @message.errors.full_messages, status: 422
    end
  end

  def destroy
    @subscription = Subscription.includes(:user).find_by(user_id: current_user.id,
                                         channel_id: params[:channel_id])

    @subscription.destroy

    @user = current_user
    @channels = @user.channels

    render 'api/users/show'
  end

  def sub_params
    params.require(:sub).permit(:channel_id)
  end
end
