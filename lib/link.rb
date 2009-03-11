class Link
  include DataMapper::Resource
  TOKEN_LENGTH = 4
  
  belongs_to :user
  has n, :visits, :constraint => :destroy

  property :id, Serial, :protected => true
  property :url, String
  property :token, String
  property :clicks, Integer
  property :created_at, DateTime

  validates_present :url
  
  before :create, :generate_token
  before :save, :sanitize_url

  def add_visit(request)
    visit = visits.build(:ip_address => request.ip)
    visit.save
    return visit
  end
  private
  
  def generate_token
    self.token = random_token
  end

  def random_token
    chars = ('a'..'z').to_a+('A'..'Z').to_a+('0'..'9').to_a
    temp_token = ''
    srand
    TOKEN_LENGTH.times do
      pos = rand(chars.size-1)
      temp_token << chars[pos]
    end
    temp_token
  end
  
  def sanitize_url
    # If the url already begins with "http://", just return.
    return if url =~ /^http[s]?:\/\/\w/
    self.url = 'http://' + url
  end
  
end
