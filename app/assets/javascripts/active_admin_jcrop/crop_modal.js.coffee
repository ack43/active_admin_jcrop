window.active_admin_jcrop =
  start: ->
    if $('.crop_modal_open').length
      $('.crop_modal_open').click ->
        input_field_wrapper = $(this).closest(".jcropable")
        content = $(this).parent().find('.crop_modal_content').clone()
        image = content.find('img.cropping_image')
        active_admin_jcrop.buttons_text =
          save_cropped_image: image.data('translateSaveCroppedImage')
          cancel: image.data('translateCancel')
        active_admin_jcrop.cropper =
          object_class: image.data('objectClass')
          object_id: image.data('objectId')
          crop_field: image.data('cropField')
          jcropper_url: image.data('jcropperUrl')

        $(content).appendTo('body').dialog
          width: content.width()
          height: content.height() + 100
          modal: true
          position: {
             my: "center",
             at: "center",
             of: window
          }
          buttons: [
            {
              text: active_admin_jcrop.buttons_text.save_cropped_image
              click: ->
                submitButton = $('input[type="submit"]')[0]
                submitButton.disabled = true
                previousValue = submitButton.value
                submitButton.value = 'Cropping image...'
                text: 'aews'
                cropper = active_admin_jcrop.cropper
                loader_svg = "data:image/svg+xml,%3Csvg%20version%3D%221.1%22%20id%3D%22loader-1%22%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20xmlns%3Axlink%3D%22http%3A//www.w3.org/1999/xlink%22%20x%3D%220px%22%20y%3D%220px%22%20width%3D%2240px%22%20height%3D%2240px%22%20viewBox%3D%220%200%2040%2040%22%20enable-background%3D%22new%200%200%2040%2040%22%20xml%3Aspace%3D%22preserve%22%3E%0A%20%20%3Cpath%20opacity%3D%220.2%22%20fill%3D%22%23000%22%20d%3D%22M20.201%2C5.169c-8.254%2C0-14.946%2C6.692-14.946%2C14.946c0%2C8.255%2C6.692%2C14.946%2C14.946%2C14.946%0A%20%20%20%20s14.946-6.691%2C14.946-14.946C35.146%2C11.861%2C28.455%2C5.169%2C20.201%2C5.169z%20M20.201%2C31.749c-6.425%2C0-11.634-5.208-11.634-11.634%0A%20%20%20%20c0-6.425%2C5.209-11.634%2C11.634-11.634c6.425%2C0%2C11.633%2C5.209%2C11.633%2C11.634C31.834%2C26.541%2C26.626%2C31.749%2C20.201%2C31.749z%22%3E%3C/path%3E%0A%20%20%3Cpath%20fill%3D%22%23000%22%20d%3D%22M26.013%2C10.047l1.654-2.866c-2.198-1.272-4.743-2.012-7.466-2.012h0v3.312h0%0A%20%20%20%20C22.32%2C8.481%2C24.301%2C9.057%2C26.013%2C10.047z%22%20transform%3D%22rotate%2812%2020%2020%29%22%3E%0A%20%20%20%20%3CanimateTransform%20attributeType%3D%22xml%22%20attributeName%3D%22transform%22%20type%3D%22rotate%22%20from%3D%220%2020%2020%22%20to%3D%22360%2020%2020%22%20dur%3D%220.5s%22%20repeatCount%3D%22indefinite%22%3E%3C/animateTransform%3E%0A%20%20%20%20%3C/path%3E%0A%20%20%3C/svg%3E"
                input_field_wrapper.find(".inline-hints img").attr("src", loader_svg)
                $.ajax
                  type: 'PUT'
                  url: cropper.jcropper_url
                  data:
                    image_data: cropper
                  success: (data,status,xhr,e)->
                    # window.location.reload()
                    input_field_wrapper.find(".inline-hints img").attr("src", data.image_urls.thumb)
                    submitButton.value = previousValue
                    submitButton.disabled = false
                  error: ->
                    alert('There was an error while cropping the image')
                  $(@).dialog('close')
            }
            {
              text: active_admin_jcrop.buttons_text.cancel
              click: ->
                $(@).dialog('close').remove()

            }
          ]
        options = $.extend {}, image.data('jcropOptions')
        options.onSelect = (coords) ->
          update_cropper(coords)
          if image.data('jcropOptions').showDimensions
            content.find('.crop_modal_dimensions').first().text("#{coords.w}x#{coords.h}")
          if fn = image.data('jcropOptions').onSelect
            if typeof fn is 'string'
              window[fn] coords
            else if typeof fn is 'function'
              fn coords
          return
        options.onChange = (coords) ->
          update_cropper(coords)
          if image.data('jcropOptions').showDimensions
            content.find('.crop_modal_dimensions').first().text("#{coords.w}x#{coords.h}")
          if fn = image.data('jcropOptions').onChange
            if typeof fn is 'string'
              window[fn] coords
            else if typeof fn is 'function'
              fn coords
          return
        options.onRelease = ->
          if fn = image.data('jcropOptions').onRelease
            if typeof fn is 'string'
              window[fn] coords
            else if typeof fn is 'function'
              fn coords
          return
        image.Jcrop(options)
        return

      update_cropper = (coords) ->
        active_admin_jcrop.cropper.crop_x = coords.x
        active_admin_jcrop.cropper.crop_y = coords.y
        active_admin_jcrop.cropper.crop_w = coords.w
        active_admin_jcrop.cropper.crop_h = coords.h
        return
      return

$ ->
  active_admin_jcrop.start()
