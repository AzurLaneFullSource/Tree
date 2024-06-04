local var0 = class("MainMallBtn", import(".MainBaseBtn"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg3)

	arg0.sellTag = findTF(arg2, "sell")
	arg0.skinTag = findTF(arg2, "skin")
	arg0.mallTip = findTF(arg2, "tip")
end

function var0.OnClick(arg0)
	arg0:OpenMall()
end

function var0.OpenMall(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.CHARGE_MENU)

	local var0 = isActive(arg0.sellTag) or isActive(arg0.skinTag) or isActive(arg0.mallTip)

	pg.m02:sendNotification(GAME.TRACK, TrackConst.GetTrackData(TrackConst.SYSTEM_SHOP, TrackConst.ACTION_ENTER_MAIN, var0))
	PlayerPrefs.SetInt("Tec_Ship_Gift_Enter_Tag", 1)
	PlayerPrefs.Save()
end

return var0
