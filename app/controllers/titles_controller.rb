class TitlesController < ApplicationController
  

  def create
    Content.new(content_params).save
  end

  def create_good
     #good_count = GoodUser.where(answer_id:good_params[:answer_id]).count
    GoodUser.new(good_params).save        
  end

  def answer
    Answer.new(answer_params).save        
  end

  def user_title

    if Content.where(sub:content_params[:sub]).where(switch:1).empty?
      render json: [1]
    else
      render json: [0]
    end
  end

  def send_to_client0
    if content_params.empty? && Content.where(switch:0).blank?
       render json: [title:"emp",size:200,id:4]
    else
      @content = Content.where(switch:0).limit(20)
      render json: @content
    end
  end

  def send_to_client
    #パラメーターをフロントから送った場合とそうじゃない場合
    if content_params.empty? && Content.where(switch:1).empty?
      render json: [title:"emp",size:200,id:"emp"]

    elsif content_params.empty?
      @content = Content.where(switch:1).order("RANDOM()")
      render json: @content

    elsif content_params[:id] == "emp"
      render json: [answer: "emp"]

    elsif content_params[:sub] != "emp" && content_params[:switch] == "1"          
      @answer = Answer.where(content_id:content_params[:id])
      @answer = @answer.map { |answer|
                              if GoodUser.where(answer_id: answer.id).where(sub: content_params[:sub]).empty? 
                                good_user = "gray"
                              else
                                good_user = "blue"
                              end
                            {id: answer[:id],answer: answer[:answer],content_id: answer[:content_id],good: good_user}
                         }

      render json: [Content.where(id: content_params[:id]).where(switch:1).select("title","id","size") ,@answer]
    
    elsif content_params[:switch] == "1"  
       render json: [Content.where(id: content_params[:id]).where(switch:1).select("title","id","size") ,Answer.where(content_id:content_params[:id]).select("answer")]

    elsif content_params[:switch] == "0" && Answer.where(content_id:content_params[:id]).empty?
      render json: [Content.where(id: content_params[:id]).where(switch:0).select("title","id","size") ,[answer: "emp"]]

    elsif content_params[:switch] == "0"
      @answer = Answer.where(content_id:content_params[:id]).select("answer","id")
      @answer = @answer.map{|answer,index|
      cou = GoodUser.where(answer_id: answer[:id]).count
      {id: answer[:id],answer: answer[:answer],count: cou}
      @answer = @answer.sort {|a, b| b[:count] <=> a[:count] }
        render json: [Content.where(id: content_params[:id]).where(switch:0).select("title","id","size") ,@answer]
          
    end
  end

  def content_params
    params.permit(:title, :sub, :size, :id, :switch)
  end

  def answer_params
    params.permit(:content_id, :answer, :user_sub)
  end
  
end
