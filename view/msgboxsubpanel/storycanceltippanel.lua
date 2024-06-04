local var0 = class("StoryCancelTipPanel", import(".MsgboxSubPanel"))

function var0.getUIName(arg0)
	return "Msgbox4StoryCancelTip"
end

function var0.OnInit(arg0)
	setText(arg0._tf:Find("Name"), i18n("autofight_story"))
end

function var0.PreRefresh(arg0, arg1)
	arg1.title = pg.MsgboxMgr.TITLE_INFORMATION

	var0.super.PreRefresh(arg0, arg1)
end

function var0.OnRefresh(arg0, arg1)
	arg0:SetWindowSize(Vector2(1000, 640))

	local var0 = arg0._tf:Find("CircleProgress")
	local var1 = arg0._tf:Find("TimeText")
	local var2 = 5

	LeanTween.value(go(var0), var2, 0, var2):setOnUpdate(System.Action_float(function(arg0)
		setFillAmount(var0, arg0 - math.floor(arg0))
		setText(var1, math.clamp(math.ceil(arg0), 0, var2))
	end)):setOnComplete(System.Action(function()
		existCall(arg1.onYes)
		arg0:closeView()
	end))
end

function var0.OnHide(arg0)
	return
end

function var0.OnDestory(arg0)
	LeanTween.cancel(arg0._tf:Find("CircleProgress"))
end

return var0
