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

        erb :main
    end

    post '/:genres/:game_name' do  |genres, game_name|
        gen_id = db.execute("SELECT id FROM genres WHERE id = ?", genres)
        game_id = db.execute("SELECT id FROM game WHERE id = ?", game_name)

        com = params['words'] 
        query = 'INSERT INTO comment (com) VALUES (?) RETURNING id'
        result = db.execute(query, name).first  
        redirect "/#{genres}/#{game_name}"
      end
end


