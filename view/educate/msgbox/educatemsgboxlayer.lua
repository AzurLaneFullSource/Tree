local var0 = class("EducateMsgBoxLayer", import("..base.EducateBaseUI"))

var0.TYPE_NORMAL = 1
var0.TYPE_SINGLE_ITEM = 2

local var1 = {
	[var0.TYPE_NORMAL] = Vector2(924, 616),
	[var0.TYPE_SINGLE_ITEM] = Vector2(1060, 628)
}
local var2 = {
	[var0.TYPE_NORMAL] = i18n("child_msg_title_tip"),
	[var0.TYPE_SINGLE_ITEM] = i18n("child_msg_title_detail")
}

function var0.getUIName(arg0)
	return "EducateMsgBoxUI"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0._window = arg0._tf:Find("anim_root/window")

	setActive(arg0._window, true)

	arg0._top = arg0._window:Find("top")
	arg0._titleText = arg0._top:Find("title")
	arg0._closeBtn = arg0._top:Find("btnBack")
	arg0._msgPanel = arg0._window:Find("msg_panel")
	arg0.contentText = arg0._msgPanel:Find("content"):GetComponent("RichText")
	arg0._sigleItemPanel = arg0._window:Find("single_item_panel")
	arg0.singleItemTF = arg0._sigleItemPanel:Find("item")
	arg0.singleItemOwn = arg0._sigleItemPanel:Find("own")
	arg0.singleItemName = arg0._sigleItemPanel:Find("display_panel/name")
	arg0.singleItemDesc = arg0._sigleItemPanel:Find("display_panel/desc/Text")
	arg0._noBtn = arg0._window:Find("button_container/no")

	setText(arg0._noBtn:Find("pic"), i18n("word_cancel"))

	arg0._yesBtn = arg0._window:Find("button_container/yes")

	setText(arg0._yesBtn:Find("pic"), i18n("word_ok"))
end

function var0.didEnter(arg0)
	arg0:ShowMsgBox(arg0.contextData)
end

function var0.ShowMsgBox(arg0, arg1)
	arg0:commonSetting(arg1)
	arg0:showByType(arg1)
end

function var0.commonSetting(arg0, arg1)
	arg0.settings = arg1

	local var0 = arg0.settings.type or var0.TYPE_NORMAL

	arg0._window.sizeDelta = var1[var0]

	setText(arg0._titleText, var2[var0])
	setActive(arg0._msgPanel, false)
	setActive(arg0._sigleItemPanel, false)

	local var1 = arg0.settings.hideNo or false
	local var2 = arg0.settings.hideYes or false
	local var3 = arg0.settings.hideClose or false
	local var4 = arg0.settings.onYes or function()
		return
	end
	local var5 = arg0.settings.onNo or function()
		return
	end
	local var6 = arg0.settings.onClose or function()
		return
	end

	setActive(arg0._noBtn, not var1)
	onButton(arg0, arg0._noBtn, function()
		if var5 then
			var5()
		end

		arg0:_close()
	end, SFX_CANCEL)
	setActive(arg0._yesBtn, not var2)
	onButton(arg0, arg0._yesBtn, function()
		if var4 then
			var4()
		end

		arg0:_close()
	end, SFX_CANCEL)
	setActive(arg0._closeBtn, not var3)
	onButton(arg0, arg0._closeBtn, function()
		if var6 then
			var6()
		else
			var5()
		end

		arg0:_close()
	end, SFX_CANCEL)
	onButton(arg0, tf(arg0._go):Find("anim_root/bg"), function()
		if var6 then
			var6()
		else
			var5()
		end

		arg0:_close()
	end, SFX_CANCEL)
end

function var0.showByType(arg0, arg1)
	local var0 = arg0.settings.type or var0.TYPE_NORMAL

	switch(var0, {
		[var0.TYPE_NORMAL] = function()
			arg0:showNormalMsgBox()
		end,
		[var0.TYPE_SINGLE_ITEM] = function()
			arg0:showSingleItemBox()
		end
	})
end

function var0.showNormalMsgBox(arg0)
	setActive(arg0._msgPanel, true)

	arg0.contentText.text = arg0.settings.content or ""
end

function var0.showSingleItemBox(arg0)
	setActive(arg0._sigleItemPanel, true)
	setActive(arg0._noBtn, false)
	EducateHelper.UpdateDropShow(arg0.singleItemTF, arg0.settings.drop)

	local var0 = EducateHelper.GetDropConfig(arg0.settings.drop)

	setText(arg0.singleItemName, var0.name or "")

	if arg0.settings.drop.type == EducateConst.DROP_TYPE_RES and var0.id == EducateChar.RES_MOOD_ID then
		setText(arg0.singleItemDesc, arg0:getMoodDesc(var0.desc))
	else
		setText(arg0.singleItemDesc, var0.desc or var0.name or "")
	end

	if arg0.settings.drop.type == EducateConst.DROP_TYPE_ITEM then
		local var1 = getProxy(EducateProxy):GetItemCntById(var0.id)

		setText(arg0.singleItemOwn, i18n("child_msg_owned", var1))
		setActive(arg0.singleItemOwn, true)
	else
		setActive(arg0.singleItemOwn, false)
	end
end

function var0.getMoodDesc(arg0, arg1)
	local var0 = getProxy(EducateProxy):GetCharData():GetMoodStage()

	return string.gsub(arg1, "$1", i18n("child_mood_desc" .. var0))
end

function var0._close(arg0)
	arg0.anim:Play("anim_educate_MsgBox_out")
end

function var0.onBackPressed(arg0)
	arg0:_close()
end

function var0.willExit(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.contextData.onExit then
		arg0.contextData.onExit()
	end
end

return var0
