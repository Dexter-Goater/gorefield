extends AudioStreamPlayer
@export_dir var sound_folder: String = "res://Audio/3D/Background/"
@export var min_delay: float = 0.0  
@export var max_delay: float = 0.0   
@export var autostart: bool = true

var _clips: Array[AudioStream] = []
var _last_index: int = -1

func _ready() -> void:
	_load_clips()
	finished.connect(_on_finished)
	if autostart and not _clips.is_empty():
		_play_random()

func _load_clips() -> void:
	_clips.clear()
	var dir := DirAccess.open(sound_folder)

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			var ext := file_name.get_extension().to_lower()
			if ext in ["wav", "ogg", "mp3"]:
				var path := sound_folder.path_join(file_name)
				var stream := load(path) as AudioStream
				if stream != null:
					_clips.append(stream)
		file_name = dir.get_next()
	dir.list_dir_end()


func _play_random() -> void:
	if _clips.is_empty():
		return

	var index := _pick_index_no_repeat()
	stream = _clips[index]
	_last_index = index
	play()

func _pick_index_no_repeat() -> int:
	if _clips.size() == 1:
		return 0
	var index := randi() % _clips.size()
	while index == _last_index:
		index = randi() % _clips.size()
	return index

func _on_finished() -> void:
	if max_delay > 0.0:
		var delay := randf_range(min_delay, max_delay)
		await get_tree().create_timer(delay).timeout
	_play_random()
