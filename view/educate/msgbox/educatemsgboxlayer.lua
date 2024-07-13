local var0_0 = class("EducateMsgBoxLayer", import("..base.EducateBaseUI"))

var0_0.TYPE_NORMAL = 1
var0_0.TYPE_SINGLE_ITEM = 2

local var1_0 = {
	[var0_0.TYPE_NORMAL] = Vector2(924, 616),
	[var0_0.TYPE_SINGLE_ITEM] = Vector2(1060, 628)
}
local var2_0 = {
	[var0_0.TYPE_NORMAL] = i18n("child_msg_title_tip"),
	[var0_0.TYPE_SINGLE_ITEM] = i18n("child_msg_title_detail")
}

function var0_0.getUIName(arg0_1)
	return "EducateMsgBoxUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

	arg0_2.anim = arg0_2:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

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
	arg0_2._noBtn = arg0_2._window:Find("button_container/no")

	setText(arg0_2._noBtn:Find("pic"), i18n("word_cancel"))

	arg0_2._yesBtn = arg0_2._window:Find("button_container/yes")

	setText(arg0_2._yesBtn:Find("pic"), i18n("word_ok"))
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

	local var0_6 = arg0_6.settings.type or var0_0.TYPE_NORMAL

	arg0_6._window.sizeDelta = var1_0[var0_6]

	setText(arg0_6._titleText, var2_0[var0_6])
	setActive(arg0_6._msgPanel, false)
	setActive(arg0_6._sigleItemPanel, false)

	local var1_6 = arg0_6.settings.hideNo or false
	local var2_6 = arg0_6.settings.hideYes or false
	local var3_6 = arg0_6.settings.hideClose or false
	local var4_6 = arg0_6.settings.onYes or function()
		return
	end
	local var5_6 = arg0_6.settings.onNo or function()
		return
	end
	local var6_6 = arg0_6.settings.onClose or function()
		return
	end

	setActive(arg0_6._noBtn, not var1_6)
	onButton(arg0_6, arg0_6._noBtn, function()
		if var5_6 then
			var5_6()
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	setActive(arg0_6._yesBtn, not var2_6)
	onButton(arg0_6, arg0_6._yesBtn, function()
		if var4_6 then
			var4_6()
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	setActive(arg0_6._closeBtn, not var3_6)
	onButton(arg0_6, arg0_6._closeBtn, function()
		if var6_6 then
			var6_6()
		else
			var5_6()
		end

		arg0_6:_close()
	end, SFX_CANCEL)
	onButton(arg0_6, tf(arg0_6._go):Find("anim_root/bg"), function()
		if var6_6 then
			var6_6()
		else
			var5_6()
		end

		arg0_6:_close()
	end, SFX_CANCEL)
end

function var0_0.showByType(arg0_14, arg1_14)
	local var0_14 = arg0_14.settings.type or var0_0.TYPE_NORMAL

	switch(var0_14, {
		[var0_0.TYPE_NORMAL] = function()
			arg0_14:showNormalMsgBox()
		end,
		[var0_0.TYPE_SINGLE_ITEM] = function()
			arg0_14:showSingleItemBox()
		end
	})
end

function var0_0.showNormalMsgBox(arg0_17)
	setActive(arg0_17._msgPanel, true)

	arg0_17.contentText.text = arg0_17.settings.content or ""
end

function var0_0.showSingleItemBox(arg0_18)
	setActive(arg0_18._sigleItemPanel, true)
	setActive(arg0_18._noBtn, false)
	EducateHelper.UpdateDropShow(arg0_18.singleItemTF, arg0_18.settings.drop)

	local var0_18 = EducateHelper.GetDropConfig(arg0_18.settings.drop)

	setText(arg0_18.singleItemName, var0_18.name or "")

	if arg0_18.settings.drop.type == EducateConst.DROP_TYPE_RES and var0_18.id == EducateChar.RES_MOOD_ID then
		setText(arg0_18.singleItemDesc, arg0_18:getMoodDesc(var0_18.desc))
	else
		setText(arg0_18.singleItemDesc, var0_18.desc or var0_18.name or "")
	end

	if arg0_18.settings.drop.type == EducateConst.DROP_TYPE_ITEM then
		local var1_18 = getProxy(EducateProxy):GetItemCntById(var0_18.id)

		setText(arg0_18.singleItemOwn, i18n("child_msg_owned", var1_18))
		setActive(arg0_18.singleItemOwn, true)
	else
		setActive(arg0_18.singleItemOwn, false)
	end
end

function var0_0.getMoodDesc(arg0_19, arg1_19)
	local var0_19 = getProxy(EducateProxy):GetCharData():GetMoodStage()

	return string.gsub(arg1_19, "$1", i18n("child_mood_desc" .. var0_19))
end

function var0_0._close(arg0_20)
	arg0_20.anim:Play("anim_educate_MsgBox_out")
end

function var0_0.onBackPressed(arg0_21)
	arg0_21:_close()
end

function var0_0.willExit(arg0_22)
	arg0_22.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_22._tf)

	if arg0_22.contextData.onExit then
		arg0_22.contextData.onExit()
	end
end

return var0_0
