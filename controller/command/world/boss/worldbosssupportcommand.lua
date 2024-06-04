local var0 = class("WorldBossSupportCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().type

	assert(var0)

	local var1 = nowWorld().worldBossProxy
	local var2 = var1:GetSelfBoss()

	if not var2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_not_found"))

		return
	end

	if var2:isDeath() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_is_death"))

		return
	end

	if var0 == WorldBoss.SUPPORT_TYPE_GUILD then
		if not getProxy(GuildProxy):getRawData() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_whitout_guild"))

			return
		end
	elseif var0 == WorldBoss.SUPPORT_TYPE_FRIEND then
		local var3 = getProxy(FriendProxy):getRawData()

		if table.getCount(var3) <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_whitout_friend"))

			return
		end
	end

	local function var4(arg0)
		if arg0.result == 0 then
			if var0 == WorldBoss.SUPPORT_TYPE_FRIEND then
				var1:UpdateFriendSupported()
			elseif var0 == WorldBoss.SUPPORT_TYPE_GUILD then
				var1:UpdateGuildSupported()
			elseif var0 == WorldBoss.SUPPORT_TYPE_WORLD then
				var1:UpdateWorldSupported()
			end

			var1:UpdateSelfBoss(var2)
			arg0:sendNotification(GAME.WORLD_BOSS_SUPPORT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_call_support_failed") .. arg0.result)
		end
	end

	pg.ConnectionMgr.GetInstance():Send(34509, {
		type = var0
	}, 34510, var4)
end

return var0
