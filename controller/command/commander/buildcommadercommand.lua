local var0 = class("BuildCommaderCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.callback
	local var3 = var0.tip
	local var4 = getProxy(CommanderProxy)
	local var5 = var4:getPoolById(var1)
	local var6 = getProxy(PlayerProxy):getData()
	local var7 = getProxy(BagProxy)
	local var8 = var5:getConsume()
	local var9 = {}

	for iter0, iter1 in ipairs(var8) do
		if iter1[1] == DROP_TYPE_RESOURCE then
			if var6:getResById(iter1[2]) < iter1[3] then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end
		elseif iter1[1] == DROP_TYPE_ITEM then
			local var10 = iter1[2]

			if var7:getItemCountById(var10) < iter1[3] then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end
		end

		local var11 = Drop.Create(iter1)

		table.insert(var9, var11)
	end

	pg.ConnectionMgr.GetInstance():Send(25002, {
		boxid = var1
	}, 25003, function(arg0)
		if arg0.result == 0 then
			local var0 = CommanderBox.New(arg0.box)

			var4:updateBox(var0)

			for iter0, iter1 in ipairs(var9) do
				arg0:sendNotification(GAME.CONSUME_ITEM, iter1)
			end

			arg0:sendNotification(GAME.COMMANDER_ON_BUILD_DONE)

			if var3 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_build_done"))
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_build_erro", arg0.result))
		end

		if var2 then
			var2()
		end
	end)
end

return var0
