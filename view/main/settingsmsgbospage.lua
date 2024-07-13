local var0_0 = class("SettingsMsgBosPage", import("..base.BaseSubView"))

var0_0.ALIGN_CENTER = 0
var0_0.ALIGN_LEFT = 1

function var0_0.getUIName(arg0_1)
	return "SetttingMsgbox"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.textTr = arg0_2:findTF("window/view/content/Text")
	arg0_2.text = arg0_2.textTr:GetComponent(typeof(Text))
	arg0_2.scrollrect = arg0_2:findTF("window/view/content")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6, arg2_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
	var0_0.super.Show(arg0_6)

	arg0_6.text.text = arg1_6

	arg0_6:UpdateLayout(arg2_6 or var0_0.ALIGN_CENTER)

	arg0_6.scrollrect:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 1

	arg0_6._tf:SetAsLastSibling()
end

function var0_0.UpdateLayout(arg0_7, arg1_7)
	local var0_7 = Vector2(0.5, 0.5)
	local var1_7 = TextAnchor.MiddleCenter

	if arg1_7 == var0_0.ALIGN_LEFT then
		var0_7 = Vector2(0, 1)
		var1_7 = TextAnchor.UpperLeft
	end

	arg0_7.textTr.pivot = var0_7
	arg0_7.text.alignment = var1_7

	local var2_7 = arg0_7.textTr:GetComponent(typeof(LayoutElement)).preferredWidth

	setAnchoredPosition(arg0_7.textTr, {
		x = var2_7 * (var0_7.x - 0.5)
	})
end

function var0_0.Hide(arg0_8)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf, arg0_8._parentTf)
	var0_0.super.Hide(arg0_8)

	arg0_8.text.text = ""
end

function var0_0.OnDestroy(arg0_9)
	arg0_9:Hide()
end

return var0_0
