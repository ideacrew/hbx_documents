require 'mongoid-shell'

module Mongodb
  class MongodbBackup
    def self.run(options = {})
      mongodump = Mongoid::Shell::Commands::Mongodump.new(options)
      system mongodump.to_s
    end
  end
end

#Mongodb::MongodbBackup.run()