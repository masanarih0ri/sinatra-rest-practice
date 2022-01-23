# frozen_string_literal: true

require 'pstore'

class Memos
  STORAGE_FILE = './tmp/storage'
  private_constant :STORAGE_FILE

  def self.all
    store = PStore.new(STORAGE_FILE)
    store.transaction do
      memos = store['memos'] || {}
      memos.values
    end
  end

  def self.find(id)
    store = PStore.new(STORAGE_FILE)
    store.transaction do
      memos = store['memos'] || {}
      memos[id]
    end
  end

  def self.add(memo)
    store = PStore.new(STORAGE_FILE)
    store.transaction do
      memos = store['memos'] || {}
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
