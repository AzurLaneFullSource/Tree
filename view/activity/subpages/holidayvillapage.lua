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

		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.HOLIDAY_VILLA_MAP)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_8)
	arg0_8.nday = arg0_8.activity.data3

	local var0_8 = arg0_8:IsFinishSign()

	setActive(arg0_8.got, false)
	setActive(arg0_8.go, not arg0_8:IsLockLiner() and var0_8)
	setActive(arg0_8.Notbtn, arg0_8:IsLockLiner())

	if not var0_8 then
		setActive(arg0_8.Notbtn, false)

		local var1_8 = arg0_8.taskGroup[arg0_8.nday]

		arg0_8.curTaskVO = arg0_8.taskProxy:getTaskById(var1_8) or arg0_8.taskProxy:getFinishTaskById(var1_8)
		arg0_8.remainCnt = math.min(arg0_8.activity:getDayIndex(), #arg0_8.taskGroup) - arg0_8.nday

		if arg0_8.curTaskVO:getTaskStatus() == 1 then
			arg0_8.remainCnt = arg0_8.remainCnt + 1
		end

		warning("self.remainCnt   :", arg0_8.remainCnt)
		setActive(arg0_8.getBtn_tip, arg0_8.remainCnt > 0)
		setActive(arg0_8.getBtn, arg0_8.remainCnt > 0)
		setActive(arg0_8.got, arg0_8.remainCnt == 0)
		setActive(arg0_8.countbg, true)
		setText(arg0_8.countText, i18n("liner_sign_cnt_tip") .. arg0_8.remainCnt)
	else
		setActive(arg0_8.countbg, false)
		setActive(arg0_8.getBtn, false)
	end

	for iter0_8, iter1_8 in ipairs(arg0_8.list) do
		setActive(arg0_8:findTF("accomplish", arg0_8.list[iter0_8]), var0_8 or iter0_8 < arg0_8.nday)
		setImageAlpha(iter1_8, (var0_8 or iter0_8 < arg0_8.nday) and 0 or 1)
		setActive(arg0_8:findTF("Check_point", arg0_8.list[iter0_8]), not var0_8 and iter0_8 == arg0_8.nday)
	end
end

function var0_0.IsFinishSign(arg0_9)
	local var0_9 = arg0_9.taskGroup[#arg0_9.taskGroup]
	local var1_9 = arg0_9.taskProxy:getTaskById(var0_9) or arg0_9.taskProxy:getFinishTaskById(var0_9)

	return var1_9 and var1_9:getTaskStatus() == 2
end

function var0_0.IsLockLiner(arg0_10)
	local var0_10 = getProxy(ActivityProxy):getActivityById(ActivityConst.HOLIDAY_ACT_ID)

	return not var0_10 or var0_10:isEnd()
end

return var0_0
