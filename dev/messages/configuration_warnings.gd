class_name ConfigurationWarnings


static func missing_required_properties(node: Node) -> String:
	return node.owner.name + "/" + node.name + " missing required properties"
