class_name CardControl extends Control

@onready var card_box: VBoxContainer = $CardVBox
@onready var double_click_timer: Timer = $DoubleClickTimer
@onready var menu: PopupMenu = $PopupMenu
@export var grand_parent: Control
@export_multiline() var empty_result_text: String = ""
@onready var empty_tip: Control = $空提示
var unstar_texture: Texture2D = preload("res://resources/未收藏.svg")
var star_texture: Texture2D = preload("res://resources/已收藏.svg")

var popup_line_id: int = -1
var popup_search_word: String = ""
var popup_song: Song
var recently_double_clicked: bool = false

class Song:
	var title: String
	var artist: String


func add_card(card: Card):
	# TODO 特效
	card_box.add_child(card)
	
func clear() -> void:
	for i in card_box.get_children():
		# TODO 特效
		i.queue_free()

func _process(_delta: float) -> void:
	self.custom_minimum_size = card_box.get_minimum_size()

func play_player(audio: AudioStream):
	grand_parent.play_player(audio)



func resolve_search_result(result: Array):
	clear()
	if result.is_empty():
		$"空提示/Label".text = empty_result_text
		empty_tip.show()
		return
	else:
		empty_tip.hide()
	var song_and_card: Dictionary[Song, Card]
	for i in result:
		var song_card_existed: bool = false
		for j in song_and_card.keys():
			if i["title"] == j.title and i["artist"] == j.artist:
				song_card_existed = true
				song_and_card[j].lines.append(i["line"])
				song_and_card[j].line_ids.append(i["line_id"])
				song_and_card[j].start_times.append(i["start_time"])
				song_and_card[j].end_times.append(i["end_time"])
				break
		if song_card_existed:
			continue
		# 否则就是没有相应的卡片, 直接添加:
		var card = Card.new_card(i["title"], i["artist"], i["line"], i["line_id"], i["start_time"], i["end_time"])
		card.request_line_ogg.connect(request_and_play_line_ogg)
		card.line_double_pressed.connect(_on_line_double_clicked)
		add_card(card)
		var song: Song = Song.new()
		song.title = card.title
		song.artist = card.artist
		song_and_card[song] = card

func request_and_play_line_ogg(line_id: int):
	Connector.get_line_ogg(line_id)
	var result = await Connector.request_completed
	if result is not AudioStreamOggVorbis:
		return
	if not recently_double_clicked:
		play_player(result)
	else:
		recently_double_clicked = false
		
func _on_line_double_clicked(line_id: int):
	recently_double_clicked = true
	
	if FavoriteManager.has(line_id):
		menu.set_item_text(0, "取消收藏")
		menu.set_item_icon(0, star_texture)
	else:
		menu.set_item_text(0, "收藏")
		menu.set_item_icon(0, unstar_texture)
	menu.popup()
	menu.position = get_global_mouse_position()
	popup_line_id = line_id
	
func _on_popup_menu_id_pressed(id: int) -> void:
	match id:
		0:
			if FavoriteManager.has(popup_line_id):
				FavoriteManager.erase(popup_line_id)
			else:
				var stared_line = FavoriteManager.StaredLine.new()
				stared_line.line_id = popup_line_id
				FavoriteManager.favorites.append(stared_line)
				FavoriteManager.write_favorites()
		1:
			# 我们来梳理一下思路: 首先要整一个api, 用于获取网易云歌曲id, 这个可以放在客户端里吧?
			# 然后, 我们只需获取, 之后OS.shell_open("orpheus://song/{得到的}?startTime={startTime}")即可!
			Connector.get_lines([popup_line_id])
			var line_data: Array[Dictionary] = await Connector.request_completed
			var keyword: String = line_data[0]["title"] + " " + line_data[0]["artist"]
			Connector.search_netease_song(keyword)
			var search_result: Dictionary = await Connector.request_completed
			var song_id: String = search_result["songs"][0]["id"]
			print(song_id)
