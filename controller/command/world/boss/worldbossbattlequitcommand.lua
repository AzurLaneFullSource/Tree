local var0_0 = class("WorldBossBattleQuitCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	if not var0_1 then
		return
	end

	local var1_1 = nowWorld():GetBossProxy()
	local var2_1 = var1_1:GetBossById(var0_1)

	if var2_1 and not var1_1:IsSelfBoss(var2_1) then
		var1_1:RemoveCacheBoss(var0_1)

		local var3_1 = getProxy(ChatProxy)
		local var4_1 = var3_1:GetMessagesByUniqueId(var0_1 .. "_" .. var2_1.lastTime)

		for iter0_1, iter1_1 in ipairs(var4_1) do
			iter1_1.args.isDeath = true

			var3_1:UpdateMsg(iter1_1)
		end

		local var5_1 = getProxy(GuildProxy)
		local var6_1 = var5_1:GetMessagesByUniqueId(var0_1 .. "_" .. var2_1.lastTime)

		for iter2_1, iter3_1 in ipairs(var6_1) do
			iter3_1.args.isDeath = true

			var5_1:UpdateMsg(iter3_1)
		end
	end
end

return var0_0
