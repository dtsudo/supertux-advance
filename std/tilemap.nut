////////////////
// TILED MAPS //
////////////////

::tileSearchDir <- ["."]

::findFileName <- function(path) {
	if(typeof path != "string") return ""
	if(path.len() == 0) return ""

	for(local i = path.len() - 1; i >= 0; i--) {
		if(path[i] == "/" || path[i] == "\\") return path.slice(i + 1)
	}

	return path
}

////////////
// SHAPES //
////////////

::Rec <- class {
	x = 0.0
	y = 0.0
	w = 0.0
	h = 0.0
	slope = 0
	// 0 no slope
	// 1 top right
	// 2 top left
	// 3 bottom right
	// 4 bottom left

	constructor(_x, _y, _w, _h, _slope) {
		x = _x
		y = _y
		w = _w
		h = _h
		slope = _slope
	}

	function _typeof() { return "Rec" }

	function setPos(_x, _y, _a) {
		x = _x
		y = _y
	}
}

::hitTest <- function(a, b) {
	switch(typeof a) {
		case "Rec":
			switch(typeof b) {
				case "Rec":
					if(abs(a.x - b.x) > abs(a.w + b.w)) return false
					if(abs(a.y - b.y) > abs(a.h + b.h)) return false

					//Slopes
					if(a.slope != 0 || b.slope != 0) {
						switch(a.slope) {
							case 1:
								switch(b.slope) {
									case 1:
										break
									case 2:
										break
									case 3:
										break
									case 4:
										break
								}
								break

							case 2:
								switch(b.slope) {
									case 1:
										break
									case 2:
										break
									case 3:
										break
									case 4:
										break
								}
								break

							case 3:
								switch(b.slope) {
									case 1:
										break
									case 2:
										break
									case 3:
										break
									case 4:
										break
								}
								break

							case 4:
								switch(b.slope) {
									case 1:
										break
									case 2:
										break
									case 3:
										break
									case 4:
										break
								}
								break
						}
					}

					return true
					break

				default:
					return false
					break
			}
			break

		default:
			return false
			break
	}
}

///////////////////
// TILEMAP CLASS //
///////////////////

::Tilemap <- class {
	data = {}
	tileset = []
	tilef = []
	tilew = 0
	tileh = 0
	mapw = 0
	maph = 0
	geo = []
	w = 0
	h = 0

	constructor(filename) {
		if(fileExists(filename)) {
			data = jsonRead(fileRead(filename))

			mapw = data.width
			maph = data.height
			tilew = data.tilewidth
			tileh = data.tileheight
			w = mapw * tilew
			h = maph * tileh

			for(local i = 0; i < data.tilesets.len(); i++) {
				//Extract filename
				print("Get filename")
				local filename = data.tilesets[i].image
				local shortname = findFileName(filename)
				print("Full map name: " + filename + ".")
				print("Short map name: " + shortname + ".")

				local tempspr = findSprite(shortname)
				print("Temp sprite: " + shortname)

				if(tempspr != 0) {
					tileset.push(tempspr)
					print("Added tempspr: " + shortname)
				}
				else { //Search for file
					if(fileExists(filename)) {
						print("Attempting to add full filename")
						tileset.push(newSprite(filename, data.tilewidth, data.tileheight, data.tilesets[i].margin, data.tilesets[i].spacing, 0, 0, 0))
						print("Added tileset " + shortname + ".")
					}
					else for(local j = 0; j < tileSearchDir.len(); j++) {
						if(fileExists(tileSearchDir[j] + "/" + shortname)) {
							print("Adding from search path: " + tileSearchDir[j])
							tileset.push(newSprite(tileSearchDir[j] + "/" + shortname, data.tilewidth, data.tileheight, data.tilesets[i].margin, data.tilesets[i].spacing, 0, 0, 0))
							break
						}
					}
				}

				tilef.push(data.tilesets[i].firstgid)

				print("Added " + spriteName(tileset[i]) + ".\n")
			}

			//Generate polygon lists
			for(local i = 0; i < data.layers.len(); i++) {
				if(data.layers[i].type == "objectgroup") {
					local nl = [data.layers[i].name, []]; //New layer, stores name and object list
					for(local j = 0; j < data.layers[i].objects.len(); j++) {
						if(data.layers[i].objects[j].rawin("polygon")) {
							/*
							local np = Polygon(data.layers[i].objects[j].x, data.layers[i].objects[j].y, [])
							for(local k = 0; k < data.layers[i].objects[j].polygon.len(); k++) {
								np.addPoint(data.layers[i].objects[j].polygon[k].x, data.layers[i].objects[j].polygon[k].y)
							}
							nl[1].push(np)
							*/
						}
						else if(data.layers[i].objects[j].rawin("ellipse")) {}
						else if(data.layers[i].objects[j].rawin("point")) {}
						else {
							local obj = data.layers[i].objects[j]
							local np = 0
							switch(obj["type"]) {
								case "tr":
									np = Rec(obj.x + (obj.width / 2), obj.y + (obj.height / 2), obj.width / 2, obj.height / 2, 1)
									break
								case "tl":
									np = Rec(obj.x + (obj.width / 2), obj.y + (obj.height / 2), obj.width / 2, obj.height / 2, 2)
									break
								case "br":
									np = Rec(obj.x + (obj.width / 2), obj.y + (obj.height / 2), obj.width / 2, obj.height / 2, 3)
									break
								case "bl":
									np = Rec(obj.x + (obj.width / 2), obj.y + (obj.height / 2), obj.width / 2, obj.height / 2, 4)
									break
								default:
									np = Rec(obj.x + (obj.width / 2), obj.y + (obj.height / 2), obj.width / 2, obj.height / 2, 0)
									break
							}
							nl[1].push(np)
						}
					}
					geo.push(nl)
				}
			}
		}
		else print("Map file " + filename + " does not exist!")
	}

	function drawTiles(x, y, mx, my, mw, mh, l) { //@mx through @mh are the rectangle of tiles that will be drawn
		//Find layer
		local t = -1; //Target layer
		for(local i = 0; i < data.layers.len(); i++) {
			if(data.layers[i].type == "tilelayer" && data.layers[i].name == l) {
				t = i
				break
			}
		}
		if(t == -1) {
			return; //Quit if no tile layer by that name was found
		}

		//Make sure values are in range
		if(data.layers[t].width < mx + mw) mw = data.layers[t].width - mx
		if(data.layers[t].height < my + mh) mh = data.layers[t].height - my
		if(mx < 0) mx = 0
		if(my < 0) my = 0
		if(mx > data.layers[t].width) mx = data.layers[t].width
		if(my > data.layers[t].height) my = data.layers[t].height

		for(local i = my; i < my + mh; i++) {
			for(local j = mx; j < mx + mw; j++) {
				if(i * data.layers[t].width + j >= data.layers[t].data.len()) return
				local n = data.layers[t].data[(i * data.layers[t].width) + j]; //Number value of the tile
				if(n != 0) {
					for(local k = data.tilesets.len() - 1; k >= 0; k--) {
						if(n >= data.tilesets[k].firstgid) {
							drawSprite(tileset[k], n - data.tilesets[k].firstgid, x + (j * data.tilewidth), y + (i * data.tileheight))
							k = -1
							break
						}
					}
				}
			}
		}
	}

	function drawShapes(_x, _y, l) {
		if(geo.len() == 0) return

		for(local i = 0; i < geo.len(); i++) {
			if(geo[i][0] == l) {
				for(local j = 0; j < geo[i][1].len(); j++) geo[i][1][j].drawPos(_x, _y)
			}
		}
	}
}