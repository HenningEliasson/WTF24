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

        erb :main
    end
end


