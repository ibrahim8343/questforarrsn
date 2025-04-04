@tool
class_name DialogPortrait extends Sprite2D

var blink : bool = false : set = _set_blink
var open_mouth : bool = false : set = _set_open_mouth
var mouth_open_frames : int = 0
var audio_pitch_base : float = 1.0

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

# إضافة الحروف المتحركة العربية
var arabic_vowels = "اوئي"

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	DialogSystem.letter_added.connect(check_mouth_open)
	blinker()

# التحقق من الحركة المناسبة للفم بناءً على الحروف المنطوقة
func check_mouth_open(l : String) -> void:
	if arabic_vowels.contains(l):  # إذا كانت الحروف متحركة في اللغة العربية
		open_mouth = true
		mouth_open_frames += 3
		audio_stream_player.pitch_scale = randf_range(audio_pitch_base - 0.04, audio_pitch_base + 0.04)
		audio_stream_player.play()
	elif '.,!?'.contains(l):  # عند وجود علامات الترقيم مثل النقطة أو الاستفهام
		audio_stream_player.pitch_scale = audio_pitch_base - 0.1
		audio_stream_player.play()
		mouth_open_frames = 0
	
	if mouth_open_frames > 0:
		mouth_open_frames -= 1
	
	if mouth_open_frames == 0:
		if open_mouth == true:
			open_mouth = false
			audio_stream_player.pitch_scale = randf_range(audio_pitch_base - 0.08, audio_pitch_base + 0.02)
			audio_stream_player.play()

	pass

# تحديث صورة الشخصية بناءً على حالة الفم والرمش
func update_portrait() -> void:
	if open_mouth == true:
		frame = 2  # تعيين الإطار الخاص بالفم المفتوح
	else:
		frame = 0  # تعيين الإطار الخاص بالفم المغلق
	
	if blink == true:
		frame += 1  # تعيين الإطار الخاص بالرمش

# محاكاة الرمش
func blinker() -> void:
	if blink == false:
		await get_tree().create_timer(randf_range(0.1, 3)).timeout
	else:
		await get_tree().create_timer(0.15).timeout
	blink = not blink
	blinker()

# تعديل حركة الرمش
func _set_blink(_value : bool) -> void:
	if blink != _value:
		blink = _value
		update_portrait()

# تعديل حركة الفم
func _set_open_mouth(_value : bool) -> void:
	if open_mouth != _value:
		open_mouth = _value
		update_portrait()
