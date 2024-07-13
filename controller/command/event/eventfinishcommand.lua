local var0_0 = class("EventFinishCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.callback
	local var3_1 = var0_1.onConfirm
	local var4_1 = getProxy(EventProxy)
	local var5_1 = var4_1:findInfoById(var1_1)
	local var6_1, var7_1 = var4_1:CanFinishEvent(var5_1)

	if not var6_1 then
		if var7_1 then
			pg.TipsMgr.GetInstance():ShowTips(var7_1)
		end

		if var2_1 then
			var2_1()
		end

		return
	end

	if var5_1:IsActivityType() then
		arg0_1:sendNotification(GAME.ACT_COLLECTION_EVENT_OP, {
			arg2 = 0,
			cmd = ActivityConst.COLLETION_EVENT_OP_SUBMIT,
			arg1 = var1_1,
			arg_list = {},
			callBack = var2_1,
			onConfirm = var3_1
		})
	else
		pg.ConnectionMgr.GetInstance():Send(13005, {
			id = var1_1
		}, 13006, function(arg0_2)
			if arg0_2.result == 0 then
				getProxy(EventProxy):findInfoById(var1_1):SavePrevFormation()
				var0_0.OnFinish(var1_1, arg0_2, var3_1)

				if var2_1 then
					var2_1()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("event_finish_fail", arg0_2.result))

				if var2_1 then
					var2_1()
				end
			end
		end)
	end
end

function var0_0.OnFinish(arg0_3, arg1_3, arg2_3)
	pg.TipsMgr.GetInstance():ShowTips(i18n("event_finish_success"))

	local var0_3 = getProxy(EventProxy)
	local var1_3 = {}
	local var2_3 = {}

	if arg1_3.exp > 0 then
		local var3_3 = getProxy(BayProxy)
		local var4_3 = var0_3:findInfoById(arg0_3).shipIds

		for iter0_3, iter1_3 in ipairs(var4_3) do
			local var5_3 = var3_3:getShipById(iter1_3)

			if var5_3 then
				local var6_3 = Clone(var5_3)

				var6_3:addExp(arg1_3.exp)
				var3_3:updateShip(var6_3)
				table.insert(var1_3, var5_3)
				table.insert(var2_3, var6_3)
			end
		end
	end

	local var7_3 = PlayerConst.addTranDrop(arg1_3.drop_list)
	local var8_3 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_EVENT)

	if var8_3 then
		local var9_3 = var8_3:getConfig("config_client").shopActID

		if var9_3 then
			local var10_3 = pg.activity_template[var9_3].config_client.pt_id

			_.each(var7_3, function(arg0_4)
				if arg0_4.id == var10_3 then
					arg0_4.catchupActTag = true
				end
			end)
			table.sort(var7_3, CompareFuncs({
				function(arg0_5)
					return arg0_5.id == var10_3 and 1 or 0
				end
			}))
		end
	end

	local var11_3 = getProxy(PlayerProxy)
	local var12_3 = var11_3:getData()

	var12_3.collect_attack_count = var12_3.collect_attack_count + 1

	var11_3:updatePlayer(var12_3)

	local var13_3, var14_3 = var0_3:findInfoById(arg0_3)

	table.remove(var0_3.eventList, var14_3)
	_.each(arg1_3.new_collection, function(arg0_6)
		table.insert(var0_3.eventList, EventInfo.New(arg0_6))
	end)
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	pg.m02:sendNotification(GAME.EVENT_LIST_UPDATE)
	pg.m02:sendNotification(GAME.EVENT_SHOW_AWARDS, {
		eventId = arg0_3,
		oldShips = var1_3,
		newShips = var2_3,
		awards = var7_3,
		isCri = arg1_3.is_cri > 0,
		onConfirm = arg2_3
	})
end

return var0_0
