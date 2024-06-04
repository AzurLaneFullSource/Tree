local var0 = class("RemoveLayersCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.context

	assert(isa(var1, Context), "should be an instance of Context")
	pg.SceneMgr.GetInstance():removeLayer(arg0.facade, var1, function()
		arg0:sendNotification(GAME.REMOVE_LAYER_DONE, var1)
		existCall(var0.callback)
	end)
end

return var0
