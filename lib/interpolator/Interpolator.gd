
var t = null
var start = null
var end = null
var value = null
var duration = 0.0


func is_running():
	return t != null

func start_interpolator(end_val, start_val = null):
	t = 0.0
	if start_val != null:
		start = start_val
	else:
		start = value
			
	end = end_val

func run_interpolator(delta):
	value = lerp(start, end, get_t(t))
	
	t += delta / duration
	if t > 1.0:
		t = null

func reset():
	t = null

func get_direction() -> float:
	if is_running():
		return end - start
	else:
		return 0.0

###########################################################################
# Virtual functions
###########################################################################

func get_t(new_t: float) -> float:
	return new_t

