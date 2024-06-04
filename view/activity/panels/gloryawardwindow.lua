local var0 = class("GloryAwardWindow", import(".PtAwardWindow"))

local function var1(arg0)
	local var0 = arg0.taskList
	local var1 = getProxy(TaskProxy)

	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = var1:getTaskVO(var0)

			setText(arg2:Find("title/Text"), "PHASE " .. arg1 + 1)
			setText(arg2:Find("target/title"), var1:getConfig("desc"))
			setText(arg2:Find("target/Text"), "")

			local var2 = var1:getConfig("award_display")[1]
			local var3 = {
				type = var2[1],
				id = var2[2],
				count = var2[3]
			}

			updateDrop(arg2:Find("award"), var3)
			onButton(arg0.binder, arg2:Find("award"), function()
				arg0.binder:emit(BaseUI.ON_DROP, var3)
			end, SFX_PANEL)
			setActive(arg2:Find("award/mask"), var1:isReceive())
		end
	end)
	arg0.UIlist:align(#var0)
end

function var0.Show(arg0, arg1)
	arg0.taskList = arg1.taskList
	arg0.taskVO = arg1.taskVO

	var1(arg0)

	arg0.totalTxt.text = arg0.taskVO:getProgress()
	arg0.totalTitleTxt.text = i18n("pt_total_count", i18n("pass_times"))

	setActive(arg0._tf, true)
end

return var0
