class AddAdminUser < ActiveRecord::Migration
  def self.up
    @user = User.create({:login=>"admin",:email => "din.chick@gmail.com", :password => "admin", :password_confirmation=> "admin" })
  end

  def self.down
   User.destroy_all(:login=>"admin")
  end
end
