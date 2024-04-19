class Type
  attr_reader   :name,
                :damage_to,
                :damage_from,
                :moves

  def set_attributes_from_url(query)
    @url = ::ApplicationHelper::URL + "/type/#{query}"
    self.class.const_set(:ATTRIBUTES, ::ApiConsumer.new(@url).call || {})
  end

  def initialize(query)
    set_attributes_from_url(query)

    @name = ATTRIBUTES["name"]
    @damage_to = find_damaged_to(ATTRIBUTES["damage_relations"])
    @damage_from = find_damaged_from(ATTRIBUTES["damage_relations"])
    @moves = find_moves
  end

  def find_damaged_to(damage_relations)
    damaged_types = ATTRIBUTES["damage_relations"].select { |relation| relation.in?(["double_damage_to", "half_damage_to", "no_damage_to"])}
    names_of_damage_types(damaged_types)
  end

  def find_damaged_from(damaged_relations)
    damaged_types = ATTRIBUTES["damage_relations"].select { |relation| relation.in?(["double_damage_from", "half_damage_from", "no_damage_from"])}
    names_of_damage_types(damaged_types)
  end

  def names_of_damage_types(damage_types)
    damage_types.transform_values { |type| type.pluck("name") }
  end

  def find_moves
    ATTRIBUTES["moves"].pluck("name")
  end
end
