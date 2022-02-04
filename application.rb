# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative 'classes/memo'
require_relative 'classes/memos'

before do
  @connect = PG.connect(dbname: 'memoapp')
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = Memos.all(@connect)
  slim :index
end

get '/memos/new' do
  slim :new
end

post '/memos' do
  @memo = Memo.create(params[:title], params[:body])
  Memos.add(@memo, @connect)
  redirect to('/')
end

get '/memos/:id' do
  @memo = Memos.find(params['id'], @connect)
  slim :show
end

get '/memos/:id/edit' do
  @memo = Memos.find(params['id'], @connect)
  slim :edit
end

patch '/memos/:id' do
  @memo = Memos.find(params['id'], @connect)
  @memo['title'] = params[:title]
  @memo['body'] = params[:body]
  Memos.update(@memo, @connect)
  redirect to("/memos/#{@memo['id']}")
end

delete '/memos/:id' do
  Memos.delete(params[:id], @connect)
  redirect to('/')
end

not_found do
  slim :not_found
end
