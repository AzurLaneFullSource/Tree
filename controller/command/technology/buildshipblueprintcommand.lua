local var0_0 = class("BuildShipBluePrintCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.hideTip
	local var3_1 = getProxy(TechnologyProxy)
	local var4_1 = var3_1:getBluePrintById(var1_1)
	local var5_1, var6_1 = var4_1:isFinishPrevTask()

	if not var6_1 then
		pg.TipsMgr.GetInstance():ShowTips("without finish pre task")

		return
	end

	local var7_1 = var3_1:getColdTime()
	local var8_1 = pg.TimeMgr.GetInstance():GetServerTime()

	if var8_1 < var7_1 then
		local var9_1 = var7_1 - var8_1

		var9_1 = var9_1 < 0 and 0 or var9_1

		local var10_1 = math.floor(var9_1 / 86400)
		local var11_1

		if var10_1 > 0 then
			var11_1 = i18n("time_remaining_tip") .. var10_1 .. i18n("word_date")
		else
			local var12_1 = math.floor(var9_1 / 3600)

			if var12_1 > 0 then
				var11_1 = i18n("time_remaining_tip") .. var12_1 .. i18n("word_hour")
			else
				local var13_1 = math.floor(var9_1 / 60)

				if var13_1 > 0 then
					var11_1 = i18n("time_remaining_tip") .. var13_1 .. i18n("word_minute")
				else
					var11_1 = i18n("time_remaining_tip") .. var9_1 .. i18n("word_second")
				end
			end
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_cannot_build_tip", var11_1))

		return
	end

	local var14_1 = {}
	local var15_1 = var3_1:getBuildingBluePrint()

	if var15_1 then
		table.insert(var14_1, function(arg0_2)
			local var0_2 = var15_1:getShipVO()
			local var1_2 = var4_1:getShipVO()

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("cannot_build_multiple_printblue", var0_2:getConfig("name"), var1_2:getConfig("name")),
				onYes = function()
					arg0_1:sendNotification(GAME.STOP_BLUEPRINT, {
						id = var15_1.id,
						callback = arg0_2
					})
				end
			})
		end)
	else
		table.insert(var14_1, function(arg0_4)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_build_time_tip"),
				onYes = arg0_4
			})
		end)
	end

	seriesAsync(var14_1, function()
		pg.ConnectionMgr.GetInstance():Send(63200, {
			blueprint_id = var1_1
		}, 63201, function(arg0_6)
			if arg0_6.result == 0 then
				var3_1:updateColdTime()
				var4_1:start(arg0_6.time)
				var3_1:updateBluePrint(var4_1)
				arg0_1:sendNotification(GAME.BUILD_SHIP_BLUEPRINT_DONE)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("printblue_build_erro") .. arg0_6.result)
			end
		end)
	end)
end

return var0_0
