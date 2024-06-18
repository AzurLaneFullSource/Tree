local var0_0 = class("FeastOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.activityId
	local var2_1 = var0_1.cmd or 0
	local var3_1 = var0_1.arg1 or 0
	local var4_1 = var0_1.arg2 or 0
	local var5_1 = var0_1.argList or {}
	local var6_1 = var0_1.kvpArgs or {}
	local var7_1 = var0_1.callback

	if var2_1 == FeastDorm.OP_RANDOM_SHIPS then
		pg.ConnectionMgr.GetInstance():Send(26158, {
			act_id = var1_1,
			ship_group_id = var5_1
		}, 26159, function(arg0_2)
			if arg0_2.ret == 0 then
				local var0_2 = getProxy(FeastProxy)
				local var1_2 = var0_2:getData()

				var1_2:SetRefreshTime(arg0_2.refresh_time)

				local var2_2 = {}

				for iter0_2, iter1_2 in ipairs(arg0_2.party_roles) do
					var2_2[iter1_2.tid] = true

					local var3_2 = var1_2:GetFeastShip(iter1_2.tid)

					if not var3_2 then
						local var4_2 = FeastShip.New(iter1_2)
						local var5_2 = var1_2:GetInvitedFeastShip(iter1_2.tid)

						if var5_2 ~= nil then
							var4_2:SetSkinId(var5_2:GetSkinId())
						end

						var1_2:AddShip(var4_2)
					else
						var3_2:UpdateBubble(iter1_2.bubble)
						var3_2:UpdateSpeechBubble(iter1_2.speech_bubble)
					end
				end

				for iter2_2, iter3_2 in pairs(var1_2:GetFeastShipList()) do
					if var2_2[iter2_2] ~= true then
						var1_2:RemoveShip(iter2_2)
					end
				end

				var0_2:UpdateData(var1_2)
				var0_2:AddRefreshTimer()
				arg0_1:sendNotification(GAME.FEAST_OP_DONE, {
					cmd = FeastDorm.OP_RANDOM_SHIPS,
					ships = var1_2:GetPutShipList(),
					awards = {}
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.ret] .. arg0_2.ret)
			end

			if var7_1 then
				var7_1()
			end
		end)
	else
		if not arg0_1:CheckRes(var2_1, var3_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end

		pg.ConnectionMgr.GetInstance():Send(11202, {
			activity_id = var1_1,
			cmd = var2_1,
			arg1 = var3_1,
			arg2 = var4_1,
			arg_list = var5_1,
			kvargs1 = var6_1
		}, 11203, function(arg0_3)
			if arg0_3.result == 0 then
				local var0_3 = PlayerConst.addTranDrop(arg0_3.award_list)

				if var2_1 == FeastDorm.OP_INTERACTION then
					arg0_1:HandleInteraction(var3_1, var4_1, arg0_3.number[1] or 0, var0_3)
				elseif var2_1 == FeastDorm.OP_MAKE_TICKET then
					arg0_1:HandleMakeTicket(var3_1)
				elseif var2_1 == FeastDorm.OP_GIVE_TICKET then
					arg0_1:HandleGiveTicket(var3_1, arg0_3.number[1] or 0, var0_3)
				elseif var2_1 == FeastDorm.OP_GIVE_GIFT then
					arg0_1:HandleGiveGift(var3_1, var0_3)
				elseif var2_1 == FeastDorm.OP_ENTER then
					-- block empty
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
			end

			if var7_1 then
				var7_1()
			end
		end)
	end
end

function var0_0.CheckRes(arg0_4, arg1_4, arg2_4)
	local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)
	local var1_4 = 0
	local var2_4 = 1
	local var3_4 = getProxy(FeastProxy):getRawData():GetInvitedFeastShip(arg2_4)

	if arg1_4 == FeastDorm.OP_MAKE_TICKET then
		local var4_4 = var3_4:GetTicketConsume()

		return var0_4:getVitemNumber(var4_4.id) >= var4_4.count
	elseif arg1_4 == FeastDorm.OP_GIVE_GIFT then
		local var5_4 = var3_4:GetGiftConsume()

		return var0_4:getVitemNumber(var5_4.id) >= var5_4.count
	else
		return true
	end
end

function var0_0.HandleInteraction(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	local var0_5 = getProxy(FeastProxy):getRawData()
	local var1_5 = var0_5:GetFeastShip(arg1_5)

	var1_5.speechBubble = arg3_5

	local var2_5 = ""

	if var1_5:IsSpecial() then
		var2_5 = var0_5:GetInvitedFeastShip(arg1_5):GetSpeechContent(var1_5.bubble, var1_5.speechBubble)
	end

	var1_5:ClearBubble()
	arg0_5:sendNotification(GAME.FEAST_OP_DONE, {
		cmd = FeastDorm.OP_INTERACTION,
		groupId = arg1_5,
		value = var1_5:GetBubble(),
		chat = var2_5,
		awards = arg4_5
	})
end

function var0_0.HandleMakeTicket(arg0_6, arg1_6)
	local var0_6 = getProxy(FeastProxy):getRawData():GetInvitedFeastShip(arg1_6)
	local var1_6 = var0_6:GetTicketConsume()
	local var2_6 = getProxy(ActivityProxy)
	local var3_6 = var2_6:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	var3_6:subVitemNumber(var1_6.id, var1_6.count)
	var2_6:updateActivity(var3_6)
	var0_6:SetInvitationState(InvitedFeastShip.STATE_MAKE_TICKET)
	arg0_6:sendNotification(GAME.FEAST_OP_DONE, {
		cmd = FeastDorm.OP_MAKE_TICKET,
		groupId = arg1_6,
		value = var0_6:GetInvitationState(),
		awards = {}
	})
end

function var0_0.HandleGiveTicket(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = getProxy(FeastProxy):getRawData()
	local var1_7 = var0_7:GetInvitedFeastShip(arg1_7)

	var1_7:SetInvitationState(InvitedFeastShip.STATE_GOT_TICKET)

	local var2_7 = var1_7:GetSkinId()
	local var3_7 = FeastShip.New({
		skinId = 0,
		tid = arg1_7,
		bubble = arg2_7
	})

	var3_7:SetSkinId(var2_7)
	var0_7:AddShip(var3_7)
	arg0_7:sendNotification(GAME.FEAST_OP_DONE, {
		cmd = FeastDorm.OP_GIVE_TICKET,
		groupId = arg1_7,
		value = var1_7:GetInvitationState(),
		awards = arg3_7
	})
end

function var0_0.HandleGiveGift(arg0_8, arg1_8, arg2_8)
	local var0_8 = getProxy(FeastProxy):getRawData():GetInvitedFeastShip(arg1_8)
	local var1_8 = var0_8:GetGiftConsume()
	local var2_8 = getProxy(ActivityProxy)
	local var3_8 = var2_8:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	var3_8:subVitemNumber(var1_8.id, var1_8.count)
	var2_8:updateActivity(var3_8)
	var0_8:SetGiftState(InvitedFeastShip.GIFT_STATE_GOT)
	arg0_8:sendNotification(GAME.FEAST_OP_DONE, {
		cmd = FeastDorm.OP_GIVE_GIFT,
		groupId = arg1_8,
		value = var0_8:GetGiftState(),
		awards = arg2_8
	})
end

return var0_0
