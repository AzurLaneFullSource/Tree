local var0_0 = class("StartCampTecCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.tecID
	local var2_1 = var0_1.levelID
	local var3_1 = pg.TimeMgr.GetInstance():DescCDTime(pg.fleet_tech_template[var2_1].time)
	local var4_1 = getProxy(TechnologyNationProxy)
	local var5_1 = var4_1:getStudyingTecItem()

	if var5_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("technology_uplevel_error_studying", pg.fleet_tech_group[var5_1].name))

		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("technology_uplevel_error_no_res", pg.fleet_tech_template[var2_1].cost, var3_1, math.fmod(var0_1.levelID, 1000) - 1, math.fmod(var0_1.levelID, 1000)),
		onYes = function()
			if getProxy(PlayerProxy):getData().gold < pg.fleet_tech_template[var2_1].cost then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_gold"))

				return
			end

			pg.ConnectionMgr.GetInstance():Send(64001, {
				tech_group_id = var1_1,
				tech_id = var2_1
			}, 64002, function(arg0_3)
				if arg0_3.result == 0 then
					local var0_3 = pg.TimeMgr.GetInstance():GetServerTime() + pg.fleet_tech_template[var2_1].time

					var4_1:updateTecItem(var1_1, nil, var2_1, var0_3)
					var4_1:setTimer()
					arg0_1:sendNotification(TechnologyConst.START_TEC_BTN_SUCCESS, var1_1)
					var4_1:refreshRedPoint()
					arg0_1:sendNotification(TechnologyConst.UPDATE_REDPOINT_ON_TOP)

					local var1_3 = getProxy(PlayerProxy)
					local var2_3 = var1_3:getData()

					var2_3:consume({
						[id2res(1)] = pg.fleet_tech_template[var2_1].cost
					})
					var1_3:updatePlayer(var2_3)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_cell", arg0_3.result))
				end
			end)
		end,
		weight = LayerWeightConst.TOP_LAYER
	})
end

return var0_0
