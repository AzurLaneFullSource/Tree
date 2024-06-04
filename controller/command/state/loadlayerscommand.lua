local var0 = class("LoadLayersCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	var0.type = LOAD_TYPE_LAYER

	var0.context:extendData({
		isLayer = true
	})
	SCENE.CheckPreloadData(var0, function()
		arg0:sendNotification(GAME.LOAD_CONTEXT, var0)
	end)
end

return var0
