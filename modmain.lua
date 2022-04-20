AddReplicableComponent("thirst")
AddReplicableComponent("waterlevel")


env._G = GLOBAL
env.require = _G.require
env.STRINGS = _G.STRINGS
env.ACTIONS = _G.ACTIONS
env.RPC = _G.RPC
env.SendRPCToServer = _G.SendRPCToServer
env.BufferedAction = _G.BufferedAction
env.SpawnPrefab = _G.SpawnPrefab
env.TheWorld = _G.TheWorld

PrefabFiles = require("water_prefablist")

Assets = require("water_assets")

STRINGS.NAMES.DRINKS_TAB = "WATER"
STRINGS.TABS.DRINKS_TAB = "Water"
_G.RECIPETABS['DRINKS_TAB'] = {str = "DRINKS_TAB", sort=3, icon_atlas = "images/tea_inventoryitem.xml", icon = "watertab.tex"}

_G.WATERTYPE = 
{
	CLEAN = "CLEAN",
	DIRTY = "DIRTY",
	SALTY = "SALTY",
}

modimport("scripts/water_recipes")
modimport("scripts/strings/strings")
--modimport("scripts/strings/speech")
modimport("scripts/water_tuning")
modimport("scripts/water_actions")
modimport("scripts/water_containers")

AddMinimapAtlas("images/tea_minimap.xml")

modimport("scripts/water_main.lua")
modimport("init/postinit/postinit_player")
modimport("scripts/widgets/thirstbadge_statusdisplays")

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

