class Search::Resource
  include Search::Methods::Find
  include Search::Methods::Fetch

  def initializer(file)
    @resource = read_and_parce_json(file: file)
    @index = Search::Index.new(db: @resource).fetch
  end

  private

  def read_and_parse_json(file)
    JSON.parse File.read file
  end
end