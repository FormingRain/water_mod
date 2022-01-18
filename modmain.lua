env._G = GLOBAL
env.require = _G.require
env.STRINGS = _G.STRINGS

PrefabFiles =
{
	"barrel",
	"brewery",
	"bucket",
	"bucketfull",
	"caffeinberry",
	"campkettle",
	"cup",
	"desalinator",
	"kettle",
	"portablekettle",
	"preparedrink",
	"tea_tree",
	"tea_seed",
	"well",
	"well_drilling",
}

Assets =
{
    Asset("ATLAS", "images/tea_inventoryitem.xml"),
    Asset("IMAGE", "images/tea_inventoryitem.tex"),
	Asset("ATLAS", "images/tea_minimap.xml"),
    Asset("IMAGE", "images/tea_minimap.tex"),
	Asset("SOUNDPACKAGE", "sound/fil_drink.fev"),	
    Asset("SOUND", "sound/fil_drink.fsb"),
	Asset("ANIM", "anim/swap_cup.zip" ),
	Asset("ANIM", "anim/fili_thirst_bage.zip" ),
}

STRINGS.NAMES.DRINKS_TAB = "WATER"
STRINGS.TABS.DRINKS_TAB = "Water"
_G.RECIPETABS['DRINKS_TAB'] = {str = "DRINKS_TAB", sort=3, icon_atlas = "images/tea_inventoryitem.xml", icon = "watertab.tex"}

_G.FUELTYPE.WATER = "WATER"

_G.WATERTYPE = 
{
	CLEAN = "CLEAN",
	DIRTY = "DIRTY",
	SALTY = "SALTY",
}

modimport("scripts/recipes.lua")
--modimport("scripts/strings/strings.lua")
--modimport("scripts/strings/speech.lua")
modimport("scripts/watertuning.lua")
modimport("scripts/prepareagedrink.lua")
modimport("scripts/preparedrink.lua")
modimport("scripts/wateractions.lua")

AddMinimapAtlas("images/tea_minimap.xml")



local function BackBucket(inst)
    local owner = inst.components.inventoryitem.owner
	if owner and owner.components.inventory then
		owner.components.inventory:GiveItem(GLOBAL.SpawnPrefab("bucket"))
	end
    inst:Remove()
end

TUNING.CLEANSOURCE =
{
	"oasislake",
	"hotspring"
}

local function CleanWater(inst)
	inst:AddTag("cleanwater")
end

for _, v in pairs(TUNING.CLEANSOURCE) do
	AddPrefabPostInit(v, function(inst) inst:AddTag("cleanwater") end)
end

--[[for k, v in pairs(require("preparedrink")) do
	AddCookerRecipe("kettle", v)
end]]--

--[[for k, v in pairs(require("prepareagedrink")) do
	AddCookerRecipe("brewery", v)
end]]--

--[[AddIngredientValues("foliage", {decoration=1, inedible=1})
AddIngredientValues("petals", {decoration=1, inedible=1})
AddIngredientValues("succulent_picked", {decoration=1, inedible=1})
AddIngredientValues("tealeaves", {decoration=1, inedible=1})
AddIngredientValues("beefalo_milk", {milk=1, dairy=1})
AddIngredientValues("moon_tree_blossom", {decoration=1, inedible=1})
AddIngredientValues("firenettles", {decoration=1, inedible=1})
AddIngredientValues("tillweeds", {decoration=1, inedible=1})]]--

AddPrefabPostInit("fertilizer", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	inst:DoTaskInTime(0, function()	
        inst.components.finiteuses:SetOnFinished(BackBucket)
	end)
end)

local function bottleadd(inst)

	inst.entity:AddSoundEmitter()
	
	local function OnFill(inst, from_object)
		local filleditem
		if from_object ~= nil then
			if from_object:HasTag("cleanwater") then
				filleditem = GLOBAL.SpawnPrefab("bottle_water")
			else
				filleditem = GLOBAL.SpawnPrefab("bottle_dirty")
			end
		else
			filleditem = GLOBAL.SpawnPrefab("bottle_salt")
		end
		
		inst.SoundEmitter:PlaySound("turnoftides/common/together/water/emerge/medium")
		
		if filleditem == nil then
			return false
		end
	
		local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem:GetGrandOwner() or nil
		if owner ~= nil then
			local container = owner.components.inventory or owner.components.container
			local item = container:RemoveItem(inst, false) or inst
			item:Remove()
			container:GiveItem(filleditem, nil, owner:GetPosition())
		else
			source.Transform:SetPosition(inst.Transform:GetWorldPosition())
			local item =
				inst.components.stackable ~= nil and
				inst.components.stackable:IsStack() and
				inst.components.stackable:Get() or
				inst
			item:Remove()
		end
		
		return true
	end
	inst:AddTag("fil_bottle")
	inst:AddTag("emptiy")
	
	inst:AddComponent("tradable")

    inst:AddComponent("fillable")
	inst.components.fillable.overrideonfillfn = OnFill
	inst.components.fillable.showoceanaction = true
	inst.components.fillable.acceptsoceanwater = true
end

AddPrefabPostInit("messagebottleempty",bottleadd)

-- bum: 이 코드가 말리기 위해 추가한 코드임
-- AFS: dryer:StartDrying calls dryable.components.perishable:GetPercent(), so we need to add such hack to
-- make tea leaves dryable on the rack.
AddComponentPostInit("dryer", function(self)
    local _StartDrying = self.StartDrying
    
    function self:StartDrying(dryable, ...)
        if dryable.components.dryable ~= nil and dryable.components.perishable == nil then
            dryable:AddComponent("perishable")
        end
        
        return _StartDrying(self, dryable, ...)
    end
end)
