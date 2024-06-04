local var0 = class("LinerScene", import("view.base.BaseUI"))

var0.AUTO_DELAY_TIME = 0.5
var0.SCALE_ANIM_TIME = 0.5
var0.FINISH_TARGET_ROOM_ID = 4
var0.FINISH_CHAR_CNT = 10
var0.GUIDE_ROOM_ID = 22
var0.MODE_NORMAL = 1
var0.MODE_FULLVIEW = 2

function var0.getUIName(arg0)
	return "LinerMainUI"
end

function var0.PlayBGM(arg0)
	local var0 = arg0.activity

	if not var0 then
		var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

		assert(var0 and not var0:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)
	end

	local var1 = var0:GetBgmName()

	pg.BgmMgr.GetInstance():Push(arg0.__cname, var1)
end

function var0.init(arg0)
	arg0.mapTF = arg0:findTF("map")
	arg0.bgTF = arg0:findTF("bg", arg0.mapTF)
	arg0.roomsTF = arg0:findTF("content", arg0.mapTF)
	arg0.topUI = arg0:findTF("top")
	arg0.nameBgTF = arg0:findTF("name_bg", arg0.topUI)
	arg0.nameInput = arg0:findTF("name/input", arg0.topUI)
	arg0.logBtn = arg0:findTF("logbook", arg0.topUI)
	arg0.timeBgTF = arg0:findTF("time/bg", arg0.topUI)
	arg0.timeTF = arg0:findTF("time/Text", arg0.topUI)
	arg0.targetTagTF = arg0:findTF("time/target/tag", arg0.topUI)
	arg0.targetLayoutCom = arg0:findTF("time/target", arg0.topUI):GetComponent(typeof(HorizontalLayoutGroup))
	arg0.targetTF = arg0:findTF("time/target/Text", arg0.topUI)
	arg0.focusTF = arg0:findTF("focus", arg0.topUI)

	setActive(arg0:findTF("tpl", arg0.focusTF), false)

	arg0.bgDiffList = {
		arg0.bgTF,
		arg0.nameBgTF,
		arg0.timeBgTF,
		arg0:findTF("1/icon", arg0.roomsTF),
		arg0:findTF("3/icon", arg0.roomsTF),
		arg0:findTF("4/icon", arg0.roomsTF)
	}

	local var0 = arg0:findTF("pages")

	arg0.timePage = LinerPassTimePage.New(var0, arg0)
	arg0.roomPage = LinerRoomInfoPage.New(var0, arg0)

	local var1, var2, var3 = getSizeRate()

	arg0.delta = Vector2(var2 - 100, var3 - 100) / 2
	arg0.extendLimit = Vector2(arg0.mapTF.rect.width - arg0._tf.rect.width, arg0.mapTF.rect.height - arg0._tf.rect.height) / 2
	arg0.fullFactor = math.max(arg0._tf.rect.width / arg0.mapTF.rect.width, arg0._tf.rect.height / arg0.mapTF.rect.height)
end

function var0.addListeners(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.LINER_NAMED_ID)

	assert(var0 and not var0:isEnd(), "not exist named act, id: " .. ActivityConst.LINER_NAMED_ID)

	arg0.linerName = var0:getStrData1()

	setInputText(arg0.nameInput, arg0.linerName)

	arg0.defaultName = getProxy(PlayerProxy):getRawData():GetName()

	onInputEndEdit(arg0, arg0.nameInput, function(arg0)
		if arg0 ~= arg0.defaultName and not nameValidityCheck(arg0, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			setInputText(arg0.nameInput, arg0.linerName)

			return
		else
			local var0 = getInputText(arg0.nameInput)

			arg0:emit(LinerMediator.SET_NAME, {
				actId = var0.id,
				strValue = var0,
				callback = function()
					arg0.linerName = var0

					setInputText(arg0.nameInput, arg0.linerName)
					pg.TipsMgr.GetInstance():ShowTips(i18n("liner_name_modify"))
				end
			})
		end
	end)

	local var1 = PLATFORM_CODE == PLATFORM_CH and LOCK_NAMED

	arg0.nameInput:GetComponent(typeof(InputField)).interactable = not var1

	setActive(arg0:findTF("name/edit", arg0.topUI), not var1)
	onButton(arg0, arg0:findTF("back", arg0.topUI), function()
		arg0:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("home", arg0.topUI), function()
		arg0:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("help", arg0.topUI), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.liner_help.tip
		})
	end, SFX_CANCEL)
	onButton(arg0, arg0.logBtn, function()
		arg0:emit(LinerMediator.GO_SUBLAYER, Context.New({
			mediator = LinerLogBookMediator,
			viewComponent = LinerLogBookLayer
		}))
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("fullview", arg0.topUI), function()
		if arg0.mode == var0.MODE_NORMAL then
			arg0:SwitchMode(var0.MODE_FULLVIEW)
		else
			arg0:SwitchMode(var0.MODE_NORMAL)
		end
	end, SFX_PANEL)
	onScroll(arg0, arg0.mapTF, function(arg0)
		arg0:onDragFunction()
	end)
end

function var0.didEnter(arg0)
	arg0:addListeners()

	arg0.mode = var0.MODE_NORMAL
	arg0.isFirstUpdate = true

	arg0:UpdateData()
	arg0:InitRooms()

	local var0 = {}

	table.insert(var0, function(arg0)
		if arg0.activity:GetCurIdx() == 1 then
			arg0:managedTween(LeanTween.delayedCall, function()
				local var0 = arg0.targetIds[1]

				triggerButton(arg0:findTF(tostring(var0), arg0.roomsTF))
			end, var0.AUTO_DELAY_TIME, nil)
		else
			arg0()
		end
	end)
	arg0:UpdateView(function()
		seriesAsync(var0, function()
			return
		end)
	end)
end

function var0.InitRooms(arg0)
	arg0.rooms = {}
	arg0.roomChars = {}
	arg0.roomIds = arg0.activity:GetAllExploreRoomIds()

	eachChild(arg0.roomsTF, function(arg0)
		local var0 = tonumber(arg0.name)

		if not var0 then
			return
		end

		if table.contains(arg0.roomIds, var0) then
			arg0.rooms[var0] = LinerRoom.New(var0)
			arg0.roomChars[var0] = {}
		end
	end)

	arg0.floatItemList = UIItemList.New(arg0.focusTF, arg0.focusTF:Find("tpl"))

	arg0.floatItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.targetIds[arg1]

			arg2.name = var0

			local var1 = arg0.curTime:GetType()

			eachChild(arg0:findTF("tag", arg2), function(arg0)
				setActive(arg0, arg0.name == "type" .. var1)
			end)
			eachChild(arg0:findTF("arrow", arg2), function(arg0)
				setActive(arg0, arg0.name == "type" .. var1)
			end)
			onButton(arg0, arg2, function()
				arg0:FocusNode(var0)
			end, SFX_PANEL)
		end
	end)
end

function var0.UpdateRooms(arg0)
	eachChild(arg0.roomsTF, function(arg0)
		local var0 = tonumber(arg0.name)

		if not var0 then
			return
		end

		arg0:OnUpdateRoom(var0, arg0)
	end)

	if arg0.isReallyTime then
		arg0:InitRandomChars()
	else
		arg0:FillRandomChars()
	end

	arg0.isFirstUpdate = false
end

function var0.OnUpdateRoom(arg0, arg1, arg2)
	if not table.contains(arg0.roomIds, arg1) then
		setActive(arg0:findTF("tag", arg2), false)
		setActive(arg0:findTF("mask", arg2), false)
		setActive(arg0:findTF("explore", arg2), false)
		onButton(arg0, arg2, function()
			if arg0.mode == var0.MODE_FULLVIEW then
				arg0:SwitchMode(var0.MODE_NORMAL)
				arg0:FocusNode(arg1)
			end
		end, SFX_CONFIRM)

		return
	end

	local var0 = arg0.curTime:GetType()
	local var1 = table.contains(arg0.targetIds, arg1) or var0 == LinerTime.TYPE.EXPLORE
	local var2 = arg0:findTF("tag", arg2)

	setActive(var2, var1)
	eachChild(var2, function(arg0)
		setActive(arg0, arg0.name == "type" .. var0)
	end)

	local var3 = var0 == LinerTime.TYPE.EXPLORE and table.contains(arg0.exploredRoomIds, arg1)
	local var4 = var0 == LinerTime.TYPE.EXPLORE and not table.contains(arg0.exploredRoomIds, arg1)

	setActive(arg0:findTF("mask", arg2), var3)
	setActive(arg0:findTF("explore", arg2), var4)
	onButton(arg0, arg2, function()
		if arg0.mode == var0.MODE_FULLVIEW then
			arg0:SwitchMode(var0.MODE_NORMAL)
			arg0:FocusNode(arg1)

			return
		end

		if not var1 or var3 then
			return
		end

		if arg0.isFinishAll and not arg0.isReallyTime then
			pg.NewStoryMgr.GetInstance():Play(arg0.endingStory, function()
				arg0:PlayAnim(function()
					arg0:UpdateData()
					arg0:CheckTime()
				end)
			end)

			return
		end

		switch(var0, {
			[LinerTime.TYPE.TARGET] = function()
				pg.NewStoryMgr.GetInstance():Play(arg0.curTime:GetStory(), function()
					arg0:emit(LinerMediator.CLICK_ROOM, arg0.activity.id, arg1)

					arg0.needAutoCheck = true
				end, true)
			end,
			[LinerTime.TYPE.EXPLORE] = function()
				arg0.roomPage:ExecuteAction("ShowInfo", arg0.activity, arg1, function()
					arg0:CheckTime()
				end)
			end,
			[LinerTime.TYPE.EVENT] = function()
				local var0 = arg0.curTime:GetEventSubType(arg1)

				if var0 == LinerTime.EVENT_SUB_TYPE.CLUE then
					arg0.roomPage:ExecuteAction("ShowInfo", arg0.activity, arg1, function()
						arg0:CheckTime()
					end)
				elseif var0 == LinerTime.EVENT_SUB_TYPE.STORY then
					pg.NewStoryMgr.GetInstance():Play(arg0.curTime:GetStory(arg1), function()
						arg0:emit(LinerMediator.CLICK_ROOM, arg0.activity.id, arg1)

						arg0.needAutoCheck = true
					end, true)
				end
			end,
			[LinerTime.TYPE.STORY] = function()
				seriesAsync({
					function(arg0)
						if arg0.activity:GetCurIdx() == 1 then
							arg0()
						else
							arg0:PlayAnim(function()
								arg0:UpdateBg("day")
							end, arg0)
						end
					end,
					function(arg0)
						pg.NewStoryMgr.GetInstance():Play(arg0.curTime:GetStory(), arg0, true)
					end
				}, function()
					arg0:emit(LinerMediator.CLICK_ROOM, arg0.activity.id, arg1)

					arg0.needAutoCheck = true
				end)
			end
		})
	end, SFX_CONFIRM)

	if not arg0.isFinishAll or arg0.isFinishAll and not arg0.isReallyTime then
		arg0:UpdateRoomChar(arg1, arg2)
	end
end

function var0.UpdateRoomChar(arg0, arg1, arg2)
	if arg0.oldTime.id == arg0.curTime.id and not arg0.isFirstUpdate then
		return
	end

	local var0 = arg0.rooms[arg1]
	local var1 = var0:GetSpineCharInfo(arg0.oldTime.id)
	local var2 = var0:GetSpineCharInfo(arg0.curTime.id)
	local var3 = var1 and var1[1] or ""
	local var4 = var2 and var2[1] or ""

	if var3 == var4 and not arg0.isFirstUpdate then
		return
	end

	local var5 = arg0:findTF("char", arg2)

	if arg0.roomChars[arg1][1] and arg0.roomChars[arg1][2] then
		if LeanTween.isTweening(arg0.roomChars[arg1][2]) then
			LeanTween.cancel(arg0.roomChars[arg1][2])
		end

		PoolMgr.GetInstance():ReturnSpineChar(arg0.roomChars[arg1][1], arg0.roomChars[arg1][2])

		arg0.roomChars[arg1][1] = nil
		arg0.roomChars[arg1][2] = nil
	end

	if var4 ~= "" then
		PoolMgr.GetInstance():GetSpineChar(var4, true, function(arg0)
			arg0.roomChars[arg1][1] = var4
			arg0.roomChars[arg1][2] = arg0

			setLocalScale(tf(arg0), {
				x = LinerRoomCharPoint.SCALE,
				y = LinerRoomCharPoint.SCALE
			})
			setParent(arg0, var5)
			arg0:InitCharBehavior(arg1, tf(arg0), var2[2])
		end)
	end
end

function var0.InitCharBehavior(arg0, arg1, arg2, arg3)
	local var0 = LinerRoomCharPoint[arg1]
	local var1 = LinerRoomCharPoint.SCALE

	if var0.type == 2 then
		setLocalPosition(arg2, var0.idlePoint)

		local var2 = arg3 or LinerRoomCharPoint.IDLE_ACTION

		arg2:GetComponent("SpineAnimUI"):SetAction(var2, 0)
	elseif var0.type == 1 then
		local var3 = var0.startPoint.x
		local var4 = var0.endPoint.x
		local var5 = (var4 - var3) / LinerRoomCharPoint.SPEED

		setLocalPosition(arg2, var0.startPoint)

		local var6 = arg3 or LinerRoomCharPoint.MOVE_ACTION

		arg2:GetComponent("SpineAnimUI"):SetAction(var6, 0)
		arg0:managedTween(LeanTween.value, nil, go(arg2), var3, var4, var5):setOnUpdate(System.Action_float(function(arg0)
			setLocalPosition(arg2, {
				x = arg0
			})

			if arg0 == var3 then
				setLocalScale(arg2, {
					x = var1,
					y = var1
				})
			end

			if arg0 == var4 then
				setLocalScale(arg2, {
					x = -var1,
					y = var1
				})
			end
		end)):setLoopPingPong()
	end
end

function var0.GetRandomItems(arg0, arg1, arg2)
	assert(arg2 <= #arg1, "不合法的随机数量")

	local var0 = {}

	for iter0 = 1, #arg1 do
		table.insert(var0, iter0)
	end

	shuffle(var0)

	local var1 = {}

	for iter1 = 1, arg2 do
		table.insert(var1, arg1[var0[iter1]])
	end

	return var1
end

function var0.InitRandomChars(arg0)
	for iter0, iter1 in pairs(arg0.roomChars) do
		if iter1[1] and iter1[2] then
			if LeanTween.isTweening(iter1[2]) then
				LeanTween.cancel(iter1[2])
			end

			PoolMgr.GetInstance():ReturnSpineChar(iter1[1], iter1[2])

			arg0.roomChars[iter0][1] = nil
			arg0.roomChars[iter0][2] = nil
		end
	end

	local var0 = arg0:GetRandomItems(underscore.filter(arg0.roomIds, function(arg0)
		return arg0 ~= 4 and arg0 ~= 31
	end), var0.FINISH_CHAR_CNT)
	local var1 = arg0:GetRandomItems(arg0.sdConfig, var0.FINISH_CHAR_CNT)

	for iter2, iter3 in ipairs(var0) do
		local var2 = var1[iter2]

		PoolMgr.GetInstance():GetSpineChar(var2, true, function(arg0)
			arg0.roomChars[iter3][1] = var2
			arg0.roomChars[iter3][2] = arg0

			local var0 = arg0:findTF(iter3 .. "/char", arg0.roomsTF)

			setLocalScale(tf(arg0), {
				x = LinerRoomCharPoint.SCALE,
				y = LinerRoomCharPoint.SCALE
			})
			setParent(arg0, var0)
			arg0:InitCharBehavior(iter3, tf(arg0))
		end)
	end
end

function var0.FillRandomChars(arg0)
	if arg0.oldTime.id == arg0.curTime.id and not arg0.isFirstUpdate then
		return
	end

	local var0 = Clone(arg0.roomIds)
	local var1 = Clone(arg0.sdConfig)
	local var2 = 0

	for iter0, iter1 in ipairs(arg0.roomIds) do
		local var3 = arg0.rooms[iter1]:GetSpineCharInfo(arg0.curTime.id)

		if var3 and var3[1] and var3[2] then
			table.removebyvalue(var0, iter1)

			if table.contains(var1, var3[1]) then
				table.removebyvalue(var1, var3[1])
			end

			var2 = var2 + 1
		end
	end

	if arg0.randomIds and #arg0.randomIds > 0 then
		for iter2, iter3 in pairs(arg0.roomChars) do
			if iter3[1] and iter3[2] and table.contains(arg0.randomIds, iter2) then
				if LeanTween.isTweening(iter3[2]) then
					LeanTween.cancel(iter3[2])
				end

				PoolMgr.GetInstance():ReturnSpineChar(iter3[1], iter3[2])

				arg0.roomChars[iter2][1] = nil
				arg0.roomChars[iter2][2] = nil
			end
		end
	end

	arg0.randomIds = {}

	local var4 = var0.FINISH_CHAR_CNT - var2

	arg0.randomIds = arg0:GetRandomItems(underscore.filter(var0, function(arg0)
		return arg0 ~= 4 and arg0 ~= 31
	end), var4)

	local var5 = arg0:GetRandomItems(var1, var4)

	for iter4, iter5 in ipairs(arg0.randomIds) do
		local var6 = var5[iter4]

		PoolMgr.GetInstance():GetSpineChar(var6, true, function(arg0)
			arg0.roomChars[iter5][1] = var6
			arg0.roomChars[iter5][2] = arg0

			local var0 = arg0:findTF(iter5 .. "/char", arg0.roomsTF)

			setLocalScale(tf(arg0), {
				x = LinerRoomCharPoint.SCALE,
				y = LinerRoomCharPoint.SCALE
			})
			setParent(arg0, var0)
			arg0:InitCharBehavior(iter5, tf(arg0))
		end)
	end
end

function var0.UpdateBg(arg0, arg1)
	local var0 = arg1 or arg0.curTime:GetBgType()

	for iter0, iter1 in ipairs(arg0.bgDiffList) do
		eachChild(iter1, function(arg0)
			setActive(arg0, arg0.name == var0)
		end)
	end
end

function var0.UpdateFinishTime(arg0)
	local var0 = os.date("*t", os.time())
	local var1 = var0.hour
	local var2 = var0.min
	local var3 = var1 < 12 and " AM" or " PM"

	arg0:UpdateBg(arg0.activity:GetReallyTimeType(var1))

	if var1 > 12 then
		var1 = var1 - 12
	end

	setText(arg0.timeTF, string.format("%d:%02d ", var1, var2) .. var3)
end

function var0.UpdateTimeUI(arg0)
	if arg0.isReallyTime then
		eachChild(arg0.targetTagTF, function(arg0)
			setActive(arg0, false)
		end)

		arg0.targetLayoutCom.spacing = -60

		setText(arg0.targetTF, i18n("liner_target_type5"))

		arg0.finishTimer = Timer.New(function()
			arg0:UpdateFinishTime()
		end, 60, -1)

		arg0.finishTimer:Start()
		arg0:UpdateFinishTime()

		return
	end

	setText(arg0.timeTF, arg0.curTime:GetStartTimeDesc())

	local var0 = arg0.curTime:GetType()

	eachChild(arg0.targetTagTF, function(arg0)
		setActive(arg0, not arg0.isFinishAll and arg0.name == "type" .. var0)
	end)

	local var1 = ""

	switch(var0, {
		[LinerTime.TYPE.TARGET] = function()
			var1 = i18n("liner_target_type1", arg0.rooms[arg0.targetIds[1]]:GetName())
		end,
		[LinerTime.TYPE.EXPLORE] = function()
			local var0 = arg0.curTime:GetExploreCnt()
			local var1 = arg0.activity:GetRemainExploreCnt()

			var1 = i18n("liner_target_type2") .. string.format("(%d/%d)", var0 - var1, var0)
		end,
		[LinerTime.TYPE.EVENT] = function()
			local var0 = #arg0.curTime:GetTargetRoomIds()
			local var1 = arg0.activity:GetRoomIdx() - 1

			if arg0.isFinishAll then
				var1 = var0
			end

			var1 = i18n("liner_target_type3") .. string.format("(%d/%d)", var1, var0)
		end,
		[LinerTime.TYPE.STORY] = function()
			var1 = i18n("liner_target_type4", arg0.rooms[arg0.targetIds[1]]:GetName())
		end
	})

	arg0.targetLayoutCom.spacing = (var0 == LinerTime.TYPE.EXPLORE or arg0.isFinishAll) and -60 or -10

	if arg0.isFinishAll then
		var1 = i18n("liner_target_type4")
	end

	setText(arg0.targetTF, var1)
end

function var0.CheckTime(arg0)
	local var0 = arg0.oldTime.id ~= arg0.curTime.id
	local var1 = arg0.activity:GetCurIdx()
	local var2 = math.max(var1 - 1, 1)

	if var0 then
		arg0.timePage:ExecuteAction("ShowAnim", arg0.activity, var2, var1, function()
			arg0:UpdateView()
		end)
	else
		arg0:UpdateView()
	end
end

function var0.UpdateView(arg0, arg1)
	arg0:UpdateBg()
	arg0:UpdateTimeUI()
	arg0:UpdateRooms()
	arg0:UpdateTips()
	arg0.floatItemList:align(#arg0.targetIds)

	if arg0.curTime:GetType() ~= LinerTime.TYPE.EXPLORE and arg0.targetIds[1] then
		arg0:FocusNode(arg0.targetIds[1], arg1)
	else
		arg0:onDragFunction()
	end

	if arg0.curTime:GetType() == LinerTime.TYPE.EXPLORE and not pg.NewStoryMgr.GetInstance():IsPlayed("Liner_1") then
		arg0:FocusNode(var0.GUIDE_ROOM_ID, function()
			pg.NewGuideMgr.GetInstance():Play("Liner_1")
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = "Liner_1"
			})
		end)
	end

	if arg0.oldTime.id ~= arg0.curTime.id then
		arg0:PlayBGM()
	end
end

function var0.UpdateData(arg0)
	arg0.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(arg0.activity and not arg0.activity:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	arg0.endingStory = arg0.activity:getConfig("config_client").endingstory[1]
	arg0.timeConfig = arg0.activity:getConfig("config_client").endingtime
	arg0.sdConfig = arg0.activity:getConfig("config_client").sd
	arg0.isFinishAll = arg0.activity:IsFinishAllTime()
	arg0.isReallyTime = arg0.isFinishAll and pg.NewStoryMgr.GetInstance():IsPlayed(arg0.endingStory)
	arg0.exploredRoomIds = arg0.activity:GetExploredRoomIds()
	arg0.curEventInfos = arg0.activity:GetCurEventInfo()
	arg0.oldTime = arg0.curTime and Clone(arg0.curTime) or nil
	arg0.curTime = arg0.activity:GetCurTime()

	if not arg0.oldTime then
		arg0.oldTime = Clone(arg0.curTime)
	end

	if arg0.isFinishAll then
		if not arg0.isReallyTime then
			arg0.targetIds = {
				var0.FINISH_TARGET_ROOM_ID
			}
		else
			arg0.targetIds = {}
		end
	elseif arg0.curTime:GetType() == LinerTime.TYPE.EVENT then
		arg0.targetIds = {
			arg0:_getCurEventRoomId()
		}
	else
		arg0.targetIds = arg0.curTime:GetTargetRoomIds()
	end

	if arg0.needAutoCheck then
		arg0.needAutoCheck = false

		arg0:CheckTime()
	end
end

function var0._getCurEventRoomId(arg0)
	return arg0.curTime:GetParamInfo()[arg0.activity:GetRoomIdx()][1]
end

function var0.UpdateTips(arg0)
	setActive(arg0:findTF("tip", arg0.logBtn), LinerLogBookLayer.IsTip())
end

function var0.onDragFunction(arg0)
	if not var0.screenPoints then
		var0.screenPoints = {
			Vector2(-arg0.delta.x, arg0.delta.y),
			Vector2(arg0.delta.x, arg0.delta.y),
			Vector2(arg0.delta.x, -arg0.delta.y),
			Vector2(-arg0.delta.x, -arg0.delta.y)
		}
	end

	for iter0, iter1 in ipairs(arg0.targetIds) do
		local var0 = arg0.roomsTF:Find(tostring(iter1))

		if var0 then
			local var1 = arg0._tf:InverseTransformPoint(var0.position)
			local var2

			for iter2, iter3 in ipairs(var0.screenPoints) do
				local var3 = var0.screenPoints[iter2 % 4 + 1]
				local var4 = Vector2(var1.x, var1.y)
				local var5, var6, var7 = LineLine(Vector2.zero, var4, iter3, var3)

				if var5 then
					var2 = var4 * var6

					break
				end
			end

			local var8 = arg0.floatItemList.container:Find(tostring(iter1))
			local var9 = var8:GetComponent(typeof(CanvasGroup))
			local var10 = tobool(var2)

			var9.interactable = var10
			var9.blocksRaycasts = var10
			var9.alpha = var10 and 1 or 0

			setActive(arg0:findTF(iter1 .. "/tag", arg0.roomsTF), not var10)

			if var2 then
				local var11 = var2 * (1 - 50 / var2:Magnitude())

				setAnchoredPosition(var8, var11)

				local var12 = math.rad2Deg * math.atan2(var2.y, var2.x)

				setLocalEulerAngles(var8:Find("arrow"), {
					z = var12
				})
			end
		end
	end
end

function var0.FocusNode(arg0, arg1, arg2)
	local var0 = arg0.roomsTF:Find(tostring(arg1)).anchoredPosition * -1

	var0.x = math.clamp(var0.x, -arg0.extendLimit.x, arg0.extendLimit.x)
	var0.y = math.clamp(var0.y, -arg0.extendLimit.y, arg0.extendLimit.y)

	if arg0.twFocusId then
		LeanTween.cancel(arg0.twFocusId)

		arg0.twFocusId = nil
	end

	local var1 = {}

	table.insert(var1, function(arg0)
		SetCompomentEnabled(arg0.mapTF, typeof(ScrollRect), false)

		local var0 = (arg0.mapTF.anchoredPosition - var0).magnitude
		local var1 = var0 > 0 and var0 / (40 * math.sqrt(var0)) or 0

		arg0.twFocusId = LeanTween.move(arg0.mapTF, Vector3(var0.x, var0.y, 0), var1):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0)
			arg0:onDragFunction()
		end)):setOnComplete(System.Action(arg0)).uniqueId
	end)
	seriesAsync(var1, function()
		SetCompomentEnabled(arg0.mapTF, typeof(ScrollRect), true)

		if arg2 then
			arg2()
		end
	end)
end

function var0.SwitchMode(arg0, arg1, arg2)
	arg0.mode = arg1

	local var0 = arg0.mode == var0.MODE_NORMAL

	setActive(arg0.focusTF, var0)

	local var1 = arg0.mapTF.localScale.x
	local var2 = var0 and 1 or arg0.fullFactor

	arg0:managedTween(LeanTween.value, nil, go(arg0.mapTF), var1, var2, var0.SCALE_ANIM_TIME):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0)
		setLocalScale(arg0.mapTF, {
			x = arg0,
			y = arg0,
			z = arg0
		})
	end))

	if not var0 then
		arg0:managedTween(LeanTween.move, nil, go(arg0.mapTF), Vector3(0, 0, 0), var0.SCALE_ANIM_TIME):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
			if arg2 then
				arg2()
			end
		end))
	elseif arg2 then
		arg2()
	end
end

function var0.PlayAnim(arg0, arg1, arg2)
	seriesAsync({
		function(arg0)
			if not arg0.swithAnimTF then
				PoolMgr.GetInstance():GetUI("OtherworldCoverUI", true, function(arg0)
					arg0.swithAnimTF = arg0.transform

					setParent(arg0.swithAnimTF, arg0._tf, false)
					setActive(arg0.swithAnimTF, false)
					arg0()
				end)
			else
				arg0()
			end
		end,
		function(arg0)
			setActive(arg0.swithAnimTF, true)

			local var0 = arg0.swithAnimTF:Find("yuncaizhuanchang"):GetComponent(typeof(SpineAnimUI))

			var0:SetActionCallBack(function(arg0)
				if arg0 == "finish" then
					if arg2 then
						arg2()
					end

					setActive(arg0.swithAnimTF, false)
				elseif arg0 == "action" and arg1 then
					arg1()
				end
			end)
			var0:SetAction("action", 0)
		end
	}, function()
		return
	end)
end

function var0.onBackPressed(arg0)
	if arg0.timePage and arg0.timePage:GetLoaded() and arg0.timePage:isShowing() then
		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	arg0.timePage:Destroy()

	arg0.timePage = nil

	arg0.roomPage:Destroy()

	arg0.roomPage = nil

	for iter0, iter1 in pairs(arg0.roomChars) do
		if iter1[1] and iter1[2] then
			PoolMgr.GetInstance():ReturnSpineChar(iter1[1], iter1[2])
		end
	end

	arg0.roomChars = nil

	if arg0.finishTimer ~= nil then
		arg0.finishTimer:Stop()

		arg0.finishTimer = nil
	end
end

return var0
