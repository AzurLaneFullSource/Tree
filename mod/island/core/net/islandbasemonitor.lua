local var0_0 = class("IslandBaseMonitor")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.island = arg1_1

	arg0_1:onRegister()
end

function var0_0.GetIsland(arg0_2)
	return arg0_2.island
end

function var0_0.IsSelf(arg0_3, arg1_3)
	return arg0_3.island.id == arg1_3
end

function var0_0.onRegister(arg0_4)
	arg0_4.event = {}

	arg0_4:register()
end

function var0_0.on(arg0_5, arg1_5, arg2_5)
	pg.ConnectionMgr.GetInstance():On(arg1_5, function(arg0_6)
		arg2_5(arg0_6)
	end)
	table.insert(arg0_5.event, arg1_5)
end

function var0_0.onRemove(arg0_7)
	arg0_7:remove()

	for iter0_7, iter1_7 in ipairs(arg0_7.event) do
		pg.ConnectionMgr.GetInstance():Off(iter1_7)
	end
end

function var0_0.Dispose(arg0_8)
	arg0_8:onRemove()
end

function var0_0.register(arg0_9)
	return
end

function var0_0.remove(arg0_10)
	return
end

return var0_0
