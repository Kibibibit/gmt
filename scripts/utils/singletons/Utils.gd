extends Node

## Selects a random element from the given array
func random_element(array: Array):
	return array[randi() % array.size()]
