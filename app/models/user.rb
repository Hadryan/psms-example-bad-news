# A stub for User. Has 'name' and 'id'
class User
  ALL = [
    OpenStruct.new(id: 123, name: 'Alice'),
    OpenStruct.new(id: 456, name: 'Bob')
  ]

  def self.all
    ALL
  end

  def self.find(id)
    ALL.select { |u| i.id == id }
  end
end
