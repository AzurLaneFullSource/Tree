local var0_0 = class("NewServerPTGood", import(".....model.vo.BaseVO"))

var0_0.GoodType = {
	MultiTotalLimit = 2,
	SingleLimit = 1,
	MultiEachLimit = 4,
	RandomLimit = 3
}

function var0_0.bindConfigTable(arg0_1)
	return pg.newserver_shop_template
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2
	arg0_2.configId = arg1_2
	arg0_2.configID = arg1_2
	arg0_2.count = -1
	arg0_2.multiEachInfoMap = {}
	arg0_2.isMultiEachLimit = false
end

function var0_0.updateAllInfo(arg0_3, arg1_3)
	local var0_3 = arg1_3.data2KeyValueList[arg0_3.configId]
	local var1_3 = var0_3.dataMap

	arg0_3.count = var0_3.value

	if arg0_3:getConfig("goods_type") == var0_0.GoodType.MultiEachLimit then
		arg0_3.isMultiEachLimit = true

		for iter0_3, iter1_3 in pairs(var1_3) do
			arg0_3.multiEachInfoMap[iter0_3] = iter1_3
		end
	end
end

function var0_0.updateCount(arg0_4, arg1_4)
	arg0_4.count = arg0_4.count - arg1_4
end

function var0_0.isLeftCount(arg0_5)
	return arg0_5.count > 0
end

function var0_0.getCount(arg0_6)
	return arg0_6.count
end

function var0_0.isSelectable(arg0_7)
	local var0_7 = arg0_7:getConfig("goods_type")

	return var0_7 == var0_0.GoodType.MultiTotalLimit or var0_7 == var0_0.GoodType.MultiEachLimit
end

function var0_0.getContainIDList(arg0_8)
	return arg0_8:getConfig("goods")
end

function var0_0.getUnlockIndex(arg0_9)
	return arg0_9:getConfig("unlock_time") / 604800 + 1
end

return var0_0
