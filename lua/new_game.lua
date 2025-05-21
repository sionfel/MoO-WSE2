--[[

new_game.lua

This runs a function that generates the universe, place the appropriate parties

]]

require "generators"

function InitNewGame(galaxy_size)
	-- Generate universe
	print("Generating universe of size: " .. galaxy_size)
	UniverseGeneration()
	
end