local var0_0 = class("NewEducateUpgradeNormalSiteCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = var0_1.id
	local var3_1 = var0_1.normalId

	pg.ConnectionMgr.GetInstance():Send(29070, {
		id = var2_1,
		work_id = var3_1
	}, 29071, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = pg.child2_site_normal[var3_1]
			local var1_2 = pg.child2_site_normal.get_id_list_by_character[var2_1]
			local var2_2 = underscore.detect(var1_2, function(arg0_3)
				local var0_3 = pg.child2_site_normal[arg0_3]

				return var0_3.type == var0_2.type and var0_3.site_lv == var0_2.site_lv + 1
			end)

			getProxy(NewEducateProxy):GetCurChar():UpdateNormalType2Id(var0_2.type, var2_2)
			existCall(var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_UpgradeNormalSite", arg0_2.result))
		end
	end)
end

return var0_0
