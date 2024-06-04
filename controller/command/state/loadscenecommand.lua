local var0 = class("LoadSceneCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	var0.type = LOAD_TYPE_SCENE

	if not var0.isReload then
		var0.prevContext = var0.prevContext or getProxy(ContextProxy):getCurrentContext()
	end

	SCENE.CheckPreloadData(var0, function()
		arg0:sendNotification(GAME.LOAD_CONTEXT, var0)
	end)
end

return var0
