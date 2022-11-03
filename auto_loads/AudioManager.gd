extends Node

enum sound_type{
	hero_attack,
	dash
}
# Plays a sound.
func play(file_name: String, volume_db: float = 1.0, pitch_scale: float = 1.0) -> void:
	var audio = load("res://audio/" + file_name)
	play_audio(audio, volume_db, pitch_scale)

func play_type(type: int, volume_db: float = 1.0, pitch_scale: float = 1.0) -> void:
	var audio
	match(type):
		sound_type.hero_attack:
			audio = pick_from([
				"sword_hit_1.wav",
				"sword_hit_2.wav",
				"sword_hit_3.wav"
			])
		
		sound_type.dash:
			audio = pick_from([
				"dash_1.wav",
				"dash_2.wav",
			])
	
	play_audio(audio, volume_db, pitch_scale)

func play_audio(audio, volume_db, pitch_scale) -> void:
	var audio_stream_player = AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.bus = "Effects"
	audio_stream_player.stream = audio
	audio_stream_player.volume_db = volume_db
	audio_stream_player.pitch_scale = pitch_scale
	audio_stream_player.play()
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")

func pick_from(sounds: Array) -> AudioStream:
	randomize()
	sounds.shuffle()
	return load("res://audio/" + sounds.front()) as AudioStream
	
