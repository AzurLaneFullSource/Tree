local var0 = class("MusicLikeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.musicID
	local var2 = var0.isAdd
	local var3 = getProxy(AppreciateProxy)

	pg.ConnectionMgr.GetInstance():Send(17507, {
		id = var1,
		action = var2
	}, 17508, function(arg0)
		if arg0.result == 0 then
			if var2 == 0 then
				var3:addMusicIDToLikeList(var1)
			elseif var2 == 1 then
				var3:removeMusicIDFromLikeList(var1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips("Like Fail" .. tostring(arg0.result))
		end
	end)
end

return var0
