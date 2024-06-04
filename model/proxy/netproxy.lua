local var0 = class("NetProxy", pm.Proxy)

function var0.onRegister(arg0)
	arg0.event = {}

	arg0:register()
end

function var0.register(arg0)
	return
end

function var0.on(arg0, arg1, arg2)
	pg.ConnectionMgr.GetInstance():On(arg1, function(arg0)
		arg2(arg0)
	end)
	table.insert(arg0.event, arg1)
end

function var0.onRemove(arg0)
	arg0:remove()

	for iter0, iter1 in ipairs(arg0.event) do
		pg.ConnectionMgr.GetInstance():Off(iter1)
	end
end

function var0.remove(arg0)
	return
end

function var0.getRawData(arg0)
	return arg0.data
end

function var0.getData(arg0)
	return Clone(arg0.data)
end

return var0
