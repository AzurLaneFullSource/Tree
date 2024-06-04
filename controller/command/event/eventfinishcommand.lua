local var0 = class("EventFinishCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.callback
	local var3 = var0.onConfirm
	local var4 = getProxy(EventProxy)
	local var5 = var4:findInfoById(var1)
	local var6, var7 = var4:CanFinishEvent(var5)

	if not var6 then
		if var7 then
			pg.TipsMgr.GetInstance():ShowTips(var7)
		end

		if var2 then
			var2()
		end

		return
	end

	if var5:IsActivityType() then
		arg0:sendNotification(GAME.ACT_COLLECTION_EVENT_OP, {
			arg2 = 0,
			cmd = ActivityConst.COLLETION_EVENT_OP_SUBMIT,
			arg1 = var1,
			arg_list = {},
			callBack = var2,
			onConfirm = var3
		})
	else
		pg.ConnectionMgr.GetInstance():Send(13005, {
			id = var1
		}, 13006, function(arg0)
			if arg0.result == 0 then
				getProxy(EventProxy):findInfoById(var1):SavePrevFormation()
				var0.OnFinish(var1, arg0, var3)

				if var2 then
					var2()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("event_finish_fail", arg0.result))

				if var2 then
					var2()
				end
			end
		end)
	end
end

function var0.OnFinish(arg0, arg1, arg2)
	pg.TipsMgr.GetInstance():ShowTips(i18n("event_finish_success"))

	local var0 = getProxy(EventProxy)
	local var1 = {}
	local var2 = {}

	if arg1.exp > 0 then
		local var3 = getProxy(BayProxy)
		local var4 = var0:findInfoById(arg0).shipIds

		for iter0, iter1 in ipairs(var4) do
			local var5 = var3:getShipById(iter1)

			if var5 then
				local var6 = Clone(var5)

				var6:addExp(arg1.exp)
				var3:updateShip(var6)
				table.insert(var1, var5)
				table.insert(var2, var6)
			end
		end
	end

	local var7 = PlayerConst.addTranDrop(arg1.drop_list)
	local var8 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_EVENT)

	if var8 then
		local var9 = var8:getConfig("config_client").shopActID

		if var9 then
			local var10 = pg.activity_template[var9].config_client.pt_id

			_.each(var7, function(arg0)
				if arg0.id == var10 then
					arg0.catchupActTag = true
				end
			end)
			table.sort(var7, CompareFuncs({
				function(arg0)
					return arg0.id == var10 and 1 or 0
				end
			}))
		end
	end

	local var11 = getProxy(PlayerProxy)
	local var12 = var11:getData()

	var12.collect_attack_count = var12.collect_attack_count + 1

	var11:updatePlayer(var12)

	local var13, var14 = var0:findInfoById(arg0)

	table.remove(var0.eventList, var14)
	_.each(arg1.new_collection, function(arg0)
		table.insert(var0.eventList, EventInfo.New(arg0))
	end)
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	pg.m02:sendNotification(GAME.EVENT_LIST_UPDATE)
	pg.m02:sendNotification(GAME.EVENT_SHOW_AWARDS, {
		eventId = arg0,
		oldShips = var1,
		newShips = var2,
		awards = var7,
		isCri = arg1.is_cri > 0,
		onConfirm = arg2
	})
end

return var0
