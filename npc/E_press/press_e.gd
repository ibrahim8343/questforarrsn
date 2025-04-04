extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var player_in_range: bool = false  # لمعرفة إن كان اللاعب داخل النطاق

func _on_body_entered(body) -> void:
	if body is Player:
		if not player_in_range:
			player_in_range = true
			animation_player.play("show_press")  # تشغيل أنيميشن الإظهار
			await animation_player.animation_finished  # انتظار انتهاء الأنيميشن الأول
			if player_in_range:  # التأكد من أن اللاعب لا يزال في النطاق
				animation_player.play("move")  # تشغيل الأنيميشن المستمر
		print("Player entered the interaction range.")

func _on_body_exited(body) -> void:
	if body is Player:
		player_in_range = false
		animation_player.stop()  # إيقاف جميع الأنيميشنات
		animation_player.play("hide_press")  # تشغيل أنيميشن الإخفاء
		print("Player exited the interaction range.")
