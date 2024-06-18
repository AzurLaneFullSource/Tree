local var0_0 = class("ApartmentDoTalkCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.talkId
	local var2_1 = var0_1.callback
	local var3_1 = pg.dorm3d_dialogue_group[var1_1].char_id
	local var4_1 = getProxy(ApartmentProxy)
	local var5_1 = var4_1:getApartment(var3_1)

	if var5_1.talkDic[var1_1] then
		existCall(var2_1)
		arg0_1:sendNotification(GAME.APARTMENT_DO_TALK_DONE, {
			talkId = var1_1
		})

		return
	end

	pg.ConnectionMgr.GetInstance():Send(28015, {
		dialog_id = var1_1
	}, 28016, function(arg0_2)
		if arg0_2.result == 0 then
			var5_1.talkDic[var1_1] = true

			var4_1:updateApartment(var5_1)

			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			existCall(var2_1, var0_2)
			arg0_1:sendNotification(GAME.APARTMENT_DO_TALK_DONE, {
				talkId = var1_1,
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
