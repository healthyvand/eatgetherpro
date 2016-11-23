class Account::AskerRequestsController < ApplicationController

  def index
    @asker_requests = AskerRequest.where(user_id: current_user)
    # @posts = current_user.asker_requests
  end

  def destroy
    @asker_request = AskerRequest.find(params[:id])

    @asker_request.destroy
    redirect_to :back
    flash[:alert] = "取消成功"
  end

end