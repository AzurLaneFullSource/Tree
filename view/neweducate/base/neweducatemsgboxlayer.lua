local var0_0 = class("NewEducateMsgBoxLayer", import("view.newEducate.base.NewEducateBaseUI"))

var0_0.TYPE = {
	SHOP = 3,
	BOX = 1,
	ITEM = 2
}

local var1_0 = {
	[var0_0.TYPE.BOX] = Vector2(924, 616),
	[var0_0.TYPE.ITEM] = Vector2(1060, 628),
	[var0_0.TYPE.SHOP] = Vector2(1060, 628)
}
local var2_0 = {
	[var0_0.TYPE.BOX] = i18n("child_msg_title_tip"),
	[var0_0.TYPE.ITEM] = i18n("child_msg_title_detail"),
	[var0_0.TYPE.SHOP] = i18n("child_msg_title_detail")
}

function var0_0.getUIName(arg0_1)
	return "NewEducateMsgBoxUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

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
	arg0_2._noBtn = arg0_2._window:Find("button_container/no")

	setText(arg0_2._noBtn:Find("pic"), i18n("word_cancel"))

	arg0_2._yesBtn = arg0_2._window:Find("button_container/yes")

	setText(arg0_2._yesBtn:Find("pic"), i18n("word_ok"))

	arg0_2._buyBtn = arg0_2._window:Find("button_container/buy")

	setText(arg0_2._buyBtn:Find("pic"), i18n("word_ok"))
end

function var0_0.didEnter(arg0_4)
	arg0_4:ShowMsgBox(arg0_4.contextData)
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
		local var0_11 = arg0_6.contextData.onExit

		function arg0_6.contextData.onExit()
			existCall(var5_6)
			existCall(var0_11)
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	setActive(arg0_6._yesBtn, not var2_6)
	onButton(arg0_6, arg0_6._yesBtn, function()
		local var0_13 = arg0_6.contextData.onExit

		function arg0_6.contextData.onExit()
			existCall(var4_6)
			existCall(var0_13)
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	setActive(arg0_6._buyBtn, arg0_6.settings.type == var0_0.TYPE.SHOP)
	onButton(arg0_6, arg0_6._buyBtn, function()
		local var0_15 = arg0_6.contextData.onExit

		function arg0_6.contextData.onExit()
			existCall(var6_6)
			existCall(var0_15)
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	setActive(arg0_6._closeBtn, not var3_6)
	onButton(arg0_6, arg0_6._closeBtn, function()
		local var0_17 = arg0_6.contextData.onExit

		function arg0_6.contextData.onExit()
			existCall(var7_6)
			existCall(var0_17)
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	onButton(arg0_6, tf(arg0_6._go):Find("anim_root/bg"), function()
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
		end
	})
end

function var0_0.showNormalMsgBox(arg0_25)
	setActive(arg0_25._msgPanel, true)

	arg0_25.contentText.text = arg0_25.settings.content or ""
end

function var0_0.showSingleItemBox(arg0_26)
	setActive(arg0_26._sigleItemPanel, true)
	setActive(arg0_26._noBtn, false)
	NewEducateHelper.UpdateItem(arg0_26.singleItemTF, arg0_26.settings.drop)

	local var0_26 = NewEducateHelper.GetDropConfig(arg0_26.settings.drop)

	setText(arg0_26.singleItemName, var0_26.name or "")

	local var1_26 = getProxy(NewEducateProxy):GetCurChar()
	local var2_26 = var1_26:GetOwnCnt(arg0_26.settings.drop)

	setText(arg0_26.singleItemOwn, i18n("child_msg_owned", var2_26))

	if arg0_26.settings.drop.type == NewEducateConst.DROP_TYPE.RES and var0_26.type == NewEducateChar.RES_TYPE.MOOD then
		local var3_26 = var1_26:GetMoodStage()

		setText(arg0_26.singleItemDesc, string.gsub(var0_26.desc, "$1", i18n("child2_mood_desc" .. var3_26)))
	else
		setText(arg0_26.singleItemDesc, var0_26.desc or var0_26.name or "")
	end
end

function var0_0.showShopBuyBox(arg0_27)
	setActive(arg0_27._shopPanel, true)
	setActive(arg0_27._yesBtn, false)
	setActive(arg0_27._buyBtn, true)
	setText(arg0_27._buyBtn:Find("price/Text"), arg0_27.settings.price)

	local var0_27 = pg.child2_shop[arg0_27.settings.shopId]

	LoadImageSpriteAsync("neweducateicon/" .. var0_27.icon, arg0_27.goodsIcon)
	setText(arg0_27.goodsName, var0_27.name)

	if var0_27.goods_type == NewEducateGoods.TYPE.BENEFIT then
		local var1_27 = pg.child2_benefit_list[var0_27.goods_id]

		setText(arg0_27.goodsDesc, var1_27.desc)
	else
		setText(arg0_27.goodsDesc, var0_27.desc)
	end
end

function var0_0._close(arg0_28)
	arg0_28.anim:Play("anim_educate_MsgBox_out")
end

function var0_0.onBackPressed(arg0_29)
	if arg0_29.settings.hideNo or arg0_29.settings.hideClose then
		return
	end

	arg0_29:_close()
end

function var0_0.willExit(arg0_30)
	arg0_30.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_30._tf)

	if arg0_30.contextData.onExit then
		arg0_30.contextData.onExit()
	end
end

return var0_0
