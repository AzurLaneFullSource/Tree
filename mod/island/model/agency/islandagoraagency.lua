local var0_0 = class("IslandAgoraAgency", import(".IslandBaseAgency"))

var0_0.ADD_FURNITURE = "IslandAgoraAgency:ADD_FURNITURE"
var0_0.AGORA_UPGRADE = "IslandAgoraAgency:AGORA_UPGRADE"
var0_0.ADD_THEME = "IslandAgoraAgency:ADD_THEME"
var0_0.DEL_THEME = "IslandAgoraAgency:DEL_THEME"
var0_0.PLACEMENT_UPDATE = "IslandAgoraAgency:PLACEMENT_UPDATE"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.level = arg1_1.agora_level or 1
	arg0_1.maxLevel = table.getCount(IslandConst.AGORA_LEVEL_2_SIZE)
	arg0_1.furnitures = {}
	arg0_1.themes = {}
	arg0_1.systemThemes = {}
	arg0_1.isUpdateThemes = false

	for iter0_1, iter1_1 in ipairs(pg.island_furniture_theme.all) do
		local var0_1 = pg.island_furniture_theme[iter1_1]
		local var1_1 = require("Mod.Island.Agora.theme.theme_" .. iter1_1)
		local var2_1 = IslandTheme.New(var1_1)

		var2_1:SetName(var0_1.name)
		table.insert(arg0_1.systemThemes, var2_1)
	end

	arg0_1.placedData = IslandTheme.New(arg1_1)
	arg0_1.capacityList = {
		pg.island_set.island_build_capacity.key_value_int
	}
	arg0_1.consumeList = {}

	for iter2_1, iter3_1 in ipairs(pg.island_set.island_build_expansion.key_value_varchar) do
		table.insert(arg0_1.capacityList, iter3_1[3])
		table.insert(arg0_1.consumeList, iter3_1[2])
	end
end

function var0_0.InitPrivateData(arg0_2, arg1_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.furniture_list) do
		table.insert(var0_2, IslandFurniture.New(iter1_2))
	end

	local var1_2 = pg.island_set.island_pre_placement.key_value_varchar

	if var1_2[1] then
		local var2_2 = var1_2[1][1]

		if _.all(var0_2, function(arg0_3)
			return arg0_3.id ~= var2_2
		end) then
			table.insert(var0_2, IslandFurniture.New({
				count = 1,
				id = var2_2
			}))
		end
	end

	if var1_2[2] then
		local var3_2 = var1_2[2][1]

		if _.all(var0_2, function(arg0_4)
			return arg0_4.id ~= var3_2
		end) then
			table.insert(var0_2, IslandFurniture.New({
				count = 1,
				id = var3_2
			}))
		end
	end

	arg0_2.furnitures = var0_2
end

function var0_0.RawAddFurniture(arg0_5, arg1_5, arg2_5)
	assert(isa(arg1_5, IslandFurniture), "IslandAgoraAgency:AddFurniture: furniture must be IslandFurniture")

	local var0_5 = _.detect(arg0_5.furnitures, function(arg0_6)
		return arg0_6.id == arg1_5.id
	end)

	if var0_5 then
		var0_5.count = var0_5.count + 1
	else
		table.insert(arg0_5.furnitures, arg1_5)
	end
end

function var0_0.AddFurniture(arg0_7, arg1_7, arg2_7)
	assert(isa(arg1_7, IslandFurniture), "IslandAgoraAgency:AddFurniture: furniture must be IslandFurniture")

	local var0_7 = _.detect(arg0_7.furnitures, function(arg0_8)
		return arg0_8.id == arg1_7.id
	end)

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandFurnitureAdd(arg1_7.id, arg2_7 or ""))

	if var0_7 then
		var0_7.count = var0_7.count + 1

		arg0_7:DispatchEvent(var0_0.ADD_FURNITURE, var0_7)
	else
		IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.FURNITURE, 0, 1)

		local var1_7 = pg.island_furniture_template[arg1_7.id].type

		IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.FURNITURE, var1_7, 1)
		table.insert(arg0_7.furnitures, arg1_7)
		arg0_7:DispatchEvent(var0_0.ADD_FURNITURE, arg1_7)
	end
end

function var0_0.GetSystemThemes(arg0_9)
	return arg0_9.systemThemes
end

function var0_0.AddTheme(arg0_10, arg1_10)
	table.insert(arg0_10.themes, arg1_10)
	arg0_10:DispatchEvent(var0_0.ADD_THEME, arg1_10)
end

function var0_0.DelTheme(arg0_11, arg1_11)
	local var0_11 = _.detect(arg0_11.themes, function(arg0_12)
		return arg0_12.id == arg1_11
	end)

	if var0_11 then
		table.removebyvalue(arg0_11.themes, var0_11)
		arg0_11:DispatchEvent(var0_0.DEL_THEME, arg1_11)
	end
end

function var0_0.GetThemes(arg0_13)
	return arg0_13.themes
end

function var0_0.SetThemes(arg0_14, arg1_14)
	arg0_14.themes = arg1_14

	for iter0_14, iter1_14 in ipairs(arg0_14.themes) do
		arg0_14:DispatchEvent(var0_0.ADD_THEME, iter1_14)
	end

	arg0_14.isUpdateThemes = true
end

function var0_0.IsUpdateThemes(arg0_15)
	return arg0_15.isUpdateThemes
end

function var0_0.GetFurnitures(arg0_16)
	return arg0_16.furnitures
end

function var0_0.GetFurnituresByType(arg0_17, arg1_17)
	return underscore.select(arg0_17.furnitures, function(arg0_18)
		return pg.island_furniture_template[arg0_18.id].type == arg1_17
	end)
end

function var0_0.GetPlacedData(arg0_19)
	return arg0_19.placedData
end

function var0_0.GetCapacity(arg0_20)
	return arg0_20.capacityList[arg0_20.level] or 0
end

function var0_0.GetNextCapacity(arg0_21)
	if not arg0_21:CanUpgrade() then
		return arg0_21:GetCapacity()
	end

	return arg0_21.capacityList[arg0_21.level + 1] or 0
end

function var0_0.GetLevel(arg0_22)
	return arg0_22.level
end

function var0_0.CanUpgrade(arg0_23)
	return arg0_23.level < arg0_23.maxLevel
end

function var0_0.GetUpgradeConsume(arg0_24)
	if not arg0_24:CanUpgrade() then
		return nil
	end

	local var0_24 = arg0_24.consumeList[arg0_24.level] or {}

	return Drop.New({
		type = var0_24[1],
		id = var0_24[2],
		count = var0_24[3]
	})
end

function var0_0.Upgrade(arg0_25)
	arg0_25.level = arg0_25.level + 1

	local var0_25 = arg0_25:GetCapacity()

	arg0_25:DispatchEvent(var0_0.AGORA_UPGRADE, arg0_25.level, var0_25)
end

function var0_0.UpdatePlacedData(arg0_26, arg1_26, arg2_26)
	arg0_26.placedData = IslandTheme.New({
		placed_data = arg1_26
	})

	if not arg2_26 then
		arg0_26:DispatchEvent(var0_0.PLACEMENT_UPDATE, arg0_26.placedData)
	end
end

return var0_0
