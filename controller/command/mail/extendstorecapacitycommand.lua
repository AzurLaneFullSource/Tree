local var0_0 = class("ExtendStoreCapacityCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().isDiamond
	local var1_1 = ({
		getProxy(PlayerProxy):getRawData():GetExtendStoreCost()
	})[var0_1 and 1 or 2]

	if not var1_1 then
		pg.TipsMgr.GetInstance():ShowTips("level max")

		return
	elseif var1_1:getOwnedCount() < var1_1.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var1_1:getName()))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(30010, {
		arg = var1_1.id
	}, 30011, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(PlayerProxy):getData()

			var0_2:consume({
				[id2res(var1_1.id)] = var1_1.count
			})

			var0_2.mailStoreLevel = var0_2.mailStoreLevel + 1

			getProxy(PlayerProxy):updatePlayer(var0_2)
			arg0_1:sendNotification(GAME.EXTEND_STORE_CAPACITY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
