local var0_0 = class("Technology", import(".BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.technology_data_template
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.poolId = arg1_2.pool_id
	arg0_2.time = arg1_2.time
	arg0_2.isQueue = arg1_2.queue
end

function var0_0.start(arg0_3, arg1_3)
	arg0_3.time = arg1_3
end

function var0_0.isActivate(arg0_4)
	return arg0_4.time > 0
end

function var0_0.isCompleted(arg0_5)
	return arg0_5:isFinish() and arg0_5:finishCondition()
end

function var0_0.isStarting(arg0_6)
	if not arg0_6:isActivate() then
		return false
	end

	return pg.TimeMgr.GetInstance():GetServerTime() < arg0_6.time
end

function var0_0.isWaiting(arg0_7)
	if not arg0_7:isActivate() then
		return false
	end

	return pg.TimeMgr.GetInstance():GetServerTime() < arg0_7.time - arg0_7:getConfig("time")
end

function var0_0.isDoing(arg0_8)
	if not arg0_8:isActivate() then
		return false
	end

	local var0_8 = pg.TimeMgr.GetInstance():GetServerTime()

	return var0_8 >= arg0_8.time - arg0_8:getConfig("time") and var0_8 < arg0_8.time
end

function var0_0.isFinish(arg0_9)
	if not arg0_9:isActivate() then
		return false
	end

	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_9.time
end

function var0_0.finishCondition(arg0_10)
	if arg0_10.isQueue then
		return true
	end

	local var0_10 = arg0_10:getConfig("condition")

	return var0_10 == 0 or getProxy(TaskProxy):getTaskVO(var0_10):isFinish()
end

function var0_0.hasResToStart(arg0_11)
	local var0_11 = arg0_11:getConfig("consume")
	local var1_11 = getProxy(PlayerProxy):getData()
	local var2_11 = getProxy(BagProxy)

	for iter0_11, iter1_11 in ipairs(var0_11) do
		if iter1_11[1] == DROP_TYPE_RESOURCE and var1_11:getResById(iter1_11[2]) < iter1_11[3] then
			return false, i18n("common_no_resource")
		elseif iter1_11[1] == DROP_TYPE_ITEM and var2_11:getItemCountById(iter1_11[2]) < iter1_11[3] then
			return false, i18n("common_no_item_1")
		end
	end

	return true
end

function var0_0.reset(arg0_12)
	arg0_12.time = 0
end

return var0_0
