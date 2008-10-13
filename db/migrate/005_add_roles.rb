class AddRoles < ActiveRecord::Migration
  def self.up
    Role.create(:name=>"admin")
    Role.create(:name=>"captain")
    Role.create(:name=>"standard")
  end

  def self.down
    Role.destroy_all(:name=>["admin","captain","standard"])
  end
end
