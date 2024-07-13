local var0_0 = class("BuildCommaderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.callback
	local var3_1 = var0_1.tip
	local var4_1 = getProxy(CommanderProxy)
	local var5_1 = var4_1:getPoolById(var1_1)
	local var6_1 = getProxy(PlayerProxy):getData()
	local var7_1 = getProxy(BagProxy)
	local var8_1 = var5_1:getConsume()
	local var9_1 = {}

	for iter0_1, iter1_1 in ipairs(var8_1) do
		if iter1_1[1] == DROP_TYPE_RESOURCE then
			if var6_1:getResById(iter1_1[2]) < iter1_1[3] then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end
		elseif iter1_1[1] == DROP_TYPE_ITEM then
			local var10_1 = iter1_1[2]

			if var7_1:getItemCountById(var10_1) < iter1_1[3] then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

				return
			end
		end

		local var11_1 = Drop.Create(iter1_1)

		table.insert(var9_1, var11_1)
	end

	pg.ConnectionMgr.GetInstance():Send(25002, {
		boxid = var1_1
	}, 25003, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = CommanderBox.New(arg0_2.box)

			var4_1:updateBox(var0_2)

			for iter0_2, iter1_2 in ipairs(var9_1) do
				arg0_1:sendNotification(GAME.CONSUME_ITEM, iter1_2)
			end

			arg0_1:sendNotification(GAME.COMMANDER_ON_BUILD_DONE)

			if var3_1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_build_done"))
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_build_erro", arg0_2.result))
		end

		if var2_1 then
			var2_1()
		end
	end)
end

return var0_0
