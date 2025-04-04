class_name QuestItem extends Button

var quest : Quest

@onready var title_label: Label = $TitleLabel
@onready var step_label: Label = $StepLabel

# دالة لتحويل الأرقام من إنجليزي إلى عربي
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

# دالة لتهيئة المهمة
func intialize(q_data : Quest, q_state) -> void:
	quest = q_data
	title_label.text = q_data.title  # إذا كانت العنوان باللغة العربية، سيتم عرضه بالعربية
	
	if q_state.is_complete:
		step_label.text = "مكتمل"  # النص بالعربية
		step_label.modulate = Color.LIGHT_GREEN
	else:
		var step_count : int = q_data.steps.size()
		var completed_count : int = q_state.completed_steps.size()
		
		# تحويل الأرقام إلى أرقام عربية قبل عرضها
		step_label.text = "خطوة المهمة: " + convert_to_arabic_numbers(str(completed_count)) + "/" + convert_to_arabic_numbers(str(step_count))
