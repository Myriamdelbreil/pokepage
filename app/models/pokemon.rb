class Pokemon
  attr_reader   :height,
                :is_default,
                :weight,
                :moves,
                :types,
                :name

  def set_attributes_from_url(query)
    @url = ::ApplicationHelper::URL + "/pokemon/#{query}"
    self.class.const_set(:ATTRIBUTES, ::ApiConsumer.new(@url).call || {})
  end

  def initialize(query)
    set_attributes_from_url(query)
    # we pass a query instead of name bc you can create one with its id
    @name = ATTRIBUTES["name"]
    @height = ATTRIBUTES["height"]
    @is_default = ATTRIBUTES["is_default"]
    @weight = ATTRIBUTES["weight"]
    @types = build_types
    @moves = find_moves
  end

  def build_types
    return {} unless ATTRIBUTES["types"]

    ATTRIBUTES["types"].map { |type| type["type"]["name"] }.map { |name| ::Type.new(name) }
  end

  def find_moves
    return {} unless ATTRIBUTES["moves"]

    ATTRIBUTES["moves"].map { |data| data.dig("move", "name") }
  end
end
