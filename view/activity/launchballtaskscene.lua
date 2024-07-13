local var0_0 = class("LaunchBallTaskScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "LaunchBallTaskUI"
end

function var0_0.getBGM(arg0_2)
	return "cw-story"
end

function var0_0.init(arg0_3)
	arg0_3.taskDatas = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_ZUMA_TASK):getConfig("config_client")
	arg0_3.iconTpl = findTF(arg0_3._tf, "ad/players/Viewport/Content/iconTpl")

	setActive(arg0_3.iconTpl, false)

	arg0_3.iconContent = findTF(arg0_3._tf, "ad/players/Viewport/Content")
	arg0_3.icons = {}

	for iter0_3 = 1, #arg0_3.taskDatas do
		local var0_3 = tf(instantiate(arg0_3.iconTpl))
		local var1_3 = iter0_3
		local var2_3 = arg0_3.taskDatas[iter0_3].player
		local var3_3 = LaunchBallActivityMgr.GetPlayerZhuanshuIndex(var2_3)
		local var4_3

		if var3_3 then
			var4_3 = LaunchBallActivityMgr.CheckZhuanShuAble(ActivityConst.MINIGAME_ZUMA, var3_3)
		else
			var4_3 = true
		end

		setActive(findTF(var0_3, "lock"), not var4_3)
		GetSpriteFromAtlasAsync("ui/launchballtaskui_atlas", "playerIcon" .. arg0_3.taskDatas[iter0_3].player, function(arg0_4)
			if arg0_4 then
				setImageSprite(findTF(var0_3, "img"), arg0_4, true)
			end
		end)
		setParent(var0_3, arg0_3.iconContent)
		setActive(var0_3, true)
		onButton(arg0_3, var0_3, function()
			if var4_3 then
				arg0_3:selectPlayer(var2_3)
			else
				local var0_5

				if var2_3 == 2 then
					var0_5 = i18n("launchball_lock_Shinano")
				elseif var2_3 == 3 then
					var0_5 = i18n("launchball_lock_Yura")
				elseif var2_3 == 4 then
					var0_5 = i18n("launchball_lock_Shimakaze")
				end

				pg.TipsMgr.GetInstance():ShowTips(var0_5)
			end
		end)
		table.insert(arg0_3.icons, {
			tf = var0_3,
			player = var2_3
		})
	end

	arg0_3.taskTpl = findTF(arg0_3._tf, "ad/tasks/Viewport/Content/taskTpl")
	arg0_3.taskContent = findTF(arg0_3._tf, "ad/tasks/Viewport/Content")

	setActive(arg0_3.taskTpl, false)

	arg0_3.tasks = {}

	onButton(arg0_3, findTF(arg0_3._tf, "ad/getAll"), function()
		if #arg0_3.submitTasks > 1 then
			arg0_3:emit(LaunchBallTaskMediator.SUBMIT_ALL, arg0_3.submitTasks)
		end
	end)

	arg0_3.helpWindow = findTF(arg0_3._tf, "helpWindow")

	setActive(arg0_3.helpWindow, false)
	onButton(arg0_3, findTF(arg0_3.helpWindow, "ad"), function()
		setActive(arg0_3.helpWindow, false)
	end)
	onButton(arg0_3, findTF(arg0_3.helpWindow, "ad/btnOk"), function()
		setActive(arg0_3.helpWindow, false)
	end)
	onButton(arg0_3, findTF(arg0_3._tf, "ad/back"), function()
		arg0_3:closeView()
	end)
	arg0_3:selectPlayer(1)
end

function var0_0.selectPlayer(arg0_10, arg1_10)
	for iter0_10 = 1, #arg0_10.icons do
		local var0_10 = arg0_10.icons[iter0_10].tf

		setActive(findTF(var0_10, "selected"), arg0_10.icons[iter0_10].player == arg1_10)
	end

	local var1_10 = arg0_10:getTaskByPlayer(arg1_10)

	arg0_10:updateTaskList(var1_10)

	arg0_10.selectPlayerId = arg1_10
end

function var0_0.updateTaskList(arg0_11, arg1_11)
	arg0_11.submitTasks = {}

	for iter0_11 = 1, #arg0_11.tasks do
		setActive(arg0_11.tasks[iter0_11].tf, false)
	end

	local var0_11 = {}

	for iter1_11 = 1, #arg1_11 do
		local var1_11 = arg1_11[iter1_11][2]
		local var2_11 = arg1_11[iter1_11][1]
		local var3_11 = getProxy(TaskProxy):getTaskById(var1_11)
		local var4_11 = getProxy(TaskProxy):getFinishTaskById(var1_11)

		if var3_11 then
			table.insert(var0_11, {
				data = var3_11,
				type = var2_11
			})
		elseif var4_11 then
			table.insert(var0_11, {
				data = var4_11,
				type = var2_11
			})
		end
	end

	table.sort(var0_11, function(arg0_12, arg1_12)
		local var0_12 = arg0_12.data
		local var1_12 = arg1_12.data

		if var0_12:getTaskStatus() == 1 and var1_12:getTaskStatus() ~= 1 then
			return true
		elseif var0_12:getTaskStatus() ~= 1 and var1_12:getTaskStatus() == 1 then
			return false
		elseif var0_12:getTaskStatus() == 2 and var1_12:getTaskStatus() ~= 2 then
			return false
		elseif var0_12:getTaskStatus() ~= 2 and var1_12:getTaskStatus() == 2 then
			return true
		else
			return var0_12.id < var1_12.id
		end
	end)

	for iter2_11 = 1, #var0_11 do
		local var5_11

		if iter2_11 > #arg0_11.tasks then
			var5_11 = tf(instantiate(arg0_11.taskTpl))

			setParent(var5_11, arg0_11.taskContent)
			setActive(var5_11, true)
			table.insert(arg0_11.tasks, {
				tf = var5_11
			})
		else
			var5_11 = arg0_11.tasks[iter2_11].tf
		end

		local var6_11 = var0_11[iter2_11].data
		local var7_11 = var0_11[iter2_11].type
		local var8_11 = var6_11.id
		local var9_11
		local var10_11
		local var11_11
		local var12_11
		local var13_11 = var6_11:getProgress()
		local var14_11 = var6_11:getTargetNumber()
		local var15_11 = var6_11:getConfig("desc")
		local var16_11 = var6_11:getConfig("award_display")[1]

		setSlider(findTF(var5_11, "Slider"), 0, 1, var13_11 / var14_11)

		local var17_11 = {
			type = var16_11[1],
			id = var16_11[2],
			count = var16_11[3]
		}

		updateDrop(findTF(var5_11, "icon"), var17_11)
		setActive(findTF(var5_11, "icon"), true)
		setText(findTF(var5_11, "desc"), var15_11)
		setText(findTF(var5_11, "progress"), var13_11 .. "/" .. var14_11)

		local var18_11

		if var7_11 == LaunchBallTaskMgr.type_series_split then
			var18_11 = i18n("launchball_spilt_series")
		elseif var7_11 == LaunchBallTaskMgr.type_close_split then
			var18_11 = i18n("launchball_spilt_mix")
		elseif var7_11 == LaunchBallTaskMgr.type_over_split then
			var18_11 = i18n("launchball_spilt_over")
		elseif var7_11 == LaunchBallTaskMgr.type_many_split then
			var18_11 = i18n("launchball_spilt_many")
		end

		if var18_11 then
			setActive(findTF(var5_11, "tip"), true)
		else
			setActive(findTF(var5_11, "tip"), false)
		end

		onButton(arg0_11, findTF(var5_11, "tip"), function()
			setText(findTF(arg0_11.helpWindow, "ad/desc"), var18_11)
			setActive(arg0_11.helpWindow, true)
		end)
		setActive(findTF(var5_11, "go"), var6_11:getTaskStatus() == 0)
		setActive(findTF(var5_11, "got"), var6_11:getTaskStatus() == 2)
		setActive(findTF(var5_11, "get"), var6_11:getTaskStatus() == 1)
		onButton(arg0_11, findTF(var5_11, "go"), function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SIXTH_ANNIVERSARY_JP_DARK)
		end)
		onButton(arg0_11, findTF(var5_11, "get"), function()
			pg.m02:sendNotification(GAME.SUBMIT_TASK, var8_11)
		end)
		setActive(var5_11, true)

		if var6_11:getTaskStatus() == 1 then
			table.insert(arg0_11.submitTasks, var6_11)
		end
	end

	setActive(findTF(arg0_11._tf, "ad/getAll"), #arg0_11.submitTasks > 1)
end

function var0_0.updateTasks(arg0_16)
	arg0_16:selectPlayer(arg0_16.selectPlayerId)
end

function var0_0.getTaskByPlayer(arg0_17, arg1_17)
	for iter0_17 = 1, #arg0_17.taskDatas do
		if arg0_17.taskDatas[iter0_17].player == arg1_17 then
			return arg0_17.taskDatas[iter0_17].task
		end
	end
end

function var0_0.willExit(arg0_18)
	return
end

return var0_0
