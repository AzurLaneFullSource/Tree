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
		local var1_1, var2_1 = pcall(function()
			return require("Mod.Island.Agora.theme.theme_" .. iter1_1)
		end)

		if not var1_1 then
			var2_1 = {
				id = iter1_1,
				placed_data = {}
			}
		end

		local var3_1 = IslandTheme.New(var2_1)

		var3_1:SetName(var0_1.name)
		table.insert(arg0_1.systemThemes, var3_1)
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

function var0_0.InitPrivateData(arg0_3, arg1_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg1_3.furniture_list) do
		table.insert(var0_3, IslandFurniture.New(iter1_3))
	end

	local var1_3 = pg.island_set.island_pre_placement.key_value_varchar

	if var1_3[1] then
		local var2_3 = var1_3[1][1]

		if _.all(var0_3, function(arg0_4)
			return arg0_4.id ~= var2_3
		end) then
			table.insert(var0_3, IslandFurniture.New({
				count = 1,
				id = var2_3
			}))
		end
	end

	if var1_3[2] then
		local var3_3 = var1_3[2][1]

		if _.all(var0_3, function(arg0_5)
			return arg0_5.id ~= var3_3
		end) then
			table.insert(var0_3, IslandFurniture.New({
				count = 1,
				id = var3_3
			}))
		end
	end

	arg0_3.furnitures = var0_3
end

function var0_0.RawAddFurniture(arg0_6, arg1_6, arg2_6)
	assert(isa(arg1_6, IslandFurniture), "IslandAgoraAgency:AddFurniture: furniture must be IslandFurniture")

	local var0_6 = _.detect(arg0_6.furnitures, function(arg0_7)
		return arg0_7.id == arg1_6.id
	end)

	if var0_6 then
		var0_6.count = var0_6.count + 1
	else
		table.insert(arg0_6.furnitures, arg1_6)
	end
end

function var0_0.AddFurniture(arg0_8, arg1_8, arg2_8)
	assert(isa(arg1_8, IslandFurniture), "IslandAgoraAgency:AddFurniture: furniture must be IslandFurniture")

	local var0_8 = _.detect(arg0_8.furnitures, function(arg0_9)
		return arg0_9.id == arg1_8.id
	end)

	if not var0_8 then
		arg1_8:SetNew(true)
	end

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandFurnitureAdd(arg1_8.id, arg2_8 or ""))

	if var0_8 then
		var0_8.count = var0_8.count + 1

		arg0_8:DispatchEvent(var0_0.ADD_FURNITURE, var0_8)
	else
		IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.FURNITURE, 0, 1)

		local var1_8 = pg.island_furniture_template[arg1_8.id].type

		IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.FURNITURE, var1_8, 1)
		table.insert(arg0_8.furnitures, arg1_8)
		arg0_8:DispatchEvent(var0_0.ADD_FURNITURE, arg1_8)
	end
end

function var0_0.ClearNew(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.furnitures) do
		if iter1_10.configId == arg1_10 then
			iter1_10:SetNew(false)
		end
	end
end

function var0_0.ClearAllNew(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.furnitures) do
		iter1_11:SetNew(false)
	end
end

function var0_0.GetSystemThemes(arg0_12)
	return arg0_12.systemThemes
end

function var0_0.AddTheme(arg0_13, arg1_13)
	table.insert(arg0_13.themes, arg1_13)
	arg0_13:DispatchEvent(var0_0.ADD_THEME, arg1_13)
end

function var0_0.DelTheme(arg0_14, arg1_14)
	local var0_14 = _.detect(arg0_14.themes, function(arg0_15)
		return arg0_15.id == arg1_14
	end)

	if var0_14 then
		table.removebyvalue(arg0_14.themes, var0_14)
		arg0_14:DispatchEvent(var0_0.DEL_THEME, arg1_14)
	end
end

function var0_0.GetThemes(arg0_16)
	return arg0_16.themes
end

function var0_0.SetThemes(arg0_17, arg1_17)
	arg0_17.themes = arg1_17

	for iter0_17, iter1_17 in ipairs(arg0_17.themes) do
		arg0_17:DispatchEvent(var0_0.ADD_THEME, iter1_17)
	end

	arg0_17.isUpdateThemes = true
end

function var0_0.IsUpdateThemes(arg0_18)
	return arg0_18.isUpdateThemes
end

function var0_0.GetFurnitures(arg0_19)
	return arg0_19.furnitures
end

function var0_0.GetFurnituresByType(arg0_20, arg1_20)
	return underscore.select(arg0_20.furnitures, function(arg0_21)
		return pg.island_furniture_template[arg0_21.id].type == arg1_20
	end)
end

function var0_0.GetPlacedData(arg0_22)
	return arg0_22.placedData
end

function var0_0.GetCapacity(arg0_23)
	return arg0_23.capacityList[arg0_23.level] or 0
end

function var0_0.GetNextCapacity(arg0_24)
	if not arg0_24:CanUpgrade() then
		return arg0_24:GetCapacity()
	end

	return arg0_24.capacityList[arg0_24.level + 1] or 0
end

function var0_0.GetLevel(arg0_25)
	return arg0_25.level
end

function var0_0.CanUpgrade(arg0_26)
	return arg0_26.level < arg0_26.maxLevel
end

function var0_0.GetUpgradeConsume(arg0_27)
	if not arg0_27:CanUpgrade() then
		return nil
	end

	local var0_27 = arg0_27.consumeList[arg0_27.level] or {}

	return Drop.New({
		type = var0_27[1],
		id = var0_27[2],
		count = var0_27[3]
	})
end

function var0_0.Upgrade(arg0_28)
	arg0_28.level = arg0_28.level + 1

	local var0_28 = arg0_28:GetCapacity()

	arg0_28:DispatchEvent(var0_0.AGORA_UPGRADE, arg0_28.level, var0_28)
end

function var0_0.UpdatePlacedData(arg0_29, arg1_29, arg2_29)
	arg0_29.placedData = IslandTheme.New({
		placed_data = arg1_29
	})

	if not arg2_29 then
		arg0_29:DispatchEvent(var0_0.PLACEMENT_UPDATE, arg0_29.placedData)
	end
end

return var0_0
