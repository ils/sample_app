module ApplicationHelper


 #Return a title on a per-page basis
 def title
   base_title = "Ruby on Rails Tutorial Sample App"
     if @title.nil?
       base_title
     else
       "#{base_title} | #{@title}"
     end
    
 end
 
 #The logo for the site, so image tags can be replaced by logo action
 def logo
 image_tag("logo.png", :alt => "Sample App", :class => "round")
 end


end
