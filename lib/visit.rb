class Visit
  include DataMapper::Resource
  
  belongs_to :link

  property :id, Serial, :protected => true
  property :ip_address, String
  property :created_at, DateTime

end
