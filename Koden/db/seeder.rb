require 'sqlite3'

class Seeder

    def self.seed!
        puts "Seeding the DB"
        drop_tables
        create_tables
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
            PRIMARY KEY("id" AUTOINCREMENT)'
        );
    end
    
    def self.seed_data
        puts "  * Seeding tables"
    end
end