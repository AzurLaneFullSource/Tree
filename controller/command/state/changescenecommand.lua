local var0 = class("ChangeSceneCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = arg1:getType()
	local var2 = getProxy(ContextProxy):popContext()
	local var3 = Context.New()

	var3:extendData(var1)
	SCENE.SetSceneInfo(var3, var0)
	arg0:sendNotification(GAME.LOAD_SCENE, {
		prevContext = var2,
		context = var3
	})
end

return var0
