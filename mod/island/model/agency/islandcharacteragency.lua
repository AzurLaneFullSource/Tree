local var0_0 = class("IslandCharacterAgency", import(".IslandBaseAgency"))

var0_0.ADD_SHIP = "IslandCharacterAgency:ADD_SHIP"
var0_0.SHIP_LEVEL_UP = "IslandCharacterAgency:SHIP_LEVEL_UP"
var0_0.SHIP_GET_STATE = "IslandCharacterAgency:SHIP_GET_STATE"
var0_0.CHANGE_CHARACTER_DRESS = "IslandCharacterAgency:CHANGE_CHARACTER_DRESS"
var0_0.NPC_CONFIG_ID = 1

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.inviteList = {}
	arg0_1.ships = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.ship_sys.invite_list or {}) do
		table.insert(arg0_1.inviteList, iter1_1)
	end

	for iter2_1, iter3_1 in ipairs(arg1_1.ship_sys.ship_list or {}) do
		local var0_1 = IslandShip.New(iter3_1)

		arg0_1.ships[var0_1.id] = var0_1
	end

	local var1_1 = IslandNpcShip.New({
		id = var0_0.NPC_CONFIG_ID
	})

	arg0_1.ships[var1_1.id] = var1_1
	arg0_1.hasDressData = {}

	for iter4_1, iter5_1 in ipairs(arg1_1.ship_sys.had_dress or {}) do
		arg0_1.hasDressData[iter5_1.id] = IslandOwnedDressItem.New(iter5_1)
	end

	arg0_1.read_list = arg1_1.ship_sys.read_list
	arg0_1.shipSkinDic = {}

	for iter6_1, iter7_1 in ipairs(arg1_1.ship_sys.skin_list) do
		local var2_1 = arg0_1.shipSkinDic[iter7_1.ship_id] or {}

		for iter8_1, iter9_1 in ipairs(iter7_1.skin_list) do
			table.insert(var2_1, IslandShipSkin.New(iter9_1))
		end

		arg0_1.shipSkinDic[iter7_1.ship_id] = var2_1
	end

	arg0_1.shipWearDressData = {}

	for iter10_1, iter11_1 in ipairs(arg1_1.ship_sys.wear_list or {}) do
		local var3_1 = arg0_1.shipWearDressData[iter11_1.ship_id] or {}

		table.insert(var3_1, IslandShipDressItem.New(iter11_1))

		arg0_1.shipWearDressData[iter11_1.ship_id] = var3_1
	end
end

function var0_0.CanFollowPlayer(arg0_2, arg1_2)
	local var0_2 = arg0_2.ships[arg1_2]

	if not var0_2 then
		return false
	end

	local var1_2 = var0_2:GetCantFollowTaskIdList()
	local var2_2 = false

	if #var1_2 > 0 then
		local var3_2 = arg0_2:GetHost():GetTaskAgency()

		var2_2 = _.any(var1_2, function(arg0_3)
			return var3_2:GetTask(arg0_3) ~= nil
		end)
	end

	return var0_2:GetState() == IslandShip.STATE_NORMAL and not var2_2
end

function var0_0.GetInviteList(arg0_4)
	return arg0_4.inviteList
end

function var0_0.AddInvite(arg0_5, arg1_5)
	table.insert(arg0_5.inviteList, arg1_5)
end

function var0_0.HasInvite(arg0_6, arg1_6)
	return _.any(arg0_6.inviteList, function(arg0_7)
		return arg1_6 == arg0_7
	end)
end

function var0_0.RemoveInvite(arg0_8, arg1_8)
	table.removebyvalue(arg0_8.inviteList, arg1_8)
end

function var0_0.GetShips(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.ships) do
		if iter1_9.id ~= var0_0.NPC_CONFIG_ID then
			table.insert(var0_9, iter1_9)
		end
	end

	return var0_9
end

function var0_0.GetShipsContainNpc(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10.ships) do
		table.insert(var0_10, iter1_10)
	end

	return var0_10
end

function var0_0.AddShip(arg0_11, arg1_11)
	arg0_11.ships[arg1_11.id] = arg1_11

	arg0_11:DispatchEvent(var0_0.ADD_SHIP, arg1_11)
end

function var0_0.GetShipById(arg0_12, arg1_12)
	return arg0_12.ships[arg1_12]
end

function var0_0.GetUnlockOrCanUnlockShipConfigIds(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(pg.island_chara_template.all) do
		if iter1_13 ~= var0_0.NPC_CONFIG_ID and (arg0_13.ships[iter1_13] or arg0_13:HasInvite(iter1_13)) then
			table.insert(var0_13, iter1_13)
		end
	end

	table.sort(var0_13, CompareFuncs({
		function(arg0_14)
			return arg0_13.ships[arg0_14] and 0 or 1
		end,
		function(arg0_15)
			return arg0_15
		end
	}))

	return var0_13
end

function var0_0.GetUnlockOrCanUnlockShipConfigIdsContainNpc(arg0_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs(pg.island_chara_template.all) do
		if arg0_16.ships[iter1_16] or arg0_16:HasInvite(iter1_16) then
			table.insert(var0_16, iter1_16)
		end
	end

	table.sort(var0_16, CompareFuncs({
		function(arg0_17)
			return arg0_16.ships[arg0_17] and 0 or 1
		end,
		function(arg0_18)
			return arg0_18
		end
	}))

	return var0_16
end

function var0_0.GetAllSkinCnt(arg0_19)
	local var0_19 = 0

	for iter0_19, iter1_19 in pairs(arg0_19.shipSkinDic) do
		var0_19 = var0_19 + #iter1_19
	end

	return var0_19
end

function var0_0.GetOwnSkinListByShipId(arg0_20, arg1_20)
	return arg0_20.shipSkinDic[arg1_20] or {}
end

function var0_0.AddSkin(arg0_21, arg1_21)
	local var0_21 = pg.island_skin_template[arg1_21].ship_group
	local var1_21 = arg0_21.shipSkinDic[var0_21] or {}

	table.insert(var1_21, IslandShipSkin.New({
		color_id = 0,
		id = arg1_21,
		color_list = {}
	}))

	arg0_21.shipSkinDic[var0_21] = var1_21
end

function var0_0.AddSkinColor(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = arg0_22.shipSkinDic[arg1_22] or {}

	for iter0_22, iter1_22 in ipairs(var0_22) do
		if iter1_22.id == arg2_22 then
			iter1_22:AddSkinColor(arg3_22)
		end
	end
end

function var0_0.GetCurrentSkinColorByShipId(arg0_23, arg1_23, arg2_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.shipSkinDic[arg1_23] or {}) do
		if iter1_23.id == arg2_23 then
			return iter1_23.color_id
		end
	end

	return 0
end

function var0_0.GetAllOwnDressDic(arg0_24)
	return arg0_24.hasDressData
end

function var0_0.GetDiffDressCnt(arg0_25)
	return #underscore.keys(arg0_25.hasDressData)
end

function var0_0.GetDiffDressCntByType(arg0_26, arg1_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.hasDressData) do
		if pg.island_dress_template[iter0_26].type == arg1_26 and not table.contains(var0_26, iter0_26) then
			table.insert(var0_26, iter0_26)
		end
	end

	return #var0_26
end

function var0_0.ExistDressId(arg0_27, arg1_27)
	return arg0_27.hasDressData[arg1_27] ~= nil
end

function var0_0.GetDressIdRealCount(arg0_28, arg1_28)
	local var0_28 = arg0_28:GetOwnDressCountByDressId()

	for iter0_28, iter1_28 in pairs(arg0_28.shipWearDressData) do
		for iter2_28, iter3_28 in ipairs(iter1_28) do
			if iter3_28.dress_id == arg1_28 then
				var0_28 = var0_28 + 1
			end
		end
	end

	return var0_28
end

function var0_0.GetOwnDressCountByDressId(arg0_29, arg1_29)
	return arg0_29.hasDressData[arg1_29] and arg0_29.hasDressData[arg1_29].num or 0
end

function var0_0.AddDressItem(arg0_30, arg1_30, arg2_30, arg3_30)
	if not arg0_30.hasDressData[arg1_30] then
		local var0_30 = arg3_30 and 0 or 1

		arg0_30.hasDressData[arg1_30] = IslandOwnedDressItem.New({
			id = arg1_30,
			num = arg2_30,
			read = var0_30
		})
	else
		arg0_30.hasDressData[arg1_30].num = arg0_30.hasDressData[arg1_30].num + arg2_30

		if arg3_30 then
			arg0_30.hasDressData[arg1_30].read = 1
		end
	end
end

function var0_0.ReduceDressItem(arg0_31, arg1_31, arg2_31)
	if not arg0_31.hasDressData[arg1_31] then
		return
	end

	arg0_31.hasDressData[arg1_31].num = arg0_31.hasDressData[arg1_31].num - arg2_31
end

function var0_0.CheckSkinIsOwned(arg0_32, arg1_32)
	if arg1_32 == 0 then
		return true
	end

	local var0_32 = pg.island_skin_template[arg1_32].ship_group

	for iter0_32, iter1_32 in pairs(arg0_32:GetOwnSkinListByShipId(var0_32)) do
		if iter1_32.id == arg1_32 then
			return true
		end
	end

	return false
end

function var0_0.GetSkinData(arg0_33, arg1_33)
	if arg1_33 == 0 then
		return nil
	end

	local var0_33 = pg.island_skin_template[arg1_33].ship_group

	for iter0_33, iter1_33 in pairs(arg0_33:GetOwnSkinListByShipId(var0_33)) do
		if iter1_33.id == arg1_33 then
			return iter1_33
		end
	end

	return nil
end

function var0_0.SetSkinCurrentColor(arg0_34, arg1_34, arg2_34)
	if arg1_34 == 0 then
		return
	end

	local var0_34 = arg0_34:GetSkinData(arg1_34)

	if var0_34 then
		var0_34:SetCurrentColor(arg2_34)
	end
end

function var0_0.GetSkinCurrentColor(arg0_35, arg1_35)
	if arg1_35 == 0 then
		return 0
	end

	local var0_35 = arg0_35:GetSkinData(arg1_35)

	if var0_35 then
		return var0_35:GetCurrentColor()
	end

	return 0
end

function var0_0.CheckSkinColorIsOwned(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg0_36:GetSkinData(arg1_36)

	if not var0_36 then
		return false
	end

	return var0_36:CheckColorOwned(arg2_36)
end

function var0_0.GetHasDressData(arg0_37, arg1_37)
	return arg0_37.hasDressData[arg1_37]
end

function var0_0.SetDressHasRead(arg0_38, arg1_38)
	if not arg0_38.hasDressData[arg1_38] then
		return
	end

	arg0_38.hasDressData[arg1_38].read = 1
end

function var0_0.CheckRedDotByDressType(arg0_39, arg1_39)
	for iter0_39, iter1_39 in pairs(arg0_39.hasDressData) do
		if iter1_39:getConfigTable().type == arg1_39 and iter1_39.read == 0 then
			return true
		end
	end

	return false
end

function var0_0.GetCurDressIdByShipId(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40.shipWearDressData[arg1_40] or {}

	for iter0_40, iter1_40 in ipairs(var0_40) do
		if iter1_40:getConfigTable().type == arg2_40 then
			return iter1_40
		end
	end

	return nil
end

function var0_0.DischargeDressOnShip(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41.shipWearDressData[arg1_41] or {}
	local var1_41 = -1

	for iter0_41, iter1_41 in ipairs(var0_41) do
		if iter1_41.dress_id == arg2_41 then
			var1_41 = iter0_41
		end
	end

	if var1_41 ~= -1 then
		table.remove(var0_41, var1_41)
	end

	arg0_41.shipWearDressData[arg1_41] = var0_41
end

function var0_0.ChargeDressOnShip(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg0_42.shipWearDressData[arg1_42] or {}

	table.insert(var0_42, IslandShipDressItem.New({
		ship_id = arg1_42,
		dress_id = arg2_42
	}))

	arg0_42.shipWearDressData[arg1_42] = var0_42
end

function var0_0.GetShipHoldedDressDic(arg0_43)
	return arg0_43.shipWearDressData
end

return var0_0
