class Pokemon
  attr_reader   :height,
                :is_default,
                :weight,
                :moves,
                :types,
                :name,
                :attributes,
                :id

  def initialize(query)
    # we pass a query instead of name bc you can create one with its id

    @attributes = ::ApiConsumer.new("/pokemon/#{query}").call || {}
    @id = attributes["id"]
    @name = attributes["name"]
    @height = attributes["height"]
    @is_default = attributes["is_default"]
    @weight = attributes["weight"]
    @types = build_types
    @moves = find_moves
  end

  def build_types
    return {} unless attributes["types"]

    attributes["types"].map { |type| type["type"]["name"] }.map { |name| ::Type.new(name) }
  end

  def find_moves
    return {} unless attributes["moves"]

    attributes["moves"].map { |data| data.dig("move", "name") }
  end
end
