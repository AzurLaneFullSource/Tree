local var0_0 = class("HolidayCoreActivityZ52Page", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.progTF = arg0_1._tf:Find("bg/prog")
	arg0_1.btnLock = arg0_1._tf:Find("bg/btnLock")
	arg0_1.lock = arg0_1.btnLock:Find("lock")
	arg0_1.btnGo = arg0_1._tf:Find("bg/btnGo")
	arg0_1.btnSign = arg0_1._tf:Find("bg/btnSign")
	arg0_1.tipSign = arg0_1.btnSign:Find("tip")
	arg0_1.remainTimes = arg0_1.btnSign:Find("remainTimes")
	arg0_1.prog = {}

	for iter0_1 = 1, arg0_1.progTF.childCount do
		arg0_1.prog[iter0_1] = arg0_1:createProg(arg0_1.progTF:Find("prog_" .. iter0_1))
	end
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.curDay = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = underscore.flatten(arg0_2.activity:getConfig("config_data"))
	arg0_2.preStory = arg0_2.activity:getConfig("config_client").preStory

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.btnSign, function()
		if not arg0_3.enableSign then
			return
		end

		seriesAsync({
			function(arg0_5)
				local var0_5 = arg0_3.activity:getConfig("config_client").story

				if checkExist(var0_5, {
					arg0_3.curDay
				}, {
					1
				}) then
					pg.NewStoryMgr.GetInstance():Play(var0_5[arg0_3.curDay][1], arg0_5)
				else
					arg0_5()
				end
			end,
			function(arg0_6)
				if arg0_3.curTaskVO and arg0_3.curTaskVO:getTaskStatus() == 1 then
					arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.curTaskVO, arg0_6)
				else
					arg0_6()
				end
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.btnGo, function()
		if arg0_3:isTargetLocking() then
			return
		end

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MALL_MAP)
	end, SFX_PANEL)
	setText(arg0_3.lock, i18n("20260514_story_unlock_tip"))
end

function var0_0.OnUpdateFlush(arg0_8)
	arg0_8.curDay = arg0_8.activity.data3
	arg0_8.enableSign = false

	local var0_8 = arg0_8:isAllSigned()
	local var1_8 = arg0_8:isTargetLocking()

	setActive(arg0_8.btnSign, not var0_8)
	setActive(arg0_8.btnLock, var1_8 and var0_8)
	setActive(arg0_8.btnGo, not var1_8 and var0_8)

	if not var0_8 then
		local var2_8 = arg0_8.taskGroup[arg0_8.curDay]
		local var3_8 = math.min(arg0_8.activity:getDayIndex(), #arg0_8.taskGroup)

		arg0_8.curTaskVO = arg0_8.taskProxy:getTaskById(var2_8) or arg0_8.taskProxy:getFinishTaskById(var2_8)
		arg0_8.remain = math.max(var3_8 - arg0_8.curDay, 0)

		if arg0_8.curTaskVO:getTaskStatus() == 1 then
			arg0_8.remain = arg0_8.remain + 1
		end

		arg0_8.enableSign = arg0_8.remain > 0

		setText(arg0_8.remainTimes, arg0_8.remain)
	end

	local var4_8 = arg0_8.enableSign and arg0_8.curDay - 1 or arg0_8.curDay

	for iter0_8 = 1, var4_8 do
		local var5_8 = arg0_8.prog[iter0_8]

		setActive(var5_8.signed, iter0_8 <= var4_8)
		setActive(var5_8.current, iter0_8 == var4_8 and not var0_8)
	end

	setActive(arg0_8.tipSign, arg0_8.enableSign)
	setGray(arg0_8.btnSign, not arg0_8.enableSign, true)
end

function var0_0.createProg(arg0_9, arg1_9)
	local var0_9 = {
		current = arg1_9:Find("current"),
		signed = arg1_9:Find("signed")
	}

	setActive(var0_9.current, false)
	setActive(var0_9.signed, false)

	return var0_9
end

function var0_0.getTargetID(arg0_10)
	return 50619
end

function var0_0.isTargetLocking(arg0_11)
	local var0_11 = getProxy(ActivityProxy):getActivityById(arg0_11:getTargetID())

	return not var0_11 or var0_11:isEnd()
end

function var0_0.isAllSigned(arg0_12)
	local var0_12 = arg0_12.taskGroup[#arg0_12.taskGroup]
	local var1_12 = arg0_12.taskProxy:getTaskById(var0_12) or arg0_12.taskProxy:getFinishTaskById(var0_12)

	return var1_12 and var1_12:getTaskStatus() == 2
end

return var0_0
