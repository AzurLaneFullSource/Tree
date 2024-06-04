local var0 = class("BuildShipBluePrintCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.hideTip
	local var3 = getProxy(TechnologyProxy)
	local var4 = var3:getBluePrintById(var1)
	local var5, var6 = var4:isFinishPrevTask()

	if not var6 then
		pg.TipsMgr.GetInstance():ShowTips("without finish pre task")

		return
	end

	local var7 = var3:getColdTime()
	local var8 = pg.TimeMgr.GetInstance():GetServerTime()

	if var8 < var7 then
		local var9 = var7 - var8

		var9 = var9 < 0 and 0 or var9

		local var10 = math.floor(var9 / 86400)
		local var11

		if var10 > 0 then
			var11 = i18n("time_remaining_tip") .. var10 .. i18n("word_date")
		else
			local var12 = math.floor(var9 / 3600)

			if var12 > 0 then
				var11 = i18n("time_remaining_tip") .. var12 .. i18n("word_hour")
			else
				local var13 = math.floor(var9 / 60)

				if var13 > 0 then
					var11 = i18n("time_remaining_tip") .. var13 .. i18n("word_minute")
				else
					var11 = i18n("time_remaining_tip") .. var9 .. i18n("word_second")
				end
			end
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_cannot_build_tip", var11))

		return
	end

	local var14 = {}
	local var15 = var3:getBuildingBluePrint()

	if var15 then
		table.insert(var14, function(arg0)
			local var0 = var15:getShipVO()
			local var1 = var4:getShipVO()

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("cannot_build_multiple_printblue", var0:getConfig("name"), var1:getConfig("name")),
				onYes = function()
					arg0:sendNotification(GAME.STOP_BLUEPRINT, {
						id = var15.id,
						callback = arg0
					})
				end
			})
		end)
	else
		table.insert(var14, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_build_time_tip"),
				onYes = arg0
			})
		end)
	end

	seriesAsync(var14, function()
		pg.ConnectionMgr.GetInstance():Send(63200, {
			blueprint_id = var1
		}, 63201, function(arg0)
			if arg0.result == 0 then
				var3:updateColdTime()
				var4:start(arg0.time)
				var3:updateBluePrint(var4)
				arg0:sendNotification(GAME.BUILD_SHIP_BLUEPRINT_DONE)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("printblue_build_erro") .. arg0.result)
			end
		end)
	end)
end

return var0
