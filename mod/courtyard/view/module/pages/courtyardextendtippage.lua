local var0_0 = class("CourtYardExtendTipPage", import(".CourtYardBaseSubPage"))

function var0_0.getUIName(arg0_1)
	return "CourtYardExtendTipUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.valueTxt = findTF(arg0_2._tf, "frame/tip_2/value_bg/Text")
	arg0_2.text1 = findTF(arg0_2._tf, "frame/tip_1/text_1")
	arg0_2.text2 = findTF(arg0_2._tf, "frame/tip_1/value_bg/Text")
	arg0_2.text3 = findTF(arg0_2._tf, "frame/tip_1/text_2")
	arg0_2.text4 = findTF(arg0_2._tf, "frame/tip_2/text_1")
	arg0_2.text5 = findTF(arg0_2._tf, "frame/tip_2/text_2")
	arg0_2.itemTF = findTF(arg0_2._tf, "frame")
	arg0_2.okBtn = findTF(arg0_2._tf, "frame/ok_btn")
	arg0_2.cancelBtn = findTF(arg0_2._tf, "frame/cancel_btn")
	arg0_2.closeBtn = findTF(arg0_2._tf, "frame/close")
	arg0_2._parent = arg0_2._tf.parent

	setText(arg0_2.okBtn:Find("Text"), i18n("word_ok"))
	setText(arg0_2.cancelBtn:Find("Text"), i18n("word_cancel"))
	setText(arg0_2:findTF("frame/tip_1/text_1"), i18n("backyard_extend_tip_1"))
	setText(arg0_2:findTF("frame/tip_1/text_2"), i18n("backyard_extend_tip_2"))
	setText(arg0_2:findTF("frame/tip_2/text_1"), i18n("backyard_extend_tip_3"))
	setText(arg0_2:findTF("frame/tip_2/text_2"), i18n("backyard_extend_tip_4"))
	setText(arg0_2:findTF("frame/title"), i18n("words_information"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.okBtn, function()
		arg0_3:Emit("Extend")
		arg0_3:Hide()
	end, SFX_CONFIRM)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
end

function var0_0.Show(arg0_8)
	local var0_8 = getProxy(BagProxy):getItemById(ITEM_BACKYARD_AREA_EXTEND) or Item.New({
		count = 0,
		id = ITEM_BACKYARD_AREA_EXTEND
	})
	local var1_8 = i18n("backyard_extendArea_tip", 1, var0_8.count)
	local var2_8 = {}

	for iter0_8, iter1_8 in ipairs(string.split(var1_8, "||")) do
		var2_8["text" .. iter0_8] = iter1_8
	end

	setActive(arg0_8._tf, true)

	local var3_8 = {
		type = DROP_TYPE_ITEM,
		id = var0_8.id
	}

	setText(arg0_8.text1, var2_8.text1)
	setText(arg0_8.text2, setColorStr(var2_8.text2, "#72bc42"))
	setText(arg0_8.text3, var2_8.text3)
	setText(arg0_8.text4, var2_8.text4)

	local var4_8 = tonumber(var0_8.count) <= 0 and setColorStr(var0_8.count, COLOR_RED) or setColorStr(var0_8.count, "#72bc42")

	setText(arg0_8.valueTxt, var4_8)
	setText(arg0_8.text5, var2_8.text6)
	updateDrop(arg0_8.itemTF, var3_8)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_8._tf)

	arg0_8.showing = true
end

function var0_0.Hide(arg0_9)
	if arg0_9.showing == true then
		arg0_9.showing = false

		setActive(arg0_9._tf, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9._tf, arg0_9._parent)
	end
end

function var0_0.OnDestroy(arg0_10)
	arg0_10:Hide()
end

return var0_0
