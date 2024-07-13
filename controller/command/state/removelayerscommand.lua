local var0_0 = class("RemoveLayersCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.context

	assert(isa(var1_1, Context), "should be an instance of Context")
	pg.SceneMgr.GetInstance():removeLayer(arg0_1.facade, var1_1, function()
		arg0_1:sendNotification(GAME.REMOVE_LAYER_DONE, var1_1)
		existCall(var0_1.callback)
	end)
end

return var0_0
