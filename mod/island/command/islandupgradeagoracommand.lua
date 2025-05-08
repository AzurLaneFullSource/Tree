local var0_0 = class("IslandUpgradeAgoraCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(IslandProxy):GetIsland():GetAgoraAgency()

	if not var1_1:CanUpgrade() then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("已是最大等级"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21305, {
		type = 0
	}, 21306, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:Upgrade()
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
