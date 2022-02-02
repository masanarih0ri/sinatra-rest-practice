# frozen_string_literal: true

require 'pstore'
require 'pg'

class Memos
  STORAGE_FILE = './tmp/storage'
  TABLE_NAME = 'memo'

  private_constant :STORAGE_FILE
  private_constant :TABLE_NAME

  def self.all
    connection = PG.connect(dbname: 'memoapp')
    @memos = []
    query = "SELECT * FROM #{TABLE_NAME}"
    connection.prepare('all', query)
    results = connection.exec_prepared('all')
    results.map { |result| @memos << result }
    @memos.sort {|a, b| a['created_at'] <=> b['created_at'] }
	end

  def self.find(id)
    memo = []
    connection = PG.connect(dbname: 'memoapp')
    query = "SELECT * FROM #{TABLE_NAME} WHERE id = '#{id}'"
    connection.prepare('find', query)
    result = connection.exec_prepared('find')
    result.map { |x| memo << x }
    memo[0]
  end

  def self.add(memo)
    connection = PG.connect(dbname: 'memoapp')
    query = "INSERT INTO #{TABLE_NAME} (id, title, body, created_at) VALUES ('#{memo.id}', '#{memo.title}', '#{memo.body}', '#{memo.created_at}')"
    connection.prepare('add', query)
	  connection.exec_prepared('add')
	end

  def self.update(memo)
    connection = PG.connect(dbname: 'memoapp')
    query = "UPDATE #{TABLE_NAME} SET title = '#{memo['title']}', body = '#{memo['body']}' WHERE id = '#{memo['id']}'"
    connection.prepare('update', query)
	  connection.exec_prepared('update')
	end

  def self.delete(id)
    connection = PG.connect(dbname: 'memoapp')
    query = "DELETE FROM #{TABLE_NAME} WHERE id = '#{id}'"
    connection.prepare('delete', query)
    connection.exec_prepared('delete')
  end
end
