local var0_0 = class("BackYardThemeTemplateMsgBox", import("....base.BaseSubView"))

var0_0.TYPE_TEXT = 1
var0_0.TYPE_IMAGE = 2

function var0_0.getUIName(arg0_1)
	return "BackYardThemeTemplateMsgBox"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.frame = arg0_2:findTF("window1")
	arg0_2.content = arg0_2:findTF("window1/content"):GetComponent(typeof(Text))
	arg0_2.frame1 = arg0_2:findTF("window2")
	arg0_2.content1 = arg0_2:findTF("window2/content"):GetComponent(typeof(Text))
	arg0_2.icon = arg0_2:findTF("window2/mask/Icon"):GetComponent(typeof(RawImage))
	arg0_2.cancelBtn = arg0_2:findTF("btns/cancel")
	arg0_2.cancelBtnTxt = arg0_2:findTF("btns/cancel/Text"):GetComponent(typeof(Text))
	arg0_2.confirmBtn = arg0_2:findTF("btns/confirm")
	arg0_2.confirmBtnTxt = arg0_2:findTF("btns/confirm/Text"):GetComponent(typeof(Text))
	arg0_2._parentTF = arg0_2._tf.parent

	setText(arg0_2:findTF("title"), i18n("words_information"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()

		if arg0_3.onCancel then
			arg0_3.onCancel()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:Hide()

		if arg0_3.onYes then
			arg0_3.onYes()
		end
	end, SFX_PANEL)
end

function var0_0.SetUp(arg0_7, arg1_7)
	arg0_7.onYes = arg1_7.onYes
	arg0_7.onCancel = arg1_7.onCancel
	arg0_7.cancelBtnTxt.text = arg1_7.cancelTxt or i18n("word_cancel")
	arg0_7.confirmBtnTxt.text = arg1_7.confirmTxt or i18n("word_ok")

	local var0_7 = arg1_7.type or var0_0.TYPE_TEXT

	if var0_7 == var0_0.TYPE_TEXT then
		arg0_7.content.text = arg1_7.content
	elseif var0_7 == var0_0.TYPE_IMAGE then
		arg0_7.content1.text = arg1_7.content

		BackYardThemeTempalteUtil.GetNonCacheTexture(arg1_7.srpiteName, arg1_7.md5, function(arg0_8)
			if not IsNil(arg0_7.icon) and arg0_8 then
				arg0_7.icon.texture = arg0_8
			end
		end)
	end

	setActive(arg0_7.frame, var0_7 == var0_0.TYPE_TEXT)
	setActive(arg0_7.frame1, var0_7 == var0_0.TYPE_IMAGE)
	setActive(arg0_7.cancelBtn, not arg1_7.hideNo)
	arg0_7:Show()
end

function var0_0.Show(arg0_9)
	var0_0.super.Show(arg0_9)
	SetParent(arg0_9._tf, pg.UIMgr.GetInstance().OverlayMain)
end

function var0_0.Hide(arg0_10)
	if not IsNil(arg0_10.icon.texture) then
		Object.Destroy(arg0_10.icon.texture)

		arg0_10.icon.texture = nil
	end

	var0_0.super.Hide(arg0_10)
	SetParent(arg0_10._tf, arg0_10._parentTF)
end

function var0_0.OnDestroy(arg0_11)
	arg0_11:Hide()
end

return var0_0
