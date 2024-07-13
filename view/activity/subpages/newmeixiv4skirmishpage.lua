local var0_0 = class("NewMeixiV4SkirmishPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.progressBar = arg0_1:findTF("progress/bar", arg0_1.bg)
	arg0_1.curNum = arg0_1:findTF("progress/cur_num", arg0_1.bg)
	arg0_1.curSection = arg0_1:findTF("progress/cur_section", arg0_1.bg)
	arg0_1.item = arg0_1:findTF("scrollview/item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("scrollview/items", arg0_1.bg)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2:initTaskData()

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.initTaskData(arg0_3)
	arg0_3.taskProxy = getProxy(TaskProxy)
	arg0_3.taskGroup = pg.activity_template[ActivityConst.NEWMEIXIV4_SKIRMISH_ID].config_data
	arg0_3.taskList = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.taskGroup) do
		for iter2_3, iter3_3 in ipairs(iter1_3) do
			table.insert(arg0_3.taskList, iter3_3)
		end
	end

	arg0_3:SetClearNum()
	arg0_3:SetCurIndex()
end

function var0_0.SetClearNum(arg0_4)
	arg0_4.clearTaskNum = 0

	for iter0_4, iter1_4 in ipairs(arg0_4.taskList) do
		if arg0_4.taskProxy:getTaskById(iter1_4) or arg0_4.taskProxy:getFinishTaskById(iter1_4) then
			arg0_4.clearTaskNum = iter0_4 - 1

			return
		end
	end
end

function var0_0.SetCurIndex(arg0_5)
	arg0_5.curTaskIndex = 1

	for iter0_5, iter1_5 in ipairs(arg0_5.taskList) do
		local var0_5 = arg0_5.taskProxy:getTaskById(iter1_5) or arg0_5.taskProxy:getFinishTaskById(iter1_5)
		local var1_5 = arg0_5.taskList[iter0_5 + 1]
		local var2_5 = arg0_5.taskProxy:getTaskById(var1_5) or arg0_5.taskProxy:getFinishTaskById(var1_5)

		if var0_5 and var0_5:getTaskStatus() == 2 then
			arg0_5.curTaskIndex = arg0_5.curTaskIndex + 1

			if not var1_5 or not var2_5 then
				arg0_5.curTaskIndex = arg0_5.curTaskIndex - 1
			end
		end
	end

	arg0_5.curTaskIndex = arg0_5.curTaskIndex + arg0_5.clearTaskNum
end

function var0_0.OnFirstFlush(arg0_6)
	onButton(arg0_6, arg0_6.battleBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NEWMEIXIV4_SKIRMISH, {
			taskList = arg0_6.taskList
		})
	end, SFX_PANEL)
	arg0_6.uilist:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg1_8 + 1
			local var1_8 = arg0_6:findTF("item", arg2_8)
			local var2_8 = arg0_6.taskList[var0_8]
			local var3_8 = arg0_6.taskProxy:getTaskById(var2_8) or arg0_6.taskProxy:getFinishTaskById(var2_8)

			setActive(arg0_6:findTF("finish", arg2_8), var3_8 and var3_8:getTaskStatus() == 2 or var0_8 <= arg0_6.clearTaskNum)
			setActive(arg0_6:findTF("lock", arg2_8), false)
			setText(arg0_6:findTF("title", arg2_8), "P" .. var0_8)
		end
	end)
	arg0_6.uilist:align(#arg0_6.taskList)
end

function var0_0.OnUpdateFlush(arg0_9)
	arg0_9:SetCurIndex()
	setText(arg0_9.curNum, string.format("%02d", arg0_9.curTaskIndex))
	setText(arg0_9.curSection, "POSITION " .. string.format("%02d", arg0_9.curTaskIndex))

	arg0_9.progressBar:GetComponent(typeof(Image)).fillAmount = arg0_9.curTaskIndex / #arg0_9.taskList
	arg0_9.items.anchoredPosition = {
		x = 0,
		y = 55 * (arg0_9.curTaskIndex - 1)
	}
end

function var0_0.IsShowRed()
	local var0_10 = getProxy(TaskProxy)
	local var1_10 = pg.activity_template[ActivityConst.NEWMEIXIV4_SKIRMISH_ID].config_data
	local var2_10 = {}

	for iter0_10, iter1_10 in ipairs(var1_10) do
		for iter2_10, iter3_10 in ipairs(iter1_10) do
			table.insert(var2_10, iter3_10)
		end
	end

	local function var3_10()
		for iter0_11, iter1_11 in ipairs(var2_10) do
			if var0_10:getTaskById(iter1_11) or var0_10:getFinishTaskById(iter1_11) then
				return iter0_11 - 1
			end
		end

		return 0
	end

	local var4_10 = 1

	for iter4_10, iter5_10 in ipairs(var2_10) do
		local var5_10 = var0_10:getTaskById(iter5_10) or var0_10:getFinishTaskById(iter5_10)
		local var6_10 = var2_10[iter4_10 + 1]
		local var7_10 = var0_10:getTaskById(var6_10) or var0_10:getFinishTaskById(var6_10)

		if var5_10 and var5_10:getTaskStatus() == 2 then
			var4_10 = var4_10 + 1

			if not var6_10 or not var7_10 then
				var4_10 = var4_10 - 1
			end
		end
	end

	local var8_10 = var2_10[var4_10 + var3_10()]
	local var9_10 = var0_10:getTaskById(var8_10) or var0_10:getFinishTaskById(var8_10)

	return var9_10 and var9_10:getTaskStatus() == 1
end

return var0_0
