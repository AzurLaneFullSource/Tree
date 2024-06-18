local var0_0 = class("BaseResourceField", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.attrs = {}
end

function var0_0.SetLevel(arg0_2, arg1_2)
	arg0_2._LV = arg1_2
	arg0_2.configId = arg1_2

	for iter0_2, iter1_2 in ipairs(arg0_2.attrs) do
		iter1_2:Update(arg0_2._LV)
	end
end

function var0_0.SetUpgradeTimeStamp(arg0_3, arg1_3)
	arg0_3._upgradeTimeStamp = arg1_3
end

function var0_0.GetUpgradeTimeStamp(arg0_4)
	return arg0_4._upgradeTimeStamp
end

function var0_0.GetDuration(arg0_5)
	if arg0_5._upgradeTimeStamp ~= 0 then
		return arg0_5._upgradeTimeStamp - pg.TimeMgr.GetInstance():GetServerTime()
	else
		return nil
	end
end

function var0_0.IsStarting(arg0_6)
	return arg0_6._upgradeTimeStamp > 0 and arg0_6._upgradeTimeStamp > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetSpendTime(arg0_7)
	return arg0_7:getConfig("time")
end

function var0_0.GetLevel(arg0_8)
	return arg0_8._LV
end

function var0_0.IsMaxLevel(arg0_9)
	local var0_9 = arg0_9:bindConfigTable()

	return arg0_9._LV == var0_9.all[#var0_9.all]
end

function var0_0.GetTargetLevel(arg0_10)
	return arg0_10:bindConfigTable()[arg0_10:GetLevel()].user_level
end

function var0_0.IsReachLevel(arg0_11)
	local var0_11 = getProxy(PlayerProxy):getRawData()
	local var1_11 = arg0_11:bindConfigTable()[arg0_11:GetLevel()]

	return var0_11.level >= var1_11.user_level
end

function var0_0.GetTargetRes(arg0_12)
	return arg0_12:bindConfigTable()[arg0_12:GetLevel()].use[2]
end

function var0_0.IsReachRes(arg0_13)
	local var0_13 = getProxy(PlayerProxy):getRawData()
	local var1_13 = arg0_13:bindConfigTable()[arg0_13:GetLevel()]

	return var0_13.gold >= var1_13.use[2]
end

function var0_0.CanUpgrade(arg0_14)
	if arg0_14:IsReachLevel() and arg0_14:IsReachRes() and not arg0_14:IsMaxLevel() and arg0_14._upgradeTimeStamp == 0 then
		return true
	end

	return false
end

function var0_0.isCommissionNotify(arg0_15, arg1_15)
	return arg0_15:getHourProduct() > arg0_15:getConfig("store") - arg1_15
end

function var0_0.GetCost(arg0_16)
	local var0_16 = arg0_16:getConfig("use")

	return {
		type = DROP_TYPE_RESOURCE,
		id = var0_16[1],
		count = var0_16[2]
	}
end

function var0_0.GetEffectAttrs(arg0_17)
	return arg0_17.attrs
end

function var0_0.GetName(arg0_18)
	assert(false)
end

function var0_0.getHourProduct(arg0_19)
	assert(false)
end

function var0_0.GetKeyWord(arg0_20)
	assert(false)
end

function var0_0.bindConfigTable(arg0_21)
	assert(false)
end

function var0_0.GetUpgradeType(arg0_22)
	assert(false)
end

function var0_0.GetResourceType(arg0_23)
	assert(false)
end

function var0_0.GetDesc(arg0_24)
	assert(false)
end

function var0_0.GetPlayerRes(arg0_25)
	assert(false)
end

function var0_0.HasRes(arg0_26)
	return arg0_26:GetPlayerRes() > 0
end

return var0_0
