require 'time'

class Memo
  attr_accessor :id, :title, :body

  def initialize(title, body, time = Time.now)
    # idをユニークにするための処理
    @id = Digest::MD5.hexdigest(title + body + time.to_s)
    @title = title
    @body = body
  end

  def self.create(title, body)
    new(title, body)
  end

  def update(title, body)
    @title = title
    @body = body
    self
  end
end