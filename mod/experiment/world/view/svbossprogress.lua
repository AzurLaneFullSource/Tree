local var0_0 = class("SVBossProgress", import("view.base.BaseSubView"))

var0_0.HideView = "SVBossProgress.HideView"

function var0_0.getUIName(arg0_1)
	return "SVBossProgress"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	arg0_3.rtFrame = arg0_3._tf:Find("frame")
	arg0_3.rtPanel = arg0_3.rtFrame:Find("buff_panel/buff_bg")
	arg0_3.rtInfo = arg0_3.rtFrame:Find("buff_panel/info")

	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
end

function var0_0.OnDestroy(arg0_5)
	return
end

function var0_0.Show(arg0_6)
	setLocalScale(arg0_6.rtFrame, Vector3(0.5, 0.5, 0.5))
	LeanTween.cancel(go(arg0_6.rtFrame))
	LeanTween.scale(arg0_6.rtFrame, Vector3.one, 0.15)
	setActive(arg0_6._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
end

function var0_0.Hide(arg0_7)
	LeanTween.cancel(go(arg0_7.rtFrame))
	setActive(arg0_7._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_7._tf, arg0_7._parentTf)
	arg0_7:emit(var0_0.HideView, arg0_7.callback)
end

function var0_0.Setup(arg0_8, arg1_8, arg2_8)
	arg0_8.callback = arg2_8

	local var0_8 = arg1_8.drops
	local var1_8 = 0
	local var2_8 = arg1_8.total

	for iter0_8, iter1_8 in ipairs(var0_8) do
		var1_8 = var1_8 + iter1_8.count
	end

	setText(arg0_8._tf:Find("frame/buff_panel/info/name"), i18n("world_boss_drop_title"))
	setText(arg0_8._tf:Find("frame/buff_panel/info/value_before"), var2_8 - var1_8)
	setText(arg0_8._tf:Find("frame/buff_panel/info/value"), var2_8)
end

return var0_0
