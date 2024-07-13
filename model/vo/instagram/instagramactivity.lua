local var0_0 = class("InstagramActivity", import("..Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.configIds = arg0_1:getConfig("config_data")
	arg0_1.times = arg0_1.data2_list
end

function var0_0.UpdateActiveCnt(arg0_2)
	arg0_2.data1 = arg0_2.data1 - 1
end

function var0_0.GetNextPushTime(arg0_3)
	local var0_3 = getProxy(InstagramProxy)

	for iter0_3, iter1_3 in ipairs(arg0_3.configIds) do
		local var1_3 = pg.activity_ins_template[iter1_3].group_id
		local var2_3 = arg0_3.times[iter0_3]

		if not var0_3:ExistGroup(var1_3) then
			return var2_3, iter1_3
		end
	end
end

function var0_0.GetCanActiveCnt(arg0_4)
	return arg0_4.data1
end

function var0_0.CanBeActivated(arg0_5)
	return true
end

function var0_0.ExistMsg(arg0_6)
	return #getProxy(InstagramProxy):GetMessages() > 0
end

return var0_0
