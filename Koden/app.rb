require 'slugify'
class Databas < Sinatra::Base

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

        erb :user
    end

    post "/" do 
        password = params['password']
        username = params['username']
        past = db.execute("SELECT * FROM users")
        past.each do |name|
            unam = name['username']
            passw = name['password']
            if unam == username &&  passw == password
                break
            elsif unam == username && passw =! password
                raise "wrong password"  
            elsif unam =! username && passw =! password
                result = db.execute("INSERT INTO users (username, password) VALUES (?,?) RETURNING id", username, password).first
            end
            #FIXA!
        end
        
        $user_id = db.execute("SELECT id FROM users WHERE username = ?", username).first
        redirect "/home"
    end

    get '/home' do
        @gen = db.execute("SELECT * FROM genre") 
        erb :index
    end

    get '/home/:genres' do |genres|
        middle = db.execute("SELECT id FROM genre WHERE genre_name = ?", genres).first 
        @game = db.execute("SELECT * FROM game WHERE genre_id =  ?", middle['id']) 
        @genres = genres
        erb :gamelist
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
        @game = db.execute("SELECT game_name FROM game WHERE id = ?", ids).first
        com_text = params['words'] 
        result = db.execute("INSERT INTO comment (user_id,game_id,com_text) VALUES (?,?,?) RETURNING id", $user_id,ids,com_text).first  
        redirect "/home/#{genres}/#{ids}"
    end
end


