class Recipe
  attr_reader :name, :description, :rating, :done, :prep_time
  attr_writer :done

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @rating = attributes[:rating]
    @done = attributes[:done] || false
    @prep_time = attributes[:prep_time]
  end

  def mark_as_done!
    @done = true
  end
end

# Recipe.new(name: "banana bread", rating: 4, description: "This is a banana bread")