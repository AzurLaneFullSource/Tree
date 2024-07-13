local var0_0 = class("StoryCancelTipPanel", import(".MsgboxSubPanel"))

function var0_0.getUIName(arg0_1)
	return "Msgbox4StoryCancelTip"
end

function var0_0.OnInit(arg0_2)
	setText(arg0_2._tf:Find("Name"), i18n("autofight_story"))
end

function var0_0.PreRefresh(arg0_3, arg1_3)
	arg1_3.title = pg.MsgboxMgr.TITLE_INFORMATION

	var0_0.super.PreRefresh(arg0_3, arg1_3)
end

function var0_0.OnRefresh(arg0_4, arg1_4)
	arg0_4:SetWindowSize(Vector2(1000, 640))

	local var0_4 = arg0_4._tf:Find("CircleProgress")
	local var1_4 = arg0_4._tf:Find("TimeText")
	local var2_4 = 5

	LeanTween.value(go(var0_4), var2_4, 0, var2_4):setOnUpdate(System.Action_float(function(arg0_5)
		setFillAmount(var0_4, arg0_5 - math.floor(arg0_5))
		setText(var1_4, math.clamp(math.ceil(arg0_5), 0, var2_4))
	end)):setOnComplete(System.Action(function()
		existCall(arg1_4.onYes)
		arg0_4:closeView()
	end))
end

function var0_0.OnHide(arg0_7)
	return
end

function var0_0.OnDestory(arg0_8)
	LeanTween.cancel(arg0_8._tf:Find("CircleProgress"))
end

return var0_0
