local var0_0 = class("DreamlandData")

var0_0.OP_GET_MAP_AWARD = 1
var0_0.OP_GET_EXPLORE_AWARD = 2
var0_0.OP_RECORD_EXPLORE = 3
var0_0.EXPLORE_TYPE_ONCE = 1
var0_0.EXPLORE_TYPE_HOLD = 2
var0_0.EXPLORE_SUBTYPE_4RAN_NORMAL = 1
var0_0.EXPLORE_SUBTYPE_3SEC = 2
var0_0.EXPLORE_SUBTYPE_3RAN_ACTION = 3
var0_0.EXPLORE_SUBTYPE_2RAN_ACTION = 4
var0_0.EXPLORE_SUBTYPE_EFFECT = 5
var0_0.EXPLORE_SUBTYPE_UNION = 6

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	local var0_1 = pg.activity_dreamland_event.all

	arg0_1.stories = _.map(var0_1, function(arg0_2)
		return pg.activity_dreamland_event[arg0_2]
	end)
	arg0_1.mapIds = pg.activity_dreamland_map.all
	arg0_1.exploreGroups = pg.activity_dreamland_explore.get_id_list_by_group
	arg0_1.exploreIds = pg.activity_dreamland_explore.all
	arg0_1.exploreRecords = {}
	arg0_1.mapAwards = {}
	arg0_1.exploreAwards = {}
	arg0_1.activityId = nil
	arg0_1.springShipIds = {}
	arg0_1.springSlotLockList = {}
	arg0_1.springMaxCnt = 0
	arg0_1.springAddition = 0

	arg0_1:UpdateActivityData(arg1_1)
	arg0_1:UpdateSpringActivityData(arg2_1)
end

function var0_0.UpdateSpringActivityData(arg0_3, arg1_3)
	arg0_3.springShipIds = _.map(arg1_3:GetShipIds(), function(arg0_4)
		if getProxy(BayProxy):RawGetShipById(arg0_4) then
			return arg0_4
		else
			return 0
		end
	end)
	arg0_3.springMaxCnt = arg1_3:GetSlotCount()
	arg0_3.springAddition = arg1_3:GetEnergyRecoverAddition()

	arg0_3:UpdateSpringSlotLockList()
end

function var0_0.UpdateSpringSlotLockList(arg0_5)
	local var0_5 = arg0_5:FindUnlockMaps()
	local var1_5 = 0

	for iter0_5, iter1_5 in ipairs(var0_5) do
		var1_5 = var1_5 + iter1_5.character_num
	end

	for iter2_5 = 1, arg0_5.springMaxCnt do
		local var2_5 = var1_5 < iter2_5

		arg0_5.springSlotLockList[iter2_5] = var2_5
	end
end

function var0_0.GetUnlockSpringCnt(arg0_6)
	local var0_6 = 0

	for iter0_6, iter1_6 in pairs(arg0_6.springSlotLockList) do
		if not iter1_6 then
			var0_6 = var0_6 + 1
		end
	end

	return var0_6
end

function var0_0.GetHotSpringAddition(arg0_7)
	return arg0_7.springAddition * 10
end

function var0_0.GetHotSpringData(arg0_8)
	return arg0_8.springShipIds
end

function var0_0.GetHotSpringMaxCnt(arg0_9)
	return arg0_9.springMaxCnt
end

function var0_0.IsLockSpringSlot(arg0_10, arg1_10)
	return arg0_10.springSlotLockList[arg1_10]
end

function var0_0.GetAllSpringShip(arg0_11)
	local var0_11 = {}
	local var1_11 = getProxy(BayProxy)
	local var2_11 = arg0_11:GetHotSpringData()

	for iter0_11, iter1_11 in ipairs(var2_11) do
		if iter1_11 > 0 then
			local var3_11 = var1_11:RawGetShipById(iter1_11)

			if var3_11 then
				local var4_11 = arg0_11:GetMapIdBySpringSlot(iter0_11)

				if not var0_11[var4_11] then
					var0_11[var4_11] = {}
				end

				table.insert(var0_11[var4_11], var3_11)
			end
		end
	end

	return var0_11
end

function var0_0.GetMapIdBySpringSlot(arg0_12, arg1_12)
	local var0_12 = arg0_12:FindUnlockMaps()
	local var1_12 = 0
	local var2_12 = 0

	for iter0_12, iter1_12 in ipairs(var0_12) do
		var2_12 = var2_12 + iter1_12.character_num

		if arg1_12 >= var1_12 + 1 and arg1_12 <= var2_12 then
			return iter1_12.id
		end

		var1_12 = var1_12 + iter1_12.character_num
	end

	return -1
end

function var0_0.MapId2MapGraph(arg0_13, arg1_13)
	local var0_13 = "DreamlandMapGraph" .. arg1_13

	if not _G[var0_13] then
		local var1_13 = pcall(function()
			_G[var0_13] = import("view.activity.Dreamland.graph." .. var0_13)
		end)
	end

	return _G[var0_13]
end

function var0_0.UpdateActivityData(arg0_15, arg1_15)
	arg0_15.activityId = arg1_15.id

	for iter0_15, iter1_15 in ipairs(arg1_15.data1_list) do
		arg0_15.mapAwards[iter1_15] = true
	end

	for iter2_15, iter3_15 in ipairs(arg1_15.data2_list) do
		arg0_15.exploreAwards[iter3_15] = true
	end

	for iter4_15, iter5_15 in ipairs(arg1_15.data3_list) do
		arg0_15.exploreRecords[iter5_15] = true
	end
end

function var0_0.GetActivityId(arg0_16)
	return arg0_16.activityId
end

function var0_0.ShouldShowChatTip(arg0_17, arg1_17)
	return not arg0_17:IsRecordExplore(arg1_17)
end

function var0_0.IsRecordExplore(arg0_18, arg1_18)
	local var0_18 = arg0_18:FindExploreObj(arg1_18).group
	local var1_18 = arg0_18.exploreGroups[var0_18] or {}

	return #var1_18 > 0 and _.any(var1_18, function(arg0_19)
		return arg0_18.exploreRecords[arg0_19] == true
	end)
end

local function var1_0(arg0_20)
	local var0_20 = pg.activity_dreamland_event[arg0_20].story

	return pg.NewStoryMgr.GetInstance():IsPlayed(var0_20)
end

function var0_0.FindPlayableStory(arg0_21)
	return (_.detect(arg0_21.stories, function(arg0_22)
		return not var1_0(arg0_22.id)
	end))
end

function var0_0.GetAllMapId(arg0_23)
	return arg0_23.mapIds
end

function var0_0.IsUnlockMap(arg0_24, arg1_24)
	local var0_24 = arg0_24:FindUnlockMaps()

	return _.any(var0_24, function(arg0_25)
		return arg0_25.id == arg1_24
	end)
end

function var0_0.IsUnlockAll(arg0_26)
	local var0_26 = arg0_26:GetAllMapId()

	return _.all(var0_26, function(arg0_27)
		return arg0_26:IsUnlockMap(arg0_27)
	end)
end

function var0_0.IsReceiveMapAward(arg0_28, arg1_28)
	return arg0_28.mapAwards[arg1_28] == true
end

function var0_0.FindMap(arg0_29, arg1_29)
	return pg.activity_dreamland_map[arg1_29]
end

function var0_0.FindUnlockMaps(arg0_30)
	local var0_30 = {}

	for iter0_30, iter1_30 in pairs(arg0_30.mapIds) do
		local var1_30 = pg.activity_dreamland_map[iter1_30]
		local var2_30 = var1_30.unlock_condition

		if var1_0(var2_30) then
			table.insert(var0_30, var1_30)
		end
	end

	return var0_30
end

function var0_0.IsFirstEvent(arg0_31)
	return _.all(arg0_31.stories, function(arg0_32)
		return not var1_0(arg0_32.id)
	end)
end

function var0_0.IsLastEvent(arg0_33)
	local var0_33 = 0

	for iter0_33, iter1_33 in ipairs(arg0_33.stories) do
		if not var1_0(iter1_33.id) then
			var0_33 = var0_33 + 1
		end
	end

	return var0_33 == 1
end

function var0_0.IsFinishAllEvent(arg0_34)
	return _.all(arg0_34.stories, function(arg0_35)
		return var1_0(arg0_35.id)
	end)
end

function var0_0.UnlockMap2UnlockExploreObj(arg0_36, arg1_36)
	local var0_36 = {}

	for iter0_36, iter1_36 in ipairs(arg1_36.explore) do
		local var1_36 = arg0_36.exploreGroups[iter1_36] or {}

		for iter2_36, iter3_36 in ipairs(var1_36) do
			local var2_36 = pg.activity_dreamland_explore[iter3_36]

			table.insert(var0_36, var2_36)
		end
	end

	return var0_36
end

function var0_0.FindCanInteractionExploreObj(arg0_37)
	local var0_37 = arg0_37:FindUnlockMaps()
	local var1_37 = {}

	for iter0_37, iter1_37 in ipairs(var0_37) do
		for iter2_37, iter3_37 in ipairs(arg0_37:UnlockMap2UnlockExploreObj(iter1_37)) do
			table.insert(var1_37, iter3_37)
		end
	end

	return var1_37
end

function var0_0.GetExploreSubType(arg0_38, arg1_38)
	for iter0_38, iter1_38 in ipairs(arg0_38.exploreIds) do
		local var0_38 = arg0_38:FindExploreObj(iter1_38)

		if var0_38.pic == arg1_38 then
			return var0_38.sub_type[1]
		end
	end

	if arg1_38 == "mengleyuan_qiqiu" then
		return var0_0.EXPLORE_SUBTYPE_4RAN_NORMAL
	end

	return 0
end

function var0_0.IsFinishMapExplore(arg0_39, arg1_39)
	local var0_39 = arg0_39:FindMap(arg1_39)

	return _.all(var0_39.explore, function(arg0_40)
		local var0_40 = arg0_39.exploreGroups[arg0_40] or {}

		return #var0_40 > 0 and _.any(var0_40, function(arg0_41)
			return arg0_39.exploreRecords[arg0_41] == true
		end)
	end)
end

function var0_0.IsReceiveExploreAward(arg0_42, arg1_42)
	return arg0_42.exploreAwards[arg1_42] == true
end

function var0_0.FindExploreObj(arg0_43, arg1_43)
	return pg.activity_dreamland_explore[arg1_43]
end

function var0_0.FindMapIdByExploreId(arg0_44, arg1_44)
	local var0_44 = arg0_44:FindUnlockMaps()

	for iter0_44, iter1_44 in ipairs(var0_44) do
		local var1_44 = arg0_44:UnlockMap2UnlockExploreObj(iter1_44)

		if _.any(var1_44, function(arg0_45)
			return arg0_45.id == arg1_44
		end) then
			return iter1_44.id
		end
	end

	return nil
end

function var0_0.GetMainExploreInMap(arg0_46, arg1_46)
	local var0_46 = arg1_46.explore
	local var1_46 = {}

	for iter0_46, iter1_46 in ipairs(var0_46) do
		local var2_46 = arg0_46.exploreGroups[iter1_46][1]

		if var2_46 ~= nil then
			table.insert(var1_46, var2_46)
		end
	end

	return var1_46
end

function var0_0.ExistAnyMapAward(arg0_47)
	local var0_47 = arg0_47:GetAllMapId()

	return _.any(var0_47, function(arg0_48)
		return arg0_47:IsUnlockMap(arg0_48) and not arg0_47:IsReceiveMapAward(arg0_48)
	end)
end

function var0_0.ExistAnyExploreAward(arg0_49)
	local var0_49 = arg0_49:GetAllMapId()

	return _.any(var0_49, function(arg0_50)
		return arg0_49:IsFinishMapExplore(arg0_50) and not arg0_49:IsReceiveExploreAward(arg0_50)
	end)
end

function var0_0.ExistAnyMapOrExploreAward(arg0_51)
	return arg0_51:ExistAnyMapAward() or arg0_51:ExistAnyExploreAward()
end

return var0_0
