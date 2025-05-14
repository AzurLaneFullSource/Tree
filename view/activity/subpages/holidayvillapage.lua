local var0_0 = class("HolidayVillaPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.signTF = arg0_1:findTF("sign", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get", arg0_1.signTF)
	arg0_1.got = arg0_1:findTF("got", arg0_1.signTF)
	arg0_1.getBtn_tip = arg0_1:findTF("get/tip", arg0_1.signTF)
	arg0_1.countbg = arg0_1:findTF("count_bg", arg0_1.signTF)
	arg0_1.countText = arg0_1:findTF("count_bg/count", arg0_1.signTF)
	arg0_1.go = arg0_1:findTF("go_btn", arg0_1.signTF)
	arg0_1.Notbtn = arg0_1:findTF("Not_unlocked", arg0_1.signTF)
	arg0_1.list = {
		arg0_1:findTF("list/unfinished_1", arg0_1.signTF),
		arg0_1:findTF("list/unfinished_2", arg0_1.signTF),
		arg0_1:findTF("list/unfinished_3", arg0_1.signTF),
		arg0_1:findTF("list/unfinished_4", arg0_1.signTF),
		arg0_1:findTF("list/unfinished_5", arg0_1.signTF)
	}

	setActive(arg0_1.go, false)
	setActive(arg0_1.Notbtn, false)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.nday = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = underscore.flatten(arg0_2.activity:getConfig("config_data"))
	arg0_2.preStory = arg0_2.activity:getConfig("config_client").preStory

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	for iter0_3 = 1, #arg0_3.list do
		setActive(arg0_3:findTF("accomplish", arg0_3.list[iter0_3]), false)
		setActive(arg0_3:findTF("Check_point", arg0_3.list[iter0_3]), false)
	end

	onButton(arg0_3, arg0_3.getBtn, function()
		if not arg0_3.remainCnt or arg0_3.remainCnt <= 0 then
			return
		end

		seriesAsync({
			function(arg0_5)
				local var0_5 = arg0_3.activity:getConfig("config_client").story

				if checkExist(var0_5, {
					arg0_3.nday
				}, {
					1
				}) then
					pg.NewStoryMgr.GetInstance():Play(var0_5[arg0_3.nday][1], arg0_5)
				else
					arg0_5()
				end
			end,
			function(arg0_6)
				if arg0_3.curTaskVO:getTaskStatus() == 1 then
					arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.curTaskVO, arg0_6)
				else
					arg0_6()
				end
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.go, function()
		if arg0_3:IsLockLiner() then
			return
		end

		seriesAsync({
			function(arg0_8)
				if not pg.NewStoryMgr.GetInstance():IsPlayed(arg0_3.preStory) then
					pg.NewStoryMgr.GetInstance():Play(arg0_3.preStory, arg0_8)
				else
					arg0_8()
				end
			end
		}, function()
			local var0_9 = Context.New({
				mediator = HolidayVillaMapScene,
				viewComponent = HolidayVillaMapMediator
			})

			arg0_3:emit(ActivityMediator.ON_ADD_SUBLAYER, var0_9)
		end)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_10)
	arg0_10.nday = arg0_10.activity.data3

	local var0_10 = arg0_10:IsFinishSign()

	arg0_10.count = 0

	for iter0_10 = 1, #arg0_10.taskGroup do
		arg0_10.curTaskVO = arg0_10.taskProxy:getTaskVO(arg0_10.taskGroup[iter0_10])

		if arg0_10.curTaskVO ~= nil and arg0_10.curTaskVO:getTaskStatus() == 2 then
			arg0_10.count = iter0_10
		end
	end

	setActive(arg0_10.got, false)
	setActive(arg0_10.go, not arg0_10:IsLockLiner() and arg0_10.count >= 5)
	setActive(arg0_10.Notbtn, arg0_10:IsLockLiner())

	if not var0_10 then
		setActive(arg0_10.Notbtn, false)

		local var1_10 = arg0_10.taskGroup[arg0_10.nday]

		arg0_10.curTaskVO = arg0_10.taskProxy:getTaskById(var1_10) or arg0_10.taskProxy:getFinishTaskById(var1_10)
		arg0_10.remainCnt = math.min(arg0_10.activity:getDayIndex(), #arg0_10.taskGroup) - arg0_10.nday

		if arg0_10.curTaskVO:getTaskStatus() == 1 then
			arg0_10.remainCnt = arg0_10.remainCnt + 1
		end

		warning("self.remainCnt   :", arg0_10.remainCnt)
		setActive(arg0_10.getBtn_tip, arg0_10.remainCnt > 0)
		setActive(arg0_10.getBtn, arg0_10.remainCnt > 0)
		setActive(arg0_10.got, arg0_10.remainCnt == 0)
		setActive(arg0_10.countbg, true)
		setText(arg0_10.countText, i18n("liner_sign_cnt_tip") .. arg0_10.remainCnt)
	else
		setActive(arg0_10.countbg, false)
		setActive(arg0_10.getBtn, false)
	end

	for iter1_10 = 1, #arg0_10.list do
		setActive(arg0_10:findTF("accomplish", arg0_10.list[iter1_10]), false)
		setActive(arg0_10:findTF("Check_point", arg0_10.list[iter1_10]), false)

		if arg0_10.count > 0 and iter1_10 <= arg0_10.count then
			setActive(arg0_10:findTF("accomplish", arg0_10.list[iter1_10]), true)

			arg0_10.list[iter1_10]:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 0)
		end
	end

	if arg0_10.count + 1 <= 5 then
		setActive(arg0_10:findTF("Check_point", arg0_10.list[arg0_10.count + 1]), true)
	end
end

function var0_0.IsFinishSign(arg0_11)
	local var0_11 = arg0_11.taskGroup[#arg0_11.taskGroup]
	local var1_11 = arg0_11.taskProxy:getTaskById(var0_11) or arg0_11.taskProxy:getFinishTaskById(var0_11)

	return var1_11 and var1_11:getTaskStatus() == 2
end

function var0_0.IsLockLiner(arg0_12)
	local var0_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.HOLIDAY_ACT_ID)

	return not var0_12 or var0_12:isEnd()
end

return var0_0
