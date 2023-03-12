--[[local function OnEaten(inst, eater)
    local item = SpawnPrefab("cup")
    local stacksize = eater.components.eater.eatwholestack and inst.components.stackable:StackSize() or 1
    item.components.stackable:SetStackSize(stacksize)
    RefundItem(inst, "cup", true)
end]]

local function OnTake(inst, taker, delta)
    local stacksize = math.clamp(math.floor(delta/TUNING.CUP_MAX_LEVEL), 1, inst.components.stackable:StackSize())

    if inst.components.stackable:IsStack() then
        inst.components.stackable:Get(stacksize):Remove()
    else
        inst:Remove()
    end
end

local function MakeCup(name, masterfn, tags)
    local assets =
    {
        Asset("ANIM", "anim/kettle_drink.zip"),
        Asset("ANIM", "anim/kettle_drink_bottle.zip"),
    }

    local prefabs =
    {
        "cup",
    }

    local function Isice(name)
        return name == "water_clean_ice" or name == "water_dirty_ice"
    end

    local function onfiremelt(inst)
    inst.components.perishable.frozenfiremult = true
    end

    local function onstopfiremelt(inst)
        inst.components.perishable.frozenfiremult = false
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("kettle_drink")
    	inst.AnimState:SetBuild("kettle_drink")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap", "kettle_drink", name)

        if tags ~= nil then
            for k, v in ipairs(tags) do
                inst:AddTag(v)
            end
        end

        if not Isice(name) then
            inst:AddTag("pre-preparedfood")
            inst:AddTag("drink")
        end

        MakeInventoryFloatable(inst)
        
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        if not Isice(name) then
            inst:AddComponent("edible")
            inst.components.edible.foodtype = FOODTYPE.GOODIES
        else
            inst:AddTag("frozen")

            inst:AddComponent("smotherer")

            inst:ListenForEvent("firemelt", onfiremelt)
            inst:ListenForEvent("stopfiremelt", onstopfiremelt)

            inst:AddComponent("perishable")
            inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
            inst.components.perishable:StartPerishing()
            --inst.components.perishable:SetOnPerishFn(onperish)
        end
        --inst.components.edible:SetOnEatenFn(OnEaten)

        inst:AddComponent("inspectable")

        inst:AddComponent("water")
        inst.components.water.watervalue = TUNING.CUP_MAX_LEVEL
        inst.components.water:SetOnTakenFn(OnTake)
        --inst.components.returnprefab = "cup"

        inst:AddComponent("watersource")
        inst.components.watersource.available = false

    	inst:AddComponent("inventoryitem")
        if Isice(name) then
            inst.components.inventoryitem:SetOnPickupFn(onstopfiremelt)
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM

        --It's weird for a cup/bottle of water to burn, isn't it?
        --MakeSmallBurnable(inst)
        --MakeSmallPropagator(inst)
        MakeHauntableLaunchAndPerish(inst)
        MakeDynamicCupImage(inst, "swap", "kettle_drink")

        if masterfn ~= nil then
            masterfn(inst)
        end

        ------------------------------------------------

        inst:AddComponent("tradable")

        ------------------------------------------------

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function cleanwater(inst)
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible.thirstvalue = TUNING.HYDRATION_SMALLTINY

    inst:AddTag("icebox_valid")

    inst.components.water:SetWaterType(WATERTYPE.CLEAN)

    inst.components.watersource.available = true
end

local function dirtywater(inst)
    inst.components.edible.healthvalue = -TUNING.HEALING_TINY
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible.thirstvalue = TUNING.HYDRATION_SMALLTINY

    inst:AddTag("icebox_valid")

    inst.components.water:SetWaterType(WATERTYPE.DIRTY)

    inst.components.watersource.available = true
end

local function cleanwater_ice(inst)
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible.thirstvalue = 0

    inst:AddTag("icebox_valid")

    inst.components.water:SetWaterType(WATERTYPE.CLEAN_ICE)

    inst.components.watersource.available = true

    inst.components.perishable.onperishreplacement = "cleanwater"
end

local function dirtywater_ice(inst)
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 0
    inst.components.edible.thirstvalue = 0

    inst:AddTag("icebox_valid")

    inst.components.water:SetWaterType(WATERTYPE.DIRTY_ICE)

    inst.components.watersource.available = true

    inst.components.perishable.onperishreplacement = "dirtywater"
end

local function saltwater(inst)
    inst.components.edible.healthvalue = -TUNING.HEALING_SMALL
    inst.components.edible.hungervalue = -TUNING.DRINK_CALORIES
    inst.components.edible.sanityvalue = 0
    inst.components.edible.thirstvalue = TUNING.HYDRATION_SALT

    inst.components.water:SetWaterType(WATERTYPE.SALTY)
end

return MakeCup("water_clean", cleanwater),
    MakeCup("water_dirty", dirtywater),
    MakeCup("water_salty", saltwater)
