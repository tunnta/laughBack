class GoodUsersController < ApplicationController
  def create
    GoodUser.new(good_params).save 
    #k
  end

  def destroy
    GoodUser.where(sub: good_params[:sub]).where(answer_id: good_params[:answer_id]).delete_all 
    
  end

  def good_params
    params.permit(:sub,:answer_id)
  end
end
