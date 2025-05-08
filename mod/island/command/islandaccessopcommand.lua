local var0_0 = class("IslandAccessOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.op
	local var2_1 = var0_1.list

	pg.ConnectionMgr.GetInstance():Send(21302, {
		cmd = var1_1,
		user_id_list = var2_1
	}, 21303, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetAccessAgency()

			if var1_1 == IslandConst.ACCESS_OP_SET_WHITELIST then
				var0_2:SetWhiteList(var2_1)
			elseif var1_1 == IslandConst.ACCESS_OP_SET_BLACKLIST then
				var0_2:SetBlackList(var2_1)
			elseif var1_1 == IslandConst.ACCESS_OP_KICK then
				-- block empty
			elseif var1_1 == IslandConst.ACCESS_OP_KICKANDBLACKLIST then
				var0_2:AddBlackList(var2_1)
			end

			arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP_DONE, {
				op = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.ret)
		end
	end)
end

return var0_0
