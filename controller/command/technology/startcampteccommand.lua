local var0 = class("StartCampTecCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.tecID
	local var2 = var0.levelID
	local var3 = pg.TimeMgr.GetInstance():DescCDTime(pg.fleet_tech_template[var2].time)
	local var4 = getProxy(TechnologyNationProxy)
	local var5 = var4:getStudyingTecItem()

	if var5 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("technology_uplevel_error_studying", pg.fleet_tech_group[var5].name))

		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("technology_uplevel_error_no_res", pg.fleet_tech_template[var2].cost, var3, math.fmod(var0.levelID, 1000) - 1, math.fmod(var0.levelID, 1000)),
		onYes = function()
			if getProxy(PlayerProxy):getData().gold < pg.fleet_tech_template[var2].cost then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_gold"))

				return
			end

			pg.ConnectionMgr.GetInstance():Send(64001, {
				tech_group_id = var1,
				tech_id = var2
			}, 64002, function(arg0)
				if arg0.result == 0 then
					local var0 = pg.TimeMgr.GetInstance():GetServerTime() + pg.fleet_tech_template[var2].time

					var4:updateTecItem(var1, nil, var2, var0)
					var4:setTimer()
					arg0:sendNotification(TechnologyConst.START_TEC_BTN_SUCCESS, var1)
					var4:refreshRedPoint()
					arg0:sendNotification(TechnologyConst.UPDATE_REDPOINT_ON_TOP)

					local var1 = getProxy(PlayerProxy)
					local var2 = var1:getData()

					var2:consume({
						[id2res(1)] = pg.fleet_tech_template[var2].cost
					})
					var1:updatePlayer(var2)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_cell", arg0.result))
				end
			end)
		end,
		weight = LayerWeightConst.TOP_LAYER
	})
end

return var0
