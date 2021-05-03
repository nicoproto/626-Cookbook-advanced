class View
  def display(recipes)
    recipes.each_with_index do |recipe, index|
      status = recipe.done ? "[X]" : "[ ]"
      puts "#{status} - #{index + 1}. #{recipe.name}: #{recipe.description} (#{recipe.rating} stars) - Prep #{recipe.prep_time}"
    end
  end

  def ask_user_for(stuff)
    puts "#{stuff.capitalize}?"
    print "> "
    return gets.chomp
  end

  def ask_user_for_index
    puts "Index?"
    print "> "
    return gets.chomp.to_i - 1
  end
end
