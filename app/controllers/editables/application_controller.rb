module Editables
  class ApplicationController < ActionController::Base  
    def update      
      if params[:editable]
        params[:editable].each do |id, e|
          Editables::Editable.find(e[:id]).update_attributes(e)
        end
        redirect_to :back
      end
    end
    
    def update_image
      @image = Editables::EditableImage.find_by_name(params[:editable_image][:name])
      if @image.present?
        @image.update_attributes(params[:editable_image])
      else
        @image = Editables::EditableImage.create(params[:editable_image])
      end
      @image.image.reprocess!
      redirect_to :back
    end
  end
end
