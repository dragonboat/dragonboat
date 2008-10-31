class AddAdminUser < ActiveRecord::Migration
  def self.up
    @user = User.new({:login=>"admin",:email => "din.chick@gmail.com", :password => "admin", :password_confirmation=> "admin" })
    @user.person.attributes = ({:first_name=>"Admin", :last_name=>"BragonBoat"})
    @user.valid?
    @user.save!
  end

  def self.down
   User.destroy_all(:login=>"admin")
  end
end
