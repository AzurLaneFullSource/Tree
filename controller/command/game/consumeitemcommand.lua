local var0_0 = class("ConsumeItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if var0_1.type == DROP_TYPE_RESOURCE then
		local var1_1 = id2res(var0_1.id)

		assert(var1_1, "res should be defined: " .. var0_1.id)

		local var2_1 = getProxy(PlayerProxy)
		local var3_1 = var2_1:getData()

		var3_1:consume({
			[var1_1] = var0_1.count
		})
		var2_1:updatePlayer(var3_1)
	elseif var0_1.type == DROP_TYPE_ITEM then
		getProxy(BagProxy):removeItemById(var0_1.id, var0_1.count)
	else
		assert(false, "no support for type --" .. var0_1.type)
	end
end

return var0_0
