require 'sinatra'
require 'sinatra/reloader'
require 'pstore'
require 'time'

class Memos
  def self.set_storage(storage)
    @@storage = storage
  end

  def self.all
    store = PStore.new(@@storage)
    store.transaction do
      store['memos'] || {}
    end
  end

  def self.find(id)
    store = PStore.new(@@storage)
    store.transaction do
      memos = store['memos'] || {}
      memos.select{|k,v| k == id}
    end
  end

  def self.add(memo)
    store = PStore.new(@@storage)
    store.transaction do
      memos = store['memos']
      memos = {} if memos.nil?
      memos[memo.id] = memo
      store['memos'] = memos
    end
  end
end

class Memo
  attr_accessor :id, :title, :body

  def self.create(title, body)
    new(title, body)
  end

  def initialize(title, body, time = Time.now)
    @id = Digest::MD5.hexdigest(title + body + time.to_s)
    @title = title
    @body = body
  end
end

configure do
  set :root, Dir.pwd
  set :storage, Dir.pwd + '/tmp/storage'
end

get '/' do
  Memos.set_storage(settings.storage)
  @memos = Memos.all.values
  slim :index
end

get '/new' do
  slim :new
end

post '/memos' do
  @memo = Memo.create(params[:title], params[:body])
  Memos.add(@memo)
  redirect to('/')
end
