# frozen_string_literal: true

require 'pstore'
require 'pg'

class Memos
  STORAGE_FILE = './tmp/storage'
  TABLE_NAME = 'memo'

  private_constant :STORAGE_FILE
  private_constant :TABLE_NAME

  def self.all(connection)
    connection.prepare('all', "SELECT * FROM #{TABLE_NAME} ORDER BY created_at")
    results = connection.exec_prepared('all')
    @memos = results.to_a
	end

  def self.find(id, connection)
    connection.prepare('find', "SELECT * FROM #{TABLE_NAME} WHERE id = $1")
    result = connection.exec_prepared('find', [id])
    memo = result.to_a
    memo[0]
  end

  def self.add(memo, connection)
    # connection = PG.connect(dbname: 'memoapp')
    connection.prepare('add', "INSERT INTO #{TABLE_NAME} (id, title, body, created_at) VALUES ($1, $2, $3, $4)")
	  connection.exec_prepared('add', ["#{memo.id}", "#{memo.title}", "#{memo.body}", "#{memo.created_at}"])
	end

  def self.update(memo, connection)
    # connection = PG.connect(dbname: 'memoapp')
    connection.prepare('update', "UPDATE #{TABLE_NAME} SET title = $1, body = $2 WHERE id = $3")
	  connection.exec_prepared('update', ["#{memo['title']}", "#{memo['body']}", "#{memo['id']}"])
	end

  def self.delete(id, connection)
    connection.prepare('delete', "DELETE FROM #{TABLE_NAME} WHERE id = $1")
    connection.exec_prepared('delete', [id])
  end
end
