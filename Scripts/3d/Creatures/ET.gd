extends AudioStreamPlayer3D

var voice_lines: Array[AudioStream] = []
var voice_line_timer: float = 0.0
var next_line_interval: float = 0.0

func _ready() -> void:
	_load_voice_lines()
	_reset_voice_line_timer()

func _process(delta: float) -> void:
	_handle_voice_line_timer(delta)

func _load_voice_lines() -> void:
	var FOLDER_PATH: String = "res://Audio/3D/Creatures/".path_join(name)
	var files: PackedStringArray = DirAccess.get_files_at(FOLDER_PATH)
	
	for file in files:
		var clean_file: String = file.trim_suffix(".import").trim_suffix(".remap")
		
		if clean_file.ends_with(".mp3") or clean_file.ends_with(".wav") or clean_file.ends_with(".ogg"):
			var file_path: String = FOLDER_PATH.path_join(clean_file)
			var stream_res = load(file_path) as AudioStream
			
			if stream_res and not voice_lines.has(stream_res):
				voice_lines.append(stream_res)
				
	if voice_lines.is_empty():
		push_warning("No valid audio files found in directory: " + FOLDER_PATH)

func _handle_voice_line_timer(delta: float) -> void:
	if voice_lines.is_empty():
		return
		
	voice_line_timer += delta
	if voice_line_timer >= next_line_interval:
		_play_random_voice_line()
		_reset_voice_line_timer()

func _reset_voice_line_timer() -> void:
	voice_line_timer = 0.0
	next_line_interval = randf_range(10.0, 20.0)

func _play_random_voice_line() -> void:
	if not voice_lines.is_empty():
		stream = voice_lines.pick_random()
		play()
