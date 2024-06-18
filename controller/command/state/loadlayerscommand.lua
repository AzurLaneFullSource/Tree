local var0_0 = class("LoadLayersCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	var0_1.type = LOAD_TYPE_LAYER

	var0_1.context:extendData({
		isLayer = true
	})
	SCENE.CheckPreloadData(var0_1, function()
		arg0_1:sendNotification(GAME.LOAD_CONTEXT, var0_1)
	end)
end

return var0_0
