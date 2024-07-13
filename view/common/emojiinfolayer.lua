local var0_0 = class("EmojiInfoLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EmojiInfoUI"
end

function var0_0.init(arg0_2)
	arg0_2.nameTxt = arg0_2:findTF("frame/name"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0_2.emojiContainer = arg0_2:findTF("frame/icon_bg")

	setText(arg0_2:findTF("frame/tip"), i18n("word_click_to_close"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	arg0_3:Flush()
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.Flush(arg0_5)
	local var0_5 = arg0_5.contextData.id

	assert(var0_5)

	local var1_5 = pg.emoji_template[var0_5]

	arg0_5.nameTxt.text = var1_5.item_name
	arg0_5.descTxt.text = var1_5.item_desc

	arg0_5:ReturnEmoji()
	arg0_5:LoadEmoji(var1_5)
end

function var0_0.LoadEmoji(arg0_6, arg1_6)
	PoolMgr.GetInstance():GetPrefab("emoji/" .. arg1_6.pic, arg1_6.pic, true, function(arg0_7)
		local var0_7 = arg0_7:GetComponent("Animator")

		if var0_7 then
			var0_7.enabled = true
		end

		setParent(arg0_7, arg0_6.emojiContainer, false)

		arg0_6.emoji = arg0_7
	end)

	arg0_6.template = arg1_6
end

function var0_0.ReturnEmoji(arg0_8)
	if arg0_8.template and arg0_8.emoji then
		local var0_8 = arg0_8.template

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0_8.pic, var0_8.pic, arg0_8.emoji)

		arg0_8.template = nil
		arg0_8.emoji = nil
	end
end

function var0_0.onBackPressed(arg0_9)
	var0_0.super.onBackPressed(arg0_9)
end

function var0_0.willExit(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf)
	arg0_10:ReturnEmoji()
end

return var0_0
