# frozen_string_literal: true

require 'pstore'

class Memos
  STORAGE_FILE = './tmp/storage'

  def self.all
    store = PStore.new(STORAGE_FILE)
    store.transaction do
      store['memos'] || {}
    end
  end

  def self.find(id)
    store = PStore.new(STORAGE_FILE)
    store.transaction do
      memos = store['memos'] || {}
      memos.select { |k| k == id }
    end
  end

  def self.add(memo)
    store = PStore.new(STORAGE_FILE)
    store.transaction do
      memos = store['memos']
      memos = {} if memos.nil?
      memos[memo.id] = memo
      store['memos'] = memos
    end
  end

  def self.delete(id)
    store = PStore.new(STORAGE_FILE)
    store.transaction do
      store['memos'].delete(id)
    end
  end
end
