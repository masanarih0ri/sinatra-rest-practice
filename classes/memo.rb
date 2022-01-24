# frozen_string_literal: true

require 'time'

class Memo
  attr_accessor :id, :title, :body, :created_at

  def initialize(title, body)
    # idをユニークにするための処理
    @id = Digest::MD5.hexdigest(title + body + Time.now.to_s)
    @title = title
    @body = body
    @created_at = Time.now
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
