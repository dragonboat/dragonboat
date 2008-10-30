class AddRolesUserAdmin < ActiveRecord::Migration
  def self.up
    @user = User.find_by_login("admin")
    @user.roles << Role.find_by_name("admin")
  end

  def self.down
    @user = User.find_by_login("admin")
    @role = Role.find_by_name("admin")
    @user.roles.delete(@role) 
  end
end
