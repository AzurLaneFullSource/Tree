local var0 = class("GalleryLikeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.picID
	local var2 = var0.isAdd
	local var3 = var0.likeCBFunc
	local var4 = getProxy(AppreciateProxy)

	pg.ConnectionMgr.GetInstance():Send(17505, {
		id = var1,
		action = var2
	}, 17506, function(arg0)
		if arg0.result == 0 then
			if var2 == 0 then
				var4:addPicIDToLikeList(var1)
			elseif var2 == 1 then
				var4:removePicIDFromLikeList(var1)
			end

			if var3 then
				var3()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips("Like Fail" .. tostring(arg0.result))
		end
	end)
end

return var0
