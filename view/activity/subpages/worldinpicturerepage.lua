local var0 = class("WorldInPictureRePage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.item = arg0:findTF("items/item", arg0.bg)
	arg0.items = arg0:findTF("items", arg0.bg)
	arg0.uilist = UIItemList.New(arg0.items, arg0.item)
	arg0.help = arg0:findTF("AD/help")
	arg0.start = arg0:findTF("AD/start")
	arg0.dayTF = arg0:findTF("Text", arg0.bg)
	arg0.tip = arg0:findTF("AD/tip")
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.worldinpicture_task_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.start, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLDINPICTURE)
	end, SFX_PANEL)

	arg0.miniGameAct = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)
end

function var0.UpdateTask(arg0, arg1, arg2)
	local var0 = arg1 + 1
	local var1 = arg0:findTF("item", arg2)
	local var2 = arg0.taskGroup[arg0.nday][var0]
	local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

	assert(var3, "without this task by id: " .. var2)

	local var4 = var3:getConfig("award_display")[1]
	local var5 = {
		type = var4[1],
		id = var4[2],
		count = var4[3]
	}

	updateDrop(var1, var5)
	onButton(arg0, var1, function()
		arg0:emit(BaseUI.ON_DROP, var5)
	end, SFX_PANEL)

	local var6 = var3:getProgress()
	local var7 = var3:getConfig("target_num")

	setText(arg0:findTF("description", arg2), var3:getConfig("desc"))
	setSlider(arg0:findTF("progress", arg2), 0, var7, var6)

	local var8 = arg0:findTF("go_btn", arg2)
	local var9 = arg0:findTF("get_btn", arg2)
	local var10 = arg0:findTF("got_btn", arg2)
	local var11 = var3:getTaskStatus()

	setActive(var8, var11 == 0)
	setActive(var9, var11 == 1)
	setActive(var10, var11 == 2)
	onButton(arg0, var8, function()
		arg0:emit(ActivityMediator.ON_TASK_GO, var3)
	end, SFX_PANEL)
	onButton(arg0, var9, function()
		arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var3)
	end, SFX_PANEL)
	setText(arg0:findTF("progressText", arg2), "<color=#789143>" .. var6 .. "</color><color=#a3876f>/" .. var7 .. "</color>")
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0 = arg0.miniGameAct
	local var1 = var0 and not var0:isEnd() and var0:readyToAchieve()

	setActive(arg0.tip, var1)
end

return var0
