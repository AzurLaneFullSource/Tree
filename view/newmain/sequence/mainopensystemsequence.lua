local var0_0 = class("MainOpenSystemSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(PlayerProxy):getRawData()

	pg.SystemOpenMgr.GetInstance():notification(var0_1.level)
	arg1_1()
end

return var0_0
