extends Node3D

@onready var animation = %AnimationPlayer

func idle():
	animation.play("Idle")

func running():
	animation.play("Running_A")

#func fall():
	#animation.play("Jump_Idle")

func jump():
	animation.play("Jump_Full_Short")
