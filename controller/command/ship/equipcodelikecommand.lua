local var0 = class("EquipCodeLikeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.shareId
	local var3 = getProxy(CollectionProxy)
	local var4 = var3:getShipGroup(var1)
	local var5 = underscore.detect(var4:getEquipCodes(), function(arg0)
		return arg0.id == var2
	end)

	pg.ConnectionMgr.GetInstance():Send(17605, {
		shipgroup = var1,
		shareid = var2
	}, 17606, function(arg0)
		if arg0.result == 0 then
			var5.afterLike = true
			var5.like = var5.like + 1

			var3:updateShipGroup(var4)
			arg0:sendNotification(GAME.EQUIP_CODE_LIKE_DONE, {
				like = true,
				shareId = var2
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_like_success"))
		elseif arg0.result == 7 then
			var5.afterLike = true

			var3:updateShipGroup(var4)
			arg0:sendNotification(GAME.EQUIP_CODE_LIKE_DONE, {
				shareId = var2
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_like_limited"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
