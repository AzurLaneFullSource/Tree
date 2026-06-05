local var0_0 = class("IslandDressUpAgency", import(".IslandBaseAgency"))

var0_0.CHANGE_PLAYER_DRESS = "IslandDressUpAgency:CHANGE_DRESS"
var0_0.MORPH_PLAYER_DRESS = "IslandDressUpAgency:MORPH_PLAYER_DRESS"

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.user_dress

	arg0_1.currentDressTypeDic = {}

	for iter0_1, iter1_1 in ipairs(var0_1.cur_dress or {}) do
		arg0_1.currentDressTypeDic[iter1_1.type] = iter1_1.id
	end

	arg0_1.hasDressList = {}

	for iter2_1, iter3_1 in ipairs(var0_1.had_dress or {}) do
		table.insert(arg0_1.hasDressList, IslandCommanderDressItem.New(iter3_1))
	end

	arg0_1.cap_Dic = {}

	for iter4_1, iter5_1 in ipairs(var0_1.cap_list) do
		arg0_1.cap_Dic[iter5_1.dress_id] = iter5_1.cap_id
	end

	arg0_1.twinCurDic = {}

	for iter6_1, iter7_1 in ipairs(var0_1.twin_cur_list or {}) do
		arg0_1.twinCurDic[iter7_1] = true
	end
end

function var0_0.SetDressHasRead(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.hasDressList) do
		if iter1_2.id == arg1_2 then
			iter1_2:SetReadState(true)
		end
	end
end

function var0_0.CheckRedDotByDressType(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.hasDressList) do
		if iter1_3:getConfigTable().type == arg1_3 and iter1_3.state == 0 then
			return true
		end
	end

	return false
end

function var0_0.GetBodyHatIsOn(arg0_4, arg1_4)
	return arg0_4.cap_Dic[arg1_4] ~= 0
end

function var0_0.GetBodyHatDressId(arg0_5, arg1_5)
	return arg0_5.cap_Dic[arg1_5] or 0
end

function var0_0.SetBodyHatIsOn(arg0_6, arg1_6, arg2_6)
	arg0_6.cap_Dic[arg1_6] = arg2_6
end

function var0_0.GetDressByType(arg0_7, arg1_7)
	return arg0_7.currentDressTypeDic[arg1_7]
end

function var0_0.GetDressUpData(arg0_8)
	return arg0_8.currentDressTypeDic
end

function var0_0.SetDressByTpye(arg0_9, arg1_9, arg2_9)
	arg0_9.currentDressTypeDic[arg1_9] = arg2_9
end

function var0_0.GetAllHasDress(arg0_10)
	return arg0_10.hasDressList
end

function var0_0.GetHasDressByType(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.hasDressList) do
		if iter1_11:getConfig("type") == arg1_11 then
			table.insert(var0_11, iter1_11)
		end
	end

	return var0_11
end

function var0_0.CheckOwnDress(arg0_12, arg1_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.hasDressList) do
		if iter1_12.id == arg1_12 then
			return true
		end
	end

	return false
end

function var0_0.AddDressByDressId(arg0_13, arg1_13)
	table.insert(arg0_13.hasDressList, IslandCommanderDressItem.New({
		color = 0,
		state = 0,
		id = arg1_13,
		color_list = {}
	}))

	local var0_13 = pg.island_dress_template[arg1_13]

	if var0_13.type == IslandShipDressHelperNew.DressType.Body then
		local var1_13 = (pg.island_dress_template.get_id_list_by_related_dress[arg1_13] or {})[1]

		if var1_13 then
			arg0_13:SetBodyHatIsOn(arg1_13, var1_13)
		end
	end

	if var0_13 and var0_13.cloth_related and var0_13.cloth_related ~= 0 then
		local var2_13

		if var0_13.defalut_cloth == 1 then
			var2_13 = arg1_13
		else
			local var3_13 = pg.island_dress_template[var0_13.cloth_related]

			var2_13 = var3_13 and var3_13.defalut_cloth == 1 and var0_13.cloth_related or arg1_13
		end

		arg0_13.twinCurDic[var2_13] = true
	end
end

function var0_0.IsNew(arg0_14)
	local var0_14 = arg0_14.currentDressTypeDic[IslandShipDressHelperNew.DressType.Hair]
	local var1_14 = arg0_14.currentDressTypeDic[IslandShipDressHelperNew.DressType.Face]
	local var2_14 = arg0_14.currentDressTypeDic[IslandShipDressHelperNew.DressType.Body]

	return var0_14 == nil and var1_14 == nil and var2_14 == nil
end

function var0_0.GetHairFaceBodyDress(arg0_15)
	local var0_15 = arg0_15:GetDressByType(IslandShipDressHelperNew.DressType.Hair)
	local var1_15 = arg0_15:GetDressByType(IslandShipDressHelperNew.DressType.Face)
	local var2_15 = arg0_15:GetDressByType(IslandShipDressHelperNew.DressType.Body)

	return var0_15, var1_15, var2_15
end

function var0_0.ChangeDress(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(arg1_16) do
		arg0_16:SetDressByTpye(iter1_16.type, iter1_16.id)

		if iter1_16.type == IslandShipDressHelperNew.DressType.Body then
			local var0_16 = arg0_16:GetMorphTargetId(iter1_16.id)

			if var0_16 and var0_16 ~= 0 then
				arg0_16:SetTwinCurId(var0_16, iter1_16.id)
			end
		end
	end
end

function var0_0.ChangeDressColor(arg0_17, arg1_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.hasDressList) do
		if iter1_17.id == arg1_17.id then
			iter1_17:ChangeColor(arg1_17.color)
		end
	end
end

function var0_0.GetCurrentColorByDressId(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.hasDressList) do
		if iter1_18.id == arg1_18 then
			return iter1_18.color
		end
	end

	return 0
end

function var0_0.CheckDressColorIsOwned(arg0_19, arg1_19, arg2_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.hasDressList) do
		if iter1_19.id == arg1_19 then
			return iter1_19:CheckColorIsOwned(arg2_19)
		end
	end

	return false
end

function var0_0.AddDressColor(arg0_20, arg1_20, arg2_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.hasDressList) do
		if iter1_20.id == arg1_20 then
			return iter1_20:AddDressColor(arg2_20)
		end
	end

	return false
end

function var0_0.ChangeCapState(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(arg1_21) do
		arg0_21:SetBodyHatIsOn(iter1_21.dress_id, iter1_21.cap_id)
	end
end

function var0_0.GetTwinCurId(arg0_22, arg1_22)
	if arg0_22.twinCurDic[arg1_22] then
		return arg1_22
	end

	local var0_22 = pg.island_dress_template[arg1_22]

	if var0_22 and var0_22.cloth_related and var0_22.cloth_related ~= 0 and arg0_22.twinCurDic[var0_22.cloth_related] then
		return var0_22.cloth_related
	end

	return 0
end

function var0_0.SetTwinCurId(arg0_23, arg1_23, arg2_23)
	local var0_23 = pg.island_dress_template[arg1_23]

	if var0_23 and var0_23.cloth_related and var0_23.cloth_related ~= 0 then
		arg0_23.twinCurDic[var0_23.cloth_related] = nil
	end

	arg0_23.twinCurDic[arg1_23] = nil
	arg0_23.twinCurDic[arg2_23] = true
end

function var0_0.GetMorphTargetId(arg0_24, arg1_24)
	if not arg1_24 or arg1_24 == 0 then
		return 0
	end

	local var0_24 = pg.island_dress_template[arg1_24]

	if not var0_24 then
		return 0
	end

	return var0_24.cloth_related or 0
end

return var0_0
