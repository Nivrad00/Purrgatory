extends "flashback_template.gd"

func _ready():
	._ready()
	text_dependencies = { 3: 2 }
	ending_label = null

func wake_up():
	.wake_up()
	
	# english
	
	var replacements = [
		'see the mountains',
		'hear the streets',
		'smell the ocean',
		'see the dusty roads',
		'feel the muggy air', 
		'see the perfect lawns',
		'see the leaky roof'
	]
	set_format_dict('hometown', replacements[choice_log[1]])
	
	var replacements2 = [
		'the corner store',
		'the creek',
		'the bookstore',
		'my great-aunt\'s house',
		'the arcade', 
		'the back of my family\'s store',
		'the soccer field'
	]
	set_format_dict('favorite_place', replacements2[choice_log[2]])
	
	# spanish
	
	var hometown_es_replacements = [
		'de las montañas que adornaban el paisaje',
		'del gentío y la cháchara en las calles',
		'de las olas rompiendo en la costa',
		'de las viejas carreteras que se perdían en el horizonte',
		'del ambiente cálido y húmedo',
		'del césped tan bien cuidado',
		'del techo que siempre estaba a punto de colapsar'
	]
	set_format_dict('hometown_es', hometown_es_replacements[choice_log[1]])
	
	var favorite_place_es_replacements = [
		'la tienda que hacía esquina y olía tan bien',
		'el descansillo rocoso a la orilla del arroyo',
		'la librería del final de mi calle',
		'el casoplón de mi tía abuela',
		'la sala de recreativos del centro comercial',
		'la trastienda del restaurante de mi familia',
		'el campo de fútbol de detrás de la escuela, que estaba tan mal cuidado'
	]
	set_format_dict('favorite_place_es', favorite_place_es_replacements[choice_log[2]])
	
	# chinese
	
	var hometown_ch_replacements = [
		'远处群山连绵',
		'街道熙熙攘攘',
		'海浪拍打岸边',
		'尘路延至天际',
		'空气闷热潮湿',
		'田园精心照料',
		'屋顶摇摇欲坠'
	]
	set_format_dict('hometown_ch', hometown_ch_replacements[choice_log[1]])
	
	var favorite_place_ch_replacements = [
		'转角那有肥皂味的小卖部',
		'溪流旁的卵石浅滩',
		'老街另一头的书店',
		'婶婶奢华的家',
		'商场里五光十色的街机厅',
		'家里小店的后屋',
		'学校后杂草疯长的田径场'
	]
	set_format_dict('favorite_place_ch', favorite_place_ch_replacements[choice_log[2]])
	
	# done
	
	emit_signal('change_room', 'flashback_kyungsoon')
