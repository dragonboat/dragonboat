class PrePopulateTentPositions < ActiveRecord::Migration
  def self.up
    1.upto(200) do |i|
      TentPosition.create(:number=>i, :status=>"available")
    end
  end

  def self.down
    TentPosition.delete_all
  end
end
