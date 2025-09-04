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
		table.insert(arg0_1.hasDressList, IslandShipDressItem.New(iter3_1))
	end

	arg0_1.cap_Dic = {}

	for iter4_1, iter5_1 in ipairs(var0_1.cap_list) do
		arg0_1.cap_Dic[iter5_1.dress_id] = iter5_1.cap_id
	end
end

function var0_0.GetBodyHatIsOn(arg0_2, arg1_2, arg2_2)
	return arg0_2.cap_Dic[arg1_2] ~= 0
end

function var0_0.GetBodyHatDressId(arg0_3, arg1_3, arg2_3)
	return arg0_3.cap_Dic[arg1_3] or 0
end

function var0_0.SetBodyHatIsOn(arg0_4, arg1_4, arg2_4)
	arg0_4.cap_Dic[arg1_4] = arg2_4
end

function var0_0.GetDressByType(arg0_5, arg1_5)
	return arg0_5.currentDressTypeDic[arg1_5]
end

function var0_0.GetDressUpData(arg0_6)
	return arg0_6.currentDressTypeDic
end

function var0_0.SetDressByTpye(arg0_7, arg1_7, arg2_7)
	arg0_7.currentDressTypeDic[arg1_7] = arg2_7
end

function var0_0.GetAllHasDress(arg0_8)
	return arg0_8.hasDressList
end

function var0_0.GetHasDressByType(arg0_9, arg1_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.hasDressList) do
		if iter1_9:getConfig("type") == arg1_9 then
			table.insert(var0_9, iter1_9)
		end
	end

	return var0_9
end

function var0_0.CheckOwnDress(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.hasDressList) do
		if iter1_10.id == arg1_10 then
			return true
		end
	end

	return false
end

function var0_0.AddDressByDressId(arg0_11, arg1_11)
	table.insert(arg0_11.hasDressList, IslandShipDressItem.New({
		color = 0,
		state = 0,
		id = arg1_11,
		color_list = {}
	}))
end

function var0_0.IsNew(arg0_12)
	local var0_12 = arg0_12.currentDressTypeDic[IslandShipDressHelperNew.DressType.Hair]
	local var1_12 = arg0_12.currentDressTypeDic[IslandShipDressHelperNew.DressType.Face]
	local var2_12 = arg0_12.currentDressTypeDic[IslandShipDressHelperNew.DressType.Body]

	return var0_12 == nil and var1_12 == nil and var2_12 == nil
end

function var0_0.GetHairFaceBodyDress(arg0_13)
	local var0_13 = arg0_13:GetDressByType(IslandShipDressHelperNew.DressType.Hair)
	local var1_13 = arg0_13:GetDressByType(IslandShipDressHelperNew.DressType.Face)
	local var2_13 = arg0_13:GetDressByType(IslandShipDressHelperNew.DressType.Body)

	return var0_13, var1_13, var2_13
end

function var0_0.GetCurCommderId(arg0_14)
	local var0_14, var1_14, var2_14 = arg0_14:GetHairFaceBodyDress()

	return (IslandShipDressHelper.GetCurCommanderId(var0_14, var1_14, var2_14))
end

function var0_0.ChangeDress(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg1_15) do
		arg0_15:SetDressByTpye(iter1_15.type, iter1_15.id)
	end
end

function var0_0.ChangeDressColor(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.hasDressList) do
		if iter1_16.id == arg1_16.id then
			iter1_16:ChangeColor(arg1_16.color)
		end
	end
end

function var0_0.GetCurrentColorByDressId(arg0_17, arg1_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.hasDressList) do
		if iter1_17.id == arg1_17 then
			return iter1_17.color
		end
	end

	return 0
end

function var0_0.CheckDressColorIsOwned(arg0_18, arg1_18, arg2_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.hasDressList) do
		if iter1_18.id == arg1_18 then
			return iter1_18:CheckColorIsOwned(arg2_18)
		end
	end

	return false
end

function var0_0.AddDressColor(arg0_19, arg1_19, arg2_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.hasDressList) do
		if iter1_19.id == arg1_19 then
			return iter1_19:AddDressColor(arg2_19)
		end
	end

	return false
end

function var0_0.ChangeCapState(arg0_20, arg1_20)
	for iter0_20, iter1_20 in ipairs(arg1_20) do
		arg0_20:SetBodyHatIsOn(iter1_20.dress_id, iter1_20.cap_id)
	end
end

return var0_0
