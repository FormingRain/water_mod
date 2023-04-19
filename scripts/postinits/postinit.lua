local postinits =
{
	components =
	{
		"stewer",
		"dryer",
		"eater",
		"edible",
		"inventoryitem_replica",
		"regrowthmanager",
		"wisecracker",
		"moisture",
		"inventoryitemmoisture",
	},

	prefabs =
	{
		"wateringcan",
		"antlion",
		"oasislake",
		"firepit",
		"player",
		"portablespicer",
		"staff",
	},

	stategraphs =
	{
		"SGwilson",
		"SGwilson_client",
	},

	widgets =
	{
		"itemtile",
	},

	utils =
	{
		"childplayer",
		"thirstvalue",
		"watertypes",
	},
}

if GetModConfigData("enable_thirst") then
	table.insert(postinits.components, "sleepingbag")
	table.insert(postinits.components, "sleepingbaguser")
	table.insert(postinits.prefabs, "wortox")
	table.insert(postinits.prefabs, "wickerbottom")
	table.insert(postinits.prefabs, "hats")
	table.insert(postinits.widgets, "statusdisplays")
	table.insert(postinits.widgets, "bloodover_water")
	table.insert(postinits.widgets, "healthbadge_water")
	table.insert(postinits.utils, "thirstvalue")
end

for dir, v in pairs(postinits) do
	for _, filename in ipairs(v) do
		modrequire("postinits/"..dir.."/"..filename)
	end
end
