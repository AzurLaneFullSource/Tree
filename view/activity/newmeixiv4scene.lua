local var0_0 = class("NewMeixiV4Scene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewMeixiV4UI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.init(arg0_3)
	arg0_3.ani = arg0_3:findTF("TV01")
	arg0_3.progress = arg0_3:findTF("progress/Text")
	arg0_3.nodes = arg0_3:findTF("nodes")
	arg0_3.nodeInfo = arg0_3:findTF("node_info")
	arg0_3.titleTxt = arg0_3:findTF("progress/title")
	arg0_3.titleNum = arg0_3:findTF("progress/cur")
	arg0_3.helpBtn = arg0_3:findTF("help_btn")
	arg0_3.storyTip = arg0_3:findTF("get_story")
	arg0_3.taskProxy = getProxy(TaskProxy)

	local var0_3 = pg.activity_template[ActivityConst.NEWMEIXIV4_SKIRMISH_ID]

	arg0_3.storyGroup = var0_3.config_client.storys
	arg0_3.memoryGroup = var0_3.config_client.memoryGroup
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4:findTF("top/back_btn"), function()
		arg0_4:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4:findTF("top/option"), function()
		arg0_4:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("MeixiV4_help")
		})
	end, SFX_PANEL)
	setText(arg0_4:findTF("bar/tip", arg0_4.storyTip), i18n("world_collection_back"))
	arg0_4:playAni()
	arg0_4:updateNodes()
end

function var0_0.setPlayer(arg0_8, arg1_8)
	arg0_8.player = arg1_8

	arg0_8:onUpdateRes(arg1_8)
end

function var0_0.onUpdateRes(arg0_9, arg1_9)
	arg0_9.player = arg1_9
end

function var0_0.playAni(arg0_10)
	SetActive(arg0_10.ani, true)
	arg0_10.ani:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_11)
		SetActive(arg0_10.ani, false)
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
end

function var0_0.setCurIndex(arg0_12)
	arg0_12.curIndex = 1
	arg0_12.clearTaskNum = 0
	arg0_12.clearTaskNum = (function()
		for iter0_13, iter1_13 in ipairs(arg0_12.contextData.taskList) do
			if arg0_12.taskProxy:getTaskById(iter1_13) or arg0_12.taskProxy:getFinishTaskById(iter1_13) then
				return iter0_13 - 1
			end
		end
	end)()

	for iter0_12, iter1_12 in ipairs(arg0_12.contextData.taskList) do
		local var0_12 = arg0_12.taskProxy:getTaskById(iter1_12) or arg0_12.taskProxy:getFinishTaskById(iter1_12)
		local var1_12 = arg0_12.contextData.taskList[iter0_12 + 1]
		local var2_12 = arg0_12.taskProxy:getTaskById(var1_12) or arg0_12.taskProxy:getFinishTaskById(var1_12)

		if var0_12 and var0_12:getTaskStatus() == 2 then
			arg0_12.curIndex = arg0_12.curIndex + 1

			if not var1_12 or not var2_12 then
				arg0_12.curIndex = arg0_12.curIndex - 1
			end
		end
	end

	arg0_12.curIndex = arg0_12.curIndex + arg0_12.clearTaskNum
end

function var0_0.updateNodes(arg0_14)
	arg0_14:setCurIndex()
	setText(arg0_14.titleTxt, "POSITION " .. string.format("%02d", arg0_14.curIndex))
	setText(arg0_14.titleNum, string.format("%02d", arg0_14.curIndex))
	eachChild(arg0_14.nodes, function(arg0_15)
		local var0_15 = tonumber(arg0_15.name)
		local var1_15 = arg0_14.contextData.taskList[var0_15]

		if not arg0_14.taskProxy:getTaskById(var1_15) then
			local var2_15 = arg0_14.taskProxy:getFinishTaskById(var1_15)
		end

		setActive(arg0_15, var0_15 <= arg0_14.curIndex)
		onButton(arg0_14, arg0_15, function()
			arg0_14:updateNodeInfo(var0_15)
		end, SFX_PANEL)
	end)
	arg0_14:updateNodeInfo(arg0_14.curIndex)
end

function var0_0.nodeInfoTween(arg0_17, arg1_17)
	local var0_17 = tf(arg0_17:findTF(tostring(arg1_17), arg0_17.nodes)).localPosition

	if arg1_17 == 9 then
		var0_17.x = var0_17.x - 80
	end

	if arg1_17 == 7 then
		var0_17.y = var0_17.y - 20
	end

	local function var1_17()
		setLocalPosition(arg0_17.nodeInfo, Vector3(var0_17.x, var0_17.y + 120, 0))
		setLocalScale(arg0_17.nodeInfo, Vector3(0, 0, 0))
		LeanTween.scale(tf(arg0_17.nodeInfo), Vector3.one, 0.1)
	end

	local function var2_17(arg0_19)
		setLocalScale(arg0_17.nodeInfo, Vector3(1, 1, 1))
		LeanTween.scale(tf(arg0_17.nodeInfo), Vector3.zero, 0.1):setOnComplete(System.Action(function()
			if arg0_19 then
				arg0_19()
			end
		end))
	end

	if not isActive(arg0_17.nodeInfo) then
		setActive(arg0_17.nodeInfo, true)
		var1_17()
	else
		var2_17(var1_17)
	end
end

function var0_0.updateNodeInfo(arg0_21, arg1_21)
	local var0_21 = getProxy(ActivityProxy):getActivityById(ActivityConst.NEWMEIXIV4_SKIRMISH_ID)

	updateActivityTaskStatus(var0_21)

	local var1_21 = arg0_21.contextData.taskList[arg1_21]
	local var2_21 = arg0_21.taskProxy:getTaskById(var1_21) or arg0_21.taskProxy:getFinishTaskById(var1_21)
	local var3_21 = pg.task_data_template[var1_21]
	local var4_21 = var2_21 and var2_21:getProgress() or var3_21.target_num
	local var5_21 = var2_21 and var2_21:getConfig("target_num") or var3_21.target_num
	local var6_21 = var2_21 and var2_21:getTaskStatus() or 2
	local var7_21 = var2_21 and var2_21:getConfig("desc") or var3_21.desc

	setSlider(arg0_21:findTF("progress", arg0_21.nodeInfo), 0, var5_21, var4_21)
	setText(arg0_21:findTF("step", arg0_21.nodeInfo), var4_21 .. "/" .. var5_21)
	setText(arg0_21:findTF("content", arg0_21.nodeInfo), var7_21)
	setText(arg0_21:findTF("title", arg0_21.nodeInfo), string.format("%02d", arg1_21))

	local var8_21 = arg0_21:findTF("go_btn", arg0_21.nodeInfo)
	local var9_21 = arg0_21:findTF("get_btn", arg0_21.nodeInfo)
	local var10_21 = arg0_21:findTF("step/finish", arg0_21.nodeInfo)

	setActive(var8_21, var6_21 == 0)
	setActive(var9_21, var6_21 == 1)
	setActive(var10_21, var6_21 == 2)
	onButton(arg0_21, var8_21, function()
		arg0_21:emit(NewMeixiV4Mediator.ON_TASK_GO, var2_21)
	end, SFX_PANEL)
	onButton(arg0_21, var9_21, function()
		arg0_21:emit(NewMeixiV4Mediator.ON_TASK_SUBMIT, var2_21)
	end, SFX_PANEL)
	eachChild(arg0_21.nodes, function(arg0_24)
		local var0_24 = arg0_21:findTF("arrow", arg0_24)

		LeanTween.cancel(var0_24.gameObject)
		setLocalPosition(var0_24, Vector3(0, 27, 0))

		if tonumber(arg0_24.name) == arg1_21 then
			setActive(var0_24, true)
			LeanTween.moveY(var0_24, 40, 0.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
		else
			setActive(var0_24, false)
		end
	end)
	arg0_21:nodeInfoTween(arg1_21)
end

function var0_0.onUpdateTask(arg0_25)
	local var0_25 = arg0_25.contextData.taskList[arg0_25.curIndex]

	for iter0_25, iter1_25 in pairs(arg0_25.storyGroup) do
		if var0_25 == iter1_25[1] then
			arg0_25:getStory(iter1_25[2], iter1_25[3])
		end
	end

	arg0_25:updateNodes()
end

function var0_0.getStory(arg0_26, arg1_26, arg2_26)
	setActive(arg0_26.storyTip, true)

	local var0_26 = pg.memory_template[arg1_26].title

	pg.NewStoryMgr.GetInstance():SetPlayedFlag(arg2_26)
	setText(arg0_26:findTF("bar/Anim/Frame/Mask/Name", arg0_26.storyTip), var0_26)
	removeOnButton(arg0_26.storyTip)
	removeOnButton(arg0_26:findTF("bar/Button", arg0_26.storyTip))
	pg.UIMgr.GetInstance():BlurPanel(arg0_26.storyTip)

	local var1_26 = arg0_26:findTF("bar", arg0_26.storyTip):GetComponent(typeof(DftAniEvent))

	local function var2_26()
		onButton(arg0_26, arg0_26.storyTip, function()
			pg.UIMgr.GetInstance():UnblurPanel(arg0_26.storyTip)
			setActive(arg0_26.storyTip, false)
		end)
		onButton(arg0_26, arg0_26:findTF("bar/Button", arg0_26.storyTip), function()
			arg0_26:emit(NewMeixiV4Mediator.GO_STORY, arg0_26.memoryGroup)
			triggerButton(arg0_26.storyTip)
		end, SFX_PANEL)
	end

	var1_26:SetEndEvent(var2_26)
end

function var0_0.willExit(arg0_30)
	setActive(arg0_30.storyTip, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_30.storyTip)
end

return var0_0
