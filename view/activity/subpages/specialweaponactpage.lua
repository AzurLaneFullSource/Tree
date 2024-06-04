local var0 = class("SpecialWeaponActPage", import(".LevelOpenActPage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	setText(arg0._tf:Find("AD/task_list/content/tpl/status/got/Text"), i18n("word_status_inEventFinished"))
	setText(arg0._tf:Find("AD/tips/Text"), i18n("spweapon_activity_ui_text1"))
	setText(arg0._tf:Find("AD/tips/Text (1)"), i18n("spweapon_activity_ui_text2"))
end

function var0.UpdateTask(arg0, arg1, arg2)
	var0.super.UpdateTask(arg0, arg1, arg2)

	local var0 = arg2:getTaskStatus()
	local var1 = arg1:Find("canvas")

	setCanvasGroupAlpha(var1, 1)
	setActive(arg1:Find("mask"), var0 == 2)

	local var2 = arg2:getConfig("desc")

	if var0 == 2 then
		setSlider(var1:Find("progress"), 0, 1, 1)
	else
		local var3 = arg2:getProgress()
		local var4 = arg2:getConfig("target_num")

		var2 = var2 .. " " .. setColorStr("(" .. var3 .. "/" .. var4 .. ")", "#FFD585FF")

		setSlider(var1:Find("progress"), 0, var4, var3)
	end

	setText(arg1:Find("canvas/Text"), var2)
end

return var0
