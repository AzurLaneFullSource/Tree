local var0_0 = class("AtelierCompositeResultView", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject
	arg0_1._tf = arg1_1
	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	setActive(arg0_1._go, false)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	setText(arg0_2._tf:Find("Window/CountBG/Tip"), i18n("ryza_composite_count"))
end

function var0_0.SetContextData(arg0_3, arg1_3)
	arg0_3.contextData = arg1_3
end

function var0_0.SetActivity(arg0_4, arg1_4)
	arg0_4.activity = arg1_4
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("BG"), function()
		arg0_5:HideCompositeResult()
	end, SFX_CANCEL)
end

function var0_0.ShowCompositeResult(arg0_7, arg1_7)
	setActive(arg0_7._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)

	local var0_7 = arg1_7[1]

	if var0_7 == nil then
		return
	end

	arg0_7._parentClass:UpdateRyzaDrop(arg0_7._tf:Find("Window/Icon"), var0_7)
	setScrollText(arg0_7._tf:Find("Window/NameBG/Rect/Name"), var0_7:getName())
	setText(arg0_7._tf:Find("Window/CountBG/Text"), var0_7.count)
end

function var0_0.HideCompositeResult(arg0_8)
	if not isActive(arg0_8._go) then
		return
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_8._tf, arg0_8._parentClass._tf)
	setActive(arg0_8._go, false)
	arg0_8:PlayGuide()

	return true
end

function var0_0.willExit(arg0_9)
	arg0_9:detach()
end

function var0_0.PlayGuide(arg0_10)
	if pg.NewStoryMgr.GetInstance():IsPlayed("NG0032") then
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0033", {
			2
		})
	end
end

return var0_0
