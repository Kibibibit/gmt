extends Node


func load_file(file_path: String) -> Dictionary:
	var output: Dictionary = {}
	
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if (file == null):
		print("Could not open ", file_path)
		return {}
	if (file.eof_reached()):
		print(file_path, " is empty!")
		return {}
	
	var header_line = file.get_csv_line()
	
	var headers: Dictionary = {}
	
	for i in range(0, header_line.size()):
		headers[i] = header_line[i]
		output[headers[i]] = []
	
	while !file.eof_reached():
		var line: Array = file.get_csv_line()
		for i in range(0, line.size()):
			output[headers[i]].append(line[i])
			
	return output
