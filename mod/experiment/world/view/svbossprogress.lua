local var0 = class("SVBossProgress", import("view.base.BaseSubView"))

var0.HideView = "SVBossProgress.HideView"

function var0.getUIName(arg0)
	return "SVBossProgress"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	arg0.rtFrame = arg0._tf:Find("frame")
	arg0.rtPanel = arg0.rtFrame:Find("buff_panel/buff_bg")
	arg0.rtInfo = arg0.rtFrame:Find("buff_panel/info")

	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_CANCEL)
end

function var0.OnDestroy(arg0)
	return
end

function var0.Show(arg0)
	setLocalScale(arg0.rtFrame, Vector3(0.5, 0.5, 0.5))
	LeanTween.cancel(go(arg0.rtFrame))
	LeanTween.scale(arg0.rtFrame, Vector3.one, 0.15)
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	LeanTween.cancel(go(arg0.rtFrame))
	setActive(arg0._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	arg0:emit(var0.HideView, arg0.callback)
end

function var0.Setup(arg0, arg1, arg2)
	arg0.callback = arg2

	local var0 = arg1.drops
	local var1 = 0
	local var2 = arg1.total

	for iter0, iter1 in ipairs(var0) do
		var1 = var1 + iter1.count
	end

	setText(arg0._tf:Find("frame/buff_panel/info/name"), i18n("world_boss_drop_title"))
	setText(arg0._tf:Find("frame/buff_panel/info/value_before"), var2 - var1)
	setText(arg0._tf:Find("frame/buff_panel/info/value"), var2)
end

return var0
