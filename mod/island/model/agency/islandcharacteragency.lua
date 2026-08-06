local var0_0 = class("IslandCharacterAgency", import(".IslandBaseAgency"))

var0_0.ADD_SHIP = "IslandCharacterAgency:ADD_SHIP"
var0_0.SHIP_LEVEL_UP = "IslandCharacterAgency:SHIP_LEVEL_UP"
var0_0.SHIP_GET_STATE = "IslandCharacterAgency:SHIP_GET_STATE"
var0_0.CHANGE_CHARACTER_DRESS = "IslandCharacterAgency:CHANGE_CHARACTER_DRESS"
var0_0.SHIP_SKILL_STATE_CHANGE = "IslandCharacterAgency:SHIP_SKILL_STATE_CHANGE"
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

	arg0_1.gameViewIDList = {}

	for iter12_1, iter13_1 in ipairs(arg1_1.ship_sys.game_ship_list) do
		arg0_1.gameViewIDList[iter13_1.game_type] = iter13_1.ship_id
	end
end

function var0_0.SetMiniGameShipViewId(arg0_2, arg1_2, arg2_2)
	arg0_2.gameViewIDList[arg1_2] = arg2_2
end

function var0_0.GetViewGameShipViewId(arg0_3, arg1_3)
	return arg0_3.gameViewIDList[arg1_3]
end

function var0_0.CanFollowPlayer(arg0_4, arg1_4)
	local var0_4 = arg0_4.ships[arg1_4]

	if not var0_4 then
		return false
	end

	local var1_4 = var0_4:GetCantFollowTaskIdList()
	local var2_4 = false

	if #var1_4 > 0 then
		local var3_4 = arg0_4:GetHost():GetTaskAgency()

		var2_4 = _.any(var1_4, function(arg0_5)
			return var3_4:GetTask(arg0_5) ~= nil
		end)
	end

	return var0_4:GetState() == IslandShip.STATE_NORMAL and not var2_4
end

function var0_0.GetInviteList(arg0_6)
	return arg0_6.inviteList
end

function var0_0.AddInvite(arg0_7, arg1_7)
	table.insert(arg0_7.inviteList, arg1_7)
end

function var0_0.HasInvite(arg0_8, arg1_8)
	return _.any(arg0_8.inviteList, function(arg0_9)
		return arg1_8 == arg0_9
	end)
end

function var0_0.RemoveInvite(arg0_10, arg1_10)
	table.removebyvalue(arg0_10.inviteList, arg1_10)
end

function var0_0.GetShips(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.ships) do
		if iter1_11.id ~= var0_0.NPC_CONFIG_ID then
			table.insert(var0_11, iter1_11)
		end
	end

	return var0_11
end

function var0_0.GetShipsContainNpc(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12.ships) do
		table.insert(var0_12, iter1_12)
	end

	return var0_12
end

function var0_0.AddShip(arg0_13, arg1_13)
	arg0_13.ships[arg1_13.id] = arg1_13

	arg0_13:DispatchEvent(var0_0.ADD_SHIP, arg1_13)
end

function var0_0.GetShipById(arg0_14, arg1_14)
	return arg0_14.ships[arg1_14]
end

function var0_0.GetUnlockOrCanUnlockShipConfigIds(arg0_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(pg.island_chara_template.all) do
		if iter1_15 ~= var0_0.NPC_CONFIG_ID and (arg0_15.ships[iter1_15] or arg0_15:HasInvite(iter1_15)) then
			table.insert(var0_15, iter1_15)
		end
	end

	table.sort(var0_15, CompareFuncs({
		function(arg0_16)
			return arg0_15.ships[arg0_16] and 0 or 1
		end,
		function(arg0_17)
			return arg0_17
		end
	}))

	return var0_15
end

function var0_0.GetUnlockOrCanUnlockShipConfigIdsContainNpc(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in ipairs(pg.island_chara_template.all) do
		if arg0_18.ships[iter1_18] or arg0_18:HasInvite(iter1_18) then
			table.insert(var0_18, iter1_18)
		end
	end

	table.sort(var0_18, CompareFuncs({
		function(arg0_19)
			return arg0_18.ships[arg0_19] and 0 or 1
		end,
		function(arg0_20)
			return arg0_20
		end
	}))

	return var0_18
end

function var0_0.GetAllSkinCnt(arg0_21)
	local var0_21 = 0

	for iter0_21, iter1_21 in pairs(arg0_21.shipSkinDic) do
		var0_21 = var0_21 + #iter1_21
	end

	return var0_21
end

function var0_0.GetOwnSkinListByShipId(arg0_22, arg1_22)
	return arg0_22.shipSkinDic[arg1_22] or {}
end

function var0_0.AddSkin(arg0_23, arg1_23)
	local var0_23 = pg.island_skin_template[arg1_23].ship_group
	local var1_23 = arg0_23.shipSkinDic[var0_23] or {}

	table.insert(var1_23, IslandShipSkin.New({
		color_id = 0,
		id = arg1_23,
		color_list = {}
	}))

	arg0_23.shipSkinDic[var0_23] = var1_23
end

function var0_0.AddSkinColor(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = arg0_24.shipSkinDic[arg1_24] or {}

	for iter0_24, iter1_24 in ipairs(var0_24) do
		if iter1_24.id == arg2_24 then
			iter1_24:AddSkinColor(arg3_24)
		end
	end
end

function var0_0.GetCurrentSkinColorByShipId(arg0_25, arg1_25, arg2_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.shipSkinDic[arg1_25] or {}) do
		if iter1_25.id == arg2_25 then
			return iter1_25.color_id
		end
	end

	return 0
end

function var0_0.GetAllOwnDressDic(arg0_26)
	return arg0_26.hasDressData
end

function var0_0.GetDiffDressCnt(arg0_27)
	return #underscore.keys(arg0_27.hasDressData)
end

function var0_0.GetDiffDressCntByType(arg0_28, arg1_28)
	local var0_28 = {}

	for iter0_28, iter1_28 in pairs(arg0_28.hasDressData) do
		if pg.island_dress_template[iter0_28].type == arg1_28 and not table.contains(var0_28, iter0_28) then
			table.insert(var0_28, iter0_28)
		end
	end

	return #var0_28
end

function var0_0.ExistDressId(arg0_29, arg1_29)
	return arg0_29.hasDressData[arg1_29] ~= nil
end

function var0_0.GetDressIdRealCount(arg0_30, arg1_30)
	local var0_30 = arg0_30:GetOwnDressCountByDressId()

	for iter0_30, iter1_30 in pairs(arg0_30.shipWearDressData) do
		for iter2_30, iter3_30 in ipairs(iter1_30) do
			if iter3_30.dress_id == arg1_30 then
				var0_30 = var0_30 + 1
			end
		end
	end

	return var0_30
end

function var0_0.GetOwnDressCountByDressId(arg0_31, arg1_31)
	return arg0_31.hasDressData[arg1_31] and arg0_31.hasDressData[arg1_31].num or 0
end

function var0_0.AddDressItem(arg0_32, arg1_32, arg2_32, arg3_32)
	if not arg0_32.hasDressData[arg1_32] then
		local var0_32 = arg3_32 and 0 or 1

		arg0_32.hasDressData[arg1_32] = IslandOwnedDressItem.New({
			id = arg1_32,
			num = arg2_32,
			read = var0_32
		})
	else
		arg0_32.hasDressData[arg1_32].num = arg0_32.hasDressData[arg1_32].num + arg2_32

		if arg3_32 then
			arg0_32.hasDressData[arg1_32].read = 1
		end
	end
end

function var0_0.ReduceDressItem(arg0_33, arg1_33, arg2_33)
	if not arg0_33.hasDressData[arg1_33] then
		return
	end

	arg0_33.hasDressData[arg1_33].num = arg0_33.hasDressData[arg1_33].num - arg2_33
end

function var0_0.CheckSkinIsOwned(arg0_34, arg1_34)
	if arg1_34 == 0 then
		return true
	end

	local var0_34 = pg.island_skin_template[arg1_34].ship_group

	for iter0_34, iter1_34 in pairs(arg0_34:GetOwnSkinListByShipId(var0_34)) do
		if iter1_34.id == arg1_34 then
			return true
		end
	end

	return false
end

function var0_0.GetSkinData(arg0_35, arg1_35)
	if arg1_35 == 0 then
		return nil
	end

	local var0_35 = pg.island_skin_template[arg1_35].ship_group

	for iter0_35, iter1_35 in pairs(arg0_35:GetOwnSkinListByShipId(var0_35)) do
		if iter1_35.id == arg1_35 then
			return iter1_35
		end
	end

	return nil
end

function var0_0.SetSkinCurrentColor(arg0_36, arg1_36, arg2_36)
	if arg1_36 == 0 then
		return
	end

	local var0_36 = arg0_36:GetSkinData(arg1_36)

	if var0_36 then
		var0_36:SetCurrentColor(arg2_36)
	end
end

function var0_0.GetSkinCurrentColor(arg0_37, arg1_37)
	if arg1_37 == 0 then
		return 0
	end

	local var0_37 = arg0_37:GetSkinData(arg1_37)

	if var0_37 then
		return var0_37:GetCurrentColor()
	end

	return 0
end

function var0_0.CheckSkinColorIsOwned(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg0_38:GetSkinData(arg1_38)

	if not var0_38 then
		return false
	end

	return var0_38:CheckColorOwned(arg2_38)
end

function var0_0.GetHasDressData(arg0_39, arg1_39)
	return arg0_39.hasDressData[arg1_39]
end

function var0_0.SetDressHasRead(arg0_40, arg1_40)
	if not arg0_40.hasDressData[arg1_40] then
		return
	end

	arg0_40.hasDressData[arg1_40].read = 1
end

function var0_0.CheckRedDotByDressType(arg0_41, arg1_41)
	for iter0_41, iter1_41 in pairs(arg0_41.hasDressData) do
		if iter1_41:getConfigTable().type == arg1_41 and iter1_41.read == 0 then
			return true
		end
	end

	return false
end

function var0_0.GetCurDressIdByShipId(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg0_42.shipWearDressData[arg1_42] or {}

	for iter0_42, iter1_42 in ipairs(var0_42) do
		if iter1_42:getConfigTable().type == arg2_42 then
			return iter1_42
		end
	end

	return nil
end

function var0_0.DischargeDressOnShip(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.shipWearDressData[arg1_43] or {}
	local var1_43 = -1

	for iter0_43, iter1_43 in ipairs(var0_43) do
		if iter1_43.dress_id == arg2_43 then
			var1_43 = iter0_43
		end
	end

	if var1_43 ~= -1 then
		table.remove(var0_43, var1_43)
	end

	arg0_43.shipWearDressData[arg1_43] = var0_43
end

function var0_0.ChargeDressOnShip(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44.shipWearDressData[arg1_44] or {}

	table.insert(var0_44, IslandShipDressItem.New({
		ship_id = arg1_44,
		dress_id = arg2_44
	}))

	arg0_44.shipWearDressData[arg1_44] = var0_44
end

function var0_0.GetShipHoldedDressDic(arg0_45)
	return arg0_45.shipWearDressData
end

function var0_0.ResetShipSkillUsed(arg0_46)
	for iter0_46, iter1_46 in pairs(arg0_46.ships) do
		iter1_46:GetSkill():UpdateUsedToday(false)
	end
end

return var0_0
