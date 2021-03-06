require 'pry'
require 'colorize'


def welcome
  puts "\u{1F377}" * 30
  puts "Hello soon-to-be wine connoisseur!".colorize(:white).colorize( :background => :red)
  puts "Please enter your name".colorize(:red)
  name_response = gets.strip
  User.find_or_create_by(name: name_response)
  # user_name_array = get_user_names
  #
  # if user_name_array.include?(name_response)
  #   User.all.find do |user|
  #     user.name == name_response
  #   end
  # else
  #   User.create(name: name_response)
  # end
end

def get_user_names
  User.all.map do |user|
    user.name
  end
end


def get_initial_user_input
  puts "Would you like to SEARCH for a wine, REVIEW a wine, get a RECOMMENDATION, or go to MY WINE REVIEWS".colorize(:white).colorize( :background => :red)
  puts "Type in an option below:".colorize(:red)
  user_choice = gets.strip.downcase
  user_choice
end

  def search
    puts "Please pick a color: Red, White, or Pink".colorize(:red)
    color_choice = gets.strip.capitalize
    puts "Please pick a country:".colorize(:red)
    country_choice = gets.strip.capitalize
    puts "Please pick a year:".colorize(:red)
    vintage_choice = gets.strip.capitalize

    result = Wine.where(color: color_choice, country: country_choice, year: vintage_choice).all
    # "user_name = :user_name"
    if result[0]
      puts "I found you some dope vinosss".colorize(:white).colorize( :background => :red)
      puts "---" * 10
      result.each do |wine|
        puts wine.name.colorize(:red)
        puts "---" * 10
      end
    else
      puts ""
      puts "I can't find any wine like that, sorry bub".colorize(:white).colorize( :background => :red)
    end
  end

def review
  puts "Perty plz put in wine name:".colorize(:red)
  user_choice = gets.strip.capitalize

  potential_matches = Wine.where("name like ?", "%#{user_choice}%")

  if potential_matches.length == 1
    puts "Is this the wine you were psyched to review? (yes or no)".colorize(:red)
    puts ""
    puts potential_matches[0]['name']
    puts potential_matches[0]['year']
    yes_no = gets.chomp
    if yes_no == 'yes'
      potential_matches[0]
    else
      keep_searching = false ########## NEED TO REFACTOR ### Something in RUN file
    end
  elsif potential_matches.length > 1
    potential_matches.each_with_index do |wine, i|
      puts "#{i+1}. #{wine['name']} -- #{wine['year']}"
      puts ""
    end
    puts "Which of these wines do you vibe with best to review? (Enter number)".colorize(:red)
    puts ""
    number_input = gets.chomp
     if (number_input.to_i) > potential_matches.length
       number_input = potential_matches.count
     end
    potential_matches[number_input.to_i - 1]
  else
    puts "We can't seem to find your wine. Womp womp womp wooooooomp. Please try searching again:".colorize(:white).colorize( :background => :red)
    review
  end
end

def create_review(user, wine)
  puts "On a scale of 1-5 how would you rate this vino (1 = worst, 5 = best)?".colorize(:red)
  rating_input = gets.strip
  puts "Leave your comments here:".colorize(:red)
  review_input = gets.strip

  Review.create(user_id: user.id, wine_id: wine.id, content: review_input, rating: rating_input)

  puts "Tanks for your review!".colorize(:red)
end

def recommendation
  puts ""
  puts "Here's your recommendation:".colorize(:red)
  wine_rec = Wine.all.sample
  puts wine_rec.name
  puts "--"
  puts wine_rec.year
    puts "--"
  puts wine_rec.country
    puts "--"
end


def user_reviews(user)
  user_review_list = Review.all.select do |review|
    review.user_id == user.id
  end
end

def generated_review_list(user)
  review_list_continued = user_reviews(user)
  if review_list_continued.length != 0
  review_list_continued.each_with_index do |review, i|
    puts "************************"
    puts "#{i+1}. Wine: #{find_wine_names_review(review)}".colorize(:red)
    puts "Your rating: *#{review.rating}*".colorize(:yellow)
    puts "#{review.content}"
    end
  else
    puts "You don't have any reviews. WUT."
  end
end

def find_wine_names_review(review)
  wine = Wine.all.select do |wine|
  wine.id == review.wine_id
  end
  wine[0].name
end

def update_delete_exit?
  puts ""
  puts "Do you want to UPDATE reviews, DELETE reviews, or EXIT reviews".colorize(:white).colorize( :background => :red)
  user_input = gets.strip.downcase
end

def delete(compiled_review_list)
  puts "Which review do you want to delete from your list above my wine explorer (ENTER NUMBER)?".colorize(:white).colorize( :background => :red)
  user_delete_number = gets.strip

  Review.delete(compiled_review_list[user_delete_number.to_i - 1].id)
end

def update(compiled_review_list)
  puts "Which review do you want to update from your list above (ENTER NUMBER)?".colorize(:red)
  user_update_number = gets.strip

  puts "Leave your new comments here:".colorize(:red)
  review_input = gets.strip

  puts "On a scale of 1-5 how would you rate this vino (1 = worst, 5 = best)?".colorize(:red)
  rating_input = gets.strip

  Review.update(compiled_review_list[user_update_number.to_i - 1].id, content: review_input, rating: rating_input )
end

def anything_else
  puts "Is there anything elsssssseeeee? (yes or no)".colorize(:white).colorize( :background => :red)
  anything_else = gets.chomp
  if anything_else == "yes"
    true
  else
    false
  end
end

def say_bye
  puts `clear`
  puts 'coolio, bye!'.colorize(:red)
  10.times do puts "\u{1F377}" * 30 end
end
