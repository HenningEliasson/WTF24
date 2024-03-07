class Databas < Sinatra::Base

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

    get '/:genres/:game_name' do |genres, game_name|
        @name = game_name
        @genres = genres 
        game = db.execute("SELECT id FROM game WHERE game_name = ?", game_name).first
        game_id = game['id']

        @comments = db.execute("SELECT com_text FROM comment WHERE game_id = ?", game_id)
        erb :main
    end

    post '/:genres/:game_name' do  |genres, game_name|
        game = db.execute("SELECT id FROM game WHERE game_name = ?", game_name).first
        game_id = game['id']
        user_id = 1
        com_text = params['words'] 
        result = db.execute('INSERT INTO comment (user_id,game_id,com_text) VALUES (?,?,?) RETURNING id', user_id,game_id,com_text).first  
        redirect "/#{genres}/#{game_name}"
    end
end


