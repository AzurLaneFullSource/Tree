local var0 = class("GetSpriteRequestPackage", import(".RequestPackage"))

function var0.__call(arg0)
	if arg0.stopped then
		return
	end

	local var0 = arg0.path
	local var1 = arg0.name

	PoolMgr.GetInstance():GetSprite(var0, var1, true, function(arg0)
		if arg0.stopped then
			PoolMgr.GetInstance():DecreasSprite(var0, var1)

			return
		end

		if arg0.onLoaded then
			arg0.onLoaded(arg0)
		end
	end)

	return arg0
end

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.path = arg1
	arg0.name = arg2
	arg0.onLoaded = arg3
end

return var0
