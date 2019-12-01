extends Node

enum Tunes {SandDungeon, SandDungeonPrison, TheBlackMask}

onready var sand_dungeon = $sand_dungeon
onready var sand_dungeon_prison = $sand_dungeon_prison
onready var sand_dungeon_battle = $sand_dungeon_battle
onready var the_black_mask = $the_blask_mask
onready var tween :Tween= $tween

const DEBUG : bool = false

var playing : int = -1
var time_begin: float
var time_delay: float

var beats_per_measure: int
var beats_per_minute: float
var beats_duration: float 
var total_measures: int
var current_measure: int
var last_measure: int

var is_next_queued: bool = false
var ignore_sand_dungeon_prison: bool = false
var wait_next: bool = false

var battle_release_time: float = 5.0

func _ready() -> void:

	set_physics_process(false)
	tween.connect("tween_completed", self, "_on_tween_completed")

func play(tune: int) -> void:
	
	
	
	match tune:
		Tunes.SandDungeon:

			if playing == tune and sand_dungeon.playing:
				return

			is_next_queued = true
			ignore_sand_dungeon_prison = true
			if current_measure == 0:
				wait_next = true
		Tunes.SandDungeonPrison:
			
			if playing == tune and sand_dungeon_prison.playing:
				return

			
			if ignore_sand_dungeon_prison:
				return
			
			#_precalculate_play(3, 240.0, 64)
			_precalculate_play(3, 240.0, 16)

			sand_dungeon_prison.play()
			sand_dungeon_battle.play()
			sand_dungeon_battle.volume_db = -80.0
			playing = tune
			
		Tunes.TheBlackMask:

			if playing == tune and the_black_mask.playing:
				return
				
			_precalculate_play(4, 310.0, 168)
			the_black_mask.play()
			playing = tune
			
			
func stop(tune: int) -> void:
	match tune:
		Tunes.SandDungeon:
			tween.interpolate_property(sand_dungeon, "volume_db", sand_dungeon.volume_db, -80.0, 4.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			tween.start()
		Tunes.TheBlackMask:
			the_black_mask.stop()

func _on_tween_completed(obj, path) -> void:
	
	if obj == sand_dungeon:
		sand_dungeon.stop()

func _precalculate_play(bp_measure, bp_min, tot_measures) -> void: 
	beats_per_measure = bp_measure
	beats_per_minute = bp_min
	total_measures = tot_measures
	beats_duration = 60.0 / beats_per_minute
	current_measure = 0

	
	time_begin = OS.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()

	set_physics_process(true)

	
func _physics_process(delta) -> void: 
	
	# Obtain from ticks.
	var time = (OS.get_ticks_usec() - time_begin) / 1000000.0
	# Compensate for latency.
	time -= time_delay
	
	# May be below 0 (did not being yet).
	time = max(0, time)
	var new_measure: int = floor((time / beats_duration) / beats_per_measure)
	if last_measure < new_measure:
		last_measure = new_measure
		if current_measure < total_measures - 1:
			
			current_measure += 1
		else:
			current_measure = 0
		
	
	if DEBUG:
		Console.add_log("tune_time", time)
		Console.add_log("beats_duration", beats_duration)
		if time > 0.0:
			Console.add_log("beats_played", floor(time / beats_duration))
			Console.add_log("measure", current_measure )
		
		Console.add_log("is_next_queued", is_next_queued)
		Console.add_log("current_measure == 15", current_measure == 15)
	
	
	match playing:
		Tunes.SandDungeonPrison:
			if current_measure == 1 and wait_next:
				wait_next = false
				
			if is_next_queued and (current_measure == 0 or current_measure >= 8) and not wait_next:
			#if is_next_queued and current_measure == 0 and not wait_next:
				
				_precalculate_play(3, 240.0, 442)
				sand_dungeon.play()
				sand_dungeon_prison.stop()
				sand_dungeon_battle.play()
				sand_dungeon_battle.volume_db = -80.0

				playing = Tunes.SandDungeon

func cue_battle() -> void:
	if playing == Tunes.TheBlackMask:
		return
		
	tween.stop_all()
	tween.interpolate_property(sand_dungeon_battle, "volume_db", sand_dungeon_battle.volume_db, 0.0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

	
func end_battle() -> void:

	if playing != Tunes.TheBlackMask:
		
		tween.stop_all()
		tween.interpolate_property(sand_dungeon_battle, "volume_db", sand_dungeon_battle.volume_db, -80.0, battle_release_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		tween.start()
	
	if playing == Tunes.TheBlackMask:
		stop(playing)

func long_battles() -> void:
	battle_release_time = 20.0

func short_battles() -> void:
	battle_release_time = 5.0

