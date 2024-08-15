extends OptionButton

signal characterChanged(char: String)

func _ready():
	add_alphabet_items()

func add_alphabet_items():
	for i in range(0,9):
		add_item(str(i), i)

func _on_item_selected(index):
	if index <= 0:
		return
	
	characterChanged.emit(get_item_text(index))
