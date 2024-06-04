local var0 = class("MainOpenSystemSequence")

function var0.Execute(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData()

	pg.SystemOpenMgr.GetInstance():notification(var0.level)
	arg1()
end

return var0
