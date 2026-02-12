local var0_0 = class("LoveLetterLevelUpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId

	if not getProxy(LoveLetterProxy):GetGroupData(var1_1):CanLevelUp() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(12408, {
		group_id = var1_1
	}, 12409, function(arg0_2)
		if arg0_2.ret == 0 then
			getProxy(LoveLetterProxy):LevelUp(var1_1)
			existCall(var0_1.callback)
			pg.m02:sendNotification(GAME.LOVE_LETTER_LEVEL_UP_DONE, {
				groupId = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.ret] .. arg0_2.ret)
		end
	end)
end

return var0_0
