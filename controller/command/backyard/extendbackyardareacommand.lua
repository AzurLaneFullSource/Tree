local var0 = class("ExtendBackYardAreaCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = getProxy(DormProxy)
	local var1 = var0:getData()

	var1:levelUp()
	var0:updateDrom(var1, BackYardConst.DORM_UPDATE_TYPE_LEVEL)
	arg0:sendNotification(GAME.EXTEND_BACKYARD_AREA_DONE)
	pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_extendArea_ok"))
end

return var0
