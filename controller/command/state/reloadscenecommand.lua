local var0 = class("ReloadSceneCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ContextProxy):popContext()

	var1:extendData(var0)
	arg0:sendNotification(GAME.LOAD_SCENE, {
		isReload = true,
		context = var1
	})
end

return var0
