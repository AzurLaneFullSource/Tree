local var0_0 = class("GoBackCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = arg1_1:getType() or 1
	local var2_1 = getProxy(ContextProxy)

	if var2_1:getContextCount() > 1 then
		local var3_1 = var2_1:popContext()
		local var4_1

		for iter0_1 = 1, var1_1 do
			if var2_1:getContextCount() > 0 then
				var4_1 = var2_1:popContext()
			else
				originalPrint("could not pop more context")

				break
			end
		end

		var4_1:extendData(var0_1)
		arg0_1:sendNotification(GAME.LOAD_SCENE, {
			isBack = true,
			prevContext = var3_1,
			context = var4_1
		})
	else
		originalPrint("no more context in the stack")
	end
end

return var0_0
