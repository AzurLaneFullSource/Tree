local var0_0 = class("ExtendBackYardAreaCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = getProxy(DormProxy)
	local var1_1 = var0_1:getData()

	var1_1:levelUp()
	var0_1:updateDrom(var1_1, BackYardConst.DORM_UPDATE_TYPE_LEVEL)
	arg0_1:sendNotification(GAME.EXTEND_BACKYARD_AREA_DONE)
	pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_extendArea_ok"))
end

return var0_0
