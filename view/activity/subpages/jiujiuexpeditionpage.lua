local var0_0 = class("JiuJiuExpeditionPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.slider = arg0_1:findTF("slider", arg0_1.bg)
	arg0_1.step = arg0_1:findTF("step", arg0_1.bg)
	arg0_1.progress = arg0_1:findTF("progress", arg0_1.bg)
	arg0_1.awardTF = arg0_1:findTF("award", arg0_1.bg)
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
	arg0_1.help = arg0_1:findTF("help", arg0_1.bg)
	arg0_1.book = arg0_1:findTF("book", arg0_1.bg)
	arg0_1.startGame = arg0_1:findTF("startGame", arg0_1.bg)
	arg0_1.desc = arg0_1:findTF("desc", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_data")

	arg0_2.taskIDList = _.flatten(var0_2)
	arg0_2.dropList = {}
	arg0_2.descs = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.taskIDList) do
		local var1_2 = pg.task_data_template[iter1_2].award_display[1]

		table.insert(arg0_2.dropList, Clone(var1_2))

		local var2_2 = pg.task_data_template[iter1_2].desc

		table.insert(arg0_2.descs, var2_2)
	end

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.battleBtn, function()
		if arg0_3.curTaskVO then
			arg0_3:emit(ActivityMediator.ON_TASK_GO, arg0_3.curTaskVO)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.curTaskVO)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.jiujiu_expedition_help.tip
		})
	end, SFX_PANEL)

	if PLATFORM_CODE ~= PLATFORM_JP then
		setActive(arg0_3.book, false)
	else
		local var0_3, var1_3, var2_3, var3_3 = JiuJiuExpeditionCollectionMediator.GetCollectionData()

		setActive(findTF(arg0_3.book, "tip"), var3_3 < var2_3)
		onButton(arg0_3, arg0_3.book, function()
			arg0_3:emit(ActivityMediator.OPEN_LAYER, Context.New({
				viewComponent = JiuJiuExpeditionCollectionLayer,
				mediator = JiuJiuExpeditionCollectionMediator
			}))
		end, SFX_PANEL)
	end

	onButton(arg0_3, arg0_3.startGame, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.JIUJIU_EXPEDITION)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_9)
	local var0_9, var1_9 = getActivityTask(arg0_9.activity)

	arg0_9.curTaskVO = var1_9

	setText(arg0_9.desc, arg0_9.curTaskVO:getConfig("desc"))

	local var2_9 = var1_9:getConfig("award_display")[1]
	local var3_9 = {
		type = var2_9[1],
		id = var2_9[2],
		count = var2_9[3]
	}

	updateDrop(arg0_9.awardTF, var3_9)
	onButton(arg0_9, arg0_9.awardTF, function()
		arg0_9:emit(BaseUI.ON_DROP, var3_9)
	end, SFX_PANEL)

	local var4_9 = var1_9:getProgress()
	local var5_9 = var1_9:getConfig("target_num")

	setText(arg0_9.progress, (var5_9 <= var4_9 and setColorStr(var4_9, COLOR_GREEN) or var4_9) .. "/" .. var5_9)
	setSlider(arg0_9.slider, 0, var5_9, var4_9)

	local var6_9 = table.indexof(arg0_9.taskIDList, var0_9, 1)

	setText(arg0_9.step, var6_9 .. "/" .. #arg0_9.taskIDList)

	local var7_9 = var1_9:getTaskStatus()

	setActive(arg0_9.battleBtn, var7_9 == 0)
	setActive(arg0_9.getBtn, var7_9 == 1)
	setActive(arg0_9.gotBtn, var7_9 == 2)

	if var7_9 == 2 then
		arg0_9.finishedIndex = var6_9
	else
		arg0_9.finishedIndex = var6_9 - 1
	end
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
