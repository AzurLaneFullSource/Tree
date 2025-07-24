local var0_0 = class("AddItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	assert(isa(var0_1, Drop), "should be an instance of Drop")
	var0_1:AddItemOperation()
	PlayerConst.UpdateLinkActivity({
		var0_1
	})
end

return var0_0
