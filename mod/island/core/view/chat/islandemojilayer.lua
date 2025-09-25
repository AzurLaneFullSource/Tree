local var0_0 = class("IslandEmojiLayer", import("view.common.EmojiLayer"))

function var0_0.getUIName(arg0_1)
	return "IslandEmojiUI"
end

function var0_0.SetTagText(arg0_2, arg1_2, arg2_2)
	var0_0.super.SetTagText(arg0_2, arg1_2, arg2_2)
	setText(arg1_2:Find("Text_1"), i18n("emoji_type_" .. arg2_2))
end

return var0_0
