local var0 = class("BackYardThemeTemplateMsgBox", import("....base.BaseSubView"))

var0.TYPE_TEXT = 1
var0.TYPE_IMAGE = 2

function var0.getUIName(arg0)
	return "BackYardThemeTemplateMsgBox"
end

function var0.OnLoaded(arg0)
	arg0.frame = arg0:findTF("window1")
	arg0.content = arg0:findTF("window1/content"):GetComponent(typeof(Text))
	arg0.frame1 = arg0:findTF("window2")
	arg0.content1 = arg0:findTF("window2/content"):GetComponent(typeof(Text))
	arg0.icon = arg0:findTF("window2/mask/Icon"):GetComponent(typeof(RawImage))
	arg0.cancelBtn = arg0:findTF("btns/cancel")
	arg0.cancelBtnTxt = arg0:findTF("btns/cancel/Text"):GetComponent(typeof(Text))
	arg0.confirmBtn = arg0:findTF("btns/confirm")
	arg0.confirmBtnTxt = arg0:findTF("btns/confirm/Text"):GetComponent(typeof(Text))
	arg0._parentTF = arg0._tf.parent

	setText(arg0:findTF("title"), i18n("words_information"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()

		if arg0.onCancel then
			arg0.onCancel()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:Hide()

		if arg0.onYes then
			arg0.onYes()
		end
	end, SFX_PANEL)
end

function var0.SetUp(arg0, arg1)
	arg0.onYes = arg1.onYes
	arg0.onCancel = arg1.onCancel
	arg0.cancelBtnTxt.text = arg1.cancelTxt or i18n("word_cancel")
	arg0.confirmBtnTxt.text = arg1.confirmTxt or i18n("word_ok")

	local var0 = arg1.type or var0.TYPE_TEXT

	if var0 == var0.TYPE_TEXT then
		arg0.content.text = arg1.content
	elseif var0 == var0.TYPE_IMAGE then
		arg0.content1.text = arg1.content

		BackYardThemeTempalteUtil.GetNonCacheTexture(arg1.srpiteName, arg1.md5, function(arg0)
			if not IsNil(arg0.icon) and arg0 then
				arg0.icon.texture = arg0
			end
		end)
	end

	setActive(arg0.frame, var0 == var0.TYPE_TEXT)
	setActive(arg0.frame1, var0 == var0.TYPE_IMAGE)
	setActive(arg0.cancelBtn, not arg1.hideNo)
	arg0:Show()
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	SetParent(arg0._tf, pg.UIMgr.GetInstance().OverlayMain)
end

function var0.Hide(arg0)
	if not IsNil(arg0.icon.texture) then
		Object.Destroy(arg0.icon.texture)

		arg0.icon.texture = nil
	end

	var0.super.Hide(arg0)
	SetParent(arg0._tf, arg0._parentTF)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
