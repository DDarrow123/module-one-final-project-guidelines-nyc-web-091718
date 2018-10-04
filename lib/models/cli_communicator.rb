require 'pry'

class Comm
  def initialize(user)
    @user = user
  end
  #recs: refactor repeated code
  #rename get_initial_user_input b/c it does more than one thing
  #review returns wine which is wierd

  def self.welcome
    puts "Hello soon-to-be wine connoisseur!"
    puts "Please enter your name" ###TODO: discuss how to build this out further
    name_response = gets.strip

    user_name_array = self.get_user_names

    if user_name_array.include?(name_response)
      current_user = User.all.select do |user|
        user.name == name_response
      end.first
    else
      current_user = User.create(name: name_response)
    end
    current_user
  end

  def self.get_user_names
    User.all.map do |user|
      user.name
    end
  end


  def get_initial_user_input
    puts "Would you like to SEARCH for a wine, REVIEW a wine, or get a RECOMMENDATION?"
    puts "Type in an option below:"
    user_choice = gets.strip.downcase

    if user_choice == 'search'
      puts "Please pick a color: Red, White, or Pink"
      color_choice = gets.strip
      puts "Please pick a country:"
      country_choice = gets.strip
      puts "Please pick a year:"
      vintage_choice = gets.strip

      result = Wine.where(color: color_choice, country: country_choice, year: vintage_choice).all
      # "user_name = :user_name"
      if result[0]
        puts "I found you some dope vinosss"
        result.each do |wine|
          puts wine.name
        end
      else
        puts "I can't find any wine like that, sorry bub"
      end
      puts "Is there anything else? (yes or no)"
      anything_else = gets.chomp
      if anything_else == "yes"
        return true
      else
        return false
      end
    end

    if user_choice == 'review'
       wine = review
       if wine
         return create_review(wine)
       end

    elsif user_choice == 'recommendation'
      recommendation #Brennan added for method below
    # elsif user_choice = 'exit'
    #   exit
   end
  end

  # def try_again
  #   puts "Did you find the wine of your dreams?"
  #   puts "Yes or No"
  #   user_choice = gets.strip.downcase
  #   if user_choice == 'yes'
  #     puts "Yay! Would you like to leave a review or get a quick recommendation?"
  #     user_choice = gets.strip.downcase
  #    end
  #     user_choice != 'no'
  # end

  def say_bye
    puts 'coolio, bye!'
  end



  def review
    puts "Please put in wine name:"
    user_choice = gets.strip.downcase

    potential_matches = Wine.where("name like ?", "%#{user_choice}%")

    if potential_matches.length == 1
      puts "Is this the wine you wish to review? (yes or no)"
      puts potential_matches[0]['name']
      puts potential_matches[0]['year']
      yes_no = gets.chomp
        if yes_no == 'yes'
          potential_matches[0]
        elsif yes_no == 'no'
          puts "Sorry we don't have the wine you're looking for. Let's head back to the main menu"
          
      end



    elsif potential_matches.length > 1
      puts "Which of these wines do you wish to review? (Enter number)"
      potential_matches.each_with_index do |wine, i|
        puts "#{i+1}. #{wine['name']} -- #{wine['year']}"
      end
      id_input = gets.chomp #user chooses a numbered wine to review (i.e. 1. Merrvale)
      potential_matches[id_input.to_i - 1]
    else
      puts "We can't seem to find your wine. Please try searching again"
      true
    end
  end

  def create_review(wine)
    puts "On a scale of 1-5 how would you rate this wine (1 = worst, 5 = best)?"
    rating_input = gets.strip
    puts "Leave your comments here:"
    review_input = gets.strip
    Review.create(user_id: @user.id, wine_id: wine.id, content: review_input, rating: rating_input)

    puts "Thanks for your review!"

    puts "Is there anything else? (yes or no)"
    anything_else = gets.chomp
    if anything_else == "yes"
      true
    else
      false
    end
  end

  def recommendation
    puts "Here's your recommendation:"
    wine = Wine.all.sample
    puts wine.name
    puts wine.year
    puts wine.country

    #make this a helper method eventually!
    puts "Is there anything else? (yes or no)"
    anything_else = gets.chomp
    if anything_else == "yes"
      return true
    else
      return false
    end
  end
end
