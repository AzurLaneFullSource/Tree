local var0_0 = class("IslandCharacterAgency", import(".IslandBaseAgency"))

var0_0.ADD_SHIP = "IslandCharacterAgency:ADD_SHIP"
var0_0.SHIP_LEVEL_UP = "IslandCharacterAgency:SHIP_LEVEL_UP"
var0_0.SHIP_GET_STATE = "IslandCharacterAgency:SHIP_GET_STATE"
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
end

function var0_0.GetInviteList(arg0_2)
	return arg0_2.inviteList
end

function var0_0.AddInvite(arg0_3, arg1_3)
	table.insert(arg0_3.inviteList, arg1_3)
end

function var0_0.HasInvite(arg0_4, arg1_4)
	return _.any(arg0_4.inviteList, function(arg0_5)
		return arg1_4 == arg0_5
	end)
end

function var0_0.RemoveInvite(arg0_6, arg1_6)
	table.removebyvalue(arg0_6.inviteList, arg1_6)
end

function var0_0.GetShips(arg0_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in pairs(arg0_7.ships) do
		if iter1_7.id ~= var0_0.NPC_CONFIG_ID then
			table.insert(var0_7, iter1_7)
		end
	end

	return var0_7
end

function var0_0.GetShipsContainNpc(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.ships) do
		table.insert(var0_8, iter1_8)
	end

	return var0_8
end

function var0_0.AddShip(arg0_9, arg1_9)
	arg0_9.ships[arg1_9.id] = arg1_9

	arg0_9:DispatchEvent(var0_0.ADD_SHIP, arg1_9)
end

function var0_0.GetShipById(arg0_10, arg1_10)
	return arg0_10.ships[arg1_10]
end

function var0_0.GetUnlockOrCanUnlockShipConfigIds(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in ipairs(pg.island_chara_template.all) do
		if iter1_11 ~= var0_0.NPC_CONFIG_ID and (arg0_11.ships[iter1_11] or arg0_11:HasInvite(iter1_11)) then
			table.insert(var0_11, iter1_11)
		end
	end

	table.sort(var0_11, CompareFuncs({
		function(arg0_12)
			return arg0_11.ships[arg0_12] and 0 or 1
		end,
		function(arg0_13)
			return arg0_13
		end
	}))

	return var0_11
end

function var0_0.GetUnlockOrCanUnlockShipConfigIdsContainNpc(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(pg.island_chara_template.all) do
		if arg0_14.ships[iter1_14] or arg0_14:HasInvite(iter1_14) then
			table.insert(var0_14, iter1_14)
		end
	end

	table.sort(var0_14, CompareFuncs({
		function(arg0_15)
			return arg0_14.ships[arg0_15] and 0 or 1
		end,
		function(arg0_16)
			return arg0_16
		end
	}))

	return var0_14
end

function var0_0.GetAllSkinCnt(arg0_17)
	local var0_17 = 0

	for iter0_17, iter1_17 in pairs(arg0_17.shipSkinDic) do
		var0_17 = var0_17 + #iter1_17
	end

	return var0_17
end

function var0_0.GetOwnSkinListByShipId(arg0_18, arg1_18)
	return arg0_18.shipSkinDic[arg1_18] or {}
end

function var0_0.AddSkin(arg0_19, arg1_19)
	local var0_19 = pg.island_skin_template[arg1_19].ship_group
	local var1_19 = arg0_19.shipSkinDic[var0_19] or {}

	table.insert(var1_19, IslandShipSkin.New({
		color_id = 0,
		id = arg1_19,
		color_list = {}
	}))

	arg0_19.shipSkinDic[var0_19] = var1_19
end

function var0_0.AddSkinColor(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = arg0_20.shipSkinDic[arg1_20] or {}

	for iter0_20, iter1_20 in ipairs(var0_20) do
		if iter1_20.id == arg2_20 then
			iter1_20:AddSkinColor(arg3_20)
		end
	end
end

function var0_0.GetCurrentSkinColorByShipId(arg0_21, arg1_21, arg2_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.shipSkinDic[arg1_21] or {}) do
		if iter1_21.id == arg2_21 then
			return iter1_21.color_id
		end
	end

	return 0
end

function var0_0.GetAllOwnDressDic(arg0_22)
	return arg0_22.hasDressData
end

function var0_0.GetDiffDressCnt(arg0_23)
	return #underscore.keys(arg0_23.hasDressData)
end

function var0_0.GetDiffDressCntByType(arg0_24, arg1_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg0_24.hasDressData) do
		if pg.island_dress_template[iter0_24].type == arg1_24 and not table.contains(var0_24, iter0_24) then
			table.insert(var0_24, iter0_24)
		end
	end

	for iter2_24, iter3_24 in pairs(arg0_24.ships) do
		local var1_24 = iter3_24:GetHasSendToShipDressByType(arg1_24)

		var0_24 = table.mergeArray(var0_24, var1_24, true)
	end

	return #var0_24
end

function var0_0.ExistDressId(arg0_25, arg1_25)
	if arg0_25.hasDressData[arg1_25] then
		return true
	end

	for iter0_25, iter1_25 in pairs(arg0_25.ships) do
		if iter1_25:CheckHasOwnDressByDressId(arg1_25) then
			return true
		end
	end

	return false
end

function var0_0.GetOwnDressCountByDressId(arg0_26, arg1_26)
	return arg0_26.hasDressData[arg1_26] and arg0_26.hasDressData[arg1_26].num or 0
end

function var0_0.AddDressItem(arg0_27, arg1_27, arg2_27)
	if not arg0_27.hasDressData[arg1_27] then
		arg0_27.hasDressData[arg1_27] = IslandOwnedDressItem.New({
			read = 0,
			id = arg1_27,
			num = arg2_27
		})
	else
		arg0_27.hasDressData[arg1_27].num = arg0_27.hasDressData[arg1_27].num + arg2_27
	end
end

function var0_0.ReduceDressItem(arg0_28, arg1_28, arg2_28)
	if not arg0_28.hasDressData[arg1_28] then
		return
	end

	arg0_28.hasDressData[arg1_28].num = arg0_28.hasDressData[arg1_28].num - arg2_28
end

function var0_0.CheckSkinIsOwned(arg0_29, arg1_29)
	if arg1_29 == 0 then
		return true
	end

	local var0_29 = pg.island_skin_template[arg1_29].ship_group

	for iter0_29, iter1_29 in pairs(arg0_29:GetOwnSkinListByShipId(var0_29)) do
		if iter1_29.id == arg1_29 then
			return true
		end
	end

	return false
end

function var0_0.GetSkinData(arg0_30, arg1_30)
	if arg1_30 == 0 then
		return nil
	end

	local var0_30 = pg.island_skin_template[arg1_30].ship_group

	for iter0_30, iter1_30 in pairs(arg0_30:GetOwnSkinListByShipId(var0_30)) do
		if iter1_30.id == arg1_30 then
			return iter1_30
		end
	end

	return nil
end

function var0_0.SetSkinCurrentColor(arg0_31, arg1_31, arg2_31)
	if arg1_31 == 0 then
		return
	end

	local var0_31 = arg0_31:GetSkinData(arg1_31)

	if var0_31 then
		var0_31:SetCurrentColor(arg2_31)
	end
end

function var0_0.CheckSkinColorIsOwned(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32:GetSkinData(arg1_32)

	if not var0_32 then
		return false
	end

	return var0_32:CheckColorOwned(arg2_32)
end

function var0_0.GetHasDressData(arg0_33, arg1_33)
	return arg0_33.hasDressData[arg1_33]
end

function var0_0.SetDressHasRead(arg0_34, arg1_34)
	if not arg0_34.hasDressData[arg1_34] then
		return
	end

	arg0_34.hasDressData[arg1_34].read = 1
end

function var0_0.CheckRedDotByDressType(arg0_35, arg1_35)
	for iter0_35, iter1_35 in pairs(arg0_35.hasDressData) do
		if pg.island_dress_template[iter0_35].type == arg1_35 and iter1_35.read == 0 then
			return true
		end
	end

	return false
end

return var0_0
