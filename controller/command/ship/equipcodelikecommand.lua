local var0_0 = class("EquipCodeLikeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.shareId
	local var3_1 = getProxy(CollectionProxy)
	local var4_1 = var3_1:getShipGroup(var1_1)
	local var5_1 = underscore.detect(var4_1:getEquipCodes(), function(arg0_2)
		return arg0_2.id == var2_1
	end)

	pg.ConnectionMgr.GetInstance():Send(17605, {
		shipgroup = var1_1,
		shareid = var2_1
	}, 17606, function(arg0_3)
		if arg0_3.result == 0 then
			var5_1.afterLike = true
			var5_1.like = var5_1.like + 1

			var3_1:updateShipGroup(var4_1)
			arg0_1:sendNotification(GAME.EQUIP_CODE_LIKE_DONE, {
				like = true,
				shareId = var2_1
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_like_success"))
		elseif arg0_3.result == 7 then
			var5_1.afterLike = true

			var3_1:updateShipGroup(var4_1)
			arg0_1:sendNotification(GAME.EQUIP_CODE_LIKE_DONE, {
				shareId = var2_1
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_like_limited"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_3.result))
		end
	end)
end

return var0_0
