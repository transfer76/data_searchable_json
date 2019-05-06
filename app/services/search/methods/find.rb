module Search::Methods::Find
  def find(query)
    @words, @antiwords = parse_query(query)
    found_ids = search(@words)
    anti_ids = search(@antiwords)
    found_ids -= anti_ids if anti_ids && found_ids
    fetch_resources(found_ids)
  end

  private

  def fetch_resources(ids)
    results = Set.new
    results unless ids
    ids.each { |id| results.add fetch(id) }
    results
  end

  def parse_query(query)
    words = query.strip
                 .downcase
                 .split(/\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/)
                 .map { |s| s.delete('"') }
    words, antiwords = extract_anti_words(words)
    [words, antiwords]
  end

  def extract_anti_words(words)
    antiwords, words = word.partition { |word| antiword?(word) }
    antiwords = antiwords.map { |s| s.delete('-') }
    [words, antiwords]
  end

  def antiword?(word)
    word =~ /\A\-+/
  end

  def search(words)
    results = Set.new
    words.each do |word|
      ids = @index[word]
      results.add(ids) if ids
    end

    results.reduce(&:&)
  end
end
