extends Node2D

@onready var code_edit: CodeEdit = get_node("%CodeEdit")
@onready var init_text: String = code_edit.text

var player_name: String

# if code is currently executing a command. used to stop parsing of text entry
var inside_cmd := true

# controls which side control is on. [TAB] switches
var text_has_control := true 

var game_ended := false

var interactables := []

func _input(input: InputEvent) -> void:
	if game_ended:
		get_viewport().set_input_as_handled()
	
	if Input.is_action_just_pressed("swap_control"):
		get_viewport().set_input_as_handled()
		swap()
	
	if input is InputEventKey and input.keycode == KEY_BACKSPACE:
		if code_edit.get_caret_column() == code_edit.get_line(code_edit.get_caret_line()).length() \
		and code_edit.get_caret_line() == code_edit.get_line_count() - 1 and \
		code_edit.get_caret_column() > 2:
			pass
		else:
			get_viewport().set_input_as_handled()
	
	set_caret_last()

func _ready() -> void:
	swap(); swap()
	
	code_edit.grab_focus()
	set_caret_last()
	code_edit.clear()
	
	$SubViewport.size = Vector2i(700, get_window().size.y)
	
	await get_tree().create_timer(1.5).timeout
	for line in init_text.split("\n"):
		await get_tree().create_timer(0.5 + randf() * 0.2).timeout
		display(line)
	code_edit.text = code_edit.text.trim_suffix("\n")
	set_caret_last()
	await get_tree().create_timer(0.1).timeout
	inside_cmd = false
	
	get_node("SubViewport/Bunker/Player").connect("interactable_entered_fov", _interactable_entered_fov)
	get_node("SubViewport/Bunker/Player").connect("interactable_exited_fov", _interactable_exited_fov)
	

func process_cmd(cmd: String, args := []):
	await get_tree().create_timer(0.15).timeout
	inside_cmd = true
	match cmd:
		'login':
			if args.size() != 1:
				display("invalid arguments. Use: login [name]")
				return
			player_name = args[0]
			display("Logging in...")
			await get_tree().create_timer(1.0).timeout
			display("ACCESS GRANTED")
			await get_tree().create_timer(0.1).timeout
			display("Welcome "+player_name)
			await get_tree().create_timer(0.1).timeout
			display("________________")
			$Screen/HBoxContainer/Viewport.show()
			display("TWO [2] TARGETS NEED NEUTRALIZATION")
			display("XA-12 'Viper' AND 12-[REDACTED]")
			display("Awaiting further input...")
			await get_tree().create_timer(0.1).timeout
			display("Use [TAB] on your keyboard to swap monitors")
			display("Use [W/A/S/D] to move and [Q/E] to turn")
			display("Available commands:")
			display("scan, shock")
		'clear':
			code_edit.clear()
		'ls':
			display("execute.sh - 12mb")
		'swap':
			swap()
		'scan':
			print(interactables)
			var tmp_interactables = []
			for interactable_obj in interactables:
				var interactable = interactable_obj.interactable_name
				if interactable in InteractableDialogue.dialogue and not \
				interactable in tmp_interactables:
					tmp_interactables.append(interactable)
					for line in InteractableDialogue.dialogue[interactable]:
						display(line)
						await get_tree().create_timer(0.12).timeout
		'shock':
			for interactable in interactables:
				if interactable.interactable_name == "MainLever":
					$SubViewport/Bunker/StaticBodies/GlassToHallway/ToHallwayPlayer.play("Move")
				elif interactable.interactable_name == "Computers":
					$SubViewport/Bunker/CanvasLayer/Interactables/Screens/Screens.show()
					interactable.interactable_name = "ComputersOn"
				elif interactable.interactable_name == "Generator":
					$SubViewport/Bunker/Interactables/DoorToSelf.queue_free()
					$SubViewport/Bunker/StaticBodies/Glass.queue_free()
					$SubViewport/Bunker/CanvasLayer/Interactables/Generator.queue_free()
					interactable.interactable_name = "DeadGenerator"
					$Screen/HBoxContainer/Viewport/TextureRect.material.set_shader_parameter("turn_red", true)
				elif interactable.interactable_name == "Us":
					$Overlay/Blood.show()
					game_ended = true
				
		_:
			display(cmd + ": command not found")

func _on_code_edit_text_changed() -> void:
	if inside_cmd:
		return
	if code_edit.text.ends_with("\n"):
		var cmds = code_edit.text.split("\n")
		if cmds.size() >= 2:
			var line = cmds[cmds.size()-2].trim_prefix("> ").split(" ")
			await process_cmd(line[0], line.slice(1))
			inside_cmd = false
		code_edit.insert_text_at_caret("> ")
	if code_edit.get_line_count() > 30:
		code_edit.remove_line_at(0)


func swap():
	text_has_control = not text_has_control
	if text_has_control:
		$SubViewport/Bunker.focused = false
		code_edit.editable = true
		$Screen/HBoxContainer/VBoxContainer2/ColorRect.modulate.a = 1.0
		$Screen/HBoxContainer/Viewport/ColorRect.modulate.a = 0.0
		$Screen/HBoxContainer/Viewport/TextureRect.material.set_shader_parameter("enabled", true)
	else:
		$SubViewport/Bunker.focused = true
		code_edit.editable = false
		$Screen/HBoxContainer/VBoxContainer2/ColorRect.modulate.a = 0.0
		$Screen/HBoxContainer/Viewport/ColorRect.modulate.a = 1.0
		$Screen/HBoxContainer/Viewport/TextureRect.material.set_shader_parameter("enabled", false)

func set_caret_last():
	var last_line = code_edit.get_line_count() - 1
	var last_col  = code_edit.get_line(last_line).length()
	code_edit.set_caret_line(last_line)
	code_edit.set_caret_column(last_col)

func display(text: String):
	code_edit.insert_text_at_caret(text+"\n")

func _interactable_entered_fov(int_name: String, interactable: Node2D):
	interactables.append(interactable)

func _interactable_exited_fov(int_name: String, interactable: Node2D):
	if interactable in interactables:
		interactables.erase(interactable)
