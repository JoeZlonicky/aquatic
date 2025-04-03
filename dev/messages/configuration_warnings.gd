class_name ConfigurationWarnings


static func any_properties_not_set(obj: Object, properties: Array[String]) -> PackedStringArray:
	var messages: PackedStringArray = []
	for p in properties:
		if obj.get(p):
			continue
		messages.append("'" + p.capitalize() + "' needs to be set.")
	return messages


static func at_least_one_property_set(obj: Object, properties: Array[String]) -> PackedStringArray:
	var messages: PackedStringArray = []
	var unset_properties: Array[String] = []
	for p in properties:
		if obj.get(p):
			return messages
		unset_properties.append(p.capitalize())
	
	messages.append("At least one needs to be set: " + ", ".join(unset_properties))
	return messages


static func any_components_not_set(components: Array[Node]) -> Array[String]:
	for c in components:
		if not c._get_configuration_warnings():
			continue
		
		return ["Components have configuration warnings. Is 'Editable Children' set?"]
	return []
