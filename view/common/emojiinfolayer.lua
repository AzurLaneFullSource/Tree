local var0 = class("EmojiInfoLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "EmojiInfoUI"
end

function var0.init(arg0)
	arg0.nameTxt = arg0:findTF("frame/name"):GetComponent(typeof(Text))
	arg0.descTxt = arg0:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0.emojiContainer = arg0:findTF("frame/icon_bg")

	setText(arg0:findTF("frame/tip"), i18n("word_click_to_close"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)
	arg0:Flush()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Flush(arg0)
	local var0 = arg0.contextData.id

	assert(var0)

	local var1 = pg.emoji_template[var0]

	arg0.nameTxt.text = var1.item_name
	arg0.descTxt.text = var1.item_desc

	arg0:ReturnEmoji()
	arg0:LoadEmoji(var1)
end

function var0.LoadEmoji(arg0, arg1)
	PoolMgr.GetInstance():GetPrefab("emoji/" .. arg1.pic, arg1.pic, true, function(arg0)
		local var0 = arg0:GetComponent("Animator")

		if var0 then
			var0.enabled = true
		end

		setParent(arg0, arg0.emojiContainer, false)

		arg0.emoji = arg0
	end)

	arg0.template = arg1
end

function var0.ReturnEmoji(arg0)
	if arg0.template and arg0.emoji then
		local var0 = arg0.template

		PoolMgr.GetInstance():ReturnPrefab("emoji/" .. var0.pic, var0.pic, arg0.emoji)

		arg0.template = nil
		arg0.emoji = nil
	end
end

function var0.onBackPressed(arg0)
	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0:ReturnEmoji()
end

return var0
