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
        @gen = db.execute("SELECT * FROM genre") 
        erb :index
    end

    get '/:genres' do |genres|
        middle = db.execute("SELECT id FROM genre WHERE genre_name = ?", genres).first 
        @game = db.execute("SELECT * FROM game WHERE genre_id =  ?", middle['id']) 
        @genres = genres
        erb :gamelist
    end

    get '/:genres/:ids' do |genres,ids|
        @genres = genres 
        @id = ids
        @game = db.execute("SELECT game_name FROM game WHERE id = ?", ids).first
        @comments = db.execute("SELECT com_text FROM comment WHERE game_id = ?", ids)
        erb :main
    end

    post "/:genres/:ids" do  |genres, ids|
        @id = ids
        @game = db.execute("SELECT game_name FROM game WHERE id = ?", ids).first
        user_id = 1
        com_text = params['words'] 
        result = db.execute("INSERT INTO comment (user_id,game_id,com_text) VALUES (?,?,?) RETURNING id", user_id,ids,com_text).first  
        redirect "/#{genres}/#{ids}"
    end
end


