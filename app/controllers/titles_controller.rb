class TitlesController < ApplicationController
  

  def create
    Content.new(content_params).save
  end

  def create_good
    GoodUser.new(good_params).save        
  end

  def answer
    Answer.new(answer_params).save
    if User.where(user_sub: user_params[:user_sub]).empty?
      User.new(user_params).save
    elsif User.where(user_sub: user_params[:user_sub]).where(name: user_params[:name]).empty?
      User.find_by(user_sub: user_params[:user_sub]).delete
      User.new(user_params).save
    elsif User.where(sub: user_params[:sub]).where(name: user_params[:name])
      User.find_by(sub: user_params[:sub]).delete
      User.new(user_params).save
    end        
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
       render json: [title:"emp",size:200,id:"emp"]
    else
      @content = Content.where(switch:0).limit(20)
      render json: @content
    end
  end

  def send_to_client_all
    if Content.where(switch:1).empty?
      render json: [title:"emp",size:200,id:"emp"]
    else
      @content = Content.where(switch:1).order("RANDOM()")
      render json: @content.select("title","id","size")
    end
  end

  def send_to_client

    if content_params[:id] == "emp"
      render json: [answer: "emp"]

    elsif content_params[:sub] != "emp" && content_params[:switch] == "1"          
      @answer = Answer.where(content_id:content_params[:id]).order("RANDOM()")
      @answer = @answer.map { |answer|
                              if GoodUser.where(answer_id: answer.id).where(sub: content_params[:sub]).empty? 
                                good_user = "gray"
                              else
                                good_user = "blue"
                              end
                            {id: answer[:id],answer: answer[:answer],content_id: answer[:content_id],good: good_user}
                         }
      if Answer.where(content_id:content_params[:id]).include?(content_params[:sub])
        user_answer = "presence"
      else
        user_answer = "nothing"
      end
      render json: [Content.where(id: content_params[:id]).where(switch:1).select("title","id","size") ,@answer,user_answer]
    
    elsif content_params[:switch] == "1"  
       render json: [Content.where(id: content_params[:id]).where(switch:1).select("title","id","size") ,Answer.where(content_id:content_params[:id]).select("answer").order("RANDOM()")]

    elsif content_params[:switch] == "0" && Answer.where(content_id:content_params[:id]).empty?
      render json: [Content.where(id: content_params[:id]).where(switch:0).select("title","id","size") ,[answer: "emp"]]

    elsif content_params[:switch] == "0"
      @answer = Answer.where(content_id:content_params[:id]).select("answer","id","user_sub")
      @answer = @answer.map{|answer,index|
        cou = GoodUser.where(answer_id: answer[:id]).count
        user = User.where(user_sub: answer[:user_sub])
        {id: answer[:id],answer: answer[:answer],count: cou,name: user[0][:name]}
        }
        @answer = @answer.sort {|a, b| b[:count] <=> a[:count] }
        render json: [Content.where(id: content_params[:id]).where(switch:0).select("title","id","size") ,@answer]
      
    end
  end

  def rank
    @rank = ranksort
    render json: @rank
  end

  def ranksort
    
      @answer = Answer.where('created_at >= ?',30.day.ago).select("user_sub","id")
      @answer = @answer.map{|answer|
        cou = GoodUser.where(answer_id: answer[:id]).count
        {sub: answer[:user_sub],count: cou}
      }
      # [{name:"k",n:"k"},{name:"c",n:"x"}] ← mapの出力はこんな感じ
      @user = User.where('created_at >= ?',30.day.ago)
      @user = @user.map{|user|
        if @answer.find_all{|val|val[:sub] == user[:user_sub]}.empty? != true
          i = 0
          cou = 0
          k = @answer.find_all{|val|val[:sub] == user[:user_sub]}
          size = k.size
          while i < size do
            cou = k[i][:count] + cou
            i += 1
          end
          {name: user[:name],count: cou}
        else
          {name: "reimu",count:0}  
        end
      }
    
  if @user.size == 0
    @user = [{name: "reimu",count: 0},{name: "marisa",count: 1000},{name:"youmu",count:1}]
  elsif @user.size == 1
    @user = [{name:"reimu",count:0},{name:"youmu",count:1},@user[0]]
  elsif @user.size == 2
    @user = [{name:"reimu",count:0},@user[0],@user[1]]
  end
  @user = @user.sort {|a, b| b[:count] <=> a[:count] }
  @user = @user.take(3)
  return @user
end

  def content_params
    params.permit(:title, :sub, :size, :id, :switch)
  end

  def answer_params
    params.permit(:content_id, :answer, :user_sub)
  end

  def user_params
    params.permit(:name,:user_sub)
  end
  
end
