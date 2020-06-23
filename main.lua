require("matrix_scene")

local scene = "mscene"

function love.draw()
	if scene == "mscene" then
		mscene_draw()
	end
end

function love.load()
	love.window.setTitle( "Game of life 2" )
	love.window.setMode(800, 700)

	if scene == "mscene" then
		mscene_load()
	end
end

function love.mousepressed(x, y, button, istouch, presses)
	if scene == "mscene" then
		mscene_mpressed(x, y, button, istouch, presses)
	end
end
