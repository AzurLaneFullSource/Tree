local var0_0 = class("LevelOpenActPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	local var0_1 = arg0_1._tf:Find("AD/task_list/content")

	arg0_1.uiList = UIItemList.New(var0_1, var0_1:Find("tpl"))

	arg0_1.uiList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			arg0_1:UpdateTask(arg2_2, arg0_1.taskVOs[arg1_2 + 1])
		end
	end)
end

function var0_0.OnDataSetting(arg0_3)
	local var0_3 = arg0_3.activity
	local var1_3 = var0_3:getConfig("config_data")[1][1]

	if not getProxy(TaskProxy):getTaskVO(var1_3) then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = var0_3.id
		})

		return true
	else
		return false
	end
end

function var0_0.OnUpdateFlush(arg0_4)
	local var0_4 = getProxy(TaskProxy)

	arg0_4.taskVOs = underscore.map(arg0_4.activity:getConfig("config_data")[1], function(arg0_5)
		return var0_4:getTaskVO(arg0_5)
	end)

	table.sort(arg0_4.taskVOs, CompareFuncs({
		function(arg0_6)
			if arg0_6:isReceive() then
				return 2
			elseif arg0_6:isFinish() then
				return 0
			else
				return 1
			end
		end
	}))
	arg0_4.uiList:align(#arg0_4.taskVOs)
end

function var0_0.UpdateTask(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg2_7:getTaskStatus()

	setImageAlpha(arg1_7:Find("bg"), var0_7 == 2 and 0.5 or 1)
	eachChild(arg1_7:Find("status"), function(arg0_8)
		setActive(arg0_8, arg0_8:GetSiblingIndex() == var0_7)
	end)

	local var1_7 = arg1_7:Find("canvas")

	setCanvasGroupAlpha(var1_7, var0_7 == 2 and 0.2 or 1)

	local var2_7 = arg2_7:getConfig("desc")

	if var0_7 == 2 then
		setSlider(var1_7:Find("progress"), 0, 1, 1)
	else
		local var3_7 = arg2_7:getProgress()
		local var4_7 = arg2_7:getConfig("target_num")

		var2_7 = var2_7 .. " " .. setColorStr("(" .. var3_7 .. "/" .. var4_7 .. ")", COLOR_RED)

		setSlider(var1_7:Find("progress"), 0, var4_7, var3_7)
	end

	setText(arg1_7:Find("canvas/Text"), var2_7)

	local var5_7 = underscore.rest(arg2_7:getConfig("award_display"), 1)

	while #var5_7 > 3 do
		table.remove(var5_7)
	end

	local var6_7 = UIItemList.New(var1_7:Find("items"), var1_7:Find("items/IconTpl"))

	var6_7:make(function(arg0_9, arg1_9, arg2_9)
		arg1_9 = arg1_9 + 1

		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = var5_7[arg1_9]
			local var1_9 = {
				type = var0_9[1],
				id = var0_9[2],
				count = var0_9[3]
			}

			updateDrop(arg2_9, var1_9)
			onButton(arg0_7, arg2_9, function()
				arg0_7:emit(BaseUI.ON_DROP, var1_9)
			end, SFX_PANEL)
		end
	end)
	var6_7:align(#var5_7)

	if var0_7 == 2 then
		removeOnButton(arg1_7)
	elseif var0_7 == 1 then
		onButton(arg0_7, arg1_7, function()
			arg0_7:emit(ActivityMediator.ON_TASK_SUBMIT, arg2_7)
		end, SFX_PANEL)
	elseif var0_7 == 0 then
		onButton(arg0_7, arg1_7, function()
			arg0_7:emit(ActivityMediator.ON_TASK_GO, arg2_7)
		end, SFX_PANEL)
	else
		assert(false, "task status error:" .. arg2_7.id)
	end
end

return var0_0
