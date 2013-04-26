module Editables
  class EditableImage < ActiveRecord::Base  
    set_table_name "editable_images"  
    
    if FileTest.exists?(Rails.root.join('config', 's3.yml'))
      config = YAML.load(File.read('config/s3.yml'))[Rails.env]
      has_attached_file :image, 
        :styles => { 
          :large =>        "1200x1200>",
          :medium =>        "600X600>", 
          :small =>         "300X300>"
        },
        :storage => :s3,
        :s3_credentials => "#{Rails.root}/config/s3.yml",
        :s3_host_alias => config["s3_host_alias"],
        :url => ":s3_alias_url",
        :path => "/paperclip/:class/:id/:style/:filename"
    else
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
end
