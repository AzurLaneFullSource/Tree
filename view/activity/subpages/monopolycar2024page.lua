local var0_0 = class("MonopolyCar2024Page", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.startBtn = arg0_1:findTF("AD/start")
	arg0_1.leftCountTxt = arg0_1.startBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_1.turnCntTxt = arg0_1:findTF("AD/turn"):GetComponent(typeof(Text))
	arg0_1.progressTxt = arg0_1:findTF("AD/progress"):GetComponent(typeof(Text))
	arg0_1.turnAwards = {
		arg0_1:findTF("AD/turn_awards/award_1"),
		arg0_1:findTF("AD/turn_awards/award_2"),
		arg0_1:findTF("AD/turn_awards/award_3")
	}
	arg0_1.turnGoBtn = arg0_1:findTF("AD/turn_awards/battle_btn")
	arg0_1.turnGetBtn = arg0_1:findTF("AD/turn_awards/get_btn")
	arg0_1.progressImage = arg0_1:findTF("AD/turn_awards/progress/bar")

	onButton(arg0_1, arg0_1.startBtn, function()
		if not arg0_1.activity or arg0_1.activity:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		for iter0_2, iter1_2 in ipairs(arg0_1.turnAwards) do
			setActive(iter1_2:Find("mark/get"), false)
		end

		arg0_1:emit(ActivityMediator.GO_MONOPOLY2024, arg0_1.activity.id, function()
			for iter0_3, iter1_3 in ipairs(arg0_1.turnAwards) do
				setActive(iter1_3:Find("mark/get"), true)
			end
		end)
	end, SFX_PANEL)

	arg0_1.taskGoBtn = arg0_1:findTF("AD/battle_btn")
	arg0_1.taskGetBtn = arg0_1:findTF("AD/get_btn")
	arg0_1.taskGotBtn = arg0_1:findTF("AD/got_btn")
	arg0_1.taskDesc = arg0_1:findTF("AD/Text"):GetComponent(typeof(Text))
	arg0_1.taskAward = arg0_1:findTF("AD/award")
	arg0_1.taskProgress = arg0_1:findTF("AD/taskProgress")
end

function var0_0.OnDataSetting(arg0_4)
	return
end

function var0_0.OnFirstFlush(arg0_5)
	return
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6:UpdateTurnAwards()
	arg0_6:UpdateTask()
end

function var0_0.UpdateTurnAwards(arg0_7)
	local var0_7 = arg0_7.activity
	local var1_7 = 3
	local var2_7 = (var0_7.data1_list[3] or 1) - 1
	local var3_7 = var0_7.data1_list[6] or 0

	arg0_7.turnCntTxt.text = var2_7 .. "/" .. var1_7

	local var4_7 = (math.max(var0_7.data2, 1) - 1) / #(var0_7:getDataConfig("map") or {})

	if var4_7 == 0 and var2_7 > 0 then
		var4_7 = 1
	end

	arg0_7.progressTxt.text = string.format("%.1f", var4_7 * 100) .. "%"

	local var5_7 = var3_7 + 1
	local var6_7 = var0_7:getDataConfig("sum_lap_reward_show")

	for iter0_7, iter1_7 in ipairs(arg0_7.turnAwards) do
		local var7_7 = var6_7[iter0_7]
		local var8_7 = Drop.New({
			type = var7_7[1],
			id = var7_7[2],
			count = var7_7[3]
		})

		updateDrop(iter1_7:Find("mask"), var8_7)
		onButton(arg0_7, iter1_7, function()
			arg0_7:emit(BaseUI.ON_DROP, var8_7)
		end, SFX_PANEL)
		setActive(iter1_7:Find("mark"), iter0_7 == var5_7)
		setActive(iter1_7:Find("got"), iter0_7 <= var3_7)
	end

	local var9_7 = var1_7 < var5_7
	local var10_7 = var5_7 <= var2_7

	setActive(arg0_7.turnGoBtn, not var10_7 and not var9_7)
	setActive(arg0_7.turnGetBtn, var10_7 and not var9_7)

	local var11_7 = {
		0.183,
		0.587,
		1
	}

	if var2_7 <= 0 then
		setFillAmount(arg0_7.progressImage, 0)
	else
		setFillAmount(arg0_7.progressImage, var11_7[var2_7] or 1)
	end

	local var12_7 = pg.TimeMgr.GetInstance():GetServerTime()
	local var13_7 = var0_7.data1
	local var14_7 = math.ceil((var12_7 - var13_7) / 86400) * var0_7:getDataConfig("daily_time") + (var0_7.data1_list[1] or 0) - (var0_7.data1_list[2] or 0)

	arg0_7.leftCountTxt.text = i18n("MonopolyCar2024Game_total_num_tip", var14_7)

	onButton(arg0_7, arg0_7.turnGetBtn, function()
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = var0_7.id,
			arg1 = var5_7,
			cmd = ActivityConst.MONOPOLY_OP_ROUND_AWD
		})
	end, SFX_PANEL)
end

function var0_0.UpdateTask(arg0_10)
	local var0_10 = pg.activity_const.MONOPOLY_TASK_ACT_ID.act_id
	local var1_10 = getProxy(ActivityProxy):getActivityById(var0_10)

	if not var1_10 or var1_10:isEnd() then
		return
	end

	local var2_10 = var1_10:getConfig("config_data")[1]
	local var3_10 = getProxy(TaskProxy)
	local var4_10 = var3_10:getTaskById(var2_10) or var3_10:getFinishTaskById(var2_10) or Task.New({
		id = var2_10
	})
	local var5_10 = var3_10:getTaskById(var2_10)
	local var6_10 = var4_10:getConfig("award_display")[1]
	local var7_10 = Drop.New({
		type = var6_10[1],
		id = var6_10[2],
		count = var6_10[3]
	})

	updateDrop(arg0_10.taskAward:Find("mask"), var7_10)
	onButton(arg0_10, arg0_10.taskAward, function()
		arg0_10:emit(BaseUI.ON_DROP, var7_10)
	end, SFX_PANEL)

	local var8_10 = var4_10:getConfig("target_num")

	if var5_10 ~= nil then
		local var9_10 = math.min(var4_10:getProgress(), var8_10)

		setSlider(arg0_10.taskProgress, 0, var8_10, var9_10)

		local var10_10 = var4_10:getConfig("desc")

		for iter0_10, iter1_10 in ipairs({
			var9_10
		}) do
			var10_10 = string.gsub(var10_10, "$" .. iter0_10, iter1_10)
		end

		arg0_10.taskDesc.text = var10_10

		local var11_10 = var4_10:isFinish()
		local var12_10 = var4_10:isReceive()

		setActive(arg0_10.taskGoBtn, not var11_10 and not var12_10)
		setActive(arg0_10.taskGetBtn, var11_10 and not var12_10)
		setActive(arg0_10.taskGotBtn, var12_10)
	else
		local var13_10 = var8_10

		setSlider(arg0_10.taskProgress, 0, var8_10, var13_10)

		local var14_10 = var4_10:getConfig("desc")

		for iter2_10, iter3_10 in ipairs({
			var13_10
		}) do
			var14_10 = string.gsub(var14_10, "$" .. iter2_10, iter3_10)
		end

		arg0_10.taskDesc.text = var14_10

		setActive(arg0_10.taskGoBtn, false)
		setActive(arg0_10.taskGetBtn, false)
		setActive(arg0_10.taskGotBtn, true)
	end

	onButton(arg0_10, arg0_10.taskGetBtn, function()
		arg0_10:emit(ActivityMediator.ON_TASK_SUBMIT, var4_10, function(arg0_13)
			if arg0_13 then
				arg0_10:OnUpdateFlush()
			end
		end)
	end, SFX_PANEL)
end

function var0_0.OnHideFlush(arg0_14)
	return
end

function var0_0.OnDestroy(arg0_15)
	return
end

return var0_0
