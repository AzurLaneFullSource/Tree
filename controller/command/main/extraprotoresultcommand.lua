local var0 = class("ExtraProtoResultCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	if var0.result == 9998 then
		getProxy(WorldProxy).isProtoLock = true

		pg.TipsMgr.GetInstance():ShowTips(i18n("world_close"))

		local var1 = getProxy(ContextProxy):getCurrentContext()
		local var2 = var1:retriveLastChild()

		if var2 and var2 ~= var1 then
			arg0:sendNotification(GAME.REMOVE_LAYERS, {
				context = var2
			})
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.MAINUI)
	else
		pg.TipsMgr.GetInstance():ShowTips(errorTip("", var0.result))
	end
end

return var0
