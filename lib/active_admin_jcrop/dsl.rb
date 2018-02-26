module ActiveAdminJcrop
  module DSL

    def jcropable
      member_action :jcropper, method: :put do
        resource.active_admin_crop! params[:image_data]

        image = resource.send(params[:image_data][:crop_field])
        urls = {}
        image.styles.keys.each do |s|
          urls[s] = image.url(s)
        end


        respond_to do |format|
          format.json {
            render(
              json: {
                status: "ok",
                image_urls: urls
              },
              status: 200
            )
          }
        end
      end
    end


  end
end
