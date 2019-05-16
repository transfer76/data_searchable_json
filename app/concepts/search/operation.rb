class Search < ActiveRecord::Base
  class Create < Trailblazer::Operation
    def process; end

    def query
        @query = params[:query]
        @results = Create.find(@query) unless @query.blank?
        respond_to do |f|
          f.html
          f.json { render json: @results }
        end
      end

      def resource
        @resource ||= Create Rails.root.join('db', 'data.json')
      end

    def initialize(db:)  #db - data.json
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

    # parse hash
    def parse(key:, item:, id:)
      fetch_names(item[key]).each do |name|
        @index[name] = @index.fetch(name, Set.new) << id
      end
    end

    # get string, split words and set downcase
    def fetch_names(str)
      [] unless str

      list = str.split(/\s*,\s*/).map(&:downcase)

      # make array string + single splitted words ["thomas eugene kurtz", "thomas", "eugene", "kurtz"]
      list += match_one_word(list) + make_word_levels(list)

      # left uniq item
      list.uniq
    end

    def match_one_word(list)
      list.map { |item| item.split(/\s+/) }.flatten
    end

    def make_word_levels(list)
      list.map { |item| item.split(/\s+/) }                   # split to single words
          .map { |item| make_words_combi([], item, 1) }# make words combination and join ' '
          .flatten                                            # flatten array
          .reject(&:nil?)                                     # reject nil values
    end

    def make_words_combi(set, list, i)
      return if list.count <= 1 || i >= list.count - 1

      set << list[0..i].join(' ')
      set << make_words_combi(set, list, i + 1)
      set.flatten
    end
  end
 end