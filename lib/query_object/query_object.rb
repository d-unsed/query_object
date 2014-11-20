module QueryObject
  class QueryObject
    attr_reader :query

    def initialize(query = nil, &block)
      @query = block_given? ? block : -> { query }
    end

    def relation
      query.call
    end

    def merge_with(query_object)
      merged_query = relation.merge(query_object.query)

      self.class.new { merged_query }
    end
  end
end
