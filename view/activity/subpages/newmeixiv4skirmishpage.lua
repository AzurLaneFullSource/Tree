local var0 = class("NewMeixiV4SkirmishPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.bg)
	arg0.progressBar = arg0:findTF("progress/bar", arg0.bg)
	arg0.curNum = arg0:findTF("progress/cur_num", arg0.bg)
	arg0.curSection = arg0:findTF("progress/cur_section", arg0.bg)
	arg0.item = arg0:findTF("scrollview/item", arg0.bg)
	arg0.items = arg0:findTF("scrollview/items", arg0.bg)
	arg0.uilist = UIItemList.New(arg0.items, arg0.item)
end

function var0.OnDataSetting(arg0)
	arg0:initTaskData()

	return updateActivityTaskStatus(arg0.activity)
end

function var0.initTaskData(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskGroup = pg.activity_template[ActivityConst.NEWMEIXIV4_SKIRMISH_ID].config_data
	arg0.taskList = {}

	for iter0, iter1 in ipairs(arg0.taskGroup) do
		for iter2, iter3 in ipairs(iter1) do
			table.insert(arg0.taskList, iter3)
		end
	end

	arg0:SetClearNum()
	arg0:SetCurIndex()
end

function var0.SetClearNum(arg0)
	arg0.clearTaskNum = 0

	for iter0, iter1 in ipairs(arg0.taskList) do
		if arg0.taskProxy:getTaskById(iter1) or arg0.taskProxy:getFinishTaskById(iter1) then
			arg0.clearTaskNum = iter0 - 1

			return
		end
	end
end

function var0.SetCurIndex(arg0)
	arg0.curTaskIndex = 1

	for iter0, iter1 in ipairs(arg0.taskList) do
		local var0 = arg0.taskProxy:getTaskById(iter1) or arg0.taskProxy:getFinishTaskById(iter1)
		local var1 = arg0.taskList[iter0 + 1]
		local var2 = arg0.taskProxy:getTaskById(var1) or arg0.taskProxy:getFinishTaskById(var1)

		if var0 and var0:getTaskStatus() == 2 then
			arg0.curTaskIndex = arg0.curTaskIndex + 1

			if not var1 or not var2 then
				arg0.curTaskIndex = arg0.curTaskIndex - 1
			end
		end
	end

	arg0.curTaskIndex = arg0.curTaskIndex + arg0.clearTaskNum
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NEWMEIXIV4_SKIRMISH, {
			taskList = arg0.taskList
		})
	end, SFX_PANEL)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0:findTF("item", arg2)
			local var2 = arg0.taskList[var0]
			local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

			setActive(arg0:findTF("finish", arg2), var3 and var3:getTaskStatus() == 2 or var0 <= arg0.clearTaskNum)
			setActive(arg0:findTF("lock", arg2), false)
			setText(arg0:findTF("title", arg2), "P" .. var0)
		end
	end)
	arg0.uilist:align(#arg0.taskList)
end

function var0.OnUpdateFlush(arg0)
	arg0:SetCurIndex()
	setText(arg0.curNum, string.format("%02d", arg0.curTaskIndex))
	setText(arg0.curSection, "POSITION " .. string.format("%02d", arg0.curTaskIndex))

	arg0.progressBar:GetComponent(typeof(Image)).fillAmount = arg0.curTaskIndex / #arg0.taskList
	arg0.items.anchoredPosition = {
		x = 0,
		y = 55 * (arg0.curTaskIndex - 1)
	}
end

function var0.IsShowRed()
	local var0 = getProxy(TaskProxy)
	local var1 = pg.activity_template[ActivityConst.NEWMEIXIV4_SKIRMISH_ID].config_data
	local var2 = {}

	for iter0, iter1 in ipairs(var1) do
		for iter2, iter3 in ipairs(iter1) do
			table.insert(var2, iter3)
		end
	end

	local function var3()
		for iter0, iter1 in ipairs(var2) do
			if var0:getTaskById(iter1) or var0:getFinishTaskById(iter1) then
				return iter0 - 1
			end
		end

		return 0
	end

	local var4 = 1

	for iter4, iter5 in ipairs(var2) do
		local var5 = var0:getTaskById(iter5) or var0:getFinishTaskById(iter5)
		local var6 = var2[iter4 + 1]
		local var7 = var0:getTaskById(var6) or var0:getFinishTaskById(var6)

		if var5 and var5:getTaskStatus() == 2 then
			var4 = var4 + 1

			if not var6 or not var7 then
				var4 = var4 - 1
			end
		end
	end

	local var8 = var2[var4 + var3()]
	local var9 = var0:getTaskById(var8) or var0:getFinishTaskById(var8)

	return var9 and var9:getTaskStatus() == 1
end

return var0
