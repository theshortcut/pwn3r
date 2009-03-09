class Link
  include DataMapper::Resource
  TOKEN_LENGTH = 4
  
  belongs_to :user
  has n, :visits

  property :id, Serial, :protected => true
  property :url, String
  property :token, String
  property :clicks, Integer
  property :created_at, DateTime

  validates_present :url
  
  before :create, :generate_token
  before :save, :sanitize_url

  private
  
  def generate_token
    self.token = random_token
  end

  def random_token
    characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890' 
    chars = "#{('a'..'z')}#{('A'..'Z')}#{('0'..'9')}"
    temp_token = ''
    srand
    TOKEN_LENGTH.times do
      pos = rand(chars.length)
      temp_token += chars[pos..pos]
    end
    temp_token
  end
  
  def sanitize_url
    # If the url already begins with "http://", just return.
    return if url =~ /^http[s]?:\/\/\w/
    self.url = 'http://' + url
  end
  
end
