local var0_0 = class("NewEducateMsgBoxLayer", import("view.newEducate.base.NewEducateBaseUI"))

var0_0.TYPE = {
	SHOP = 3,
	ITEM = 2,
	BOX = 1,
	RESET = 4
}

local var1_0 = {
	[var0_0.TYPE.BOX] = Vector2(924, 616),
	[var0_0.TYPE.ITEM] = Vector2(1060, 628),
	[var0_0.TYPE.SHOP] = Vector2(1060, 628),
	[var0_0.TYPE.RESET] = Vector2(980, 650)
}
local var2_0 = {
	[var0_0.TYPE.BOX] = i18n("child_msg_title_tip"),
	[var0_0.TYPE.ITEM] = i18n("child_msg_title_detail"),
	[var0_0.TYPE.SHOP] = i18n("child_msg_title_detail"),
	[var0_0.TYPE.RESET] = i18n("child_msg_title_tip")
}

function var0_0.getUIName(arg0_1)
	return "NewEducateMsgBoxUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)

	arg0_2.anim = arg0_2._tf:Find("anim_root"):GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2._tf:Find("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetEndEvent(function()
		arg0_2:emit(var0_0.ON_CLOSE)
	end)

	arg0_2._window = arg0_2._tf:Find("anim_root/window")

	setActive(arg0_2._window, true)

	arg0_2._top = arg0_2._window:Find("top")
	arg0_2._titleText = arg0_2._top:Find("title")
	arg0_2._closeBtn = arg0_2._top:Find("btnBack")
	arg0_2._msgPanel = arg0_2._window:Find("msg_panel")
	arg0_2.contentText = arg0_2._msgPanel:Find("content"):GetComponent("RichText")
	arg0_2._sigleItemPanel = arg0_2._window:Find("single_item_panel")
	arg0_2.singleItemTF = arg0_2._sigleItemPanel:Find("item")
	arg0_2.singleItemOwn = arg0_2._sigleItemPanel:Find("own")
	arg0_2.singleItemName = arg0_2._sigleItemPanel:Find("display_panel/name")
	arg0_2.singleItemDesc = arg0_2._sigleItemPanel:Find("display_panel/desc/Text")
	arg0_2._shopPanel = arg0_2._window:Find("shop_panel")
	arg0_2.goodsIcon = arg0_2._shopPanel:Find("item/frame/icon")
	arg0_2.goodsName = arg0_2._shopPanel:Find("display_panel/name")
	arg0_2.goodsDesc = arg0_2._shopPanel:Find("display_panel/desc/Text")
	arg0_2._resetPanel = arg0_2._window:Find("reset_panel")

	setText(arg0_2._resetPanel:Find("Text"), i18n("child2_endless_reset_tip"))

	arg0_2._resetContent = arg0_2._resetPanel:Find("content")
	arg0_2._noBtn = arg0_2._window:Find("button_container/no")

	setText(arg0_2._noBtn:Find("pic"), i18n("word_cancel"))

	arg0_2._yesBtn = arg0_2._window:Find("button_container/yes")

	setText(arg0_2._yesBtn:Find("pic"), i18n("word_ok"))

	arg0_2._buyBtn = arg0_2._window:Find("button_container/buy")

	setText(arg0_2._buyBtn:Find("pic"), i18n("word_ok"))
end

function var0_0.didEnter(arg0_4)
	arg0_4:ShowMsgBox(arg0_4.contextData)

	arg0_4.isClosing = false
end

function var0_0.ShowMsgBox(arg0_5, arg1_5)
	arg0_5:commonSetting(arg1_5)
	arg0_5:showByType(arg1_5)
end

function var0_0.commonSetting(arg0_6, arg1_6)
	arg0_6.settings = arg1_6

	local var0_6 = arg0_6.settings.type or var0_0.TYPE.BOX

	arg0_6._window.sizeDelta = var1_0[var0_6]

	setText(arg0_6._titleText, var2_0[var0_6])
	setActive(arg0_6._msgPanel, false)
	setActive(arg0_6._sigleItemPanel, false)
	setActive(arg0_6._shopPanel, false)
	setActive(arg0_6._resetPanel, false)

	local var1_6 = arg0_6.settings.hideNo or false
	local var2_6 = arg0_6.settings.hideYes or false
	local var3_6 = arg0_6.settings.hideClose or false
	local var4_6 = arg0_6.settings.onYes or function()
		return
	end
	local var5_6 = arg0_6.settings.onNo or function()
		return
	end
	local var6_6 = arg0_6.settings.onBuy or function()
		return
	end
	local var7_6 = arg0_6.settings.onClose or function()
		return
	end

	setText(arg0_6._noBtn:Find("pic"), arg0_6.settings.noText or i18n("word_cancel"))
	setText(arg0_6._yesBtn:Find("pic"), arg0_6.settings.yesText or i18n("word_ok"))
	setActive(arg0_6._noBtn, not var1_6)
	onButton(arg0_6, arg0_6._noBtn, function()
		if arg0_6.isClosing then
			return
		end

		local var0_11 = arg0_6.contextData.onExit

		function arg0_6.contextData.onExit()
			existCall(var5_6)
			existCall(var0_11)
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	setActive(arg0_6._yesBtn, not var2_6)
	onButton(arg0_6, arg0_6._yesBtn, function()
		if arg0_6.isClosing then
			return
		end

		local var0_13 = arg0_6.contextData.onExit

		function arg0_6.contextData.onExit()
			existCall(var4_6)
			existCall(var0_13)
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	setActive(arg0_6._buyBtn, arg0_6.settings.type == var0_0.TYPE.SHOP)
	onButton(arg0_6, arg0_6._buyBtn, function()
		if arg0_6.isClosing then
			return
		end

		local var0_15 = arg0_6.contextData.onExit

		function arg0_6.contextData.onExit()
			existCall(var6_6)
			existCall(var0_15)
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	setActive(arg0_6._closeBtn, not var3_6)
	onButton(arg0_6, arg0_6._closeBtn, function()
		if arg0_6.isClosing then
			return
		end

		local var0_17 = arg0_6.contextData.onExit

		function arg0_6.contextData.onExit()
			existCall(var7_6)
			existCall(var0_17)
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	onButton(arg0_6, tf(arg0_6._go):Find("anim_root/bg"), function()
		if arg0_6.isClosing then
			return
		end

		if var1_6 or var3_6 then
			return
		end

		local var0_19 = arg0_6.contextData.onExit

		function arg0_6.contextData.onExit()
			existCall(var7_6)
			existCall(var0_19)
		end

		arg0_6:_close()
	end, SFX_CANCEL)
end

function var0_0.showByType(arg0_21, arg1_21)
	local var0_21 = arg0_21.settings.type or var0_0.TYPE.BOX

	switch(var0_21, {
		[var0_0.TYPE.BOX] = function()
			arg0_21:showNormalMsgBox()
		end,
		[var0_0.TYPE.ITEM] = function()
			arg0_21:showSingleItemBox()
		end,
		[var0_0.TYPE.SHOP] = function()
			arg0_21:showShopBuyBox()
		end,
		[var0_0.TYPE.RESET] = function()
			arg0_21:showResetBox()
		end
	})
end

function var0_0.showNormalMsgBox(arg0_26)
	setActive(arg0_26._msgPanel, true)

	arg0_26.contentText.text = arg0_26.settings.content or ""
end

function var0_0.showSingleItemBox(arg0_27)
	setActive(arg0_27._sigleItemPanel, true)
	setActive(arg0_27._noBtn, false)
	NewEducateHelper.UpdateItem(arg0_27.singleItemTF, arg0_27.settings.drop)

	local var0_27 = NewEducateHelper.GetDropConfig(arg0_27.settings.drop)

	setText(arg0_27.singleItemName, var0_27.name or "")

	local var1_27 = getProxy(NewEducateProxy):GetCurChar()
	local var2_27 = var1_27:GetOwnCnt(arg0_27.settings.drop)

	setText(arg0_27.singleItemOwn, i18n("child_msg_owned", var2_27))

	if arg0_27.settings.drop.type == NewEducateConst.DROP_TYPE.RES and var0_27.type == NewEducateChar.RES_TYPE.MOOD then
		local var3_27 = var1_27:GetMoodStage()

		setText(arg0_27.singleItemDesc, string.gsub(var0_27.desc, "$1", i18n("child2_mood_desc" .. var3_27)))
	else
		setText(arg0_27.singleItemDesc, var0_27.desc or var0_27.name or "")
	end
end

function var0_0.showShopBuyBox(arg0_28)
	setActive(arg0_28._shopPanel, true)
	setActive(arg0_28._yesBtn, false)
	setActive(arg0_28._buyBtn, true)
	setText(arg0_28._buyBtn:Find("price/Text"), arg0_28.settings.price)

	local var0_28 = pg.child2_shop[arg0_28.settings.shopId]

	LoadImageSpriteAsync("neweducateicon/" .. var0_28.icon, arg0_28.goodsIcon)
	setText(arg0_28.goodsName, var0_28.name)

	if var0_28.goods_type == NewEducateGoods.TYPE.BENEFIT then
		local var1_28 = pg.child2_benefit_list[var0_28.goods_id]

		setText(arg0_28.goodsDesc, var1_28.desc)
	else
		setText(arg0_28.goodsDesc, var0_28.desc)
	end
end

function var0_0.showResetBox(arg0_29)
	setActive(arg0_29._resetPanel, true)

	local var0_29 = getProxy(NewEducateProxy):GetCurChar():GetRoundData()
	local var1_29 = var0_29:GetHeighestWave()
	local var2_29 = var0_29:GetWave()

	setText(arg0_29._resetContent:Find("history"), i18n("child2_endless_history_wave", var1_29))
	setText(arg0_29._resetContent:Find("current"), i18n("child2_endless_current_wave", var2_29))
	setActive(arg0_29._resetContent:Find("current/new"), var1_29 < var2_29)
end

function var0_0._close(arg0_30)
	arg0_30.isClosing = true

	arg0_30.anim:Play("anim_educate_MsgBox_out")
end

function var0_0.onBackPressed(arg0_31)
	if arg0_31.settings.hideNo or arg0_31.settings.hideClose then
		return
	end

	arg0_31:_close()
end

function var0_0.willExit(arg0_32)
	arg0_32.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_32._tf)

	if arg0_32.contextData.onExit then
		arg0_32.contextData.onExit()
	end
end

return var0_0
