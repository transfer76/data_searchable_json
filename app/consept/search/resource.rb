class Search::Resource
  include Search::Methods::Find
  include Search::Methods::Fetch

  def initialize(file)
    @resource = read_and_parse_json(file: file)
    @index = Search::Index.new(db: @resource).fetch
  end

  private

  def read_and_parse_json(file:)
    JSON.parse File.read file
  end
end
