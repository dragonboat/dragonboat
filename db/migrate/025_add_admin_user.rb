class AddAdminUser < ActiveRecord::Migration
  def self.up
    @user = User.new({:login=>"admin", :password => "admin", :password_confirmation=> "admin" })
    @user.person = Person.create({:first_name=>"Admin", :last_name=>"BragonBoat",:email => "admin@phillydragonboat.info"})
    @user.valid?
    @user.save!
  end

  def self.down
   User.destroy_all(:login=>"admin")
  end
end
