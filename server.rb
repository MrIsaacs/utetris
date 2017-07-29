require 'sinatra'
require 'json'
require 'pry'

set :port, 1234

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/:file' do
  path = "/Users/monsterlite/Games/tetris-attack-js/public/"
  send_file "#{path}#{params[:file]}", disposition: 'inline'
end
