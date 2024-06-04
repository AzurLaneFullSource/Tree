local var0 = class("InstagramActivity", import("..Activity"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.configIds = arg0:getConfig("config_data")
	arg0.times = arg0.data2_list
end

function var0.UpdateActiveCnt(arg0)
	arg0.data1 = arg0.data1 - 1
end

function var0.GetNextPushTime(arg0)
	local var0 = getProxy(InstagramProxy)

	for iter0, iter1 in ipairs(arg0.configIds) do
		local var1 = pg.activity_ins_template[iter1].group_id
		local var2 = arg0.times[iter0]

		if not var0:ExistGroup(var1) then
			return var2, iter1
		end
	end
end

function var0.GetCanActiveCnt(arg0)
	return arg0.data1
end

function var0.CanBeActivated(arg0)
	return true
end

function var0.ExistMsg(arg0)
	return #getProxy(InstagramProxy):GetMessages() > 0
end

return var0
