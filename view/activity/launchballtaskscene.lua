local var0 = class("LaunchBallTaskScene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "LaunchBallTaskUI"
end

function var0.getBGM(arg0)
	return "cw-story"
end

function var0.init(arg0)
	arg0.taskDatas = getProxy(ActivityProxy):getActivityById(ActivityConst.MINIGAME_ZUMA_TASK):getConfig("config_client")
	arg0.iconTpl = findTF(arg0._tf, "ad/players/Viewport/Content/iconTpl")

	setActive(arg0.iconTpl, false)

	arg0.iconContent = findTF(arg0._tf, "ad/players/Viewport/Content")
	arg0.icons = {}

	for iter0 = 1, #arg0.taskDatas do
		local var0 = tf(instantiate(arg0.iconTpl))
		local var1 = iter0
		local var2 = arg0.taskDatas[iter0].player
		local var3 = LaunchBallActivityMgr.GetPlayerZhuanshuIndex(var2)
		local var4

		if var3 then
			var4 = LaunchBallActivityMgr.CheckZhuanShuAble(ActivityConst.MINIGAME_ZUMA, var3)
		else
			var4 = true
		end

		setActive(findTF(var0, "lock"), not var4)
		GetSpriteFromAtlasAsync("ui/launchballtaskui_atlas", "playerIcon" .. arg0.taskDatas[iter0].player, function(arg0)
			if arg0 then
				setImageSprite(findTF(var0, "img"), arg0, true)
			end
		end)
		setParent(var0, arg0.iconContent)
		setActive(var0, true)
		onButton(arg0, var0, function()
			if var4 then
				arg0:selectPlayer(var2)
			else
				local var0

				if var2 == 2 then
					var0 = i18n("launchball_lock_Shinano")
				elseif var2 == 3 then
					var0 = i18n("launchball_lock_Yura")
				elseif var2 == 4 then
					var0 = i18n("launchball_lock_Shimakaze")
				end

				pg.TipsMgr.GetInstance():ShowTips(var0)
			end
		end)
		table.insert(arg0.icons, {
			tf = var0,
			player = var2
		})
	end

	arg0.taskTpl = findTF(arg0._tf, "ad/tasks/Viewport/Content/taskTpl")
	arg0.taskContent = findTF(arg0._tf, "ad/tasks/Viewport/Content")

	setActive(arg0.taskTpl, false)

	arg0.tasks = {}

	onButton(arg0, findTF(arg0._tf, "ad/getAll"), function()
		if #arg0.submitTasks > 1 then
			arg0:emit(LaunchBallTaskMediator.SUBMIT_ALL, arg0.submitTasks)
		end
	end)

	arg0.helpWindow = findTF(arg0._tf, "helpWindow")

	setActive(arg0.helpWindow, false)
	onButton(arg0, findTF(arg0.helpWindow, "ad"), function()
		setActive(arg0.helpWindow, false)
	end)
	onButton(arg0, findTF(arg0.helpWindow, "ad/btnOk"), function()
		setActive(arg0.helpWindow, false)
	end)
	onButton(arg0, findTF(arg0._tf, "ad/back"), function()
		arg0:closeView()
	end)
	arg0:selectPlayer(1)
end

function var0.selectPlayer(arg0, arg1)
	for iter0 = 1, #arg0.icons do
		local var0 = arg0.icons[iter0].tf

		setActive(findTF(var0, "selected"), arg0.icons[iter0].player == arg1)
	end

	local var1 = arg0:getTaskByPlayer(arg1)

	arg0:updateTaskList(var1)

	arg0.selectPlayerId = arg1
end

function var0.updateTaskList(arg0, arg1)
	arg0.submitTasks = {}

	for iter0 = 1, #arg0.tasks do
		setActive(arg0.tasks[iter0].tf, false)
	end

	local var0 = {}

	for iter1 = 1, #arg1 do
		local var1 = arg1[iter1][2]
		local var2 = arg1[iter1][1]
		local var3 = getProxy(TaskProxy):getTaskById(var1)
		local var4 = getProxy(TaskProxy):getFinishTaskById(var1)

		if var3 then
			table.insert(var0, {
				data = var3,
				type = var2
			})
		elseif var4 then
			table.insert(var0, {
				data = var4,
				type = var2
			})
		end
	end

	table.sort(var0, function(arg0, arg1)
		local var0 = arg0.data
		local var1 = arg1.data

		if var0:getTaskStatus() == 1 and var1:getTaskStatus() ~= 1 then
			return true
		elseif var0:getTaskStatus() ~= 1 and var1:getTaskStatus() == 1 then
			return false
		elseif var0:getTaskStatus() == 2 and var1:getTaskStatus() ~= 2 then
			return false
		elseif var0:getTaskStatus() ~= 2 and var1:getTaskStatus() == 2 then
			return true
		else
			return var0.id < var1.id
		end
	end)

	for iter2 = 1, #var0 do
		local var5

		if iter2 > #arg0.tasks then
			var5 = tf(instantiate(arg0.taskTpl))

			setParent(var5, arg0.taskContent)
			setActive(var5, true)
			table.insert(arg0.tasks, {
				tf = var5
			})
		else
			var5 = arg0.tasks[iter2].tf
		end

		local var6 = var0[iter2].data
		local var7 = var0[iter2].type
		local var8 = var6.id
		local var9
		local var10
		local var11
		local var12
		local var13 = var6:getProgress()
		local var14 = var6:getTargetNumber()
		local var15 = var6:getConfig("desc")
		local var16 = var6:getConfig("award_display")[1]

		setSlider(findTF(var5, "Slider"), 0, 1, var13 / var14)

		local var17 = {
			type = var16[1],
			id = var16[2],
			count = var16[3]
		}

		updateDrop(findTF(var5, "icon"), var17)
		setActive(findTF(var5, "icon"), true)
		setText(findTF(var5, "desc"), var15)
		setText(findTF(var5, "progress"), var13 .. "/" .. var14)

		local var18

		if var7 == LaunchBallTaskMgr.type_series_split then
			var18 = i18n("launchball_spilt_series")
		elseif var7 == LaunchBallTaskMgr.type_close_split then
			var18 = i18n("launchball_spilt_mix")
		elseif var7 == LaunchBallTaskMgr.type_over_split then
			var18 = i18n("launchball_spilt_over")
		elseif var7 == LaunchBallTaskMgr.type_many_split then
			var18 = i18n("launchball_spilt_many")
		end

		if var18 then
			setActive(findTF(var5, "tip"), true)
		else
			setActive(findTF(var5, "tip"), false)
		end

		onButton(arg0, findTF(var5, "tip"), function()
			setText(findTF(arg0.helpWindow, "ad/desc"), var18)
			setActive(arg0.helpWindow, true)
		end)
		setActive(findTF(var5, "go"), var6:getTaskStatus() == 0)
		setActive(findTF(var5, "got"), var6:getTaskStatus() == 2)
		setActive(findTF(var5, "get"), var6:getTaskStatus() == 1)
		onButton(arg0, findTF(var5, "go"), function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SIXTH_ANNIVERSARY_JP_DARK)
		end)
		onButton(arg0, findTF(var5, "get"), function()
			pg.m02:sendNotification(GAME.SUBMIT_TASK, var8)
		end)
		setActive(var5, true)

		if var6:getTaskStatus() == 1 then
			table.insert(arg0.submitTasks, var6)
		end
	end

	setActive(findTF(arg0._tf, "ad/getAll"), #arg0.submitTasks > 1)
end

function var0.updateTasks(arg0)
	arg0:selectPlayer(arg0.selectPlayerId)
end

function var0.getTaskByPlayer(arg0, arg1)
	for iter0 = 1, #arg0.taskDatas do
		if arg0.taskDatas[iter0].player == arg1 then
			return arg0.taskDatas[iter0].task
		end
	end
end

function var0.willExit(arg0)
	return
end

return var0
