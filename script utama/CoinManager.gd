extends Node

signal coin_changed(amount: int)

var coins: int = 0


func add_coins(amount: int) -> void:
	if amount <= 0:
		return

	coins += amount
	coin_changed.emit(coins)

	print("Coin bertambah: +", amount)
	print("Total Coin: ", coins)


func remove_coins(amount: int) -> bool:
	if amount <= 0:
		return false

	if coins < amount:
		return false

	coins -= amount
	coin_changed.emit(coins)

	return true


func get_coins() -> int:
	return coins


func reset_coins() -> void:
	coins = 0
	coin_changed.emit(coins)
