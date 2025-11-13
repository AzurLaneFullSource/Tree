local var0_0 = class("PSSSkinPage", import("view.activity.CorePage.CoreLoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
end

function var0_0.UpdateTask(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2 + 1
	local var1_2 = arg2_2:Find("item")
	local var2_2 = arg0_2.taskGroup[arg0_2.nday][var0_2]
	local var3_2 = arg0_2.taskProxy:getTaskById(var2_2) or arg0_2.taskProxy:getFinishTaskById(var2_2)

	assert(var3_2, "without this task by id: " .. var2_2)

	local var4_2 = Drop.Create(var3_2:getConfig("award_display")[1])

	updateDrop(var1_2, var4_2)
	onButton(arg0_2, var1_2, function()
		arg0_2:emit(BaseUI.ON_DROP, var4_2)
	end, SFX_PANEL)

	local var5_2 = var3_2:getProgress()
	local var6_2 = var3_2:getConfig("target_num")

	setText(arg2_2:Find("description"), var3_2:getConfig("desc"))
	setText(arg2_2:Find("progressText"), var5_2)
	setText(arg2_2:Find("progressText_1"), "/" .. var6_2)
	setSlider(arg2_2:Find("progress"), 0, var6_2, var5_2)

	local var7_2 = arg2_2:Find("go_btn")
	local var8_2 = arg2_2:Find("get_btn")
	local var9_2 = arg2_2:Find("got_btn")

	setText(arg2_2:Find("go_btn/Text"), i18n("island_word_go"))
	setText(arg2_2:Find("get_btn/Text"), i18n("handbook_research_final_task_btn_claim"))
	setText(arg2_2:Find("got_btn/Text"), i18n("handbook_research_final_task_btn_finished"))

	local var10_2 = var3_2:getTaskStatus()

	setActive(var7_2, var10_2 == 0)
	setActive(var8_2, var10_2 == 1)
	setActive(var9_2, var10_2 == 2)
	onButton(arg0_2, var7_2, function()
		arg0_2:emit(ActivityMediator.ON_TASK_GO, var3_2)
	end, SFX_PANEL)
	onButton(arg0_2, var8_2, function()
		local var0_5 = {}
		local var1_5 = var3_2:getConfig("award_display")
		local var2_5 = getProxy(PlayerProxy):getRawData()
		local var3_5 = pg.gameset.urpt_chapter_max.description[1]
		local var4_5 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_5)
		local var5_5, var6_5 = Task.StaticJudgeOverflow(var2_5.gold, var2_5.oil, var4_5, true, true, var1_5)

		if var5_5 then
			table.insert(var0_5, function(arg0_6)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_5,
					onYes = arg0_6
				})
			end)
		end

		seriesAsync(var0_5, function()
			arg0_2:emit(ActivityMediator.ON_TASK_SUBMIT, var3_2)
		end)
	end, SFX_PANEL)
end

return var0_0
