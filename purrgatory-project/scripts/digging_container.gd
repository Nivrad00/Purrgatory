extends Node2D

signal start_dialog(label, sprite)

func start_dialog(label, sprite):
	emit_signal('start_dialog', label, sprite)