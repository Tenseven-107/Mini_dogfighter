extends Node


var save_name = "user://Airthrashersave_game.save"


func save_game():
	var save_file = File.new()
	save_file.open(save_name, File.WRITE)
	var saved_nodes = get_tree().get_nodes_in_group("Saved")

	for node in saved_nodes:
		if node.filename.empty():
			break

		var node_details = node.get_save_stats()
		save_file.store_line(to_json(node_details))

	save_file.close()


func load_game():
	var save_file = File.new()
	if not save_file.file_exists(save_name):
		return

	var saved_nodes = get_tree().get_nodes_in_group("Saved")
	save_file.open(save_name, File.READ)
	for node in saved_nodes:
		var node_data = parse_json(save_file.get_line())
		if node.has_method("load_save_stats"):
			node.load_save_stats(node_data)


