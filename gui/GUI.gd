extends CanvasLayer

onready var arrow = $arrow
onready var health_bar = $portrait/health_bar
onready var enemy_health_bar = $enemy_bar/health_bar
onready var life_pieces = $life_pieces
onready var fun_particle = $fun_particle
onready var fun_particle_start = $fun_particle_start
onready var anims = $anims
onready var tutorial = $tutorial

var hidden: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	enemy_health_bar.hide()
	life_pieces.connect("full_piece", self, "_on_full_piece")
	
func level_loaded() -> void:
	enemy_health_bar.hide()
	life_pieces.set_pieces(GameState.get_life_pieces())
	
	tutorial.hide()
	
	if hidden:
		hidden = false
		
		anims.play("show")
	
func hide():
	hidden = true
	anims.play_backwards("show")

func prompt_arrow(actor: Position2D) -> void:
	arrow.appear(actor)
	

func unprompt_arrow() -> void:
	arrow.disappear()
	
	
func open_player_health_bar() -> void:
	health_bar.lives = GameState.current_max_life_count

func open_enemy_health_bar(how_much: int) -> void:
	enemy_health_bar.show()
	enemy_health_bar.lives = how_much

	Maestro.cue_battle()

func close_enemy_health_bar() -> void:
	enemy_health_bar.hide()
	Maestro.end_battle()

func player_life_down() -> int:
	
	GameState.current_life_count = health_bar.life_down()
	return GameState.current_life_count
	

func enemy_life_down() -> int:
	#enemy_health_bar
	var result: int = enemy_health_bar.life_down(true)
	if result <= 0:
		Maestro.end_battle()
	return result
	

func _on_full_piece() -> void:
	GameState.increment_max_life()
	
	fun_particle.emit($fun_particle_start.position, health_bar.increment_max_life())

func increment_life_pieces() -> void:
	life_pieces.increment_life_pieces()
	

func full_heal() -> void:
	health_bar.full_heal()
	
	
	
