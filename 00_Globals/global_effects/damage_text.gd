extends Node2D
class_name DamageText

var travel_distance: Vector2 = Vector2(10, -20)

# دالة لتحويل الأرقام الإنجليزية إلى أرقام عربية
func convert_to_arabic_numbers(text: String) -> String:
	var english_numbers = "0123456789"
	var arabic_numbers = "٠١٢٣٤٥٦٧٨٩"
	
	var result = ""
	for char in text:
		var index = english_numbers.find(char)
		if index != -1:
			result += arabic_numbers[index]
		else:
			result += char  # إذا لم يكن رقمًا، أضفه كما هو
	
	return result

func start(_number: String, _pos: Vector2) -> void:
	$Label.text = convert_to_arabic_numbers(_number)  # تحويل الرقم إلى العربية
	global_position = _pos
	
	# تحريك النص للأعلى بشكل عشوائي
	travel_distance.y *= randf_range(0.5, 1.5)
	travel_distance.x *= randf_range(-1.5, 1.5)
	
	var duration: float = randf_range(0.75, 1.25)
	
	var tween: Tween = create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	# تحريك النص
	tween.tween_property(self, "global_position", global_position + travel_distance, duration)
	
	# تقليل الشفافية تدريجياً حتى يختفي
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), duration).set_ease(Tween.EASE_IN)
	
	# حذف العقدة بعد انتهاء التحريك
	tween.chain().tween_callback(self.queue_free)
