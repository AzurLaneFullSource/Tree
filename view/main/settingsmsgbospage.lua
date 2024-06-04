local var0 = class("SettingsMsgBosPage", import("..base.BaseSubView"))

var0.ALIGN_CENTER = 0
var0.ALIGN_LEFT = 1

function var0.getUIName(arg0)
	return "SetttingMsgbox"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("window/top/btnBack")
	arg0.textTr = arg0:findTF("window/view/content/Text")
	arg0.text = arg0.textTr:GetComponent(typeof(Text))
	arg0.scrollrect = arg0:findTF("window/view/content")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	var0.super.Show(arg0)

	arg0.text.text = arg1

	arg0:UpdateLayout(arg2 or var0.ALIGN_CENTER)

	arg0.scrollrect:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 1

	arg0._tf:SetAsLastSibling()
end

function var0.UpdateLayout(arg0, arg1)
	local var0 = Vector2(0.5, 0.5)
	local var1 = TextAnchor.MiddleCenter

	if arg1 == var0.ALIGN_LEFT then
		var0 = Vector2(0, 1)
		var1 = TextAnchor.UpperLeft
	end

	arg0.textTr.pivot = var0
	arg0.text.alignment = var1

	local var2 = arg0.textTr:GetComponent(typeof(LayoutElement)).preferredWidth

	setAnchoredPosition(arg0.textTr, {
		x = var2 * (var0.x - 0.5)
	})
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	var0.super.Hide(arg0)

	arg0.text.text = ""
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
