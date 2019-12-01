
enum ShakeDirectionTypes {X_AXIS, Y_AXIS, ALL_DIRECTIONS, GIVEN_DIRECTION}
enum ShakeMovementTypes {ARCH, STRONG_TO_LOW}

var DIRECTIONS = [Vector2(0, -1), Vector2(1, -1).normalized(), Vector2(1, 0), Vector2(1, 1).normalized(), Vector2(0, 1), Vector2(-1, 1).normalized(), Vector2(-1, 0), Vector2(-1, -1).normalized()]



var shake_delta = 0
var shake_duration = 0
var movement_duration = 0
var shake_type = ShakeDirectionTypes.ALL_DIRECTIONS
var shake_movement_type = ShakeMovementTypes.ARCH
var amplitude = 10
var given_direction = Vector2(1, 0)

var start_rotation := 0.0
var current_rotation := 0.0
var target_rotation := 0.0
var rotation_direction := 1.0
var rotation_amplitude := 0.0

var current_host = null
var is_processing : bool = false

func _init(host) -> void:
	
	current_host = host

func shake(duration, amp, rot_amp, shk_type, shk_mov_type, given_dir=null):
	
	if not is_processing:
		start_point = Vector2()
		is_processing = true
	
	total_movements = 15.0
	amplitude = amp
	rotation_amplitude = rot_amp
	shake_type = shk_type
	shake_movement_type = shk_mov_type
	shake_delta = duration + 0.5
	shake_duration = duration
	movement_duration = duration / (total_movements + 1.0)
	movement_count = 0
	movement_t = 0
	shake_t = 0
	direction = null

	current_spot = current_host.offset
	if given_dir != null:
		given_direction = given_dir
	_generate_new_target(0)


var direction = null
func _generate_new_target(t):
	match shake_type:
		ShakeDirectionTypes.GIVEN_DIRECTION:
			if direction == null:
				direction = given_direction
			else:
				direction *= -1
		ShakeDirectionTypes.X_AXIS:
			if direction == null:
				direction = Vector2(1, 0)
			else:
				direction *= -1
		ShakeDirectionTypes.Y_AXIS:
			if direction == null:
				direction = Vector2(0, 1)
			else:
				direction *= -1
		ShakeDirectionTypes.ALL_DIRECTIONS:
			var choosen = DIRECTIONS[randi() % 8]
			if direction == null:
				direction = choosen
			elif choosen.dot(direction) > 0.5:
				direction = choosen * -1
			else:
				direction = choosen
				
				
	if shake_movement_type == ShakeMovementTypes.ARCH:
		target = direction * lerp(0, amplitude, Smoothstep.arch(t, 4)) * rand_range(0.8, 1)
	else:
		target = direction * lerp(0, amplitude, Smoothstep.flip(Smoothstep.stop4(t))) * rand_range(0.8, 1)

	target_rotation = lerp(rotation_amplitude, 0, Smoothstep.start2(t)) * rand_range(0, rotation_direction)
	if rotation_direction > 0:
		rotation_direction = -1.0
	else:
		rotation_direction = 1.0

var movement_t = 0
var movement_count = 0
var shake_t = 0

var total_movements = 0
var target = Vector2()
var current_spot = Vector2()
var start_point = Vector2()
func process(delta) -> bool:
	if not is_processing:
		return false
	
	if shake_delta > 0:
		shake_delta -= delta

		if movement_t >= 1 and movement_count < total_movements:
			movement_t = 0
			current_spot = target
			current_rotation = target_rotation
			_generate_new_target(shake_t)
			movement_count += 1
		elif movement_t >= 1 and movement_count == total_movements:
			movement_t = 0
			current_spot = target
			current_rotation = target_rotation
			target = start_point
			target_rotation = start_rotation
		current_host.offset = current_spot.linear_interpolate(target, movement_t)
		current_host.rotation = lerp(current_rotation, target_rotation, movement_t)
		
		shake_t += delta / shake_duration
		movement_t += delta / movement_duration
		return true
	else:
		current_host.offset = start_point
		current_host.rotation = start_rotation

		is_processing = false
		#set_physics_process(false)
		return false

