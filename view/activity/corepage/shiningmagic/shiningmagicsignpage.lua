local var0_0 = class("ShiningMagicSignPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.daysTF = arg0_1.bg:Find("days")
	arg0_1.btnSign = arg0_1.bg:Find("btn_sign")
	arg0_1.remainTimes = arg0_1.btnSign:Find("remainTimes")
	arg0_1.tipSign = arg0_1.btnSign:Find("tip")
	arg0_1.btnSigned = arg0_1.bg:Find("btn_sign_gray")
	arg0_1.btnSignedAll = arg0_1.bg:Find("btn_sign_gray_all")
	arg0_1.days = {}

	for iter0_1 = 1, arg0_1.daysTF.childCount do
		arg0_1.days[iter0_1] = arg0_1:initDayTpl(arg0_1.daysTF:Find("day_" .. iter0_1))
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
end

function var0_0.OnUpdateFlush(arg0_7)
	arg0_7.curDay = arg0_7.activity.data3
	arg0_7.enableSign = false

	local var0_7 = arg0_7:isAllSigned()

	setActive(arg0_7.btnSignedAll, var0_7)

	if not var0_7 then
		local var1_7 = arg0_7.taskGroup[arg0_7.curDay]
		local var2_7 = math.min(arg0_7.activity:getDayIndex(), #arg0_7.taskGroup)

		arg0_7.curTaskVO = arg0_7.taskProxy:getTaskById(var1_7) or arg0_7.taskProxy:getFinishTaskById(var1_7)
		arg0_7.remain = math.max(var2_7 - arg0_7.curDay, 0)

		if arg0_7.curTaskVO:getTaskStatus() == 1 then
			arg0_7.remain = arg0_7.remain + 1
		end

		arg0_7.enableSign = arg0_7.remain > 0

		setText(arg0_7.remainTimes, i18n("shiningmagicsignpage_sign_remain") .. "  " .. arg0_7.remain)
	end

	local var3_7 = arg0_7.enableSign and arg0_7.curDay - 1 or arg0_7.curDay

	for iter0_7 = 1, var3_7 do
		local var4_7 = arg0_7.days[iter0_7]

		setActive(var4_7.signed, iter0_7 <= var3_7)
	end

	setActive(arg0_7.btnSign, arg0_7.enableSign)
end

function var0_0.initDayTpl(arg0_8, arg1_8)
	local var0_8 = {
		signed = arg1_8:Find("on")
	}

	setActive(var0_8.signed, false)

	return var0_8
end

function var0_0.isAllSigned(arg0_9)
	local var0_9 = arg0_9.taskGroup[#arg0_9.taskGroup]
	local var1_9 = arg0_9.taskProxy:getTaskById(var0_9) or arg0_9.taskProxy:getFinishTaskById(var0_9)

	return var1_9 and var1_9:getTaskStatus() == 2
end

return var0_0
