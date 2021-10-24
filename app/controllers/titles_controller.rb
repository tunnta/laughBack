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
        render json: [0]
        else
        render json: [1]
        end
      end

      def send_to_client_all

        @content = Content.where(switch:1).select("id")

        render json: @content

      end

      def send_to_client
        #パラメーターをフロントから送った場合とそうじゃない場合

        if content_params.empty? && Content.present?

          render json: [title:"emp",size:200,id:0]

        elsif content_params.empty?

        @content = Content.where(switch:1).order("RANDOM()").limit(5)
        render json: @content.select("title","id","size")

        elsif content_params[:sub] && content_params[:sub] != "emp"
          
          @answer = Answer.where(title_id:content_params[:id])

         @answer = @answer.map { |answer|
                                  if GoodUser.where(answer_id: answer.id).where(sub: content_params[:sub]).empty? 
                                    good_user = "gray"
                                  else
                                    good_user = "blue"
                                  end
                                {id: answer[:id],answer: answer[:answer],title_id: answer[:title_id],good: good_user}
                             }
  
            render json: [Content.where(id: content_params[:id]).where(switch:1).select("title","id","size") ,@answer]
        
        else
          
           render json: [Content.where(id: content_params[:id]).where(switch:1).select("title","id","size") ,Answer.where(title_id:content_params[:id])]
        end
      end


      def content_params
        params.permit(:title, :sub, :size, :id, :switch)
      end

      def answer_params
        params.permit(:title_id, :answer, :user_sub)
      end

      def good_params
        params.permit(:sub,:answer_id)
      end

      
end
