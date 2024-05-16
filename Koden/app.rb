require 'slugify'
require 'debug'
class Databas < Sinatra::Base

    enable :sessions

    helpers do
        def h(text)
            Rack::Utils.escape_html(text)
          end
        
          def hattr(text)
            Rack::Utils.escape_path(text)
          end
    end

    def db
        return @db if @db
        @db = SQLite3::Database.new('./db/videogames.db')
        @db.results_as_hash = true
        return @db 
    end

    get '/' do

        erb :index
    end

    post '/' do 
        password = params['password']
        username = params['username']
        past = db.execute("SELECT * FROM users")
        past.each do |name|
            unam = name['username']
            passw = name['password']
            if unam == username &&  passw == password
                session[:user_id] = db.execute("SELECT id FROM users WHERE username = ?", username).first['id']
                redirect "/home"
            end
        end
        redirect "/wrong" 
    end

    post '/new_here' do
        username = params['new_username']
        password = params['new_password']
        past = db.execute("SELECT * FROM users")
        past.each do |name|
            unam = name['username']
            if unam == username
               redirect "/wrong2"
            end
        end
        result = db.execute("INSERT INTO users (username, password) VALUES (?,?) RETURNING id", username, password).first 
        session[:user_id] = db.execute("SELECT id FROM users WHERE username = ?", username).first
        redirect '/home'
    end

    post '/guest' do
        session[:user_id] = 0
        redirect '/home'
    end

    get '/wrong' do

        erb :wrong
    end

    post '/wrong' do
        redirect "/"
    end

    get '/wrong2' do

        erb :wrong2
    end

    post '/wrong2' do
        redirect '/'
    end

    get '/home' do
        @gen = db.execute("SELECT * FROM genre") 
        erb :genres
    end

    get '/home/:genres' do |genres|
        @genres = genres
        middle = db.execute("SELECT * FROM genre WHERE genre_name = ?", genres).first
        @game = db.execute("SELECT * FROM game WHERE genre_id = ? ORDER BY game_name ASC", middle['id'])
        if session[:user_id] != 0
            @user_id = session[:user_id]
        end
        
        erb :gamelist
    end

    get '/add' do

        erb :add
    end 

    post '/add' do
        if session[:user_id]['id'] == 1
            game_name = params['game_name']
            genre_id = params['genre_id']
            past = db.execute("SELECT * FROM game")
            past.each do |name|
                gnam = name['game_name']
                if gnam == game_name
                   redirect "/wrong_game"
                end
            end
            result = db.execute("INSERT INTO game (game_name, genre_id) VALUES (?,?) RETURNING id", game_name, genre_id).first
        end 
    end

    get '/wrong_game' do
        erb :wrong_game
    end

    post '/wrong_game' do
        redirect '/add'
    end

    get '/home/:genres/:ids' do |genres,ids|
        @genres = genres 
        @id = ids
        @game = db.execute("SELECT game_name FROM game WHERE id = ?", ids).first
        @comments = db.execute("SELECT * FROM comment WHERE game_id = ?", ids)
        erb :main
    end

    post "/home/:genres/:ids" do  |genres, ids|
        @id = ids
        id_user = session[:user_id]['id']
        @game = db.execute("SELECT game_name FROM game WHERE id = ?", ids).first
        com_text = params['words'] 
        if com_text == ''
            redirect "/home/#{genres}/#{ids}"
        end
        result = db.execute("INSERT INTO comment (user_id,game_id,com_text) VALUES (?,?,?) RETURNING id", id_user,ids,com_text).first  
        redirect "/home/#{genres}/#{ids}"
    end
end


