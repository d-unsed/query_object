module QueryObject
  class QueryObject
    attr_reader :query

    def initialize(query = nil, &block)
      @query = block_given? ? block : -> { query }
    end
  end
end
