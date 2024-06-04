local var0 = class("NewMeixiV4Scene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "NewMeixiV4UI"
end

function var0.ResUISettings(arg0)
	return true
end

function var0.init(arg0)
	arg0.ani = arg0:findTF("TV01")
	arg0.progress = arg0:findTF("progress/Text")
	arg0.nodes = arg0:findTF("nodes")
	arg0.nodeInfo = arg0:findTF("node_info")
	arg0.titleTxt = arg0:findTF("progress/title")
	arg0.titleNum = arg0:findTF("progress/cur")
	arg0.helpBtn = arg0:findTF("help_btn")
	arg0.storyTip = arg0:findTF("get_story")
	arg0.taskProxy = getProxy(TaskProxy)

	local var0 = pg.activity_template[ActivityConst.NEWMEIXIV4_SKIRMISH_ID]

	arg0.storyGroup = var0.config_client.storys
	arg0.memoryGroup = var0.config_client.memoryGroup
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/back_btn"), function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	onButton(arg0, arg0:findTF("top/option"), function()
		arg0:emit(var0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("MeixiV4_help")
		})
	end, SFX_PANEL)
	setText(arg0:findTF("bar/tip", arg0.storyTip), i18n("world_collection_back"))
	arg0:playAni()
	arg0:updateNodes()
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1

	arg0:onUpdateRes(arg1)
end

function var0.onUpdateRes(arg0, arg1)
	arg0.player = arg1
end

function var0.playAni(arg0)
	SetActive(arg0.ani, true)
	arg0.ani:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
		SetActive(arg0.ani, false)
	end)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
end

function var0.setCurIndex(arg0)
	arg0.curIndex = 1
	arg0.clearTaskNum = 0
	arg0.clearTaskNum = (function()
		for iter0, iter1 in ipairs(arg0.contextData.taskList) do
			if arg0.taskProxy:getTaskById(iter1) or arg0.taskProxy:getFinishTaskById(iter1) then
				return iter0 - 1
			end
		end
	end)()

	for iter0, iter1 in ipairs(arg0.contextData.taskList) do
		local var0 = arg0.taskProxy:getTaskById(iter1) or arg0.taskProxy:getFinishTaskById(iter1)
		local var1 = arg0.contextData.taskList[iter0 + 1]
		local var2 = arg0.taskProxy:getTaskById(var1) or arg0.taskProxy:getFinishTaskById(var1)

		if var0 and var0:getTaskStatus() == 2 then
			arg0.curIndex = arg0.curIndex + 1

			if not var1 or not var2 then
				arg0.curIndex = arg0.curIndex - 1
			end
		end
	end

	arg0.curIndex = arg0.curIndex + arg0.clearTaskNum
end

function var0.updateNodes(arg0)
	arg0:setCurIndex()
	setText(arg0.titleTxt, "POSITION " .. string.format("%02d", arg0.curIndex))
	setText(arg0.titleNum, string.format("%02d", arg0.curIndex))
	eachChild(arg0.nodes, function(arg0)
		local var0 = tonumber(arg0.name)
		local var1 = arg0.contextData.taskList[var0]

		if not arg0.taskProxy:getTaskById(var1) then
			local var2 = arg0.taskProxy:getFinishTaskById(var1)
		end

		setActive(arg0, var0 <= arg0.curIndex)
		onButton(arg0, arg0, function()
			arg0:updateNodeInfo(var0)
		end, SFX_PANEL)
	end)
	arg0:updateNodeInfo(arg0.curIndex)
end

function var0.nodeInfoTween(arg0, arg1)
	local var0 = tf(arg0:findTF(tostring(arg1), arg0.nodes)).localPosition

	if arg1 == 9 then
		var0.x = var0.x - 80
	end

	if arg1 == 7 then
		var0.y = var0.y - 20
	end

	local function var1()
		setLocalPosition(arg0.nodeInfo, Vector3(var0.x, var0.y + 120, 0))
		setLocalScale(arg0.nodeInfo, Vector3(0, 0, 0))
		LeanTween.scale(tf(arg0.nodeInfo), Vector3.one, 0.1)
	end

	local function var2(arg0)
		setLocalScale(arg0.nodeInfo, Vector3(1, 1, 1))
		LeanTween.scale(tf(arg0.nodeInfo), Vector3.zero, 0.1):setOnComplete(System.Action(function()
			if arg0 then
				arg0()
			end
		end))
	end

	if not isActive(arg0.nodeInfo) then
		setActive(arg0.nodeInfo, true)
		var1()
	else
		var2(var1)
	end
end

function var0.updateNodeInfo(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.NEWMEIXIV4_SKIRMISH_ID)

	updateActivityTaskStatus(var0)

	local var1 = arg0.contextData.taskList[arg1]
	local var2 = arg0.taskProxy:getTaskById(var1) or arg0.taskProxy:getFinishTaskById(var1)
	local var3 = pg.task_data_template[var1]
	local var4 = var2 and var2:getProgress() or var3.target_num
	local var5 = var2 and var2:getConfig("target_num") or var3.target_num
	local var6 = var2 and var2:getTaskStatus() or 2
	local var7 = var2 and var2:getConfig("desc") or var3.desc

	setSlider(arg0:findTF("progress", arg0.nodeInfo), 0, var5, var4)
	setText(arg0:findTF("step", arg0.nodeInfo), var4 .. "/" .. var5)
	setText(arg0:findTF("content", arg0.nodeInfo), var7)
	setText(arg0:findTF("title", arg0.nodeInfo), string.format("%02d", arg1))

	local var8 = arg0:findTF("go_btn", arg0.nodeInfo)
	local var9 = arg0:findTF("get_btn", arg0.nodeInfo)
	local var10 = arg0:findTF("step/finish", arg0.nodeInfo)

	setActive(var8, var6 == 0)
	setActive(var9, var6 == 1)
	setActive(var10, var6 == 2)
	onButton(arg0, var8, function()
		arg0:emit(NewMeixiV4Mediator.ON_TASK_GO, var2)
	end, SFX_PANEL)
	onButton(arg0, var9, function()
		arg0:emit(NewMeixiV4Mediator.ON_TASK_SUBMIT, var2)
	end, SFX_PANEL)
	eachChild(arg0.nodes, function(arg0)
		local var0 = arg0:findTF("arrow", arg0)

		LeanTween.cancel(var0.gameObject)
		setLocalPosition(var0, Vector3(0, 27, 0))

		if tonumber(arg0.name) == arg1 then
			setActive(var0, true)
			LeanTween.moveY(var0, 40, 0.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
		else
			setActive(var0, false)
		end
	end)
	arg0:nodeInfoTween(arg1)
end

function var0.onUpdateTask(arg0)
	local var0 = arg0.contextData.taskList[arg0.curIndex]

	for iter0, iter1 in pairs(arg0.storyGroup) do
		if var0 == iter1[1] then
			arg0:getStory(iter1[2], iter1[3])
		end
	end

	arg0:updateNodes()
end

function var0.getStory(arg0, arg1, arg2)
	setActive(arg0.storyTip, true)

	local var0 = pg.memory_template[arg1].title

	pg.NewStoryMgr.GetInstance():SetPlayedFlag(arg2)
	setText(arg0:findTF("bar/Anim/Frame/Mask/Name", arg0.storyTip), var0)
	removeOnButton(arg0.storyTip)
	removeOnButton(arg0:findTF("bar/Button", arg0.storyTip))
	pg.UIMgr.GetInstance():BlurPanel(arg0.storyTip)

	local var1 = arg0:findTF("bar", arg0.storyTip):GetComponent(typeof(DftAniEvent))

	local function var2()
		onButton(arg0, arg0.storyTip, function()
			pg.UIMgr.GetInstance():UnblurPanel(arg0.storyTip)
			setActive(arg0.storyTip, false)
		end)
		onButton(arg0, arg0:findTF("bar/Button", arg0.storyTip), function()
			arg0:emit(NewMeixiV4Mediator.GO_STORY, arg0.memoryGroup)
			triggerButton(arg0.storyTip)
		end, SFX_PANEL)
	end

	var1:SetEndEvent(var2)
end

function var0.willExit(arg0)
	setActive(arg0.storyTip, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.storyTip)
end

return var0
