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
        @db = SQLite3::Database.new('db/Databas.sqlite')
        @db.results_as_hash = true
        return @db
    end

    def self.drop_tables
        puts "  * Dropping Tables"
        db.execute('DROP TABLE IF EXISTS bordett')
    end
    
    
    def self.create_tables
        puts "  * Creating tables"
        db.execute('CREATE TABLE "Bordett" (
            "id"	INTEGER UNIQUE,
            "Sak"	TEXT,
            PRIMARY KEY("id" AUTOINCREMENT)
        )') 
    end
    
    def self.seed_data
        puts "  * Seeding tables"
    end
end