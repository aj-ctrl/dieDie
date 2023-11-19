extends Node2D

var die = preload("res://die.tscn")
var list_dice = []

var plr1col1 = []
var plr1col2 = []
var plr1col3 = []
var plr2col1 = []
var plr2col2 = []
var plr2col3 = []

var plr1col1total = 0
var plr1col2total = 0
var plr1col3total = 0
var plr2col1total = 0
var plr2col2total = 0
var plr2col3total = 0
var plr1total = 0
var plr2total = 0

@onready var plr1slots1 = [$Player1/Board/dieSlot1,$Player1/Board/dieSlot2,$Player1/Board/dieSlot3]
@onready var plr1slots2 = [$Player1/Board/dieSlot4,$Player1/Board/dieSlot5,$Player1/Board/dieSlot6]
@onready var plr1slots3 = [$Player1/Board/dieSlot7,$Player1/Board/dieSlot8,$Player1/Board/dieSlot9]
@onready var plr2slots1 = [$Player2/Board/dieSlot7,$Player2/Board/dieSlot8,$Player2/Board/dieSlot9]
@onready var plr2slots2 = [$Player2/Board/dieSlot4,$Player2/Board/dieSlot5,$Player2/Board/dieSlot6]
@onready var plr2slots3 = [$Player2/Board/dieSlot1,$Player2/Board/dieSlot2,$Player2/Board/dieSlot3]

@onready var plr_2_col_1_scr = $Player2/Text/Plr2Col1Scr
@onready var plr_2_col_2_scr = $Player2/Text/Plr2Col2Scr
@onready var plr_2_col_3_scr = $Player2/Text/Plr2Col3Scr
@onready var plr_1_col_1_scr = $Player1/Text/Plr1Col1Scr
@onready var plr_1_col_2_scr = $Player1/Text/Plr1Col2Scr
@onready var plr_1_col_3_scr = $Player1/Text/Plr1Col3Scr

var plr1Color = Color("#0099ff")
var plr2Color = Color("#ff9933")
var matchColor = Color("#ffff66")
var whiteColor = Color("#ffffff")

var currentDie
var isPlr1Turn = true
var plrHasRolled = false
var isGameActive = true

func _ready():
	pass # Replace with function body.


func _process(_delta):
	process_scores()
	if isGameActive:
		if isPlr1Turn:
			$Player2/Board.modulate = whiteColor
			$Player1/Board.modulate = plr1Color
			TakeTurn(1)
		else:
			$Player1/Board.modulate = whiteColor
			$Player2/Board.modulate = plr2Color
			TakeTurn(2)
	else:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func process_scores():
	plr1col1total = process_score(plr1col1, plr_1_col_1_scr)
	plr1col2total = process_score(plr1col2, plr_1_col_2_scr)
	plr1col3total = process_score(plr1col3, plr_1_col_3_scr)
	plr2col1total = process_score(plr2col1, plr_2_col_1_scr)
	plr2col2total = process_score(plr2col2, plr_2_col_2_scr)
	plr2col3total = process_score(plr2col3, plr_2_col_3_scr)
	plr1total = plr1col1total + plr1col2total + plr1col3total
	plr2total = plr2col1total + plr2col2total + plr2col3total
	if plr1total > plr2total:
		$Player2/Text/Plr2Scr.modulate = whiteColor
		$Player1/Text/Plr1Scr.modulate = plr1Color
	else:
		if plr2total > plr1total:
			$Player1/Text/Plr1Scr.modulate = whiteColor
			$Player2/Text/Plr2Scr.modulate = plr2Color
		else:
			$Player1/Text/Plr1Scr.modulate = whiteColor
			$Player2/Text/Plr2Scr.modulate = whiteColor
	$Player1/Text/Plr1Scr.text = str(plr1total)
	$Player2/Text/Plr2Scr.text = str(plr2total)

func process_score(column:Array, scoreDisplay:Label):
	var total = 0
	scoreDisplay.modulate = whiteColor
	for item in column:
		item.modulate = whiteColor
	match column.size():
		1:
			total = column[0].value
		2:
			if column[0].value == column[1].value:
				column[0].modulate = matchColor
				column[1].modulate = matchColor
				scoreDisplay.modulate = matchColor
				total = (column[0].value + column[1].value) * 2
			else:
				total = column[0].value + column[1].value
		3:
			total = column[0].value + column[1].value + column[2].value
			if column[0].value == column[1].value:
				column[0].modulate = matchColor
				column[1].modulate = matchColor
				scoreDisplay.modulate = matchColor
				total = ((column[0].value + column[1].value) * 2) + column[2].value
			if column[0].value == column[2].value:
				column[0].modulate = matchColor
				column[2].modulate = matchColor
				scoreDisplay.modulate = matchColor
				total = ((column[0].value + column[2].value) * 2) + column[1].value
			if column[1].value == column[2].value:
				column[2].modulate = matchColor
				column[1].modulate = matchColor
				scoreDisplay.modulate = matchColor
				total = ((column[1].value + column[2].value) * 2) + column[0].value
			if column[0].value == column[1].value and column[0].value == column[2].value:
				column[0].modulate = matchColor
				column[1].modulate = matchColor
				column[2].modulate = matchColor
				scoreDisplay.modulate = matchColor
				total = (column[0].value + column[1].value + column[2].value) * 3
	scoreDisplay.text = str(total)
	return total

func TakeTurn(player):
	if !plrHasRolled:
		rollDie(player)
		plrHasRolled = true
	if player == 1:
		if Input.is_action_just_pressed("ui_left") and plr1col1.size() < 3:
			plr1col1.push_back(currentDie)
			process_matches(plr2col1, plr2slots1)
			update_slots(plr1col1, plr1slots1)
			isPlr1Turn = false
			plrHasRolled = false
		if Input.is_action_just_pressed("ui_up") and plr1col2.size() < 3:
			plr1col2.push_back(currentDie)
			process_matches(plr2col2, plr2slots2)
			update_slots(plr1col2, plr1slots2)
			isPlr1Turn = false
			plrHasRolled = false
		if Input.is_action_just_pressed("ui_right") and plr1col3.size() < 3:
			plr1col3.push_back(currentDie)
			process_matches(plr2col3, plr2slots3)
			update_slots(plr1col3, plr1slots3)
			isPlr1Turn = false
			plrHasRolled = false
		if !isPlr1Turn:
			check_gamestate()
	else:
		if Input.is_action_just_pressed("ui_left") and plr2col1.size() < 3:
			plr2col1.push_back(currentDie)
			process_matches(plr1col1, plr1slots1)
			update_slots(plr2col1, plr2slots1)
			isPlr1Turn = true
			plrHasRolled = false
		if Input.is_action_just_pressed("ui_up") and plr2col2.size() < 3:
			plr2col2.push_back(currentDie)
			process_matches(plr1col2, plr1slots2)
			update_slots(plr2col2, plr2slots2)
			isPlr1Turn = true
			plrHasRolled = false
		if Input.is_action_just_pressed("ui_right") and plr2col3.size() < 3:
			plr2col3.push_back(currentDie)
			process_matches(plr1col3, plr1slots3)
			update_slots(plr2col3, plr2slots3)
			isPlr1Turn = true
			plrHasRolled = false
		if isPlr1Turn:
			check_gamestate()

func process_matches(oppColumn:Array, oppSlots):
	var i = oppColumn.size() - 1
	while i > -1:
		if oppColumn[i].value == currentDie.value:
			oppColumn[i].kill()
			oppColumn.pop_at(i)
		i -= 1
	update_slots(oppColumn, oppSlots)

func update_slots(column, slots):
	var tween
	match column.size():
		1:
			tween = get_tree().create_tween()
			tween.tween_property(column[0],"global_position",slots[0].global_position,.2).set_trans(Tween.TRANS_SINE)
		2:
			tween = get_tree().create_tween()
			tween.tween_property(column[0],"global_position",slots[0].global_position,.2).set_trans(Tween.TRANS_SINE)
			tween = get_tree().create_tween()
			tween.tween_property(column[1],"global_position",slots[1].global_position,.2).set_trans(Tween.TRANS_SINE)
		3:
			tween = get_tree().create_tween()
			tween.tween_property(column[0],"global_position",slots[0].global_position,.2).set_trans(Tween.TRANS_SINE)
			tween = get_tree().create_tween()
			tween.tween_property(column[1],"global_position",slots[1].global_position,.2).set_trans(Tween.TRANS_SINE)
			tween = get_tree().create_tween()
			tween.tween_property(column[2],"global_position",slots[2].global_position,.2).set_trans(Tween.TRANS_SINE)

func check_gamestate():
	if plr1col1.size() == 3 and plr1col2.size() == 3 and plr1col3.size() == 3 or plr2col1.size() == 3 and plr2col2.size() == 3 and plr2col3.size() == 3:
		isGameActive = false
	if isGameActive == false:
		end_game()

func end_game():
	process_scores()
	var finalLabel = $Text/FinalScore/Label
	var finalPanel = $Text/FinalScore
	if plr1total > plr2total:
		finalLabel.modulate = plr1Color
		finalLabel.text = "Player 1 Wins! " + str(plr1total) + " : " + str(plr2total)
	else:
		if plr2total > plr1total:
			finalLabel.modulate = plr2Color
			finalLabel.text = "Player 2 Wins! " + str(plr2total) + " : " + str(plr1total)
		else:
			finalLabel.text = "It's a tie! " + str(plr1total) + " : " + str(plr2total)
	finalPanel.show()

func rollDie(player):
	currentDie = die.instantiate()
	add_child(currentDie)
	list_dice.push_back(currentDie)
	currentDie = list_dice.back()
	
	if player == 1:
		currentDie.global_position = $Player1/Board/RollSlot.global_position
	else:
		currentDie.global_position = $Player2/Board/RollSlot.global_position
