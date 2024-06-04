local var0 = class("NewServerPTGood", import(".....model.vo.BaseVO"))

var0.GoodType = {
	MultiTotalLimit = 2,
	SingleLimit = 1,
	MultiEachLimit = 4,
	RandomLimit = 3
}

function var0.bindConfigTable(arg0)
	return pg.newserver_shop_template
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg1
	arg0.configID = arg1
	arg0.count = -1
	arg0.multiEachInfoMap = {}
	arg0.isMultiEachLimit = false
end

function var0.updateAllInfo(arg0, arg1)
	local var0 = arg1.data2KeyValueList[arg0.configId]
	local var1 = var0.dataMap

	arg0.count = var0.value

	if arg0:getConfig("goods_type") == var0.GoodType.MultiEachLimit then
		arg0.isMultiEachLimit = true

		for iter0, iter1 in pairs(var1) do
			arg0.multiEachInfoMap[iter0] = iter1
		end
	end
end

function var0.updateCount(arg0, arg1)
	arg0.count = arg0.count - arg1
end

function var0.isLeftCount(arg0)
	return arg0.count > 0
end

function var0.getCount(arg0)
	return arg0.count
end

function var0.isSelectable(arg0)
	local var0 = arg0:getConfig("goods_type")

	return var0 == var0.GoodType.MultiTotalLimit or var0 == var0.GoodType.MultiEachLimit
end

function var0.getContainIDList(arg0)
	return arg0:getConfig("goods")
end

function var0.getUnlockIndex(arg0)
	return arg0:getConfig("unlock_time") / 604800 + 1
end

return var0
