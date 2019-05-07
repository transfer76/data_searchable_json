class Search::Index
  def initialize(db:)
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

  private

  def parse(key:, item:, id:)
    fetch_names(item[key]).each do |name|
      @index[name] = @index.fetch(name, Set.new) << id
    end
  end

  def fetch_names(str)
    [] unless str

    list = str.split(/\s*,\s*/).map(&:downcase)
    list += match_one_word(list) + make_word_levels(list)
    list.uniq
  end

  def match_one_word(list)
    list.map { |item| item.split(/\s+/) }.flatten
  end

  def make_word_levels(list)
    list.map { |item| item.split(/\s+/) }
        .map { |item| make_words_combi([], item, 1) }
        .flatten
        .reject(&:nil?)
  end

  def make_words_combi(set, list, i)
    return if list.count <= 1 || i >= list.count - 1

    set << list[0..i].join(' ')
    set << make_words_combi(set, list, i + 1)
    set.flatten
  end
end
