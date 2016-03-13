tool #no validation, but has_method will not work in editor without tool
extends "ConditionalAction.gd"

const BaseEffect = preload("../Effects/BaseEffect.gd")

var _effects = null #[]

var _delay_sorter = DelaySorter.new()
var _effects_arranged_by_delay = false #ugly, figure out a better way

func is_action_done(): #bool
	var done = true
	for e in _effects:
		done = done and e.is_effect_done()
		if not done:
			break
	
	return done;
	
func add_on_fast_forward():
	_sort_effects_by_delay()
	for e in _effects:
		e.fast_forward()
	pass
	
func _do_play_action(): #bool
	if _effects == null or _effects_arranged_by_delay:
		_effects = null #to force _get_effects()
		_get_effects()
		
	for e in _effects:
		e.play_effect(use_fixed_process)
	return true
	
func add_on_prepare_action():
	.add_on_prepare_action() #calling parent method to get conditions
	_get_effects()
	pass

func _get_effects():
	if _effects != null:
		return
	
	_effects = []
	
	for child in get_children():
		if child extends BaseEffect:
			_effects.append(child)
			
	_effects_arranged_by_delay = false
	pass

func _sort_effects_by_delay():
	_effects.sort_custom(_delay_sorter, "sort")
	_effects_arranged_by_delay = true
	pass
	
class DelaySorter:
	
	func sort(first, second):
		return first.delay < second.delay