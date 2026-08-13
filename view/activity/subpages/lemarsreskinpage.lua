local var0_0 = class("LeMarsReSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.displayBtn = arg0_1.bg:Find("display_btn")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.displayBtn, function()
		local var0_3 = {}
		local var1_3 = {}
		local var2_3 = arg0_2.taskGroup[arg0_2.nday][1]
		local var3_3 = arg0_2.taskProxy:getTaskById(var2_3) or arg0_2.taskProxy:getFinishTaskById(var2_3)
		local var4_3 = var3_3:getProgress()
		local var5_3 = arg0_2.nday

		for iter0_3, iter1_3 in ipairs(arg0_2.activity:getConfig("config_data")) do
			for iter2_3, iter3_3 in ipairs(iter1_3) do
				local var6_3 = pg.task_data_template[iter3_3]

				if var6_3 and var6_3.award_display and var6_3.award_display[1] then
					table.insert(var0_3, var6_3.award_display[1])
					table.insert(var1_3, var6_3.target_num)
				end
			end
		end

		if var3_3:getTaskStatus() ~= 2 then
			var5_3 = var5_3 - 1
		end

		arg0_2:emit(ActivityMediator.ON_AWARD_WINDOW, var0_3, var5_3, {
			i18n("LeMarsReSkinPage_reward_target"),
			i18n("LeMarsReSkinPage_reward_title")
		}, {
			targetList = var1_3,
			nowGet = var4_3
		})
	end, SFX_PANEL)
end

function var0_0.UpdateTask(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4 + 1
	local var1_4 = arg2_4:Find("award")
	local var2_4 = arg0_4.taskGroup[arg0_4.nday][1]
	local var3_4 = arg0_4.taskProxy:getTaskById(var2_4) or arg0_4.taskProxy:getFinishTaskById(var2_4)

	assert(var3_4, "without this task by id: " .. var2_4)

	local var4_4 = Drop.Create(var3_4:getConfig("award_display")[1])

	updateDrop(var1_4, var4_4)
	onButton(arg0_4, var1_4, function()
		arg0_4:emit(BaseUI.ON_DROP, var4_4)
	end, SFX_PANEL)

	local var5_4 = var3_4:getProgress()
	local var6_4 = var3_4:getConfig("target_num")

	setScrollText(arg2_4:Find("mask/description"), var3_4:getConfig("desc"))

	local var7_4, var8_4 = arg0_4:GetProgressColor()
	local var9_4

	var9_4 = var7_4 and setColorStr(var5_4, var7_4) or var5_4

	local var10_4

	var10_4 = var8_4 and setColorStr("/" .. var6_4, var8_4) or "/" .. var6_4

	setText(arg2_4:Find("progress"), var9_4 .. var10_4)
	setSlider(arg2_4:Find("slider"), 0, var6_4, var5_4)

	local var11_4 = arg2_4:Find("go_btn")
	local var12_4 = arg2_4:Find("get_btn")
	local var13_4 = arg2_4:Find("got_btn")
	local var14_4 = var3_4:getTaskStatus()

	setActive(var11_4, var14_4 == 0)
	setActive(var12_4, var14_4 == 1)
	setActive(var13_4, var14_4 == 2)
	onButton(arg0_4, var11_4, function()
		arg0_4:emit(ActivityMediator.ON_TASK_GO, var3_4)
	end, SFX_PANEL)
	onButton(arg0_4, var12_4, function()
		local var0_7 = {}
		local var1_7 = var3_4:getConfig("award_display")
		local var2_7 = getProxy(PlayerProxy):getRawData()
		local var3_7 = pg.gameset.urpt_chapter_max.description[1]
		local var4_7 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_7)
		local var5_7, var6_7 = Task.StaticJudgeOverflow(var2_7.gold, var2_7.oil, var4_7, true, true, var1_7)

		if var5_7 then
			table.insert(var0_7, function(arg0_8)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_7,
					onYes = arg0_8
				})
			end)
		end

		seriesAsync(var0_7, function()
			arg0_4:emit(ActivityMediator.ON_TASK_SUBMIT, var3_4)
		end)
	end, SFX_PANEL)
end

function var0_0.GetProgressColor(arg0_10)
	return "#1EA2ACFF", "#3DCCD7"
end

return var0_0
