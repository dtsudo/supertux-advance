//asset stuffs
print("Loading Frostlands")

//music

::musfreeze <- "contrib/frostlands/music/freezingpoint.ogg"
::musball <- "contrib/frostlands/music/city-theme.ogg"

//visual assets
::bgAuroraALT <- newSprite("contrib/frostlands/gfx/BG/aurora-alt.png", 720, 240, 0, 0, 0, 0)
::bgSnowPlainALT <- newSprite("contrib/frostlands/gfx/BG/bgSnowPlain-alt.png", 720, 240, 0, 0, 0, 0)
::bgSnowNever <- newSprite("contrib/frostlands/gfx/BG/Anever.png", 720, 240, 0, 0, 0, 0)
::bgRace <- newSprite("contrib/frostlands/gfx/BG/tuxracer.png", 320, 240, 0, 0, 0, 0)
::sprC1 <- newSprite("contrib/frostlands/gfx/effects/star1.png", 7, 7, 0, 0, 3, 3)
::sprFireBlock <- newSprite("contrib/frostlands/gfx/obj/Fireblock.png", 16, 16, 0, 0, 0, 0)

//NPCS
::sprTinyFireGuinb <- newSprite("contrib/frostlands/gfx/NPC/tinyfireguinb.png", 13, 23, 0, 0, 6, 23)
::sprRKO <- newSprite("contrib/frostlands/gfx/NPC/Frost.png", 18, 46, 0, 0, 9, 46)
::sprmark <- newSprite("contrib/frostlands/gfx/NPC/mark.png", 67, 48, 0, 0, 32, 47)
::sprmarq <- newSprite("contrib/frostlands/gfx/NPC/marqies.png", 34, 40, 0, 0, 32, 40)
::sprTuckles2 <- newSprite("contrib/frostlands/gfx/NPC/tuckles2.png", 18, 34, 0, 0, 8, 34)

//OG style
::sprCoinOG <- newSprite("contrib/frostlands/gfx/obj/fl-coin.png", 16, 16, 0, 0, 8, 8)
::sprFlowerFireOG <- newSprite("contrib/frostlands/gfx/obj/fl-fireflower.png", 16, 16, 0, 0, 8, 8)
::sprFlowerIceOG <- newSprite("contrib/frostlands/gfx/obj/fl-iceflower.png", 16, 16, 0, 0, 8, 8)
::sprEarthShellOG <- newSprite("contrib/frostlands/gfx/obj/fl-earthshell.png", 16, 16, 0, 0, 8, 8)
::sprInfoBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-infobox.png", 16, 16, 0, 0, 0, 0)
::sprTriggerBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-redbox.png", 16, 16, 0, 0, 0, 0)
::sprItemBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-itembox.png", 16, 16, 0, 0, 0, 0)
::sprSnowballOG <- newSprite("contrib/frostlands/gfx/obj/fl-snowball.png", 16, 16, 0, 0, 8, 8)
::sprStarOG <- newSprite("contrib/frostlands/gfx/obj/fl-star.png", 16, 16, 0, 0, 8, 8)
::sprWoodBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-woodbox.png", 16, 16, 0, 0, 0, 0)
::sprWoodChunksOG <- newSprite("contrib/frostlands/gfx/obj/fl-woodchunks.png", 8, 8, 0, 0, 4, 4)
::sprCoinN1 <- newSprite("contrib/frostlands/gfx/obj/coin-n1.png", 16, 16, 0, 0, 8, 8)
::sprCoinN5 <- newSprite("contrib/frostlands/gfx/obj/coin-n5.png", 16, 16, 0, 0, 8, 8)
::sprCoinN10 <- newSprite("contrib/frostlands/gfx/obj/coin-n10.png", 16, 16, 0, 0, 8, 8)
::sprEmptyBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-emptybox.png", 16, 16, 0, 0, 0, 0)

::gfxOverrideFL <- function(never = false) {
	if(actor.rawin("WoodBlock")) foreach(i in actor["WoodBlock"]) {
		i.sprite = sprWoodBoxOG
		i.spriteBreak = sprWoodChunksOG
		i.spriteCoin = sprCoinOG
	}

	if(actor.rawin("ItemBlock")) foreach(i in actor["ItemBlock"]) {
		i.spriteFull = sprItemBoxOG
		i.spriteEmpty = sprEmptyBoxOG
		i.spriteCoin = sprCoinOG
		i.spriteFire = sprFlowerFireOG
		i.spriteIce = sprFlowerIceOG
		i.spriteEarth = sprEarthShellOG
		i.spriteStar = sprStarOG
	}

	if(never){
		if(actor.rawin("Coin")) foreach(i in actor["Coin"]) {
			i.sprite = sprCoinN1
			i.sprite = sprCoinN5
			i.sprite = sprCoinN10
		}
	}
	else if(actor.rawin("Coin")) foreach(i in actor["Coin"]) {
		i.sprite = sprCoinOG
	}
}

//background shiz

::dbgAuroraF <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAuroraALT, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgNever <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowNever, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgSnowPlainF <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowPlainALT, 0, ((-camx / 8) % 720) + (i * 720), (screenH() / 2) - 120)
	}
}

::dbgRace <- function() {
	drawSprite(bgRace, 0, 0, (screenH() / 2) - 120)
}

::FireBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	fireshape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		slideshape = Rec(x, y - 1, 12, 8, 0)
		fireshape = Rec(x, y, 16, 16, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {

		if(actor.rawin("Fireball")) foreach(i in actor["Fireball"])  if(hitTest(fireshape, i.shape)) {
			tileSetSolid(x, y, 0)
			deleteActor(id)
			deleteActor(i.id)
			newActor(Flame, x, y)
			playSound(sndFlame, 0)
		}

		if(actor.rawin("ExplodeF")) foreach(i in actor["ExplodeF"])  if(hitTest(fireshape, i.shape)) {
			tileSetSolid(x, y, 0)
			deleteActor(id)
			deleteActor(i.id)
			newActor(Poof, x, y)
			playSound(sndFlame, 0)
		}

		drawSprite(sprFireBlock, 0, x - 8 - camx, y - 8 - camy)
	}
}

::TNTALT <- class extends Actor {
	shape = null
	gothit = false
	hittime = 0.0
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 10, 10, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		drawSprite(sprC4, frame, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "TNTALT" }
}

::Spakle <- class extends Actor{
	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
	}
		function run() {
	if(getFrames() % 3 == 0){
	newActor(c1, x - 16 + randInt(32), y - 16 + randInt(100))
	}
	}
}

::c1 <- class extends Actor {
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}
	function run() {
		if(frame < 1) frame += 0.02
		frame += 0.05
		y -= 0.5
		if(frame >= 3) deleteActor(id)
		else drawSpriteEx(sprC1, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1)
	}
}

print("Loaded Frostlands")