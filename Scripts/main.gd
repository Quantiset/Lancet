extends Node2D

@onready var code_edit: CodeEdit = get_node("%CodeEdit")
@onready var init_text: String = code_edit.text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func process_cmd(cmd: String, args := []):
	match cmd:
		'clear':
			code_edit.clear()
			code_edit.insert_text_at_caret(init_text)
		'ls':
			code_edit.insert_text_at_caret("execute.sh - 12mb\n")
		_:
			code_edit.insert_text_at_caret(cmd + ": command not found\n")

func _on_code_edit_text_changed() -> void:
	if code_edit.text.ends_with("\n"):
		var cmds = code_edit.text.split("\n")
		if cmds.size() >= 2:
			var line = cmds[cmds.size()-2].trim_prefix("> ").split(" ")
			process_cmd(line[0], line.slice(1))
		code_edit.insert_text_at_caret("> ")

 
