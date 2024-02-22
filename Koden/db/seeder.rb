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
        db.execute('DROP TABLE IF EXISTS game_platform')
        db.execute('DROP TABLE IF EXISTS game_publisher')
        db.execute('DROP TABLE IF EXISTS genre')
        db.execute('DROP TABLE IF EXISTS platform')
        db.execute('DROP TABLE IF EXISTS publisher')
    end
    
    
    def self.create_tables
    puts "  * Creating tables"
        db.execute('CREATE TABLE "game" (
            "id"	INTEGER,
            "genre_id"	INTEGER,
            "game_name"	TEXT DEFAULT NULL,
            CONSTRAINT "fk_gm_gen" FOREIGN KEY("genre_id") REFERENCES "genre"("id"),
            PRIMARY KEY("id")
        );') 
        db.execute('CREATE TABLE "game_platform" (
            "id"	INTEGER,
            "game_publisher_id"	INTEGER DEFAULT NULL,
            "platform_id"	INTEGER DEFAULT NULL,
            "release_year"	INTEGER DEFAULT NULL,
            PRIMARY KEY("id"),
            CONSTRAINT "fk_gpl_pla" FOREIGN KEY("platform_id") REFERENCES "platform"("id"),
            CONSTRAINT "fk_gpl_gp" FOREIGN KEY("game_publisher_id") REFERENCES "game_publisher"("id")
        );') 
        db.execute('CREATE TABLE "game_publisher" (
            "id"	INTEGER,
            "game_id"	INTEGER DEFAULT NULL,
            "publisher_id"	INTEGER DEFAULT NULL,
            CONSTRAINT "fk_gpu_gam" FOREIGN KEY("game_id") REFERENCES "game"("id"),
            CONSTRAINT "fk_gpu_pub" FOREIGN KEY("publisher_id") REFERENCES "publisher"("id"),
            PRIMARY KEY("id")
        );') 
        db.execute('CREATE TABLE "genre" (
            "id"	INTEGER,
            "genre_name"	TEXT DEFAULT NULL,
            PRIMARY KEY("id")
        );') 
        db.execute('CREATE TABLE "platform" (
            "id"	INTEGER,
            "platform_name"	TEXT DEFAULT NULL,
            PRIMARY KEY("id")
        );') 
        db.execute('CREATE TABLE "publisher" (
            "id"	INTEGER,
            "publisher_name"	TEXT DEFAULT NULL,
            PRIMARY KEY("id")
        );') 
    end
    
    def self.seed_data
        puts "  * Seeding tables"
    end
end