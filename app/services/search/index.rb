class Search::Index
  def initialize(db)
    @index = {}
    db.each_with_index do |item, id|
      parse(key: 'Name', item: item, id: id)
      parse(key: 'Type', item: item, id: id)
      parse(key: 'Designed by', item: item, id: id)
    end
  end

  def fetch
    @index
  end
end