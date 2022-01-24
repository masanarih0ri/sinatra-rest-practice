# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative 'classes/memo'
require_relative 'classes/memos'

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = Memos.all
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
  @memo = Memos.find(params['id'])
  slim :show
end

get '/memos/:id/edit' do
  @memo = Memos.find(params['id'])
  slim :edit
end

patch '/memos/:id' do
  @memo = Memos.find(params['id'])
  @memo['title'] = params[:title]
  @memo['body'] = params[:body]
  Memos.update(@memo)
  redirect to("/memos/#{@memo['id']}")
end

delete '/memos/:id' do
  Memos.delete(params[:id])
  redirect to('/')
end

not_found do
  slim :not_found
end
