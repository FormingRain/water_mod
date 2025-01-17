env._G = GLOBAL
env.require = _G.require
env.STRINGS = _G.STRINGS
env.ACTIONS = _G.ACTIONS
env.RPC = _G.RPC
env.SendRPCToServer = _G.SendRPCToServer
env.BufferedAction = _G.BufferedAction
env.SpawnPrefab = _G.SpawnPrefab
env.ThePlayer = _G.ThePlayer
env.TheWorld = _G.TheWorld
env.net_ushortint = _G.net_ushortint
env.net_bool = _G.net_bool

PrefabFiles = require("water_prefablist")

Assets = require("water_assets")

_G.WATERTYPE = 
{
	CLEAN = "CLEAN",
	DIRTY = "DIRTY",
	SALTY = "SALTY",
}

modimport("scripts/water_recipes.lua")
modimport("scripts/strings/strings.lua")
modimport("scripts/strings/speech.lua")
modimport("scripts/water_tuning.lua")
modimport("scripts/water_actions.lua")
modimport("scripts/water_containers.lua")

if GetModConfigData("enable_thirst") ~= 1 then
	modimport("init/postinit/postinit_player")
	modimport("scripts/widgets/thirstbadge_statusdisplays.lua")
end

AddMinimapAtlas("images/tea_minimap.xml")

modimport("scripts/water_main.lua")

local drinks = require("preparedrink")
local drinks_fermented = require("prepareagedrink")

for k, recipe in pairs(drinks) do
	AddCookerRecipe("kettle", recipe)
	AddCookerRecipe("portablekettle", recipe)
end

for k, recipe in pairs(drinks_fermented) do
	AddCookerRecipe("brewery", recipe)
end

local teaingredients = {
	"foliage",
	"petals",
	"succulent_picked",
	"tealeaves",
	"tealeaves_dried",
	"firenettles",
	"tillweed",
	"moon_tree_blossom",
}

AddIngredientValues(teaingredients, {decoration=1, inedible=1})
AddIngredientValues({"beefalo_milk"}, {milk=1, dairy=1})

AddIngredientValues({"caffeinberry_bean"}, {fruit=.5})
AddIngredientValues({"caffeinberry_bean_cooked"}, {fruit=1})

AddReplicableComponent("waterlevel")

if GetModConfigData("enable_thirst") ~= 1 then
	AddReplicableComponent("thirst")
end

