require 'pstore'

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