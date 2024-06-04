local var0 = class("PermanentYamashiroSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnFirstFlush(arg0)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0:findTF("item", arg2)
			local var2 = arg0.taskGroup[arg0.nday][var0]
			local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

			assert(var3, "without this task by id: " .. var2)

			local var4 = var3:getConfig("award_display")[1]
			local var5 = {
				type = var4[1],
				id = var4[2],
				count = var4[3]
			}

			updateDrop(var1, var5)
			onButton(arg0, var1, function()
				arg0:emit(BaseUI.ON_DROP, var5)
			end, SFX_PANEL)

			local var6 = var3:getProgress()
			local var7 = var3:getConfig("target_num")

			setText(arg0:findTF("description", arg2), var3:getConfig("desc"))
			setText(arg0:findTF("progressText", arg2), setColorStr(var6, "#36AF41FF") .. "/" .. var7)
			setSlider(arg0:findTF("progress", arg2), 0, var7, var6)

			local var8 = arg0:findTF("go_btn", arg2)
			local var9 = arg0:findTF("get_btn", arg2)
			local var10 = arg0:findTF("got_btn", arg2)
			local var11 = var3:getTaskStatus()

			setActive(var8, var11 == 0)
			setActive(var9, var11 == 1)
			setActive(var10, var11 == 2)
			onButton(arg0, var8, function()
				arg0:emit(ActivityMediator.ON_TASK_GO, var3)
			end, SFX_PANEL)
			onButton(arg0, var9, function()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var3)
			end, SFX_PANEL)
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(tostring(arg0.nday), "#36AF41FF") .. "/" .. #arg0.activity:getConfig("config_data"))
end

return var0
