require "sinatra"
require 'erb'
require 'pry'

enable  :sessions
use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
# expire after reset button
}

score = [0,0]

def keep_score(score, winner)
    if winner == "Player"
      score[1] += 1
    elsif winner == "Computer"
      score[0] += 1
    end
    score
end

def game_over?(score)
  return true if score.include?(2)
  false
end


def play_game(computer, player)
  win = { r: :s, p: :r, s: :p }
  winner = ""
  if win[computer] == player
    winner = "Computer"
  elsif win[player] == computer
    winner = "Player"
  else
    "Try again"
  end
  winner
end

def computer_choice
  shapes = [:r, :p, :s]
  return shapes.sample
end


def user_chooses_shape(params)
  return params.keys.first.to_sym
end

conversion = {r: "rock", p: "paper", s: "scissors" }

#*** ROUTES ****

get "/" do
  redirect "/rps"
end

get "/rps" do
  erb :index, locals: {session: session}
end


post "/rps" do
  computer = computer_choice
  player = user_chooses_shape(params)
  winner = play_game(computer,player)
  score = keep_score(score, winner)
  game_over = game_over?(score)
  binding.pry
  if params.has_key?("reset")
    session.clear
    redirect "/rps"
  else
    session[:computer] = conversion[computer]
    session[:player] = conversion[player]
    session[:winner] = winner
    session[:score] = score
    session[:game] = game_over
  end
  redirect "/rps"
end
