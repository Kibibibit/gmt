class_name ScreenEffects
extends Node2D

signal anim_half_done()
signal anim_done()

const not_set: float = -1.0
var anim_speed: float = 1.0
var running: bool = false
var runnable: Callable
var delta_passed: float = not_set


func _process(delta):
	if (running):
		if (delta_passed == not_set):
			delta_passed = 0
		else:
			delta_passed += delta*anim_speed
			if (delta_passed >= 0.5):
				emit_signal("anim_half_done")
		if (!reset()):
			queue_redraw()

func reset():
	if (delta_passed > 1):
		running = false
		queue_redraw()
		delta_passed = not_set
		anim_speed = 1.0
		emit_signal("anim_done")
		return true
	return false

func _draw():
	if (running):
		runnable.call()

func screen_wipe(color: Color = Color(1,1,1)) -> ScreenEffects:
	anim_speed = 1.9
	runnable = Callable(self,"_screen_wipe_tick").bind(color)
	running = true
	return self
	
func _screen_wipe_tick(color):
	var wipe_1_d: float = min(delta_passed*2.0,1.0)
	var wipe_2_d: float = max(0,(delta_passed*2.0)-1.0)
	
	var x1: float = lerp(0, Game.width(), wipe_2_d)
	var x2: float = lerp(0, Game.width(), wipe_1_d)
	var rect_pos = Vector2(x1,0.0)
	var rect_size = Vector2(x2,Game.height())
	
	draw_rect(Rect2(rect_pos,rect_size),color)
	
