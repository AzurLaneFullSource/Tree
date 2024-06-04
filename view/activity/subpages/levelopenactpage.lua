local var0 = class("LevelOpenActPage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	local var0 = arg0._tf:Find("AD/task_list/content")

	arg0.uiList = UIItemList.New(var0, var0:Find("tpl"))

	arg0.uiList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTask(arg2, arg0.taskVOs[arg1 + 1])
		end
	end)
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity
	local var1 = var0:getConfig("config_data")[1][1]

	if not getProxy(TaskProxy):getTaskVO(var1) then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = var0.id
		})

		return true
	else
		return false
	end
end

function var0.OnUpdateFlush(arg0)
	local var0 = getProxy(TaskProxy)

	arg0.taskVOs = underscore.map(arg0.activity:getConfig("config_data")[1], function(arg0)
		return var0:getTaskVO(arg0)
	end)

	table.sort(arg0.taskVOs, CompareFuncs({
		function(arg0)
			if arg0:isReceive() then
				return 2
			elseif arg0:isFinish() then
				return 0
			else
				return 1
			end
		end
	}))
	arg0.uiList:align(#arg0.taskVOs)
end

function var0.UpdateTask(arg0, arg1, arg2)
	local var0 = arg2:getTaskStatus()

	setImageAlpha(arg1:Find("bg"), var0 == 2 and 0.5 or 1)
	eachChild(arg1:Find("status"), function(arg0)
		setActive(arg0, arg0:GetSiblingIndex() == var0)
	end)

	local var1 = arg1:Find("canvas")

	setCanvasGroupAlpha(var1, var0 == 2 and 0.2 or 1)

	local var2 = arg2:getConfig("desc")

	if var0 == 2 then
		setSlider(var1:Find("progress"), 0, 1, 1)
	else
		local var3 = arg2:getProgress()
		local var4 = arg2:getConfig("target_num")

		var2 = var2 .. " " .. setColorStr("(" .. var3 .. "/" .. var4 .. ")", COLOR_RED)

		setSlider(var1:Find("progress"), 0, var4, var3)
	end

	setText(arg1:Find("canvas/Text"), var2)

	local var5 = underscore.rest(arg2:getConfig("award_display"), 1)

	while #var5 > 3 do
		table.remove(var5)
	end

	local var6 = UIItemList.New(var1:Find("items"), var1:Find("items/IconTpl"))

	var6:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var5[arg1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	var6:align(#var5)

	if var0 == 2 then
		removeOnButton(arg1)
	elseif var0 == 1 then
		onButton(arg0, arg1, function()
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, arg2)
		end, SFX_PANEL)
	elseif var0 == 0 then
		onButton(arg0, arg1, function()
			arg0:emit(ActivityMediator.ON_TASK_GO, arg2)
		end, SFX_PANEL)
	else
		assert(false, "task status error:" .. arg2.id)
	end
end

return var0
