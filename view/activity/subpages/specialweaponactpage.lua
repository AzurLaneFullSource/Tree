local var0_0 = class("SpecialWeaponActPage", import(".LevelOpenActPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
	setText(arg0_1._tf:Find("AD/task_list/content/tpl/status/got/Text"), i18n("word_status_inEventFinished"))
	setText(arg0_1._tf:Find("AD/tips/Text"), i18n("spweapon_activity_ui_text1"))
	setText(arg0_1._tf:Find("AD/tips/Text (1)"), i18n("spweapon_activity_ui_text2"))
end

function var0_0.UpdateTask(arg0_2, arg1_2, arg2_2)
	var0_0.super.UpdateTask(arg0_2, arg1_2, arg2_2)

	local var0_2 = arg2_2:getTaskStatus()
	local var1_2 = arg1_2:Find("canvas")

	setCanvasGroupAlpha(var1_2, 1)
	setActive(arg1_2:Find("mask"), var0_2 == 2)

	local var2_2 = arg2_2:getConfig("desc")

	if var0_2 == 2 then
		setSlider(var1_2:Find("progress"), 0, 1, 1)
	else
		local var3_2 = arg2_2:getProgress()
		local var4_2 = arg2_2:getConfig("target_num")

		var2_2 = var2_2 .. " " .. setColorStr("(" .. var3_2 .. "/" .. var4_2 .. ")", "#FFD585FF")

		setSlider(var1_2:Find("progress"), 0, var4_2, var3_2)
	end

	setText(arg1_2:Find("canvas/Text"), var2_2)
end

return var0_0
