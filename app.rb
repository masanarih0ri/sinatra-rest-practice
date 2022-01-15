# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pstore'
require 'time'

class Memos
  def self.all
    store = PStore.new('./tmp/storage.json')
    store.transaction do
      store['memos'] || {}
    end
  end

  def self.find(id)
    store = PStore.new('./tmp/storage.json')
    store.transaction do
      memos = store['memos'] || {}
      memos.select { |k| k == id }
    end
  end

  def self.add(memo)
    store = PStore.new('./tmp/storage.json')
    store.transaction do
      memos = store['memos']
      memos = {} if memos.nil?
      memos[memo.id] = memo
      store['memos'] = memos
    end
  end

  def self.delete(id)
    store = PStore.new('./tmp/storage.json')
    store.transaction do
      store['memos'].delete(id)
    end
  end
end

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

get '/' do
  redirect to('/memos')
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
