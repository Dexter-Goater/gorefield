extends Node

signal noise_emitted(position: Vector3, radius: float, loudness: float)

func emit_noise(position: Vector3, radius: float, loudness: float = 1.0) -> void:
	noise_emitted.emit(position, radius, loudness)
