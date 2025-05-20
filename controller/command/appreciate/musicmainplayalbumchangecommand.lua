local var0_0 = class("MusicMainPlayAlbumChangeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().albumName
	local var1_1 = getProxy(AppreciateProxy)
	local var2_1
	local var3_1 = var0_1 == "none" and 0 or var0_1 == "favor" and 999 or var1_1:getAlbumMusicList(var0_1)[1]

	if not var3_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(17513, {
		music_no = var3_1,
		music_mode = var1_1.musicPlayerLoopType
	}, 17514, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:setMainPlayMusicAlbum(var3_1)
			arg0_1:sendNotification(GAME.APPRECIATE_CHANGE_MAIN_PLAY_ALBUM_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
