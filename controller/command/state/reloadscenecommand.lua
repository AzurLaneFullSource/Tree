local var0_0 = class("ReloadSceneCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ContextProxy):popContext()

	var1_1:extendData(var0_1)
	arg0_1:sendNotification(GAME.LOAD_SCENE, {
		context = var1_1,
		prevContext = var1_1
	})
end

return var0_0
