local var0_0 = class("LinerScene", import("view.base.BaseUI"))

var0_0.AUTO_DELAY_TIME = 0.5
var0_0.SCALE_ANIM_TIME = 0.5
var0_0.FINISH_TARGET_ROOM_ID = 4
var0_0.FINISH_CHAR_CNT = 10
var0_0.GUIDE_ROOM_ID = 22
var0_0.MODE_NORMAL = 1
var0_0.MODE_FULLVIEW = 2

function var0_0.getUIName(arg0_1)
	return "LinerMainUI"
end

function var0_0.PlayBGM(arg0_2)
	local var0_2 = arg0_2.activity

	if not var0_2 then
		var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

		assert(var0_2 and not var0_2:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)
	end

	local var1_2 = var0_2:GetBgmName()

	pg.BgmMgr.GetInstance():Push(arg0_2.__cname, var1_2)
end

function var0_0.init(arg0_3)
	arg0_3.mapTF = arg0_3:findTF("map")
	arg0_3.bgTF = arg0_3:findTF("bg", arg0_3.mapTF)
	arg0_3.roomsTF = arg0_3:findTF("content", arg0_3.mapTF)
	arg0_3.topUI = arg0_3:findTF("top")
	arg0_3.nameBgTF = arg0_3:findTF("name_bg", arg0_3.topUI)
	arg0_3.nameInput = arg0_3:findTF("name/input", arg0_3.topUI)
	arg0_3.logBtn = arg0_3:findTF("logbook", arg0_3.topUI)
	arg0_3.timeBgTF = arg0_3:findTF("time/bg", arg0_3.topUI)
	arg0_3.timeTF = arg0_3:findTF("time/Text", arg0_3.topUI)
	arg0_3.targetTagTF = arg0_3:findTF("time/target/tag", arg0_3.topUI)
	arg0_3.targetLayoutCom = arg0_3:findTF("time/target", arg0_3.topUI):GetComponent(typeof(HorizontalLayoutGroup))
	arg0_3.targetTF = arg0_3:findTF("time/target/Text", arg0_3.topUI)
	arg0_3.focusTF = arg0_3:findTF("focus", arg0_3.topUI)

	setActive(arg0_3:findTF("tpl", arg0_3.focusTF), false)

	arg0_3.bgDiffList = {
		arg0_3.bgTF,
		arg0_3.nameBgTF,
		arg0_3.timeBgTF,
		arg0_3:findTF("1/icon", arg0_3.roomsTF),
		arg0_3:findTF("3/icon", arg0_3.roomsTF),
		arg0_3:findTF("4/icon", arg0_3.roomsTF)
	}

	local var0_3 = arg0_3:findTF("pages")

	arg0_3.timePage = LinerPassTimePage.New(var0_3, arg0_3)
	arg0_3.roomPage = LinerRoomInfoPage.New(var0_3, arg0_3)

	local var1_3, var2_3, var3_3 = getSizeRate()

	arg0_3.delta = Vector2(var2_3 - 100, var3_3 - 100) / 2
	arg0_3.extendLimit = Vector2(arg0_3.mapTF.rect.width - arg0_3._tf.rect.width, arg0_3.mapTF.rect.height - arg0_3._tf.rect.height) / 2
	arg0_3.fullFactor = math.max(arg0_3._tf.rect.width / arg0_3.mapTF.rect.width, arg0_3._tf.rect.height / arg0_3.mapTF.rect.height)
end

function var0_0.addListeners(arg0_4)
	local var0_4 = getProxy(ActivityProxy):getActivityById(ActivityConst.LINER_NAMED_ID)

	assert(var0_4 and not var0_4:isEnd(), "not exist named act, id: " .. ActivityConst.LINER_NAMED_ID)

	arg0_4.linerName = var0_4:getStrData1()

	setInputText(arg0_4.nameInput, arg0_4.linerName)

	arg0_4.defaultName = getProxy(PlayerProxy):getRawData():GetName()

	onInputEndEdit(arg0_4, arg0_4.nameInput, function(arg0_5)
		if arg0_5 ~= arg0_4.defaultName and not nameValidityCheck(arg0_5, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			setInputText(arg0_4.nameInput, arg0_4.linerName)

			return
		else
			local var0_5 = getInputText(arg0_4.nameInput)

			arg0_4:emit(LinerMediator.SET_NAME, {
				actId = var0_4.id,
				strValue = var0_5,
				callback = function()
					arg0_4.linerName = var0_5

					setInputText(arg0_4.nameInput, arg0_4.linerName)
					pg.TipsMgr.GetInstance():ShowTips(i18n("liner_name_modify"))
				end
			})
		end
	end)

	local var1_4 = PLATFORM_CODE == PLATFORM_CH and LOCK_NAMED

	arg0_4.nameInput:GetComponent(typeof(InputField)).interactable = not var1_4

	setActive(arg0_4:findTF("name/edit", arg0_4.topUI), not var1_4)
	onButton(arg0_4, arg0_4:findTF("back", arg0_4.topUI), function()
		arg0_4:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4:findTF("home", arg0_4.topUI), function()
		arg0_4:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4:findTF("help", arg0_4.topUI), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.liner_help.tip
		})
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.logBtn, function()
		arg0_4:emit(LinerMediator.GO_SUBLAYER, Context.New({
			mediator = LinerLogBookMediator,
			viewComponent = LinerLogBookLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4:findTF("fullview", arg0_4.topUI), function()
		if arg0_4.mode == var0_0.MODE_NORMAL then
			arg0_4:SwitchMode(var0_0.MODE_FULLVIEW)
		else
			arg0_4:SwitchMode(var0_0.MODE_NORMAL)
		end
	end, SFX_PANEL)
	onScroll(arg0_4, arg0_4.mapTF, function(arg0_12)
		arg0_4:onDragFunction()
	end)
end

function var0_0.didEnter(arg0_13)
	arg0_13:addListeners()

	arg0_13.mode = var0_0.MODE_NORMAL
	arg0_13.isFirstUpdate = true

	arg0_13:UpdateData()
	arg0_13:InitRooms()

	local var0_13 = {}

	table.insert(var0_13, function(arg0_14)
		if arg0_13.activity:GetCurIdx() == 1 then
			arg0_13:managedTween(LeanTween.delayedCall, function()
				local var0_15 = arg0_13.targetIds[1]

				triggerButton(arg0_13:findTF(tostring(var0_15), arg0_13.roomsTF))
			end, var0_0.AUTO_DELAY_TIME, nil)
		else
			arg0_14()
		end
	end)
	arg0_13:UpdateView(function()
		seriesAsync(var0_13, function()
			return
		end)
	end)
end

function var0_0.InitRooms(arg0_18)
	arg0_18.rooms = {}
	arg0_18.roomChars = {}
	arg0_18.roomIds = arg0_18.activity:GetAllExploreRoomIds()

	eachChild(arg0_18.roomsTF, function(arg0_19)
		local var0_19 = tonumber(arg0_19.name)

		if not var0_19 then
			return
		end

		if table.contains(arg0_18.roomIds, var0_19) then
			arg0_18.rooms[var0_19] = LinerRoom.New(var0_19)
			arg0_18.roomChars[var0_19] = {}
		end
	end)

	arg0_18.floatItemList = UIItemList.New(arg0_18.focusTF, arg0_18.focusTF:Find("tpl"))

	arg0_18.floatItemList:make(function(arg0_20, arg1_20, arg2_20)
		arg1_20 = arg1_20 + 1

		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = arg0_18.targetIds[arg1_20]

			arg2_20.name = var0_20

			local var1_20 = arg0_18.curTime:GetType()

			eachChild(arg0_18:findTF("tag", arg2_20), function(arg0_21)
				setActive(arg0_21, arg0_21.name == "type" .. var1_20)
			end)
			eachChild(arg0_18:findTF("arrow", arg2_20), function(arg0_22)
				setActive(arg0_22, arg0_22.name == "type" .. var1_20)
			end)
			onButton(arg0_18, arg2_20, function()
				arg0_18:FocusNode(var0_20)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.UpdateRooms(arg0_24)
	eachChild(arg0_24.roomsTF, function(arg0_25)
		local var0_25 = tonumber(arg0_25.name)

		if not var0_25 then
			return
		end

		arg0_24:OnUpdateRoom(var0_25, arg0_25)
	end)

	if arg0_24.isReallyTime then
		arg0_24:InitRandomChars()
	else
		arg0_24:FillRandomChars()
	end

	arg0_24.isFirstUpdate = false
end

function var0_0.OnUpdateRoom(arg0_26, arg1_26, arg2_26)
	if not table.contains(arg0_26.roomIds, arg1_26) then
		setActive(arg0_26:findTF("tag", arg2_26), false)
		setActive(arg0_26:findTF("mask", arg2_26), false)
		setActive(arg0_26:findTF("explore", arg2_26), false)
		onButton(arg0_26, arg2_26, function()
			if arg0_26.mode == var0_0.MODE_FULLVIEW then
				arg0_26:SwitchMode(var0_0.MODE_NORMAL)
				arg0_26:FocusNode(arg1_26)
			end
		end, SFX_CONFIRM)

		return
	end

	local var0_26 = arg0_26.curTime:GetType()
	local var1_26 = table.contains(arg0_26.targetIds, arg1_26) or var0_26 == LinerTime.TYPE.EXPLORE
	local var2_26 = arg0_26:findTF("tag", arg2_26)

	setActive(var2_26, var1_26)
	eachChild(var2_26, function(arg0_28)
		setActive(arg0_28, arg0_28.name == "type" .. var0_26)
	end)

	local var3_26 = var0_26 == LinerTime.TYPE.EXPLORE and table.contains(arg0_26.exploredRoomIds, arg1_26)
	local var4_26 = var0_26 == LinerTime.TYPE.EXPLORE and not table.contains(arg0_26.exploredRoomIds, arg1_26)

	setActive(arg0_26:findTF("mask", arg2_26), var3_26)
	setActive(arg0_26:findTF("explore", arg2_26), var4_26)
	onButton(arg0_26, arg2_26, function()
		if arg0_26.mode == var0_0.MODE_FULLVIEW then
			arg0_26:SwitchMode(var0_0.MODE_NORMAL)
			arg0_26:FocusNode(arg1_26)

			return
		end

		if not var1_26 or var3_26 then
			return
		end

		if arg0_26.isFinishAll and not arg0_26.isReallyTime then
			pg.NewStoryMgr.GetInstance():Play(arg0_26.endingStory, function()
				arg0_26:PlayAnim(function()
					arg0_26:UpdateData()
					arg0_26:CheckTime()
				end)
			end)

			return
		end

		switch(var0_26, {
			[LinerTime.TYPE.TARGET] = function()
				pg.NewStoryMgr.GetInstance():Play(arg0_26.curTime:GetStory(), function()
					arg0_26:emit(LinerMediator.CLICK_ROOM, arg0_26.activity.id, arg1_26)

					arg0_26.needAutoCheck = true
				end, true)
			end,
			[LinerTime.TYPE.EXPLORE] = function()
				arg0_26.roomPage:ExecuteAction("ShowInfo", arg0_26.activity, arg1_26, function()
					arg0_26:CheckTime()
				end)
			end,
			[LinerTime.TYPE.EVENT] = function()
				local var0_36 = arg0_26.curTime:GetEventSubType(arg1_26)

				if var0_36 == LinerTime.EVENT_SUB_TYPE.CLUE then
					arg0_26.roomPage:ExecuteAction("ShowInfo", arg0_26.activity, arg1_26, function()
						arg0_26:CheckTime()
					end)
				elseif var0_36 == LinerTime.EVENT_SUB_TYPE.STORY then
					pg.NewStoryMgr.GetInstance():Play(arg0_26.curTime:GetStory(arg1_26), function()
						arg0_26:emit(LinerMediator.CLICK_ROOM, arg0_26.activity.id, arg1_26)

						arg0_26.needAutoCheck = true
					end, true)
				end
			end,
			[LinerTime.TYPE.STORY] = function()
				seriesAsync({
					function(arg0_40)
						if arg0_26.activity:GetCurIdx() == 1 then
							arg0_40()
						else
							arg0_26:PlayAnim(function()
								arg0_26:UpdateBg("day")
							end, arg0_40)
						end
					end,
					function(arg0_42)
						pg.NewStoryMgr.GetInstance():Play(arg0_26.curTime:GetStory(), arg0_42, true)
					end
				}, function()
					arg0_26:emit(LinerMediator.CLICK_ROOM, arg0_26.activity.id, arg1_26)

					arg0_26.needAutoCheck = true
				end)
			end
		})
	end, SFX_CONFIRM)

	if not arg0_26.isFinishAll or arg0_26.isFinishAll and not arg0_26.isReallyTime then
		arg0_26:UpdateRoomChar(arg1_26, arg2_26)
	end
end

function var0_0.UpdateRoomChar(arg0_44, arg1_44, arg2_44)
	if arg0_44.oldTime.id == arg0_44.curTime.id and not arg0_44.isFirstUpdate then
		return
	end

	local var0_44 = arg0_44.rooms[arg1_44]
	local var1_44 = var0_44:GetSpineCharInfo(arg0_44.oldTime.id)
	local var2_44 = var0_44:GetSpineCharInfo(arg0_44.curTime.id)
	local var3_44 = var1_44 and var1_44[1] or ""
	local var4_44 = var2_44 and var2_44[1] or ""

	if var3_44 == var4_44 and not arg0_44.isFirstUpdate then
		return
	end

	local var5_44 = arg0_44:findTF("char", arg2_44)

	if arg0_44.roomChars[arg1_44][1] and arg0_44.roomChars[arg1_44][2] then
		if LeanTween.isTweening(arg0_44.roomChars[arg1_44][2]) then
			LeanTween.cancel(arg0_44.roomChars[arg1_44][2])
		end

		PoolMgr.GetInstance():ReturnSpineChar(arg0_44.roomChars[arg1_44][1], arg0_44.roomChars[arg1_44][2])

		arg0_44.roomChars[arg1_44][1] = nil
		arg0_44.roomChars[arg1_44][2] = nil
	end

	if var4_44 ~= "" then
		PoolMgr.GetInstance():GetSpineChar(var4_44, true, function(arg0_45)
			arg0_44.roomChars[arg1_44][1] = var4_44
			arg0_44.roomChars[arg1_44][2] = arg0_45

			setLocalScale(tf(arg0_45), {
				x = LinerRoomCharPoint.SCALE,
				y = LinerRoomCharPoint.SCALE
			})
			setParent(arg0_45, var5_44)
			arg0_44:InitCharBehavior(arg1_44, tf(arg0_45), var2_44[2])
		end)
	end
end

function var0_0.InitCharBehavior(arg0_46, arg1_46, arg2_46, arg3_46)
	local var0_46 = LinerRoomCharPoint[arg1_46]
	local var1_46 = LinerRoomCharPoint.SCALE

	if var0_46.type == 2 then
		setLocalPosition(arg2_46, var0_46.idlePoint)

		local var2_46 = arg3_46 or LinerRoomCharPoint.IDLE_ACTION

		arg2_46:GetComponent("SpineAnimUI"):SetAction(var2_46, 0)
	elseif var0_46.type == 1 then
		local var3_46 = var0_46.startPoint.x
		local var4_46 = var0_46.endPoint.x
		local var5_46 = (var4_46 - var3_46) / LinerRoomCharPoint.SPEED

		setLocalPosition(arg2_46, var0_46.startPoint)

		local var6_46 = arg3_46 or LinerRoomCharPoint.MOVE_ACTION

		arg2_46:GetComponent("SpineAnimUI"):SetAction(var6_46, 0)
		arg0_46:managedTween(LeanTween.value, nil, go(arg2_46), var3_46, var4_46, var5_46):setOnUpdate(System.Action_float(function(arg0_47)
			setLocalPosition(arg2_46, {
				x = arg0_47
			})

			if arg0_47 == var3_46 then
				setLocalScale(arg2_46, {
					x = var1_46,
					y = var1_46
				})
			end

			if arg0_47 == var4_46 then
				setLocalScale(arg2_46, {
					x = -var1_46,
					y = var1_46
				})
			end
		end)):setLoopPingPong()
	end
end

function var0_0.GetRandomItems(arg0_48, arg1_48, arg2_48)
	assert(arg2_48 <= #arg1_48, "不合法的随机数量")

	local var0_48 = {}

	for iter0_48 = 1, #arg1_48 do
		table.insert(var0_48, iter0_48)
	end

	shuffle(var0_48)

	local var1_48 = {}

	for iter1_48 = 1, arg2_48 do
		table.insert(var1_48, arg1_48[var0_48[iter1_48]])
	end

	return var1_48
end

function var0_0.InitRandomChars(arg0_49)
	for iter0_49, iter1_49 in pairs(arg0_49.roomChars) do
		if iter1_49[1] and iter1_49[2] then
			if LeanTween.isTweening(iter1_49[2]) then
				LeanTween.cancel(iter1_49[2])
			end

			PoolMgr.GetInstance():ReturnSpineChar(iter1_49[1], iter1_49[2])

			arg0_49.roomChars[iter0_49][1] = nil
			arg0_49.roomChars[iter0_49][2] = nil
		end
	end

	local var0_49 = arg0_49:GetRandomItems(underscore.filter(arg0_49.roomIds, function(arg0_50)
		return arg0_50 ~= 4 and arg0_50 ~= 31
	end), var0_0.FINISH_CHAR_CNT)
	local var1_49 = arg0_49:GetRandomItems(arg0_49.sdConfig, var0_0.FINISH_CHAR_CNT)

	for iter2_49, iter3_49 in ipairs(var0_49) do
		local var2_49 = var1_49[iter2_49]

		PoolMgr.GetInstance():GetSpineChar(var2_49, true, function(arg0_51)
			arg0_49.roomChars[iter3_49][1] = var2_49
			arg0_49.roomChars[iter3_49][2] = arg0_51

			local var0_51 = arg0_49:findTF(iter3_49 .. "/char", arg0_49.roomsTF)

			setLocalScale(tf(arg0_51), {
				x = LinerRoomCharPoint.SCALE,
				y = LinerRoomCharPoint.SCALE
			})
			setParent(arg0_51, var0_51)
			arg0_49:InitCharBehavior(iter3_49, tf(arg0_51))
		end)
	end
end

function var0_0.FillRandomChars(arg0_52)
	if arg0_52.oldTime.id == arg0_52.curTime.id and not arg0_52.isFirstUpdate then
		return
	end

	local var0_52 = Clone(arg0_52.roomIds)
	local var1_52 = Clone(arg0_52.sdConfig)
	local var2_52 = 0

	for iter0_52, iter1_52 in ipairs(arg0_52.roomIds) do
		local var3_52 = arg0_52.rooms[iter1_52]:GetSpineCharInfo(arg0_52.curTime.id)

		if var3_52 and var3_52[1] and var3_52[2] then
			table.removebyvalue(var0_52, iter1_52)

			if table.contains(var1_52, var3_52[1]) then
				table.removebyvalue(var1_52, var3_52[1])
			end

			var2_52 = var2_52 + 1
		end
	end

	if arg0_52.randomIds and #arg0_52.randomIds > 0 then
		for iter2_52, iter3_52 in pairs(arg0_52.roomChars) do
			if iter3_52[1] and iter3_52[2] and table.contains(arg0_52.randomIds, iter2_52) then
				if LeanTween.isTweening(iter3_52[2]) then
					LeanTween.cancel(iter3_52[2])
				end

				PoolMgr.GetInstance():ReturnSpineChar(iter3_52[1], iter3_52[2])

				arg0_52.roomChars[iter2_52][1] = nil
				arg0_52.roomChars[iter2_52][2] = nil
			end
		end
	end

	arg0_52.randomIds = {}

	local var4_52 = var0_0.FINISH_CHAR_CNT - var2_52

	arg0_52.randomIds = arg0_52:GetRandomItems(underscore.filter(var0_52, function(arg0_53)
		return arg0_53 ~= 4 and arg0_53 ~= 31
	end), var4_52)

	local var5_52 = arg0_52:GetRandomItems(var1_52, var4_52)

	for iter4_52, iter5_52 in ipairs(arg0_52.randomIds) do
		local var6_52 = var5_52[iter4_52]

		PoolMgr.GetInstance():GetSpineChar(var6_52, true, function(arg0_54)
			arg0_52.roomChars[iter5_52][1] = var6_52
			arg0_52.roomChars[iter5_52][2] = arg0_54

			local var0_54 = arg0_52:findTF(iter5_52 .. "/char", arg0_52.roomsTF)

			setLocalScale(tf(arg0_54), {
				x = LinerRoomCharPoint.SCALE,
				y = LinerRoomCharPoint.SCALE
			})
			setParent(arg0_54, var0_54)
			arg0_52:InitCharBehavior(iter5_52, tf(arg0_54))
		end)
	end
end

function var0_0.UpdateBg(arg0_55, arg1_55)
	local var0_55 = arg1_55 or arg0_55.curTime:GetBgType()

	for iter0_55, iter1_55 in ipairs(arg0_55.bgDiffList) do
		eachChild(iter1_55, function(arg0_56)
			setActive(arg0_56, arg0_56.name == var0_55)
		end)
	end
end

function var0_0.UpdateFinishTime(arg0_57)
	local var0_57 = os.date("*t", os.time())
	local var1_57 = var0_57.hour
	local var2_57 = var0_57.min
	local var3_57 = var1_57 < 12 and " AM" or " PM"

	arg0_57:UpdateBg(arg0_57.activity:GetReallyTimeType(var1_57))

	if var1_57 > 12 then
		var1_57 = var1_57 - 12
	end

	setText(arg0_57.timeTF, string.format("%d:%02d ", var1_57, var2_57) .. var3_57)
end

function var0_0.UpdateTimeUI(arg0_58)
	if arg0_58.isReallyTime then
		eachChild(arg0_58.targetTagTF, function(arg0_59)
			setActive(arg0_59, false)
		end)

		arg0_58.targetLayoutCom.spacing = -60

		setText(arg0_58.targetTF, i18n("liner_target_type5"))

		arg0_58.finishTimer = Timer.New(function()
			arg0_58:UpdateFinishTime()
		end, 60, -1)

		arg0_58.finishTimer:Start()
		arg0_58:UpdateFinishTime()

		return
	end

	setText(arg0_58.timeTF, arg0_58.curTime:GetStartTimeDesc())

	local var0_58 = arg0_58.curTime:GetType()

	eachChild(arg0_58.targetTagTF, function(arg0_61)
		setActive(arg0_61, not arg0_58.isFinishAll and arg0_61.name == "type" .. var0_58)
	end)

	local var1_58 = ""

	switch(var0_58, {
		[LinerTime.TYPE.TARGET] = function()
			var1_58 = i18n("liner_target_type1", arg0_58.rooms[arg0_58.targetIds[1]]:GetName())
		end,
		[LinerTime.TYPE.EXPLORE] = function()
			local var0_63 = arg0_58.curTime:GetExploreCnt()
			local var1_63 = arg0_58.activity:GetRemainExploreCnt()

			var1_58 = i18n("liner_target_type2") .. string.format("(%d/%d)", var0_63 - var1_63, var0_63)
		end,
		[LinerTime.TYPE.EVENT] = function()
			local var0_64 = #arg0_58.curTime:GetTargetRoomIds()
			local var1_64 = arg0_58.activity:GetRoomIdx() - 1

			if arg0_58.isFinishAll then
				var1_64 = var0_64
			end

			var1_58 = i18n("liner_target_type3") .. string.format("(%d/%d)", var1_64, var0_64)
		end,
		[LinerTime.TYPE.STORY] = function()
			var1_58 = i18n("liner_target_type4", arg0_58.rooms[arg0_58.targetIds[1]]:GetName())
		end
	})

	arg0_58.targetLayoutCom.spacing = (var0_58 == LinerTime.TYPE.EXPLORE or arg0_58.isFinishAll) and -60 or -10

	if arg0_58.isFinishAll then
		var1_58 = i18n("liner_target_type4")
	end

	setText(arg0_58.targetTF, var1_58)
end

function var0_0.CheckTime(arg0_66)
	local var0_66 = arg0_66.oldTime.id ~= arg0_66.curTime.id
	local var1_66 = arg0_66.activity:GetCurIdx()
	local var2_66 = math.max(var1_66 - 1, 1)

	if var0_66 then
		arg0_66.timePage:ExecuteAction("ShowAnim", arg0_66.activity, var2_66, var1_66, function()
			arg0_66:UpdateView()
		end)
	else
		arg0_66:UpdateView()
	end
end

function var0_0.UpdateView(arg0_68, arg1_68)
	arg0_68:UpdateBg()
	arg0_68:UpdateTimeUI()
	arg0_68:UpdateRooms()
	arg0_68:UpdateTips()
	arg0_68.floatItemList:align(#arg0_68.targetIds)

	if arg0_68.curTime:GetType() ~= LinerTime.TYPE.EXPLORE and arg0_68.targetIds[1] then
		arg0_68:FocusNode(arg0_68.targetIds[1], arg1_68)
	else
		arg0_68:onDragFunction()
	end

	if arg0_68.curTime:GetType() == LinerTime.TYPE.EXPLORE and not pg.NewStoryMgr.GetInstance():IsPlayed("Liner_1") then
		arg0_68:FocusNode(var0_0.GUIDE_ROOM_ID, function()
			pg.NewGuideMgr.GetInstance():Play("Liner_1")
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = "Liner_1"
			})
		end)
	end

	if arg0_68.oldTime.id ~= arg0_68.curTime.id then
		arg0_68:PlayBGM()
	end
end

function var0_0.UpdateData(arg0_70)
	arg0_70.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(arg0_70.activity and not arg0_70.activity:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	arg0_70.endingStory = arg0_70.activity:getConfig("config_client").endingstory[1]
	arg0_70.timeConfig = arg0_70.activity:getConfig("config_client").endingtime
	arg0_70.sdConfig = arg0_70.activity:getConfig("config_client").sd
	arg0_70.isFinishAll = arg0_70.activity:IsFinishAllTime()
	arg0_70.isReallyTime = arg0_70.isFinishAll and pg.NewStoryMgr.GetInstance():IsPlayed(arg0_70.endingStory)
	arg0_70.exploredRoomIds = arg0_70.activity:GetExploredRoomIds()
	arg0_70.curEventInfos = arg0_70.activity:GetCurEventInfo()
	arg0_70.oldTime = arg0_70.curTime and Clone(arg0_70.curTime) or nil
	arg0_70.curTime = arg0_70.activity:GetCurTime()

	if not arg0_70.oldTime then
		arg0_70.oldTime = Clone(arg0_70.curTime)
	end

	if arg0_70.isFinishAll then
		if not arg0_70.isReallyTime then
			arg0_70.targetIds = {
				var0_0.FINISH_TARGET_ROOM_ID
			}
		else
			arg0_70.targetIds = {}
		end
	elseif arg0_70.curTime:GetType() == LinerTime.TYPE.EVENT then
		arg0_70.targetIds = {
			arg0_70:_getCurEventRoomId()
		}
	else
		arg0_70.targetIds = arg0_70.curTime:GetTargetRoomIds()
	end

	if arg0_70.needAutoCheck then
		arg0_70.needAutoCheck = false

		arg0_70:CheckTime()
	end
end

function var0_0._getCurEventRoomId(arg0_71)
	return arg0_71.curTime:GetParamInfo()[arg0_71.activity:GetRoomIdx()][1]
end

function var0_0.UpdateTips(arg0_72)
	setActive(arg0_72:findTF("tip", arg0_72.logBtn), LinerLogBookLayer.IsTip())
end

function var0_0.onDragFunction(arg0_73)
	if not var0_0.screenPoints then
		var0_0.screenPoints = {
			Vector2(-arg0_73.delta.x, arg0_73.delta.y),
			Vector2(arg0_73.delta.x, arg0_73.delta.y),
			Vector2(arg0_73.delta.x, -arg0_73.delta.y),
			Vector2(-arg0_73.delta.x, -arg0_73.delta.y)
		}
	end

	for iter0_73, iter1_73 in ipairs(arg0_73.targetIds) do
		local var0_73 = arg0_73.roomsTF:Find(tostring(iter1_73))

		if var0_73 then
			local var1_73 = arg0_73._tf:InverseTransformPoint(var0_73.position)
			local var2_73

			for iter2_73, iter3_73 in ipairs(var0_0.screenPoints) do
				local var3_73 = var0_0.screenPoints[iter2_73 % 4 + 1]
				local var4_73 = Vector2(var1_73.x, var1_73.y)
				local var5_73, var6_73, var7_73 = LineLine(Vector2.zero, var4_73, iter3_73, var3_73)

				if var5_73 then
					var2_73 = var4_73 * var6_73

					break
				end
			end

			local var8_73 = arg0_73.floatItemList.container:Find(tostring(iter1_73))
			local var9_73 = var8_73:GetComponent(typeof(CanvasGroup))
			local var10_73 = tobool(var2_73)

			var9_73.interactable = var10_73
			var9_73.blocksRaycasts = var10_73
			var9_73.alpha = var10_73 and 1 or 0

			setActive(arg0_73:findTF(iter1_73 .. "/tag", arg0_73.roomsTF), not var10_73)

			if var2_73 then
				local var11_73 = var2_73 * (1 - 50 / var2_73:Magnitude())

				setAnchoredPosition(var8_73, var11_73)

				local var12_73 = math.rad2Deg * math.atan2(var2_73.y, var2_73.x)

				setLocalEulerAngles(var8_73:Find("arrow"), {
					z = var12_73
				})
			end
		end
	end
end

function var0_0.FocusNode(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg0_74.roomsTF:Find(tostring(arg1_74)).anchoredPosition * -1

	var0_74.x = math.clamp(var0_74.x, -arg0_74.extendLimit.x, arg0_74.extendLimit.x)
	var0_74.y = math.clamp(var0_74.y, -arg0_74.extendLimit.y, arg0_74.extendLimit.y)

	if arg0_74.twFocusId then
		LeanTween.cancel(arg0_74.twFocusId)

		arg0_74.twFocusId = nil
	end

	local var1_74 = {}

	table.insert(var1_74, function(arg0_75)
		SetCompomentEnabled(arg0_74.mapTF, typeof(ScrollRect), false)

		local var0_75 = (arg0_74.mapTF.anchoredPosition - var0_74).magnitude
		local var1_75 = var0_75 > 0 and var0_75 / (40 * math.sqrt(var0_75)) or 0

		arg0_74.twFocusId = LeanTween.move(arg0_74.mapTF, Vector3(var0_74.x, var0_74.y, 0), var1_75):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_76)
			arg0_74:onDragFunction()
		end)):setOnComplete(System.Action(arg0_75)).uniqueId
	end)
	seriesAsync(var1_74, function()
		SetCompomentEnabled(arg0_74.mapTF, typeof(ScrollRect), true)

		if arg2_74 then
			arg2_74()
		end
	end)
end

function var0_0.SwitchMode(arg0_78, arg1_78, arg2_78)
	arg0_78.mode = arg1_78

	local var0_78 = arg0_78.mode == var0_0.MODE_NORMAL

	setActive(arg0_78.focusTF, var0_78)

	local var1_78 = arg0_78.mapTF.localScale.x
	local var2_78 = var0_78 and 1 or arg0_78.fullFactor

	arg0_78:managedTween(LeanTween.value, nil, go(arg0_78.mapTF), var1_78, var2_78, var0_0.SCALE_ANIM_TIME):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_79)
		setLocalScale(arg0_78.mapTF, {
			x = arg0_79,
			y = arg0_79,
			z = arg0_79
		})
	end))

	if not var0_78 then
		arg0_78:managedTween(LeanTween.move, nil, go(arg0_78.mapTF), Vector3(0, 0, 0), var0_0.SCALE_ANIM_TIME):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
			if arg2_78 then
				arg2_78()
			end
		end))
	elseif arg2_78 then
		arg2_78()
	end
end

function var0_0.PlayAnim(arg0_81, arg1_81, arg2_81)
	seriesAsync({
		function(arg0_82)
			if not arg0_81.swithAnimTF then
				PoolMgr.GetInstance():GetUI("OtherworldCoverUI", true, function(arg0_83)
					arg0_81.swithAnimTF = arg0_83.transform

					setParent(arg0_81.swithAnimTF, arg0_81._tf, false)
					setActive(arg0_81.swithAnimTF, false)
					arg0_82()
				end)
			else
				arg0_82()
			end
		end,
		function(arg0_84)
			setActive(arg0_81.swithAnimTF, true)

			local var0_84 = arg0_81.swithAnimTF:Find("yuncaizhuanchang"):GetComponent(typeof(SpineAnimUI))

			var0_84:SetActionCallBack(function(arg0_85)
				if arg0_85 == "finish" then
					if arg2_81 then
						arg2_81()
					end

					setActive(arg0_81.swithAnimTF, false)
				elseif arg0_85 == "action" and arg1_81 then
					arg1_81()
				end
			end)
			var0_84:SetAction("action", 0)
		end
	}, function()
		return
	end)
end

function var0_0.onBackPressed(arg0_87)
	if arg0_87.timePage and arg0_87.timePage:GetLoaded() and arg0_87.timePage:isShowing() then
		return
	end

	var0_0.super.onBackPressed(arg0_87)
end

function var0_0.willExit(arg0_88)
	arg0_88.timePage:Destroy()

	arg0_88.timePage = nil

	arg0_88.roomPage:Destroy()

	arg0_88.roomPage = nil

	for iter0_88, iter1_88 in pairs(arg0_88.roomChars) do
		if iter1_88[1] and iter1_88[2] then
			PoolMgr.GetInstance():ReturnSpineChar(iter1_88[1], iter1_88[2])
		end
	end

	arg0_88.roomChars = nil

	if arg0_88.finishTimer ~= nil then
		arg0_88.finishTimer:Stop()

		arg0_88.finishTimer = nil
	end
end

return var0_0
