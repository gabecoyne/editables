module Editables
  module ApplicationHelper
    def can_edit?
      return false if params[:noedit].present?
      return true if current_admin
      false
    end
  
    def wysiwyg
      if !@wysiwyg
        @wysiwyg = true
        if FileTest.exists?(Rails.root.join('public', 'ckeditor', "ckeditor.js"))
          base_dir = "/ckeditor"
        else
          base_dir = "/assets/ckeditor"
        end
        return [
          '<script src="'+base_dir+'/ckeditor.js" ></script>',
          '<script src="'+base_dir+'/adapters/jquery.js" ></script>',
          '<script>$(function(){ $("textarea.editor").ckeditor(); })</script>'
        ].join(" ").html_safe
      else
        ""
      end
    end

    def editable(name, &block)
      e = Editables::Editable.find_or_create_by_name(name)
      if !e.content.present?
        e.content = capture(&block)
        e.save
      end
      html = ""
      if can_edit?
        html += '<a href="#editable-'+e.id.to_s+'" role="button" class="pull-right btn btn-mini" data-toggle="modal">edit</a>'
        form = [
          '<div class="modal hide fade" id="editable-'+e.id.to_s+'" style="width:800px; margin-left:-400px">',
            "<form action='/editables/#{e.id}' method='post' >",
              '<div class="modal-header">',
                '<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>',
                '<h3 style="color:black">'+e.name+'</h3>',
              '</div>',
              '<div class="modal-body">',
                  "<input type='hidden' name='authenticity_token' value='#{form_authenticity_token}'/>",
                  "<input type='hidden' name='editable[#{e.id}][id]' value='#{e.id}'/>",
                  "<textarea name='editable[#{e.id}][content]' style='width:98%;' class='editor'>#{e.content}</textarea>",
              '</div>',
              '<div class="modal-footer">',
                '<a href="#editable-'+e.id.to_s+'" class="btn" data-toggle="modal">Close</a>',
                '<input type="submit" class="btn btn-primary" value="Save changes">',
              '</div>',
            "</form>",
          '</div>'
        ].join(" ")
        form += wysiwyg
        html += form
        # content_for :body_top do
          # form.html_safe
        # end
      end
      html += e.content
      html.html_safe    
    end
  
    def editable_image_tag(name, width, height)
      form_id = "editable-image-#{name.gsub(" ","-")}"
      image = Editables::EditableImage.find_by_name(name)
      if image.present?
        if image.image(:cropped).present? && (open(image.image(:cropped)) rescue false)
          src = image.image(:cropped)  
        elsif width >= 1200
          src = image.image(:original)
        elsif width < 1200 && width >= 600
          src = image.image(:large)
        elsif width < 600 && width >= 300
          src = image.image(:medium)
        else
          src = image.image(:small)
        end
      else
        src = "http://placehold.it/#{width}x#{height}"
      end
      html = ""
      if can_edit?
        html += [
          "<a class='btn btn-mini pull-right' onclick='$(this).next().find(\"input[type=file]\").click()' style='margin:10px;margin-bottom:-40px;position:relative;z-index:1000;'>Upload</a>",
          "<form action='/editables/image' method='post' enctype='multipart/form-data' id='#{form_id}' style='display:none' >",
            "<input type='file' name='editable_image[image]' onchange='$(\"##{form_id}\").submit()' style='border:none;padding0' />",
            "<input type='hidden' name='editable_image[name]' value='#{name}'/>",
            "<input type='hidden' name='editable_image[width]' value='#{width}'/>",
            "<input type='hidden' name='editable_image[height]' value='#{height}'/>",
            "<input type='hidden' name='authenticity_token' value='#{form_authenticity_token}'/>",
          "</form>"
        ].join(" ")
      end
      if image.present? or can_edit?
        html +=  "<img src='#{src}' alt='#{name}' width='#{width}' height='#{height}' />"
      end
      # html += "</div>"
      html.html_safe
    end
  end
end
