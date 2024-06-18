local var0_0 = class("Chuixue7daySkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.step_txt = arg0_1:findTF("step_text", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.uilist:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg1_3 + 1
			local var1_3 = arg0_2:findTF("item", arg2_3)
			local var2_3 = arg0_2.taskGroup[arg0_2.nday][var0_3]
			local var3_3 = arg0_2.taskProxy:getTaskById(var2_3) or arg0_2.taskProxy:getFinishTaskById(var2_3)

			assert(var3_3, "without this task by id: " .. var2_3)

			local var4_3 = var3_3:getConfig("award_display")[1]
			local var5_3 = {
				type = var4_3[1],
				id = var4_3[2],
				count = var4_3[3]
			}

			updateDrop(var1_3, var5_3)
			onButton(arg0_2, var1_3, function()
				arg0_2:emit(BaseUI.ON_DROP, var5_3)
			end, SFX_PANEL)

			local var6_3 = var3_3:getProgress()
			local var7_3 = var3_3:getConfig("target_num")

			setText(arg0_2:findTF("description", arg2_3), var3_3:getConfig("desc"))
			setText(arg0_2:findTF("progressText", arg2_3), var6_3 .. "/" .. var7_3)
			setSlider(arg0_2:findTF("progress", arg2_3), 0, var7_3, var6_3)

			local var8_3 = arg0_2:findTF("go_btn", arg2_3)
			local var9_3 = arg0_2:findTF("get_btn", arg2_3)
			local var10_3 = arg0_2:findTF("got_btn", arg2_3)
			local var11_3 = var3_3:getTaskStatus()

			setActive(var8_3, var11_3 == 0)
			setActive(var9_3, var11_3 == 1)
			setActive(var10_3, var11_3 == 2)
			onButton(arg0_2, var8_3, function()
				arg0_2:emit(ActivityMediator.ON_TASK_GO, var3_3)
			end, SFX_PANEL)
			onButton(arg0_2, var9_3, function()
				arg0_2:emit(ActivityMediator.ON_TASK_SUBMIT, var3_3)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_7)
	var0_0.super.OnUpdateFlush(arg0_7)
	setText(arg0_7.step_txt, setColorStr(arg0_7.nday, "#89FF59FF") .. "/" .. #arg0_7.taskGroup)
end

return var0_0
