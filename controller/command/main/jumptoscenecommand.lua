local var0_0 = class("JumpToSceneCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1[1]
	local var2_1 = var0_1[2]

	switch(var1_1, {
		[SCENE.CORE_ACTIVITY] = function()
			arg0_1:JumpToCoreActivity(var1_1, var2_1)
		end
	}, function()
		arg0_1:sendNotification(GAME.GO_SCENE, var1_1, var2_1)
	end)
end

function var0_0.JumpToCoreActivity(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg2_4.id

	if var0_4 and not getProxy(ActivityProxy):IsActivityNotEnd(var0_4) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

		return
	end

	arg0_4:sendNotification(GAME.GO_SCENE, arg1_4, arg2_4)
end

return var0_0
