local var0 = class("WorldBossBattleQuitCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id

	if not var0 then
		return
	end

	local var1 = nowWorld():GetBossProxy()
	local var2 = var1:GetBossById(var0)

	if var2 and not var1:IsSelfBoss(var2) then
		var1:RemoveCacheBoss(var0)

		local var3 = getProxy(ChatProxy)
		local var4 = var3:GetMessagesByUniqueId(var0 .. "_" .. var2.lastTime)

		for iter0, iter1 in ipairs(var4) do
			iter1.args.isDeath = true

			var3:UpdateMsg(iter1)
		end

		local var5 = getProxy(GuildProxy)
		local var6 = var5:GetMessagesByUniqueId(var0 .. "_" .. var2.lastTime)

		for iter2, iter3 in ipairs(var6) do
			iter3.args.isDeath = true

			var5:UpdateMsg(iter3)
		end
	end
end

return var0
