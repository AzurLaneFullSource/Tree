local var0 = class("ExtendStoreCapacityCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().isDiamond
	local var1 = ({
		getProxy(PlayerProxy):getRawData():GetExtendStoreCost()
	})[var0 and 1 or 2]

	if not var1 then
		pg.TipsMgr.GetInstance():ShowTips("level max")

		return
	elseif var1:getOwnedCount() < var1.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var1:getName()))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(30010, {
		arg = var1.id
	}, 30011, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(PlayerProxy):getData()

			var0:consume({
				[id2res(var1.id)] = var1.count
			})

			var0.mailStoreLevel = var0.mailStoreLevel + 1

			getProxy(PlayerProxy):updatePlayer(var0)
			arg0:sendNotification(GAME.EXTEND_STORE_CAPACITY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
