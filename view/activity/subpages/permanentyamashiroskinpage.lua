local var0_0 = class("PermanentYamashiroSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	arg0_1.uilist:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg1_2 + 1
			local var1_2 = arg2_2:Find("item")
			local var2_2 = arg0_1.taskGroup[arg0_1.nday][var0_2]
			local var3_2 = arg0_1.taskProxy:getTaskById(var2_2) or arg0_1.taskProxy:getFinishTaskById(var2_2)

			assert(var3_2, "without this task by id: " .. var2_2)

			local var4_2 = var3_2:getConfig("award_display")[1]
			local var5_2 = {
				type = var4_2[1],
				id = var4_2[2],
				count = var4_2[3]
			}

			updateDrop(var1_2, var5_2)
			onButton(arg0_1, var1_2, function()
				arg0_1:emit(BaseUI.ON_DROP, var5_2)
			end, SFX_PANEL)

			local var6_2 = var3_2:getProgress()
			local var7_2 = var3_2:getConfig("target_num")

			setText(arg2_2:Find("description"), var3_2:getConfig("desc"))
			setText(arg2_2:Find("progressText"), setColorStr(var6_2, "#36AF41FF") .. "/" .. var7_2)
			setSlider(arg2_2:Find("progress"), 0, var7_2, var6_2)

			local var8_2 = arg2_2:Find("go_btn")
			local var9_2 = arg2_2:Find("get_btn")
			local var10_2 = arg2_2:Find("got_btn")
			local var11_2 = var3_2:getTaskStatus()

			setActive(var8_2, var11_2 == 0)
			setActive(var9_2, var11_2 == 1)
			setActive(var10_2, var11_2 == 2)
			onButton(arg0_1, var8_2, function()
				arg0_1:emit(ActivityMediator.ON_TASK_GO, var3_2)
			end, SFX_PANEL)
			onButton(arg0_1, var9_2, function()
				arg0_1:emit(ActivityMediator.ON_TASK_SUBMIT, var3_2)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_6)
	var0_0.super.OnUpdateFlush(arg0_6)
	setText(arg0_6.dayTF, setColorStr(tostring(arg0_6.nday), "#36AF41FF") .. "/" .. #arg0_6.activity:getConfig("config_data"))
end

return var0_0
