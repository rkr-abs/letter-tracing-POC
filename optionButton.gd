extends OptionButton

signal characterChanged(char: String)

func _ready():
	add_alphabet_items()

func add_alphabet_items():
	for i in range("A".unicode_at(0), "Z".unicode_at(0) + 1):
		var letter = char(i)
		add_item(letter, i)

func _on_item_selected(index):
	if index <= 0:
		return
	
	characterChanged.emit(get_item_text(index))
