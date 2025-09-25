local var0_0 = class("IslandFollowerOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.op
	local var3_1 = getProxy(IslandProxy):GetIsland()
	local var4_1 = var3_1:GetFollowerAgency()
	local var5_1 = var3_1:GetCharacterAgency()

	if not var5_1:GetShipById(var1_1) then
		return
	end

	if var2_1 == IslandConst.FOLLOWER_OP_ADD and not var5_1:CanFollowPlayer(var1_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_follower_state_no_normal"))

		return
	end

	if var2_1 == IslandConst.FOLLOWER_OP_ADD and var4_1:ReachMaxCnt() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_follower_cnt_max"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21630, {
		ship_id = var1_1,
		type = var2_1
	}, 21631, function(arg0_2)
		if arg0_2.result == 0 then
			if var2_1 == IslandConst.FOLLOWER_OP_ADD then
				var4_1:AddFollower(var1_1)
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_follow_success"))
			elseif var2_1 == IslandConst.FOLLOWER_OP_DEL then
				var4_1:DelFollower(var1_1)
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_cancel_follow_success"))
			end

			arg0_1:sendNotification(GAME.ISLAND_FOLLOWER_OP_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
