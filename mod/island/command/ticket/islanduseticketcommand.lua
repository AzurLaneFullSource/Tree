local var0_0 = class("IslandUseTicketCommand", pm.SimpleCommand)

var0_0.TYPES = {
	MANAGE = 3,
	SHIP_ORDER = 2,
	SHIP_ORDER_RELOAD = 5,
	ORDER_CD = 1,
	APPOINT = 4
}

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.id
	local var3_1 = var0_1.tickets
	local var4_1 = underscore.select(var3_1, function(arg0_2)
		return arg0_2:IsExpired()
	end)

	if #var4_1 > 0 then
		local function var5_1()
			arg0_1:sendNotification(GAME.ISLAND_REMOVE_EXPIRED_TICKET, {
				tickets = var4_1
			})
		end

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
			contentText = i18n("island_ticket_expiration_tip2"),
			onClose = var5_1,
			btnList = {
				{
					type = pg.NewStyleMsgboxMgr.BUTTON_TYPE.confirm,
					name = i18n("msgbox_text_confirm"),
					func = var5_1,
					sound = SFX_CONFIRM
				}
			}
		})

		return
	end

	local var6_1 = {}
	local var7_1 = 0

	for iter0_1, iter1_1 in ipairs(var3_1) do
		table.insert(var6_1, {
			key = {
				speed_id = iter1_1.id,
				end_time = iter1_1.endTime
			},
			num = iter1_1:GetCount()
		})

		var7_1 = var7_1 + iter1_1:GetTime() * iter1_1:GetCount()
	end

	if var1_1 == var0_0.TYPES.ORDER_CD or var1_1 == var0_0.TYPES.SHIP_ORDER or var1_1 == var0_0.TYPES.SHIP_ORDER_RELOAD or var1_1 == var0_0.TYPES.MANAGE then
		arg0_1:Send(var1_1, var2_1, var6_1, var7_1)
	elseif var1_1 == var0_0.TYPES.APPOINT then
		arg0_1:SendForAppoint(var2_1, var6_1, var7_1)
	else
		assert(false, "undefined type: " .. var1_1)
	end
end

function var0_0.Send(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	pg.ConnectionMgr.GetInstance():Send(21423, {
		type = arg1_4,
		target_id = arg2_4,
		tickets = arg3_4
	}, 21424, function(arg0_5)
		if arg0_5.result == 0 then
			switch(arg1_4, {
				[var0_0.TYPES.ORDER_CD] = function()
					getProxy(IslandProxy):GetIsland():GetOrderAgency():GetSlot(arg2_4):AddReduceTime(arg4_4)
				end,
				[var0_0.TYPES.SHIP_ORDER] = function()
					getProxy(IslandProxy):GetIsland():GetOrderAgency():GetShipOrderSlot(arg2_4):AddReduceTime(arg4_4)
				end,
				[var0_0.TYPES.MANAGE] = function()
					getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(arg2_4):UpdateEndTime(arg4_4)
				end,
				[var0_0.TYPES.SHIP_ORDER_RELOAD] = function()
					getProxy(IslandProxy):GetIsland():GetOrderAgency():ReduceNextManualReloadDelegateTime(arg4_4)
				end
			})

			local var0_5 = getProxy(IslandProxy):GetIsland():GetTicketAgency()

			for iter0_5, iter1_5 in ipairs(arg3_4) do
				var0_5:ReduceTicket(iter1_5.key.speed_id, iter1_5.key.end_time, iter1_5.num)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("island_use_ticket_success"))
			arg0_4:sendNotification(GAME.ISLAND_USE_TICKET_DONE, {
				type = arg1_4,
				id = arg2_4
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_5.result] .. arg0_5.result)
		end
	end)
end

function var0_0.SendForAppoint(arg0_10, arg1_10, arg2_10, arg3_10)
	pg.ConnectionMgr.GetInstance():Send(21427, {
		area_id = arg1_10,
		tickets = arg2_10
	}, 21428, function(arg0_11)
		if arg0_11.result == 0 then
			local var0_11 = getProxy(IslandProxy):GetIsland()
			local var1_11 = pg.island_production_slot[arg1_10].place
			local var2_11 = var0_11:GetBuildingAgency():GetBuilding(var1_11):GetDelegationSlotData(arg1_10):GetSlotRoleData()

			var2_11:AddSpeedTime(arg3_10)
			var2_11:SetCostList(arg0_11.time_list)
			var0_11:GetCharacterAgency():GetShipById(var2_11.ship_id):UpdateEnergyBeginRecoverTime(var2_11:GetFinishTime())

			local var3_11 = var0_11:GetTicketAgency()

			for iter0_11, iter1_11 in ipairs(arg2_10) do
				var3_11:ReduceTicket(iter1_11.key.speed_id, iter1_11.key.end_time, iter1_11.num)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("island_use_ticket_success"))
			arg0_10:sendNotification(GAME.ISLAND_USE_TICKET_DONE, {
				type = var0_0.TYPES.APPOINT,
				id = arg1_10
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_11.result] .. arg0_11.result)
		end
	end)
end

return var0_0
