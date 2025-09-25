local var0_0 = class("IslandSettingFlagCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().flags
	local var1_1 = getProxy(IslandProxy):GetIsland():GetSettingsAgency()
	local var2_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		if var1_1:GetFlagByType(iter1_1.type) ~= iter1_1.flag then
			table.insert(var2_1, iter1_1)
		end
	end

	if #var2_1 == 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21332, {
		flag_list = var2_1
	}, 21333, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:SetFlags(var2_1)
			arg0_1:sendNotification(GAME.ISLAND_SETTING_FLAG_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
