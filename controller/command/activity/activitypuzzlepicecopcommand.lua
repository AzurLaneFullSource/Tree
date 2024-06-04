local var0 = class("ActivityPuzzlePicecOPCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id or 0
	local var2 = var0.cmd
	local var3 = var0.actId
	local var4 = var0.callback
	local var5 = getProxy(ActivityProxy)
	local var6 = getProxy(ActivityProxy):getActivityById(var3)

	if not var6 or var6:isEnd() then
		return
	end

	local var7 = pg.activity_event_picturepuzzle[var3]

	if not var7 then
		return
	end

	if var2 == 1 then
		if #var6.data2_list > #var7.pickup_picturepuzzle + #var7.drop_picturepuzzle then
			return
		end

		if var6.data1 ~= 0 then
			return
		end

		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = var3
		})

		return
	elseif var2 == 2 then
		if not var0.isPickUp and not table.contains(var6.data1_list, var1) then
			return
		end

		if table.contains(var6.data2_list, var1) then
			return
		end
	elseif var2 == 3 then
		if table.contains(var6.data3_list, var1) then
			return
		end

		if pg.TimeMgr.GetInstance():GetServerTime() < var6.data2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("bulin_tip_other2"))

			return
		end
	elseif var2 == 4 then
		if var6.data1 ~= 1 then
			return
		end

		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 4,
			activity_id = var3
		})

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		arg2 = 0,
		activity_id = var3,
		cmd = var2,
		arg1 = var1,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			var6 = getProxy(ActivityProxy):getActivityById(var3)

			if var2 == 1 then
				var6.data1 = 1
			elseif var2 == 2 then
				table.insert(var6.data2_list, var1)
			elseif var2 == 3 then
				table.insert(var6.data3_list, var1)

				var6.data2 = pg.TimeMgr.GetInstance():GetServerTime() + var7.cd
			elseif var2 == 4 then
				var6.data1 = 2
			end

			var5:updateActivity(var6)

			if var4 then
				var4()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
