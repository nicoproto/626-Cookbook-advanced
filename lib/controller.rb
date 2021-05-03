require 'nokogiri'
require 'open-uri'

require_relative "view"
require_relative "recipe"

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  # USER ACTIONS

  def list
    display_recipes
  end

  def create
    # 1. Ask user for a name (view)
    name = @view.ask_user_for("name")
    # 2. Ask user for a description (view)
    description = @view.ask_user_for("description")
    # 3. Ask user for a rating (view)
    rating = @view.ask_user_for("rating")
    # 4. Ask user for a prep_time (view)
    prep_time = @view.ask_user_for("preparation time")
    # 5. Create recipe (model)
    recipe = Recipe.new(name: name, description: description, rating: rating, prep_time: prep_time)
    # 6. Store in cookbook (repo)
    @cookbook.add_recipe(recipe)
    # 7. Display
    display_recipes
  end

  def destroy
    # 1. Display recipes
    display_recipes
    # 2. Ask user for index (view)
    index = @view.ask_user_for_index
    # 3. Remove from cookbook (repo)
    @cookbook.remove_recipe(index)
    # 4. Display
    display_recipes
  end

  def import
    # 1. Ask user for a keyword
    keyword = @view.ask_user_for("Ingredient")
    # 2. Open url
    url = open("https://www.allrecipes.com/search/results/?search=#{keyword}")
    # 3. Parse HTML
    doc = Nokogiri::HTML(URI.open(url), nil, 'utf-8')
    # 4. For the first five results
    results = []
    doc.search(".card__recipe").take(5).each do |element|
      # 5. Create recipe and store it in results
      name = element.search('.card__title').text.strip
      description = element.search('.card__summary').text.strip
      rating = element.search('.review-star-text').text.split(" ")[1]

      recipe_url = element.search(".card__imageContainer a").first.attribute("href").value
      recipe_doc = Nokogiri::HTML(URI.open(recipe_url), nil, 'utf-8')

      prep_time = recipe_doc.search(".recipe-meta-item-body").first.text.strip

      results << Recipe.new(name: name, description: description, rating: rating, prep_time: prep_time)
    end
    # 6. Display results
    @view.display(results)
    # 7. Ask for the recipe to import
    index = @view.ask_user_for_index
    # 8. Add to cookbook
    @cookbook.add_recipe(results[index])
    # 9. Display recipes
    display_recipes
  end

  def mark_as_done
    # 1. Display recipes
    display_recipes
    # 2. Ask user for an index (view)
    index = @view.ask_user_for_index
    # 3. Mark as done and save (repo)
    @cookbook.mark_recipe_as_done(index)
    # 4. Display recipes
    display_recipes
  end

  private

  def display_recipes
    # 1. Get recipes (repo)
    recipes = @cookbook.all
    # 2. Display recipes in the terminal (view)
    @view.display(recipes)
  end
end
