namespace :watch do
    desc "dbのcontentを見て、createした時間から3日がたったものを削除とswitchをきりかえる"
    
    task transfer_data: :environment do
    
        time = Time.now

        contents = Content.where('created_at > ?',3.day.ago).where(switch: 1)

        contents.each do |content|

            if time - content.created_at >=  259000
                puts content.update(switch: 0)
            end

        end

    
end
end
