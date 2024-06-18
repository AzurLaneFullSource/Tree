local var0_0 = class("MainMallBtn", import(".MainBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg3_1)

	arg0_1.sellTag = findTF(arg2_1, "sell")
	arg0_1.skinTag = findTF(arg2_1, "skin")
	arg0_1.mallTip = findTF(arg2_1, "tip")
end

function var0_0.OnClick(arg0_2)
	arg0_2:OpenMall()
end

function var0_0.OpenMall(arg0_3)
	arg0_3:emit(NewMainMediator.GO_SCENE, SCENE.CHARGE_MENU)

	local var0_3 = isActive(arg0_3.sellTag) or isActive(arg0_3.skinTag) or isActive(arg0_3.mallTip)

	pg.m02:sendNotification(GAME.TRACK, TrackConst.GetTrackData(TrackConst.SYSTEM_SHOP, TrackConst.ACTION_ENTER_MAIN, var0_3))
	PlayerPrefs.SetInt("Tec_Ship_Gift_Enter_Tag", 1)
	PlayerPrefs.Save()
end

return var0_0
