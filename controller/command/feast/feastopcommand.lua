local var0 = class("FeastOpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.activityId
	local var2 = var0.cmd or 0
	local var3 = var0.arg1 or 0
	local var4 = var0.arg2 or 0
	local var5 = var0.argList or {}
	local var6 = var0.kvpArgs or {}
	local var7 = var0.callback

	if var2 == FeastDorm.OP_RANDOM_SHIPS then
		pg.ConnectionMgr.GetInstance():Send(26158, {
			act_id = var1,
			ship_group_id = var5
		}, 26159, function(arg0)
			if arg0.ret == 0 then
				local var0 = getProxy(FeastProxy)
				local var1 = var0:getData()

				var1:SetRefreshTime(arg0.refresh_time)

				local var2 = {}

				for iter0, iter1 in ipairs(arg0.party_roles) do
					var2[iter1.tid] = true

					local var3 = var1:GetFeastShip(iter1.tid)

					if not var3 then
						local var4 = FeastShip.New(iter1)
						local var5 = var1:GetInvitedFeastShip(iter1.tid)

						if var5 ~= nil then
							var4:SetSkinId(var5:GetSkinId())
						end

						var1:AddShip(var4)
					else
						var3:UpdateBubble(iter1.bubble)
						var3:UpdateSpeechBubble(iter1.speech_bubble)
					end
				end

				for iter2, iter3 in pairs(var1:GetFeastShipList()) do
					if var2[iter2] ~= true then
						var1:RemoveShip(iter2)
					end
				end

				var0:UpdateData(var1)
				var0:AddRefreshTimer()
				arg0:sendNotification(GAME.FEAST_OP_DONE, {
					cmd = FeastDorm.OP_RANDOM_SHIPS,
					ships = var1:GetPutShipList(),
					awards = {}
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.ret] .. arg0.ret)
			end

			if var7 then
				var7()
			end
		end)
	else
		if not arg0:CheckRes(var2, var3) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end

		pg.ConnectionMgr.GetInstance():Send(11202, {
			activity_id = var1,
			cmd = var2,
			arg1 = var3,
			arg2 = var4,
			arg_list = var5,
			kvargs1 = var6
		}, 11203, function(arg0)
			if arg0.result == 0 then
				local var0 = PlayerConst.addTranDrop(arg0.award_list)

				if var2 == FeastDorm.OP_INTERACTION then
					arg0:HandleInteraction(var3, var4, arg0.number[1] or 0, var0)
				elseif var2 == FeastDorm.OP_MAKE_TICKET then
					arg0:HandleMakeTicket(var3)
				elseif var2 == FeastDorm.OP_GIVE_TICKET then
					arg0:HandleGiveTicket(var3, arg0.number[1] or 0, var0)
				elseif var2 == FeastDorm.OP_GIVE_GIFT then
					arg0:HandleGiveGift(var3, var0)
				elseif var2 == FeastDorm.OP_ENTER then
					-- block empty
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end

			if var7 then
				var7()
			end
		end)
	end
end

function var0.CheckRes(arg0, arg1, arg2)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)
	local var1 = 0
	local var2 = 1
	local var3 = getProxy(FeastProxy):getRawData():GetInvitedFeastShip(arg2)

	if arg1 == FeastDorm.OP_MAKE_TICKET then
		local var4 = var3:GetTicketConsume()

		return var0:getVitemNumber(var4.id) >= var4.count
	elseif arg1 == FeastDorm.OP_GIVE_GIFT then
		local var5 = var3:GetGiftConsume()

		return var0:getVitemNumber(var5.id) >= var5.count
	else
		return true
	end
end

function var0.HandleInteraction(arg0, arg1, arg2, arg3, arg4)
	local var0 = getProxy(FeastProxy):getRawData()
	local var1 = var0:GetFeastShip(arg1)

	var1.speechBubble = arg3

	local var2 = ""

	if var1:IsSpecial() then
		var2 = var0:GetInvitedFeastShip(arg1):GetSpeechContent(var1.bubble, var1.speechBubble)
	end

	var1:ClearBubble()
	arg0:sendNotification(GAME.FEAST_OP_DONE, {
		cmd = FeastDorm.OP_INTERACTION,
		groupId = arg1,
		value = var1:GetBubble(),
		chat = var2,
		awards = arg4
	})
end

function var0.HandleMakeTicket(arg0, arg1)
	local var0 = getProxy(FeastProxy):getRawData():GetInvitedFeastShip(arg1)
	local var1 = var0:GetTicketConsume()
	local var2 = getProxy(ActivityProxy)
	local var3 = var2:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	var3:subVitemNumber(var1.id, var1.count)
	var2:updateActivity(var3)
	var0:SetInvitationState(InvitedFeastShip.STATE_MAKE_TICKET)
	arg0:sendNotification(GAME.FEAST_OP_DONE, {
		cmd = FeastDorm.OP_MAKE_TICKET,
		groupId = arg1,
		value = var0:GetInvitationState(),
		awards = {}
	})
end

function var0.HandleGiveTicket(arg0, arg1, arg2, arg3)
	local var0 = getProxy(FeastProxy):getRawData()
	local var1 = var0:GetInvitedFeastShip(arg1)

	var1:SetInvitationState(InvitedFeastShip.STATE_GOT_TICKET)

	local var2 = var1:GetSkinId()
	local var3 = FeastShip.New({
		skinId = 0,
		tid = arg1,
		bubble = arg2
	})

	var3:SetSkinId(var2)
	var0:AddShip(var3)
	arg0:sendNotification(GAME.FEAST_OP_DONE, {
		cmd = FeastDorm.OP_GIVE_TICKET,
		groupId = arg1,
		value = var1:GetInvitationState(),
		awards = arg3
	})
end

function var0.HandleGiveGift(arg0, arg1, arg2)
	local var0 = getProxy(FeastProxy):getRawData():GetInvitedFeastShip(arg1)
	local var1 = var0:GetGiftConsume()
	local var2 = getProxy(ActivityProxy)
	local var3 = var2:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	var3:subVitemNumber(var1.id, var1.count)
	var2:updateActivity(var3)
	var0:SetGiftState(InvitedFeastShip.GIFT_STATE_GOT)
	arg0:sendNotification(GAME.FEAST_OP_DONE, {
		cmd = FeastDorm.OP_GIVE_GIFT,
		groupId = arg1,
		value = var0:GetGiftState(),
		awards = arg2
	})
end

return var0
