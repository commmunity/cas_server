class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :service_tickets do |t|
      t.belongs_to  :ticket_granting_cookie
      t.string      :value, :null => false, :limit => 255
      t.string      :username, :null => false
      t.string      :service, :null => false, :limit => 255
      #t.string     :ipaddr, :null => false, :limit => 40
      t.datetime    :consumed_at, :null => true, :default => nil
      t.timestamps
    end
    
    create_table :login_tickets do |t|
      t.string      :value, :null => false, :limit => 255
      #t.string     :ipaddr, :null => false, :limit => 40
      t.datetime    :consumed_at, :null => true, :default => nil
      t.timestamps
    end
    
    create_table :ticket_granting_cookies do |t|
      t.string      :value, :null => false, :limit => 255
      t.string      :username, :null => false
      #t.string     :ipaddr, :null => false, :limit => 40
      t.datetime    :consumed_at, :null => true, :default => nil
      t.text        :extra_attributes, :null => true, :default => nil
      t.timestamps
    end
  end

  def self.down
  end
end
