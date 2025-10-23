local var0_0 = class("IslandSystemUnlockPage", import(".Island3dTaskAcceptPage"))

function var0_0.getUIName(arg0_1)
	return "IslandSystemUnlockMsgBox"
end

function var0_0.Show(arg0_2, arg1_2, arg2_2)
	var0_0.super.super.Show(arg0_2)
	setText(arg0_2.tipText, i18n("word_unlock"))

	local var0_2 = pg.island_ability_template[arg1_2] or {}
	local var1_2 = string.split(var0_2.show_pop_text or "", "|")

	setText(arg0_2.chapterText, var1_2[2] or "")
	setText(arg0_2.nameText, var1_2[1] or "")

	arg0_2.onExit = arg2_2
end

return var0_0
