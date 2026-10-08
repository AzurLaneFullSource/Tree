local var0_0 = class("ActivityRemasterData", import("..BaseVO"))

var0_0.MAINTAIN = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.isFinish = false

	local var0_1, var1_1, var2_1, var3_1 = arg0_1:BuildAllAwards()

	arg0_1.collectionFurnitures = var0_1
	arg0_1.ships = var1_1
	arg0_1.equipmentSkins = var2_1
	arg0_1.other = var3_1
end

function var0_0.BuildAllAwards(arg0_2)
	local var0_2 = pg.activity_limit_item_guide_re.get_id_list_by_activity[arg0_2.configId] or {}
	local var1_2 = {}
	local var2_2 = {}
	local var3_2 = {}
	local var4_2 = {}

	for iter0_2, iter1_2 in ipairs(var0_2) do
		local var5_2 = ActivityRemasterAward.New(iter1_2)

		if var5_2:IsCollectionFurniture() then
			table.insert(var1_2, var5_2)
			table.insert(var4_2, var5_2)
		elseif var5_2:IsShip() then
			table.insert(var2_2, var5_2)
		elseif var5_2:IsEquipmentSkin() then
			table.insert(var3_2, var5_2)
		else
			table.insert(var4_2, var5_2)
		end
	end

	return var1_2, var2_2, var3_2, var4_2
end

function var0_0.bindConfigTable(arg0_3)
	return pg.activity_re
end

function var0_0.IsSpecial(arg0_4)
	return arg0_4:getConfig("is_special") == 1
end

function var0_0.GetBanner(arg0_5)
	return arg0_5:getConfig("banner")
end

function var0_0.IsFinish(arg0_6)
	return arg0_6.isFinish
end

function var0_0.MarkFinish(arg0_7)
	arg0_7.isFinish = true
end

function var0_0.GetFirstOpenActId(arg0_8)
	local var0_8 = arg0_8:getConfig("act_id")
	local var1_8 = getProxy(ActivityProxy)
	local var2_8 = _.detect(var0_8, function(arg0_9)
		local var0_9 = var1_8:RawGetActivityById(arg0_9)

		return var0_9 and not var0_9:isEnd()
	end)

	assert(var2_8 and var2_8 > 0, "")

	return var2_8
end

function var0_0.GetActList(arg0_10)
	return arg0_10:getConfig("act_id")
end

function var0_0.GetRawCollectableOtherList(arg0_11)
	return arg0_11.other
end

function var0_0.GetCollectableOtherList(arg0_12)
	local var0_12 = arg0_12.other

	return _.map(var0_12, function(arg0_13)
		local var0_13 = arg0_13:GetRawDropData()
		local var1_13 = var0_13[1]
		local var2_13 = var0_13[2]
		local var3_13 = var0_13[3]

		return {
			var1_13,
			var2_13,
			var3_13
		}
	end)
end

function var0_0.GetOtherOwnStr(arg0_14)
	local var0_14 = arg0_14:GetCollectableOtherList()
	local var1_14 = #var0_14
	local var2_14 = _.map(var0_14, function(arg0_15)
		return Drop.Create(arg0_15)
	end)
	local var3_14 = 0

	for iter0_14, iter1_14 in ipairs(var2_14) do
		if iter1_14:getOwnedCount() > 0 then
			var3_14 = var3_14 + 1
		end
	end

	return var3_14 .. "/" .. var1_14
end

function var0_0.GetRawCollectableEsList(arg0_16)
	return arg0_16.equipmentSkins
end

function var0_0.GetCollectableEsList(arg0_17)
	local var0_17 = arg0_17.equipmentSkins

	return _.map(var0_17, function(arg0_18)
		local var0_18 = arg0_18:GetRawDropData()
		local var1_18 = var0_18[1]
		local var2_18 = var0_18[2]
		local var3_18 = var0_18[3]

		return {
			DROP_TYPE_EQUIPMENT_SKIN,
			var2_18,
			var3_18
		}
	end)
end

function var0_0.GetEsOwnStr(arg0_19)
	local var0_19 = arg0_19.equipmentSkins
	local var1_19 = #var0_19
	local var2_19 = 0
	local var3_19 = getProxy(EquipmentProxy)

	for iter0_19, iter1_19 in ipairs(var0_19) do
		local var4_19 = iter1_19:GetRawDropData()

		if Drop.Create(var4_19):getOwnedCount() > 0 then
			var2_19 = var2_19 + 1
		end
	end

	return var2_19 .. "/" .. var1_19
end

function var0_0.GetRawCollectableShipIdList(arg0_20)
	return arg0_20.ships
end

function var0_0.GetCollectableShipIdList(arg0_21)
	local var0_21 = {}
	local var1_21 = arg0_21.ships

	return (_.map(var1_21, function(arg0_22)
		local var0_22 = arg0_22:GetRawDropData()
		local var1_22 = var0_22[1]
		local var2_22 = var0_22[2]
		local var3_22 = var0_22[3]

		return var2_22
	end))
end

function var0_0.GetShipProgress(arg0_23)
	local var0_23 = getProxy(CollectionProxy)
	local var1_23 = arg0_23:GetCollectableShipIdList()
	local var2_23 = 0

	for iter0_23, iter1_23 in ipairs(var1_23) do
		if var0_23:RawGetShipGroup(iter1_23) then
			var2_23 = var2_23 + 1
		end
	end

	return var2_23
end

function var0_0.GetShipTotalCnt(arg0_24)
	return #arg0_24:GetCollectableShipIdList()
end

function var0_0.GetShipOwnStr(arg0_25)
	local var0_25 = arg0_25:GetShipProgress()
	local var1_25 = arg0_25:GetShipTotalCnt()

	return var0_25 .. "/" .. var1_25
end

function var0_0.GetFurnitureProgress(arg0_26)
	local var0_26 = arg0_26.collectionFurnitures

	if #var0_26 <= 0 then
		return 0
	end

	local var1_26 = var0_26[1]:GetRawDropData()
	local var2_26 = var1_26[1]
	local var3_26 = var1_26[2]
	local var4_26 = var1_26[3]

	return getProxy(DormProxy):getRawData():GetOwnFurnitureCount(var3_26) >= 1 and 1 or 0
end

function var0_0.GetFurnitureTotalCnt(arg0_27)
	return 1
end

function var0_0.GetStartTime(arg0_28, arg1_28)
	local var0_28 = getProxy(ActivityRemasterProxy).actTimeID
	local var1_28 = pg.activity_re_timer[var0_28].timer[2]

	return pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_28)
end

function var0_0.GetActivityTimeDesc(arg0_29, arg1_29, arg2_29)
	local var0_29 = getProxy(ActivityRemasterProxy).actTimeID

	if not pg.activity_re_timer[var0_29] then
		return ""
	end

	local var1_29 = arg0_29:getConfig("act_time")
	local var2_29

	for iter0_29, iter1_29 in ipairs(var1_29) do
		if iter1_29[1] == arg1_29 then
			var2_29 = iter1_29

			break
		end
	end

	if not var2_29 then
		return ""
	end

	local var3_29 = getProxy(ActivityProxy):RawGetActivityById(arg1_29)

	if not var3_29 or var3_29:isEnd() then
		return ""
	end

	local var4_29 = pg.TimeMgr.GetInstance():STimeDescC(var3_29.stopTime, "%Y/%m/%d/%H/%M/%S")
	local var5_29 = string.split(var4_29, "/")
	local var6_29 = pg.activity_re_timer[var0_29].timer[2]
	local var7_29 = var2_29[1]
	local var8_29 = var2_29[2]
	local var9_29 = var2_29[3]
	local var10_29 = pg.activity_re_timer[var0_29].is_maintain == var0_0.MAINTAIN

	return GetActTimeDesc(arg2_29, var10_29, var6_29[1][2], var6_29[1][3], var5_29[2], var5_29[3], var5_29[4], var5_29[5], var5_29[6])
end

function var0_0.GetActivityTimeDescByBanner(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30:getConfig("act_time")
	local var1_30

	for iter0_30, iter1_30 in ipairs(var0_30) do
		if iter1_30[3] == arg1_30 then
			var1_30 = iter1_30[1]

			break
		end
	end

	if not var1_30 then
		return ""
	end

	return arg0_30:GetActivityTimeDesc(var1_30, arg2_30)
end

function var0_0.GetName(arg0_31)
	return arg0_31:getConfig("name") or ""
end

return var0_0
