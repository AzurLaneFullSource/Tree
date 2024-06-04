local var0 = class("CourtYardExtendTipPage", import(".CourtYardBaseSubPage"))

function var0.getUIName(arg0)
	return "CourtYardExtendTipUI"
end

function var0.OnLoaded(arg0)
	arg0.valueTxt = findTF(arg0._tf, "frame/tip_2/value_bg/Text")
	arg0.text1 = findTF(arg0._tf, "frame/tip_1/text_1")
	arg0.text2 = findTF(arg0._tf, "frame/tip_1/value_bg/Text")
	arg0.text3 = findTF(arg0._tf, "frame/tip_1/text_2")
	arg0.text4 = findTF(arg0._tf, "frame/tip_2/text_1")
	arg0.text5 = findTF(arg0._tf, "frame/tip_2/text_2")
	arg0.itemTF = findTF(arg0._tf, "frame")
	arg0.okBtn = findTF(arg0._tf, "frame/ok_btn")
	arg0.cancelBtn = findTF(arg0._tf, "frame/cancel_btn")
	arg0.closeBtn = findTF(arg0._tf, "frame/close")
	arg0._parent = arg0._tf.parent

	setText(arg0.okBtn:Find("Text"), i18n("word_ok"))
	setText(arg0.cancelBtn:Find("Text"), i18n("word_cancel"))
	setText(arg0:findTF("frame/tip_1/text_1"), i18n("backyard_extend_tip_1"))
	setText(arg0:findTF("frame/tip_1/text_2"), i18n("backyard_extend_tip_2"))
	setText(arg0:findTF("frame/tip_2/text_1"), i18n("backyard_extend_tip_3"))
	setText(arg0:findTF("frame/tip_2/text_2"), i18n("backyard_extend_tip_4"))
	setText(arg0:findTF("frame/title"), i18n("words_information"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.okBtn, function()
		arg0:Emit("Extend")
		arg0:Hide()
	end, SFX_CONFIRM)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_CANCEL)
end

function var0.Show(arg0)
	local var0 = getProxy(BagProxy):getItemById(ITEM_BACKYARD_AREA_EXTEND) or Item.New({
		count = 0,
		id = ITEM_BACKYARD_AREA_EXTEND
	})
	local var1 = i18n("backyard_extendArea_tip", 1, var0.count)
	local var2 = {}

	for iter0, iter1 in ipairs(string.split(var1, "||")) do
		var2["text" .. iter0] = iter1
	end

	setActive(arg0._tf, true)

	local var3 = {
		type = DROP_TYPE_ITEM,
		id = var0.id
	}

	setText(arg0.text1, var2.text1)
	setText(arg0.text2, setColorStr(var2.text2, "#72bc42"))
	setText(arg0.text3, var2.text3)
	setText(arg0.text4, var2.text4)

	local var4 = tonumber(var0.count) <= 0 and setColorStr(var0.count, COLOR_RED) or setColorStr(var0.count, "#72bc42")

	setText(arg0.valueTxt, var4)
	setText(arg0.text5, var2.text6)
	updateDrop(arg0.itemTF, var3)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)

	arg0.showing = true
end

function var0.Hide(arg0)
	if arg0.showing == true then
		arg0.showing = false

		setActive(arg0._tf, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parent)
	end
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
