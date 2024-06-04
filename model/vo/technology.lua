local var0 = class("Technology", import(".BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.technology_data_template
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.poolId = arg1.pool_id
	arg0.time = arg1.time
	arg0.isQueue = arg1.queue
end

function var0.start(arg0, arg1)
	arg0.time = arg1
end

function var0.isActivate(arg0)
	return arg0.time > 0
end

function var0.isCompleted(arg0)
	return arg0:isFinish() and arg0:finishCondition()
end

function var0.isStarting(arg0)
	if not arg0:isActivate() then
		return false
	end

	return pg.TimeMgr.GetInstance():GetServerTime() < arg0.time
end

function var0.isWaiting(arg0)
	if not arg0:isActivate() then
		return false
	end

	return pg.TimeMgr.GetInstance():GetServerTime() < arg0.time - arg0:getConfig("time")
end

function var0.isDoing(arg0)
	if not arg0:isActivate() then
		return false
	end

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return var0 >= arg0.time - arg0:getConfig("time") and var0 < arg0.time
end

function var0.isFinish(arg0)
	if not arg0:isActivate() then
		return false
	end

	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.time
end

function var0.finishCondition(arg0)
	if arg0.isQueue then
		return true
	end

	local var0 = arg0:getConfig("condition")

	return var0 == 0 or getProxy(TaskProxy):getTaskVO(var0):isFinish()
end

function var0.hasResToStart(arg0)
	local var0 = arg0:getConfig("consume")
	local var1 = getProxy(PlayerProxy):getData()
	local var2 = getProxy(BagProxy)

	for iter0, iter1 in ipairs(var0) do
		if iter1[1] == DROP_TYPE_RESOURCE and var1:getResById(iter1[2]) < iter1[3] then
			return false, i18n("common_no_resource")
		elseif iter1[1] == DROP_TYPE_ITEM and var2:getItemCountById(iter1[2]) < iter1[3] then
			return false, i18n("common_no_item_1")
		end
	end

	return true
end

function var0.reset(arg0)
	arg0.time = 0
end

return var0
