module MoviesHelper

  def get_name_from_personnel_identifier(identifier)
    name = "" 
    identifier = identifier.gsub(/\-dot\-/,".") #first regenerate .
    parts = identifier.split(/\-/) #seperate by -
    (1...(parts.length-3)).each do |i| # the first part is p, the last three parts represent birthday
      name += parts[i]
      name += " "  
    end
    name.strip()
  end
  
  def get_motion_picture_rating
    ['G','PG','PG-13','NR','R','NC-17']
  end
   
end