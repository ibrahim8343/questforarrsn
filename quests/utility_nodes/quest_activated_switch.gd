@tool
@icon( "res://quests/utility_nodes/icons/quest_switch.png" )
class_name QuestActivatedSwitch extends QuestNode

enum CheckType { HAS_QUEST, QUEST_STEP_COMPLETE, ON_CURRENT_QUEST_STEP, QUEST_COMPLETE }

signal is_activated_changed( v : bool )

@export var نوع_التحقق : CheckType = CheckType.HAS_QUEST : set = _set_check_type  # نوع التحقق الذي سيتم فحصه
@export var إزالة_عند_التفعيل : bool = false  # هل سيتم إزالة العنصر عند التفعيل؟
@export var تحرير_عند_الإزالة : bool = false  # هل سيتم تحرير العنصر عند إزالته؟
@export var التفاعل_مع_الإشارة_العالمية : bool = false  # هل سيتم التفاعل مع الإشارات العالمية؟

var is_activated : bool = false


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if has_node("Sprite2D"):
		$Sprite2D.queue_free()
	if التفاعل_مع_الإشارة_العالمية == true:
		QuestManager.quest_updated.connect( _on_quest_updated )
	check_is_activated()
	pass


func check_is_activated() -> void:
	# الحصول على المهمة المرتبطة
	var _q : Dictionary = QuestManager.find_quest( linked_quest )
	
	if _q.title != "not found":
		
		if نوع_التحقق == CheckType.HAS_QUEST:
			# التحقق مما إذا كانت المهمة موجودة
			set_is_activated( true )
		
		elif نوع_التحقق == CheckType.QUEST_COMPLETE:
			# التحقق مما إذا كانت المهمة مكتملة
			var is_complete : bool = false
			if _q.is_complete is bool:
				is_complete = _q.is_complete
			set_is_activated( is_complete )
		
		elif نوع_التحقق == CheckType.QUEST_STEP_COMPLETE:
			
			if quest_step > 0:
				if _q.completed_steps.has( get_step() ) == true:
					set_is_activated( true )
				else:
					set_is_activated( false )
			else:
				set_is_activated( false )
		
		elif نوع_التحقق == CheckType.ON_CURRENT_QUEST_STEP:
			var step : String = get_step()
			if step == "N/A":
				set_is_activated( false )
				pass
			else:
				if _q.completed_steps.has( step ):
					set_is_activated( false )
				else:
					var prev_step : String = get_prev_step()
					if prev_step == "N/A":
						set_is_activated( true )
					
					elif _q.completed_steps.has( prev_step.to_lower() ):
						set_is_activated( true )
					else:
						set_is_activated( false )
			pass
		pass
	else:
		set_is_activated( false )
	
	pass


func set_is_activated( _v : bool ) -> void:
	is_activated = _v
	is_activated_changed.emit( _v )
	if is_activated == true:
		if إزالة_عند_التفعيل == true:
			hide_children()
		else:
			show_children()
	else:
		if إزالة_عند_التفعيل == true:
			show_children()
		else:
			hide_children()
	pass


func show_children() -> void:
	for c in get_children():
		c.visible = true
		c.process_mode = Node.PROCESS_MODE_INHERIT


func hide_children() -> void:
	for c in get_children():
		c.set_deferred( "visible", false )
		c.set_deferred( "process_mode", Node.PROCESS_MODE_DISABLED )
		if تحرير_عند_الإزالة:
			c.queue_free()


func _on_quest_updated( _q : Dictionary ) -> void:
	check_is_activated()
	pass


func _set_check_type( v : CheckType ) -> void:
	نوع_التحقق = v
	update_summary()
	pass


func update_summary() -> void:
	if linked_quest == null:
		settings_summary = "حدد مهمة"
		return
	settings_summary = "تحديث المهمة:\nالمهمة: " + linked_quest.title + "\n"
	if نوع_التحقق == CheckType.HAS_QUEST:
		settings_summary += "التحقق مما إذا كان اللاعب يمتلك المهمة"
	elif نوع_التحقق == CheckType.QUEST_STEP_COMPLETE:
		settings_summary += "التحقق مما إذا كان اللاعب قد أكمل الخطوة: " + get_step()
	elif نوع_التحقق == CheckType.ON_CURRENT_QUEST_STEP:
		settings_summary += "التحقق مما إذا كان اللاعب في الخطوة: " + get_step()
	elif نوع_التحقق == CheckType.QUEST_COMPLETE:
		settings_summary += "التحقق مما إذا كانت المهمة مكتملة"
