local var0_0 = class("IslandSeasonTipMsgBoxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxForSeasonTip"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.tipTitleText = arg0_2._tf:Find("tipTitle/Text"):GetComponent(typeof(Text))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)

	arg0_3.tipTitleText.text = arg0_3.settings.tipTitle
end

function var0_0.FlushBtn(arg0_4, arg1_4)
	return
end

return var0_0
