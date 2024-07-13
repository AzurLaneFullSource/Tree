local var0_0 = class("WorldBossSupportCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().type

	assert(var0_1)

	local var1_1 = nowWorld().worldBossProxy
	local var2_1 = var1_1:GetSelfBoss()

	if not var2_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_not_found"))

		return
	end

	if var2_1:isDeath() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_is_death"))

		return
	end

	if var0_1 == WorldBoss.SUPPORT_TYPE_GUILD then
		if not getProxy(GuildProxy):getRawData() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_whitout_guild"))

			return
		end
	elseif var0_1 == WorldBoss.SUPPORT_TYPE_FRIEND then
		local var3_1 = getProxy(FriendProxy):getRawData()

		if table.getCount(var3_1) <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_whitout_friend"))

			return
		end
	end

	local function var4_1(arg0_2)
		if arg0_2.result == 0 then
			if var0_1 == WorldBoss.SUPPORT_TYPE_FRIEND then
				var1_1:UpdateFriendSupported()
			elseif var0_1 == WorldBoss.SUPPORT_TYPE_GUILD then
				var1_1:UpdateGuildSupported()
			elseif var0_1 == WorldBoss.SUPPORT_TYPE_WORLD then
				var1_1:UpdateWorldSupported()
			end

			var1_1:UpdateSelfBoss(var2_1)
			arg0_1:sendNotification(GAME.WORLD_BOSS_SUPPORT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_call_support_failed") .. arg0_2.result)
		end
	end

	pg.ConnectionMgr.GetInstance():Send(34509, {
		type = var0_1
	}, 34510, var4_1)
end

return var0_0
