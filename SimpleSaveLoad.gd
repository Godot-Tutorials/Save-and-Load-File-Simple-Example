extends Node2D

# Dictionary
var saveData = {
	"playerName" : "John Snow",
	"location" : "The North"
}

# path string
var saveGameFileName: String = "user://playerData.txt"


func _ready() -> void:
	print("Original Data: ", saveData)
	self.loadData()
	print("Altered Data: ", saveData)


func editData() -> void:
	saveData.playerName = "Godot"
	saveData.location = "Tron City"


func saveData() -> void:
	self.editData()
	
	var saveFile = File.new()
	saveFile.open(saveGameFileName, File.WRITE)

	# bread and butter
	saveFile.store_line(to_json(saveData))
	saveFile.close()


func loadData() -> void:
	var dataFile = File.new()
	
	# make sure our file exists on users system
	if not dataFile.file_exists(saveGameFileName):
		return # File does not exist
	
	# allow reading only for file
	dataFile.open(saveGameFileName, File.READ)
	
	# loop through file line by line
	while dataFile.get_position() < dataFile.get_len():
		var nodeData = parse_json(dataFile.get_line())
		
		# grab save data
		saveData.playerName = nodeData["playerName"]
		saveData.location = nodeData["location"]
	dataFile.close()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		self.saveData()
		get_tree().quit() # quitting the game
