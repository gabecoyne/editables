Editables::Engine.routes.draw do

  post "image" => "application#update_image"
  
  post ":id" => "application#update"
  
end
