local var0_0 = class("WorldInPicturePage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.item = arg0_1:findTF("items/item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.bg)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.help = arg0_1:findTF("AD/help")
	arg0_1.start = arg0_1:findTF("AD/start")
	arg0_1.dayTF = arg0_1:findTF("Text", arg0_1.bg)
	arg0_1.tip = arg0_1:findTF("AD/tip")
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.worldinpicture_task_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.start, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLDINPICTURE)
	end, SFX_PANEL)

	arg0_2.miniGameAct = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)
end

function var0_0.UpdateTask(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5 + 1
	local var1_5 = arg0_5:findTF("item", arg2_5)
	local var2_5 = arg0_5.taskGroup[arg0_5.nday][var0_5]
	local var3_5 = arg0_5.taskProxy:getTaskById(var2_5) or arg0_5.taskProxy:getFinishTaskById(var2_5)

	assert(var3_5, "without this task by id: " .. var2_5)

	local var4_5 = var3_5:getConfig("award_display")[1]
	local var5_5 = {
		type = var4_5[1],
		id = var4_5[2],
		count = var4_5[3]
	}

	updateDrop(var1_5, var5_5)
	onButton(arg0_5, var1_5, function()
		arg0_5:emit(BaseUI.ON_DROP, var5_5)
	end, SFX_PANEL)

	local var6_5 = var3_5:getProgress()
	local var7_5 = var3_5:getConfig("target_num")

	setText(arg0_5:findTF("description", arg2_5), var3_5:getConfig("desc"))
	setSlider(arg0_5:findTF("progress", arg2_5), 0, var7_5, var6_5)

	local var8_5 = arg0_5:findTF("go_btn", arg2_5)
	local var9_5 = arg0_5:findTF("get_btn", arg2_5)
	local var10_5 = arg0_5:findTF("got_btn", arg2_5)
	local var11_5 = var3_5:getTaskStatus()

	setActive(var8_5, var11_5 == 0)
	setActive(var9_5, var11_5 == 1)
	setActive(var10_5, var11_5 == 2)
	onButton(arg0_5, var8_5, function()
		arg0_5:emit(ActivityMediator.ON_TASK_GO, var3_5)
	end, SFX_PANEL)
	onButton(arg0_5, var9_5, function()
		arg0_5:emit(ActivityMediator.ON_TASK_SUBMIT, var3_5)
	end, SFX_PANEL)
	setText(arg0_5:findTF("progressText", arg2_5), "<color=#789143>" .. var6_5 .. "</color><color=#a3876f>/" .. var7_5 .. "</color>")
end

function var0_0.OnUpdateFlush(arg0_9)
	var0_0.super.OnUpdateFlush(arg0_9)

	local var0_9 = arg0_9.miniGameAct
	local var1_9 = var0_9 and not var0_9:isEnd() and var0_9:readyToAchieve()

	setActive(arg0_9.tip, var1_9)
end

return var0_0
