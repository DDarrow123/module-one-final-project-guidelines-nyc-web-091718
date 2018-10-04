require_relative '../config/environment'
require 'pry'


user = Comm.welcome

comm = Comm.new(user)

keep_searching = true

while keep_searching do
  keep_searching = comm.get_initial_user_input
end
comm.say_bye
