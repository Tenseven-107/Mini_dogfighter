extends Node2D


onready var main = get_parent()
var point_net = null

var children
var children_value


func initialize(point_net_object):
	self.point_net = point_net_object


func _process(delta):
	children = get_child_count()
	if children != children_value:
		children_value = children

		var enemies = get_tree().get_nodes_in_group("Enemies")
		for enemy in enemies:
			enemy.initialize(main, point_net)
