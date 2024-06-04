local var0 = class("BaseResourceField", import("..BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.attrs = {}
end

function var0.SetLevel(arg0, arg1)
	arg0._LV = arg1
	arg0.configId = arg1

	for iter0, iter1 in ipairs(arg0.attrs) do
		iter1:Update(arg0._LV)
	end
end

function var0.SetUpgradeTimeStamp(arg0, arg1)
	arg0._upgradeTimeStamp = arg1
end

function var0.GetUpgradeTimeStamp(arg0)
	return arg0._upgradeTimeStamp
end

function var0.GetDuration(arg0)
	if arg0._upgradeTimeStamp ~= 0 then
		return arg0._upgradeTimeStamp - pg.TimeMgr.GetInstance():GetServerTime()
	else
		return nil
	end
end

function var0.IsStarting(arg0)
	return arg0._upgradeTimeStamp > 0 and arg0._upgradeTimeStamp > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.GetSpendTime(arg0)
	return arg0:getConfig("time")
end

function var0.GetLevel(arg0)
	return arg0._LV
end

function var0.IsMaxLevel(arg0)
	local var0 = arg0:bindConfigTable()

	return arg0._LV == var0.all[#var0.all]
end

function var0.GetTargetLevel(arg0)
	return arg0:bindConfigTable()[arg0:GetLevel()].user_level
end

function var0.IsReachLevel(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = arg0:bindConfigTable()[arg0:GetLevel()]

	return var0.level >= var1.user_level
end

function var0.GetTargetRes(arg0)
	return arg0:bindConfigTable()[arg0:GetLevel()].use[2]
end

function var0.IsReachRes(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = arg0:bindConfigTable()[arg0:GetLevel()]

	return var0.gold >= var1.use[2]
end

function var0.CanUpgrade(arg0)
	if arg0:IsReachLevel() and arg0:IsReachRes() and not arg0:IsMaxLevel() and arg0._upgradeTimeStamp == 0 then
		return true
	end

	return false
end

function var0.isCommissionNotify(arg0, arg1)
	return arg0:getHourProduct() > arg0:getConfig("store") - arg1
end

function var0.GetCost(arg0)
	local var0 = arg0:getConfig("use")

	return {
		type = DROP_TYPE_RESOURCE,
		id = var0[1],
		count = var0[2]
	}
end

function var0.GetEffectAttrs(arg0)
	return arg0.attrs
end

function var0.GetName(arg0)
	assert(false)
end

function var0.getHourProduct(arg0)
	assert(false)
end

function var0.GetKeyWord(arg0)
	assert(false)
end

function var0.bindConfigTable(arg0)
	assert(false)
end

function var0.GetUpgradeType(arg0)
	assert(false)
end

function var0.GetResourceType(arg0)
	assert(false)
end

function var0.GetDesc(arg0)
	assert(false)
end

function var0.GetPlayerRes(arg0)
	assert(false)
end

function var0.HasRes(arg0)
	return arg0:GetPlayerRes() > 0
end

return var0
