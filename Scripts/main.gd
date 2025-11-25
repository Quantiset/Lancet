extends Node2D

@onready var code_edit: CodeEdit = get_node("%CodeEdit")
@onready var init_text: String = code_edit.text

var player_name: String

var inside_cmd := false
var text_has_control := true

func _input(input: InputEvent) -> void:
	if Input.is_action_just_pressed("swap_control"):
		text_has_control = not text_has_control
		get_viewport().set_input_as_handled()
	
	if text_has_control:
		$SubViewport/Bunker.focused = false
		code_edit.editable = true
		$Screen/HBoxContainer/VBoxContainer2/ColorRect.modulate.a = 1.0
		$Screen/HBoxContainer/Viewport/ColorRect.modulate.a = 0.0
	else:
		$SubViewport/Bunker.focused = true
		code_edit.editable = false
		$Screen/HBoxContainer/VBoxContainer2/ColorRect.modulate.a = 0.0
		$Screen/HBoxContainer/Viewport/ColorRect.modulate.a = 1.0
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SubViewport.size = Vector2i(800, get_window().size.y)
	#$Screen/HBoxContainer/TextureRect.texture = $SubViewport.get_texture()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func process_cmd(cmd: String, args := []):
	inside_cmd = true
	match cmd:
		'login':
			if args.size() != 1:
				display("invalid arguments. Use: login [name]")
				return
			player_name = args[0]
			display("logging in...")
			await get_tree().create_timer(1.0).timeout
			display("access granted")
			await get_tree().create_timer(0.1).timeout
			display("welcome "+player_name)
			$Screen/HBoxContainer/Viewport.show()
			display("use [TAB] on your keyboard to swap focuses")
		'clear':
			code_edit.clear()
			code_edit.insert_text_at_caret(init_text.trim_suffix("> "))
		'ls':
			code_edit.insert_text_at_caret("execute.sh - 12mb\n")
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

func display(text: String):
	code_edit.insert_text_at_caret(text+"\n")
