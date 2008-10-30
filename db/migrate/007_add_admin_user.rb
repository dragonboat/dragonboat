class AddAdminUser < ActiveRecord::Migration
  def self.up
    @person = Person.create(:first_name=>"Admin", :last_name=>"BragonBoat")
    @user = User.create({:person_id=>@person,:login=>"admin",:email => "din.chick@gmail.com", :password => "admin", :password_confirmation=> "admin" })
  end

  def self.down
   User.destroy_all(:login=>"admin")
  end
end
