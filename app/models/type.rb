class Type
  attr_reader   :name,
                :damage_to,
                :damage_from,
                :moves,
                :attributes

  def initialize(query)
    @attributes = ::ApiConsumer.new("/type/#{query}").call || {}
    @name = attributes["name"]
    @damage_to = find_damaged_to(attributes["damage_relations"])
    @damage_from = find_damaged_from(attributes["damage_relations"])
    @moves = find_moves
  end

  def find_damaged_to(damage_relations)
    return {} unless attributes["damage_relations"]
 
    damaged_types = attributes["damage_relations"].select { |relation| relation.in?(["double_damage_to", "half_damage_to", "no_damage_to"])}
    return {} unless damaged_types
 
    names_of_damage_types(damaged_types)
  end

  def find_damaged_from(damaged_relations)
    return {} unless attributes["damage_relations"]
 
    damaged_types = attributes["damage_relations"].select { |relation| relation.in?(["double_damage_from", "half_damage_from", "no_damage_from"])}
    return {} unless damaged_types

    names_of_damage_types(damaged_types)
  end

  def names_of_damage_types(damage_types)
    damage_types.transform_values { |type| type.pluck("name") }
  end

  def find_moves
    attributes["moves"].pluck("name")
  end
end
