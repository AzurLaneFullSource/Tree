local var0_0 = class("IslandDressUpAgency", import(".IslandBaseAgency"))

var0_0.CHANGE_PLAYER_DRESS = "IslandDressUpAgency:CHANGE_DRESS"

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

function var0_0.GetBodyHatIsOn(arg0_4, arg1_4, arg2_4)
	return arg0_4.cap_Dic[arg1_4] ~= 0
end

function var0_0.GetBodyHatDressId(arg0_5, arg1_5, arg2_5)
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

function var0_0.GetCurCommderId(arg0_16)
	local var0_16, var1_16, var2_16 = arg0_16:GetHairFaceBodyDress()

	return (IslandShipDressHelper.GetCurCommanderId(var0_16, var1_16, var2_16))
end

function var0_0.ChangeDress(arg0_17, arg1_17)
	for iter0_17, iter1_17 in ipairs(arg1_17) do
		arg0_17:SetDressByTpye(iter1_17.type, iter1_17.id)
	end
end

function var0_0.ChangeDressColor(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.hasDressList) do
		if iter1_18.id == arg1_18.id then
			iter1_18:ChangeColor(arg1_18.color)
		end
	end
end

function var0_0.GetCurrentColorByDressId(arg0_19, arg1_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.hasDressList) do
		if iter1_19.id == arg1_19 then
			return iter1_19.color
		end
	end

	return 0
end

function var0_0.CheckDressColorIsOwned(arg0_20, arg1_20, arg2_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.hasDressList) do
		if iter1_20.id == arg1_20 then
			return iter1_20:CheckColorIsOwned(arg2_20)
		end
	end

	return false
end

function var0_0.AddDressColor(arg0_21, arg1_21, arg2_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.hasDressList) do
		if iter1_21.id == arg1_21 then
			return iter1_21:AddDressColor(arg2_21)
		end
	end

	return false
end

function var0_0.ChangeCapState(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(arg1_22) do
		arg0_22:SetBodyHatIsOn(iter1_22.dress_id, iter1_22.cap_id)
	end
end

return var0_0
