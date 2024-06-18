local var0_0 = class("GalleryLikeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.picID
	local var2_1 = var0_1.isAdd
	local var3_1 = var0_1.likeCBFunc
	local var4_1 = getProxy(AppreciateProxy)

	pg.ConnectionMgr.GetInstance():Send(17505, {
		id = var1_1,
		action = var2_1
	}, 17506, function(arg0_2)
		if arg0_2.result == 0 then
			if var2_1 == 0 then
				var4_1:addPicIDToLikeList(var1_1)
			elseif var2_1 == 1 then
				var4_1:removePicIDFromLikeList(var1_1)
			end

			if var3_1 then
				var3_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips("Like Fail" .. tostring(arg0_2.result))
		end
	end)
end

return var0_0
