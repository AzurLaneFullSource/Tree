local var0 = class("ApartmentDoTalkCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.talkId
	local var2 = var0.callback
	local var3 = pg.dorm3d_dialogue_group[var1].char_id
	local var4 = getProxy(ApartmentProxy)
	local var5 = var4:getApartment(var3)

	if var5.talkDic[var1] then
		existCall(var2)
		arg0:sendNotification(GAME.APARTMENT_DO_TALK_DONE, {
			talkId = var1
		})

		return
	end

	pg.ConnectionMgr.GetInstance():Send(28015, {
		dialog_id = var1
	}, 28016, function(arg0)
		if arg0.result == 0 then
			var5.talkDic[var1] = true

			var4:updateApartment(var5)

			local var0 = PlayerConst.addTranDrop(arg0.drop_list)

			existCall(var2, var0)
			arg0:sendNotification(GAME.APARTMENT_DO_TALK_DONE, {
				talkId = var1,
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
