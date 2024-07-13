local var0_0 = class("ExtraProtoResultCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if var0_1.result == 9998 then
		getProxy(WorldProxy).isProtoLock = true

		pg.TipsMgr.GetInstance():ShowTips(i18n("world_close"))

		local var1_1 = getProxy(ContextProxy):getCurrentContext()
		local var2_1 = var1_1:retriveLastChild()

		if var2_1 and var2_1 ~= var1_1 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var2_1
			})
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.MAINUI)
	else
		pg.TipsMgr.GetInstance():ShowTips(errorTip("", var0_1.result))
	end
end

return var0_0
