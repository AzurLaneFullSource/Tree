local var0_0 = class("HamanIITaskSkinPage", import(".TemplatePage.DayDoubleTaskTemplatePage"))

function var0_0.UpdateProgress(arg0_1)
	arg0_1:setChildVisible(arg0_1.dayTF, false)
	setActive(findTF(arg0_1.dayTF, tostring(arg0_1.nday)), true)
end

function var0_0.setChildVisible(arg0_2, arg1_2, arg2_2)
	for iter0_2 = 1, arg1_2.childCount do
		local var0_2 = arg1_2:GetChild(iter0_2 - 1)

		setActive(var0_2, arg2_2)
	end
end

function var0_0.UpdateTask(arg0_3, arg1_3, arg2_3)
	var0_0.super.UpdateTask(arg0_3, arg1_3, arg2_3)

	local var0_3 = arg2_3:Find("go_btn")
	local var1_3 = arg2_3:Find("get_btn")
	local var2_3 = arg2_3:Find("got_btn")

	setText(arg2_3:Find("go_btn/Text"), i18n("island_word_go"))
	setText(arg2_3:Find("get_btn/Text"), i18n("handbook_research_final_task_btn_claim"))
	setText(arg2_3:Find("got_btn/Text"), i18n("handbook_research_final_task_btn_finished"))
end

return var0_0
