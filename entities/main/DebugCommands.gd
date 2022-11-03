extends Node

func _ready():
	# Registering command
	# 1. argument is command name
	# 2. arg. is target (target could be a funcref)
	# 3. arg. is target name (name is not required if it is the same as first arg or target is a funcref)
	Console.add_command('give_artifact', self, 'give_artifact')\
		.set_description('Gets a list of all artifact names')\
		.add_argument('name', TYPE_STRING)\
		.register()
	
	Console.add_command('get_all_artifacts', self, 'get_all_artifacts')\
		.set_description('Gives user a specific artifact by name')\
		.register()
	
	Console.add_command('win_fight', self, 'win_fight')\
		.set_description('wins the current fight')\
		.register()

# Function that will be called by our command
func give_artifact(name = ''):
	for a in GlobalVariables.all_artifacts:
		if a.name == name:
			GlobalVariables.add_artifact(a)
			Console.write_line('artifact was added')
			return
	Console.write_line('artifact ' + name + ' not found!')

func get_all_artifacts():
	for a in GlobalVariables.all_artifacts:
		Console.write_line(a.name)

func win_fight():
	EventBus.emit_signal("fight_won")
	EventBus.emit_signal("load_map", GlobalVariables.map_types.choose)
	GlobalVariables.current_round = 1
	GlobalVariables.current_fight += 1
