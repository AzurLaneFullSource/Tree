local var0_0 = class("GloryAwardWindow", import(".PtAwardWindow"))

local function var1_0(arg0_1)
	local var0_1 = arg0_1.taskList
	local var1_1 = getProxy(TaskProxy)

	arg0_1.UIlist:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = var0_1[arg1_2 + 1]
			local var1_2 = var1_1:getTaskVO(var0_2)

			setText(arg2_2:Find("title/Text"), "PHASE " .. arg1_2 + 1)
			setText(arg2_2:Find("target/title"), var1_2:getConfig("desc"))
			setText(arg2_2:Find("target/Text"), "")

			local var2_2 = var1_2:getConfig("award_display")[1]
			local var3_2 = {
				type = var2_2[1],
				id = var2_2[2],
				count = var2_2[3]
			}

			updateDrop(arg2_2:Find("award"), var3_2)
			onButton(arg0_1.binder, arg2_2:Find("award"), function()
				arg0_1.binder:emit(BaseUI.ON_DROP, var3_2)
			end, SFX_PANEL)
			setActive(arg2_2:Find("award/mask"), var1_2:isReceive())
		end
	end)
	arg0_1.UIlist:align(#var0_1)
end

function var0_0.Show(arg0_4, arg1_4)
	arg0_4.taskList = arg1_4.taskList
	arg0_4.taskVO = arg1_4.taskVO

	var1_0(arg0_4)

	arg0_4.totalTxt.text = arg0_4.taskVO:getProgress()
	arg0_4.totalTitleTxt.text = i18n("pt_total_count", i18n("pass_times"))

	setActive(arg0_4._tf, true)
end

return var0_0
