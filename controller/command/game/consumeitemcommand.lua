local var0 = class("ConsumeItemCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	if var0.type == DROP_TYPE_RESOURCE then
		local var1 = id2res(var0.id)

		assert(var1, "res should be defined: " .. var0.id)

		local var2 = getProxy(PlayerProxy)
		local var3 = var2:getData()

		var3:consume({
			[var1] = var0.count
		})
		var2:updatePlayer(var3)
	elseif var0.type == DROP_TYPE_ITEM then
		getProxy(BagProxy):removeItemById(var0.id, var0.count)
	else
		assert(false, "no support for type --" .. var0.type)
	end
end

return var0
