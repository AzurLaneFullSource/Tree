local var0_0 = class("IslandSelectgiftCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.pos
	local var2_1 = var0_1.islandId
	local var3_1 = getProxy(IslandProxy):GetIsland()
	local var4_1 = var3_1.id == var2_1

	if not var4_1 then
		local var5_1 = getProxy(IslandProxy):GetSharedIsland():GetSignInAgency()

		if var5_1:IsFetched(getProxy(PlayerProxy):getRawData().id) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_get_git_tip"))

			return
		end

		if var5_1:IsMaxFetchCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_get_git_cnt_tip"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(21310, {
		island_id = var2_1,
		pos = var1_1
	}, 21311, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = IslandDropHelper.AddItems(arg0_2)
			local var1_2 = var3_1:GetSignInAgency()

			if var4_1 then
				var1_2:SetFetchCnt()
			else
				var1_2:SetOtherFetchCnt()
			end

			arg0_1:sendNotification(GAME.ISLAND_SELECT_GIFT_DONE, {
				dropData = var0_2
			})
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandGetGift(var2_1))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
