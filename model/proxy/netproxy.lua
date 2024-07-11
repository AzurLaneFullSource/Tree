local var0_0 = class("NetProxy", pm.Proxy)

function var0_0.onRegister(arg0_1)
	arg0_1.event = {}

	arg0_1:register()
end

function var0_0.register(arg0_2)
	return
end

function var0_0.on(arg0_3, arg1_3, arg2_3)
	pg.ConnectionMgr.GetInstance():On(arg1_3, function(arg0_4)
		arg2_3(arg0_4)
	end)
	table.insert(arg0_3.event, arg1_3)
end

function var0_0.onRemove(arg0_5)
	arg0_5:remove()

	for iter0_5, iter1_5 in ipairs(arg0_5.event) do
		pg.ConnectionMgr.GetInstance():Off(iter1_5)
	end
end

function var0_0.remove(arg0_6)
	return
end

function var0_0.getRawData(arg0_7)
	return arg0_7.data
end

function var0_0.getData(arg0_8)
	return Clone(arg0_8.data)
end

function var0_0.timeCall(arg0_9)
	return {}
end

return var0_0
