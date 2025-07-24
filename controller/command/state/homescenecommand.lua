local var0_0 = class("HomeSceneCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = arg1_1:getType()
	local var2_1 = getProxy(ContextProxy):getCurrentContext()
	local var3_1 = Context.New()

	var3_1:extendData(var1_1)
	SCENE.SetSceneInfo(var3_1, var0_1)

	var3_1.cleanStack = true

	arg0_1:sendNotification(GAME.LOAD_SCENE, {
		prevContext = var2_1,
		context = var3_1
	})
end

return var0_0
