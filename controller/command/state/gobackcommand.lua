local var0 = class("GoBackCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = arg1:getType() or 1
	local var2 = getProxy(ContextProxy)

	if var2:getContextCount() > 1 then
		local var3 = var2:popContext()
		local var4

		for iter0 = 1, var1 do
			if var2:getContextCount() > 0 then
				var4 = var2:popContext()
			else
				originalPrint("could not pop more context")

				break
			end
		end

		var4:extendData(var0)
		arg0:sendNotification(GAME.LOAD_SCENE, {
			isBack = true,
			prevContext = var3,
			context = var4
		})
	else
		originalPrint("no more context in the stack")
	end
end

return var0
