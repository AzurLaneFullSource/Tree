local var0 = class("GetSpineRequestPackage", import(".RequestPackage"))

function var0.__call(arg0)
	if arg0.stopped then
		return
	end

	local var0 = arg0.name

	PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
		if arg0.stopped then
			PoolMgr.GetInstance():ReturnSpineChar(var0, arg0)

			return
		end

		if arg0.onLoaded then
			arg0.onLoaded(arg0)
		end
	end)

	return arg0
end

function var0.Ctor(arg0, arg1, arg2)
	arg0.name = arg1
	arg0.path = "Spine"
	arg0.onLoaded = arg2
end

return var0
