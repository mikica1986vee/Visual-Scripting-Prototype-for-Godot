tool
extends EditorPlugin

const EFFECTS_PATH = "Effects"
const CONDITIONS_PATH = "Conditions"
const ACTIONS_PATH = "Actions"
const NODES_PATH = "Nodes"

const filter_out = ["BaseEffect", "BaseAnimationEffect", "BaseCondition", "BaseAction", "ConditionalAction"]

const Action = preload("Actions/Action.gd")
const Prop = preload("Nodes/Prop.gd")

var custom_types = []

var predefined_types = [
	["Prop", "Area2D", Prop, null]
]

func get_name(): 
	return "Visual Scripting Prototype"

func _init():
	pass
 
func _enter_tree():
	custom_types.clear()
	
	for e in _load_effects():
		if not e[0] in filter_out:
			custom_types.append(e)
			
	print("list of loaded scripts:")
	
	for ct in custom_types:
		print(ct)
	
	_add_custom_types(predefined_types)
	_add_custom_types(custom_types)
	
func _exit_tree():
	print("VisualScripting _exit_tree")
	_remove_custom_types(predefined_types)
	_remove_custom_types(custom_types)
	
func _load_effects():
	print("started loading effects")
	
	var list = []
	list = _do_load_from_path(list, ACTIONS_PATH, "Node")
	list = _do_load_from_path(list, CONDITIONS_PATH, "Node")
	list = _do_load_from_path(list, EFFECTS_PATH, "Node")
	
	print("finished loading effects")
	
	return list
	
func _do_load_from_path(list, relative_path, base_type):
	print ("loading from " + relative_path)
	var dir = Directory.new()
	dir.open(_get_base_plugin_path() + '/' + relative_path)
	return _load_scripts_r(dir, list, base_type)
	
func _load_scripts_from_custom_path(path, list, base_type_name): #not used
	if path == null or path == "" or path == 'res://':
		return list
		
	var dir = Directory.new()
	if dir.dir_exists(path):
		dir.open(path)
		_load_scripts_r(dir, list, base_type_name)
	
	return list
	
func _load_scripts_r(dir, list, base_type_name):
	dir.list_dir_begin()
	
	while true:
		var next = dir.get_next()
		
		if next == "":
			break;
			
		if dir.current_is_dir():
			var new_dir = Directory.new()
			
			if not _is_next_valid(next):
				continue
				
			new_dir.open(dir.get_current_dir() + '/' + next)
			_load_scripts_r(new_dir, list, base_type_name)
		else:
			if not _is_next_valid(next):
				continue
				
			var extension_index = next.find_last('.gd')
			if extension_index > 0:
				var name = next.substr(0, extension_index) #extension_index == length - 3
				var icon = null
				if dir.file_exists(name + '.png'):
					pass #icon = name + '.png' #need to load as Texture
					
				var localized_path = _localize_path( dir.get_current_dir())
				var proj_path = _get_global_res_path()
				list.append([name, base_type_name, load(localized_path + '/' + next), icon])
			pass
	
	return list
	
func _get_base_plugin_path():
	var path = get_script().get_path()
	var last_separator = path.find_last('/')
	return path.substr(0, last_separator)
	
func _localize_path(path): 
	if path.begins_with("res://"):
		return path
		
	var proj_path = _get_global_res_path()
	var pos = path.find(proj_path)
	if pos < 0:
		print("can't localize path! " + path)
		return path
	
	return "res://" + path.right(proj_path.length())
	
func _is_next_valid(next):
	return next.length() > 0 and next != "." and next != ".." and next[0] != '.'
	
func _add_custom_types(custom_types):
	for type in custom_types:
		add_custom_type(type[0], type[1], type[2], type[3])
	#add_custom_type("Action", "Node", Action, null)
	#add_custom_type("BaseEffect", "Node", BaseEffect, null)
	#add_custom_type("DebugEffect", "Node", DebugEffect, null)
	
func _remove_custom_types(custom_types):
	for t in custom_types:
		remove_custom_type(t[0])
		
func _get_global_res_path():
	return ProjectSettings.globalize_path("res://")