class Visit
  include DataMapper::Resource
  
  belongs_to :link
  belongs_to :doc 

  property :id, Serial, :protected => true
  property :ip_address, String
  property :created_at, DateTime

end
