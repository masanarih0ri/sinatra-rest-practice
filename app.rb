require 'sinatra'
require 'sinatra/reloader'
require 'pstore'
require 'time'

class Memos
  def set_storage(storage)
    @@storage = storage
  end

  def all
    store = PStore.new(@@storage)
    store.transaction do
      store['memos'] || {}
    end
  end

  def find(id)
    store = PStore.new(@@storage)
    store.transaction do
      memos = store['memos'] || {}
      memos.select{|k,v| k == id}
    end
  end

  def add(memo)
    store = PStore.new(@@storage)
    store.transaction do
      memos = store['memos']
      memos = {} if memos.nil?
      memos[memo.id] = memo
      store['memos'] = memos
    end
  end

  def delete(id)
    store = PStore.new(@@storage)
    store.transaction do
      store['memos'].delete(id)
    end
  end
end

class Memo
  attr_accessor :id, :title, :body

  def initialize(title, body, time = Time.now)
    @id = Digest::MD5.hexdigest(title + body + time.to_s)
    @title = title
    @body = body
  end

  def create(title, body)
    new(title, body)
  end

  def update(title, body)
    @title = title
    @body = body
    self
  end
end

configure do
  set :root, Dir.pwd
  set :storage, Dir.pwd + '/tmp/storage.json'
end

get '/' do
  redirect to ('/memos')
end

get '/memos' do
  @memos = Memos.all.values
  slim :index
end

get '/memos/new' do
  slim :new
end

post '/memos' do
  @memo = Memo.create(params[:title], params[:body])
  Memos.add(@memo)
  redirect to('/')
end

get '/memos/:id' do
  @memo = Memos.find(params['id']).values.first
  slim :show
end

get '/memos/:id/edit' do
  @memo = Memos.find(params['id']).values.first
  slim :edit
end

patch '/memos/:id' do
  @memo = Memos.find(params['id']).values.first
  @memo.update(params[:title], params[:body])
  Memos.add(@memo)
  redirect to("/memos/#{@memo.id}")
end

delete '/memos/:id' do
  Memos.delete(params[:id])
  redirect to('/')
end

not_found do
  slim :not_found
end