module Editables
  class EditableImage < ActiveRecord::Base  
    set_table_name "editable_images"  
    
    has_attached_file :image, 
    	:styles => { 
    	  :large =>        "1200x1200>",
    	  :medium =>        "600X600>", 
    	  :small =>         "300X300>"
    	},
      :path => ":rails_root/public/editable_images/:id/:style/:basename.:extension",
      :url => "/editable_images/:id/:style/:filename"
    
  end
end
