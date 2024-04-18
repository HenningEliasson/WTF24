require 'sqlite3'
require 'csv'

class Seeder

    def self.seed!
        puts "Seeding the DB"
        #drop_tables
        #create_tables
        seed_data
        puts "Seed complete"
    end

    private

    def self.db
        return @db if @db
        @db = SQLite3::Database.new('db/videogames.db')
        @db.results_as_hash = true
        return @db
    end

    def self.drop_tables
        puts "  * Dropping Tables"
        db.execute('DROP TABLE IF EXISTS game')
        db.execute('DROP TABLE IF EXISTS genre')
        db.execute('DROP TABLE IF EXISTS comment')
        db.execute('DROP TABLE IF EXISTS users')
    end
    
    
    def self.create_tables
    puts "  * Creating tables"
        db.execute('CREATE TABLE "game" (
            "id"	INTEGER UNIQUE,
            "genre_id"	INTEGER,
            "game_name"	TEXT DEFAULT NULL,
            PRIMARY KEY("id" AUTOINCREMENT),
            CONSTRAINT "fk_gm_gen" FOREIGN KEY("genre_id") REFERENCES "genre"("id")
        );') 
        db.execute('CREATE TABLE "genre" (
            "id"	INTEGER,
            "genre_name"	TEXT DEFAULT NULL,
            PRIMARY KEY("id")
        );') 
        db.execute('CREATE TABLE "comment" (
            "id"	INTEGER,
            "user_id"	INTEGER,
            "game_id"	INTEGER,
            "com_text"	TEXT,
            PRIMARY KEY("id" AUTOINCREMENT));'
        );
        db.execute('CREATE TABLE "users" (
            "id"	INTEGER UNIQUE,
            "username"	TEXT UNIQUE,
            "password"	TEXT,
            PRIMARY KEY("id" AUTOINCREMENT));'
        );
    end
    
    def self.seed_data
        games = CSV.readlines("db/game.csv", headers: true)
        games.each do |game|
            db.execute("INSERT INTO game (id, genre_id, game_name) VALUES (?,?,?)" game['id'], game['genre_id'], game['game_name'])
        end
        genre = CSV.readlines("db/genre.csv", headers: true)
        genre.each do |genre|
            db.execute("INSERT INTO genre (id, genre_name) VALUES (?,?)" genre['id'], genre['genre_name'])
        end
        comment = CSV.readlines("db/comment.csv", headers: true)
        comment.each do |com|
            db.execute("INSERT INTO comment (id, user_id, game_id, com_text) VALUES (?,?,?,?)" com['id'], com['user_id'], com['game_id'], com['com_text'])
        end
        user = CSV.readlines("db/user.csv", headers: true)
        user.each do |user|
            db.execute("INSERT INTO user (id, username, password) VALUES (?,?,?)" game['id'], game['username'], game['password'])
        end
        puts "  * Seeding tables"
    end
end

Seeder.seed!