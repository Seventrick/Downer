extends Node

@export var enode_data: EnodeData

@onready var next_level


#new
var indexer: Node = preload("res://enode/inverted_index.gd").new()



#create a dictionary to save with which holds each theme's array OR holds each level and once a level is used it is removed from each theme it has

#create a system that randomly picks between and loads said levels ~ ~ ~ It picks randomly but only based on one theme. could later be made more complex or make an enode_calc_advanced() later

#organize the code a little more

#make a function that sets all the levels and checks whether or not that process has been done before ~ ~ ~ it is made

#note for later: find a way to automate this process rather than putting in every level individually
"""
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	
	return files


OR
(i need to look into DirAccess)


DirAccess.get_files()

"""


#system that tracks player's main theme

#how to save individual level data?

#might have an issue with doing _ready() before loading data. Might be able to use the load funciton with the if no path: feature
func _ready() -> void:
	
	#new
	fill_index()
	
	
	
	#can be used to set the very first level OR could be a back-up in case the ENOde loses the current level somehow
	if enode_data.current_level == null or enode_data.current_level.is_empty():
		#can become the inaccessible level
		summon_level("quantum_room")
	else:
		
		#for loading level
		summon_level(enode_data.current_level)
		
		
		#these are for testing
		#next_level_name = "test_2"
		#summon_level()
		
		#update level with curent_level

#Adds the new level and removes the old one
func summon_level(next_level_name) -> void:
	
	#animation (Gopala had a cool blink animation idea)
	
	#adds new level
	next_level = load("res://enode/levels/" + next_level_name + ".tscn").instantiate()
	add_child(next_level)
	
	#changes player position to origin
	get_parent().get_node("Player").position = Vector3.ZERO
	
	
	#removes previous level and updates current_level
	if !enode_data.current_level.is_empty():
		get_child(0).queue_free()
	enode_data.current_level = next_level_name
	
	
	#send signal to set level's level_data to current level

#Picks a theme and calculates which level the player goes to next
func enode_calc(theme: String) -> void:
	
	#puts all levels with the chosen theme into an array
	var themed_levels = indexer.get_levels_by_theme(theme)
	
	#picks a random number based on the array size, rounds the number, and uses that number to pick the chosen level
	if themed_levels.size() != 0:
		var level = themed_levels[round(randf_range(0, themed_levels.size() - 1))]
		
		#summons level based on preciously chosen level
		summon_level(level)
	else:
		print("No levels found")

# Add levels to the index with their associated themes
func fill_index() -> void:
	indexer.add_to_index("test_intro", ["High School"])
	indexer.add_to_index("test_2", ["Family", "High School"])





#An animated transition between levels. This may be placed in summon_level() rather than put in its own function
func transition() -> void:
	pass















	"""
	ENODE IDEAS
	
	run enode_calc in summon_level. This will require changing 
	summon_level to have no arguments and be slightly finicky when picking a specific level
	
	run enode_calc THEN summon_level. This will allow summon level to stay the same and
	have individual levels put arguments into enode_calc. I like this option
	
	enode_calc can pull the level_data of each level and look for true tags OR level_data can
	be changed to strings that can be filled with themes OR can use groups
	
	strings might be difficult as one wrong letter messes with the entire function but also allows
	for less filler in level_data and might allow enode_calc to go through an array of tags rather
	than checking for every tag at once. 
	
	If an array of themes are used, a function can be ran similarly to how the next level is chosen (MAYBE)
	
	Array can be used as a reference, checking each individual level data for their tags, though
	this would be easier if the level_data was using booleans and searches too many levels
	
	How to limit search to certain levels? Handpicked, find a way to search by tag, 
	
	
	GPT
	
	# LevelPicker.gd (this could be a singleton or manager)

extends Node

# List of all levels. This could be dynamically populated at runtime.
var levels: Array = []

# Function to add levels (could be dynamically populated based on your game's scenes)
func add_level(level_scene: Node, level_data: LevelData):
	levels.append({"scene": level_scene, "data": level_data})

# Function to get a random level by theme
func get_random_level_by_theme(theme: String) -> Node:
	var filtered_levels = []

	# Filter the levels by the chosen theme
	for level in levels:
		if level["data"].theme == theme:
			filtered_levels.append(level)

	# If there are any levels with the specified theme, pick one randomly
	if filtered_levels.size() > 0:
		var random_index = randi() % filtered_levels.size()
		return filtered_levels[random_index]["scene"]
	
	# If no level was found with the theme, return null or a default value
	return null

	
	
	
	
	Inverse Index:
	
	struct WordInfo
 {
	 public int position;
	 public int fieldID;
 }

 Dictionary<string,List<WordInfo>> invertedIndex=new Dictionary<string,List<WordInfo>>();

	   public void BuildIndex()
	   {
			foreach (int  fieldID in GetDatabaseFieldIDS())
			{    
				string textField=GetDatabaseTextFieldForID(fieldID);

				string word;

				int position=0;

				while(GetNextWord(textField,out word,ref position)==true)
				{
					 WordInfo wi=new WordInfo();

					 if (invertedIndex.TryGetValue(word,out wi)==false)
					 {
						 invertedIndex.Add(word,new List<WordInfo>());
					 }

					 wi.Position=position;
					 wi.fieldID=fieldID;
					 invertedIndex[word].Add(wi);

				}

			}
		}
	
	
	
	
	Inverted index GPT edition
	
	# InvertedIndex.gd
extends Node

# The inverted index where each theme maps to a list of levels
var inverted_index: Dictionary = {}

# Function to add a level to the index under its themes
func add_to_index(level_id: String, themes: Array):
	for theme in themes:
		if not inverted_index.has(theme):
			inverted_index[theme] = []
		inverted_index[theme].merge(level_id)


# Main.gd or LevelManager.gd

extends Node

var indexer: Node = preload("res://InvertedIndex.gd").new()

func _ready():
	# Add levels to the index with their associated themes
	indexer.add_to_index("Level1", ["Family", "Friend"])
	indexer.add_to_index("Level2", ["High School"])
	indexer.add_to_index("Level3", ["Family", "High School"])

	# Search for levels with the "Family" theme
	var family_levels = get_levels_by_theme("Family")
	print("Family levels: ", family_levels)  # Output: ["Level1", "Level3"]
	
	# Search for levels with the "High School" theme
	var high_school_levels = get_levels_by_theme("High School")
	print("High School levels: ", high_school_levels)  # Output: ["Level2", "Level3"]



# Function to retrieve levels by theme
func get_levels_by_theme(theme: String) -> Array:
	if inverted_index.has(theme):
		return inverted_index[theme]
	return []  # Return an empty array if no levels match the theme



tests

var family_levels = get_levels_by_theme("Family")  # Returns ["Level1", "Level3"]
var friend_levels = get_levels_by_theme("Friend")  # Returns ["Level1"]
var high_school_levels = get_levels_by_theme("High School")  # Returns ["Level2", "Level3"]



removing levels

# Function to remove a level from the index
func remove_from_index(level_id: String, themes: Array):
	for theme in themes:
		if inverted_index.has(theme):
			inverted_index[theme].erase(level_id)
			if inverted_index[theme].empty():
				inverted_index.erase(theme)  # Optionally clean up empty themes

	
	
	"""
