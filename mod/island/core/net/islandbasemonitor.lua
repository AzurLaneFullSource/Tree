local var0_0 = class("IslandBaseMonitor")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.island = arg1_1

	arg0_1:onRegister()
end

function var0_0.emitCore(arg0_2, arg1_2, ...)
	arg0_2:GetIsland():DispatchEvent(IslandProxy.LINK_CORE, arg1_2, ...)
end

function var0_0.GetIsland(arg0_3)
	return arg0_3.island
end

function var0_0.IsCurrentIsland(arg0_4, arg1_4)
	return arg0_4.island.id == arg1_4
end

function var0_0.onRegister(arg0_5)
	arg0_5.event = {}

	arg0_5:register()
end

function var0_0.on(arg0_6, arg1_6, arg2_6)
	pg.ConnectionMgr.GetInstance():On(arg1_6, function(arg0_7)
		arg2_6(arg0_7)
	end)
	table.insert(arg0_6.event, arg1_6)
end

function var0_0.onRemove(arg0_8)
	arg0_8:remove()

	for iter0_8, iter1_8 in ipairs(arg0_8.event) do
		pg.ConnectionMgr.GetInstance():Off(iter1_8)
	end
end

function var0_0.Dispose(arg0_9)
	arg0_9:onRemove()
end

function var0_0.register(arg0_10)
	return
end

function var0_0.remove(arg0_11)
	return
end

return var0_0
