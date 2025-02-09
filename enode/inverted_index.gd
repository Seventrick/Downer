extends Node

# The inverted index where each theme maps to a list of levels
var inverted_index: Dictionary = {}

# Function to add a level to the index under its themes
func add_to_index(level_id: String, themes: Array):
	for theme in themes:
		if not inverted_index.has(theme):
			inverted_index[theme] = []
		inverted_index[theme].append(level_id)

func get_levels_by_theme(theme: String) -> Array:
	if inverted_index.has(theme):
		return inverted_index[theme]
	return []  #Returns an empty array if no levels match the theme

# Function to remove a level from the index
func remove_from_index(level_id: String, themes: Array):
	for theme in themes:
		if inverted_index.has(theme):
			inverted_index[theme].erase(level_id)
			 #Cleans up empty themes
			if inverted_index[theme].empty():
				inverted_index.erase(theme)
