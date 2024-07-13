local var0_0 = class("I56SkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	arg0_1.uilist:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg1_2 + 1
			local var1_2 = arg0_1:findTF("item", arg2_2)
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
			local var8_2 = var3_2:getConfig("desc")
			local var9_2 = "(" .. var6_2 .. "/" .. var7_2 .. ")"

			setText(arg0_1:findTF("description", arg2_2), var8_2 .. " " .. var9_2)
			setSlider(arg0_1:findTF("progress", arg2_2), 0, var7_2, var6_2)

			local var10_2 = arg0_1:findTF("go_btn", arg2_2)
			local var11_2 = arg0_1:findTF("get_btn", arg2_2)
			local var12_2 = arg0_1:findTF("got_btn", arg2_2)
			local var13_2 = var3_2:getTaskStatus()

			setActive(var10_2, var13_2 == 0)
			setActive(var11_2, var13_2 == 1)
			setActive(var12_2, var13_2 == 2)
			onButton(arg0_1, var10_2, function()
				arg0_1:emit(ActivityMediator.ON_TASK_GO, var3_2)
			end, SFX_PANEL)
			onButton(arg0_1, var11_2, function()
				arg0_1:emit(ActivityMediator.ON_TASK_SUBMIT, var3_2)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_6)
	var0_0.super.OnUpdateFlush(arg0_6)
	setText(arg0_6.dayTF, arg0_6.nday .. " " .. #arg0_6.taskGroup)
	eachChild(arg0_6.items, function(arg0_7)
		local var0_7 = arg0_6:findTF("get_btn", arg0_7)
		local var1_7 = arg0_6:findTF("got_btn", arg0_7)
		local var2_7 = isActive(var1_7)

		setButtonEnabled(var1_7, false)
		setButtonEnabled(var0_7, not var2_7)

		if var2_7 then
			setActive(var0_7, true)
		end
	end)
end

return var0_0
