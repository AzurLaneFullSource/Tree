local var0_0 = class("MusicPlayLoopTypeChangeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().loopType
	local var1_1 = getProxy(AppreciateProxy)
	local var2_1

	if var0_1 == "list" then
		var2_1 = 0
	elseif var0_1 == "random" then
		var2_1 = 1
	elseif var0_1 == "one" then
		var2_1 = 2
	else
		return
	end

	pg.ConnectionMgr.GetInstance():Send(17513, {
		music_no = var1_1.mainMarkMusicId,
		music_mode = var2_1
	}, 17514, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:setMusicPlayerLoopType(var2_1)
			arg0_1:sendNotification(GAME.APPRECIATE_CHANGE_MUSIC_PLAY_LOOP_TYPE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
