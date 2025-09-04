local var0_0 = class("IslandShareSignInCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(IslandProxy):GetIsland():GetAccessAgency()
	local var2_1 = not var1_1:HasOpenFlag(IslandConst.OPEN_SIGNIN)
	local var3_1 = {}
	local var4_1 = {}

	if var2_1 then
		table.insert(var3_1, IslandConst.OPEN_SIGNIN)
	else
		table.insert(var4_1, IslandConst.OPEN_SIGNIN)
	end

	pg.ConnectionMgr.GetInstance():Send(21002, {
		open_flag = var3_1,
		close_flag = var4_1
	}, 21003, function(arg0_2)
		if arg0_2.result == 0 then
			for iter0_2, iter1_2 in ipairs(var3_1) do
				var1_1:AddOpenFlag(IslandConst.OPEN_SIGNIN)
			end

			for iter2_2, iter3_2 in ipairs(var4_1) do
				var1_1:RemoveOpenFlag(IslandConst.OPEN_SIGNIN)
			end

			arg0_1:sendNotification(GAME.ISLAND_SIGN_SHARE_SIGNIN_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_share_gift_success"))
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShareSignIn())
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
