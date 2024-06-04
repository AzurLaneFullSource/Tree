local var0 = class("OtherworldMapScene", import("view.activity.BossSingle.BossSingleSceneTemplate"))
local var1 = "otherworld_scroll_value_x"
local var2 = "otherworld_mode"

var0.MODE_STORY = 1
var0.MODE_BATTLE = 2
var0.NAME2INDEX = {
	xifangjudian = 1,
	mowangcheng = 4,
	julongchaoxue = 5,
	zhongbujudian = 2,
	dongfangjudian = 3
}
var0.TYPE2NAME = {
	[BossSingleEnemyData.TYPE.EAST] = "xifangjudian",
	[BossSingleEnemyData.TYPE.NORMAL] = "zhongbujudian",
	[BossSingleEnemyData.TYPE.HARD] = "dongfangjudian",
	[BossSingleEnemyData.TYPE.SP] = "mowangcheng",
	[BossSingleEnemyData.TYPE.EX] = "julongchaoxue"
}
var0.MAP_AREA_CNT = 5
var0.MAP_AREA_START = 2
var0.FLOAT_LEFT_MIN_Y = -100
var0.FLOAT_ARROW_LIMIT_Y = {
	-50,
	50
}
var0.STORY_TPL_HALF_WIDTH = 235
var0.TERMINAL_DELAY_TIME = 0.5
var0.MAP_ANIM_TIME = 0.8
var0.DEFAULT_SCROLL_VALUE = 0.36

function var0.getUIName(arg0)
	return "OtherworldMapUI"
end

function var0.SetEventAct(arg0, arg1)
	arg0.eventAct = arg1
end

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.mapTF = arg0:findTF("map")
	arg0.bgTF = arg0:findTF("bg", arg0.mapTF)
	arg0.mapContent = arg0:findTF("content", arg0.mapTF)
	arg0.storiesTF = arg0:findTF("stories", arg0.mapContent)
	arg0.storyTpl = arg0:findTF("story_node", arg0.storiesTF)

	setActive(arg0.storyTpl, false)

	arg0.strongholdsTF = arg0:findTF("strongholds", arg0.mapContent)
	arg0.locationsTF = arg0:findTF("locations", arg0.mapContent)
	arg0.uiTF = arg0:findTF("ui")
	arg0.focusTF = arg0:findTF("focus", arg0.uiTF)

	setActive(arg0:findTF("tpl", arg0.focusTF), false)

	arg0.topUI = arg0:findTF("top", arg0.uiTF)
	arg0.ptIconTF = arg0:findTF("res_panel/icon", arg0.topUI)
	arg0.ptValueTF = arg0:findTF("res_panel/Text", arg0.topUI)
	arg0.leftUI = arg0:findTF("left", arg0.uiTF)
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.leftUI)
	arg0.storyBtn = arg0:findTF("story_btn", arg0.leftUI)
	arg0.leftArrow = arg0:findTF("arrow", arg0.leftUI)
	arg0.rightArrow = arg0:findTF("right/arrow", arg0.uiTF)
	arg0.playerId = getProxy(PlayerProxy):getRawData().id
	arg0.battleHideLocations = {
		arg0:findTF("2/xifangjudian", arg0.locationsTF),
		arg0:findTF("3/zhongbujudian", arg0.locationsTF),
		arg0:findTF("4/dongfangjudian", arg0.locationsTF),
		arg0:findTF("5/julongchaoxue", arg0.locationsTF),
		arg0:findTF("5/mowangcheng", arg0.locationsTF),
		arg0:findTF("wangdu", arg0.locationsTF)
	}
	arg0.clickMask = arg0:findTF("click_mask", arg0.uiTF)

	setActive(arg0.clickMask, false)
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
	arg0:SetNativeSizes()
	onButton(arg0, arg0:findTF("return_btn", arg0.topUI), function()
		arg0:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("home_btn", arg0.topUI), function()
		arg0:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("help_btn", arg0.topUI), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.otherworld_map_help.tip
		})
	end, SFX_CANCEL)
	onButton(arg0, arg0.battleBtn, function()
		arg0:PlaySwithAnim(function()
			arg0:ShowBattleMode()
		end)
	end, SFX_CANCEL)
	onButton(arg0, arg0.storyBtn, function()
		if not arg0.eventAct then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0:PlaySwithAnim(function()
			arg0:ShowStoryMode()
		end)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("terminal_btn", arg0.leftUI), function()
		arg0:OpenTerminal()
	end, SFX_CANCEL)
	onScroll(arg0, arg0.mapTF, function(arg0)
		setActive(arg0.leftArrow, arg0.x > 0.1)
		setActive(arg0.rightArrow, arg0.x < 0.85)

		arg0.scrollValueX = arg0.x

		arg0:onDragFunction()
	end)
	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0.contextData.resId
	}):getIcon(), "", arg0.ptIconTF)
	arg0:InitStrongholds()
	arg0:InitStoryNodes()

	arg0.bgScale = arg0._tf.rect.height / 1440

	setLocalScale(arg0.mapTF, {
		x = arg0.bgScale,
		y = arg0.bgScale,
		z = arg0.bgScale
	})

	local var0, var1, var2 = getSizeRate()

	arg0.delta = Vector2(var1 - 100, var2 - 100) / 2
	arg0.extendLimit = Vector2(arg0.mapTF.rect.width * arg0.bgScale - arg0._tf.rect.width, arg0.mapTF.rect.height * arg0.bgScale - arg0._tf.rect.height) / 2

	if not arg0.contextData.mode then
		local var3 = PlayerPrefs.GetInt(var2 .. arg0.playerId, 0)

		if var3 == 0 then
			arg0.contextData.mode = var0.MODE_BATTLE
		else
			arg0.contextData.mode = var3
		end
	end

	local var4 = arg0.eventAct and arg0.eventAct:getConfig("config_client").open_story

	if var4 and var4 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var4) or not pg.NewStoryMgr.GetInstance():IsPlayed("NG0044") then
		arg0.contextData.mode = var0.MODE_BATTLE
	end

	if arg0.contextData.mode == var0.MODE_BATTLE then
		arg0:ShowBattleMode()
	elseif arg0.eventAct then
		arg0:ShowStoryMode()
	else
		arg0:ShowBattleMode()
	end

	arg0:UpdateView()
	seriesAsync({
		function(arg0)
			local var0 = PlayerPrefs.GetFloat(var1 .. arg0.playerId, 0)

			if not PlayerPrefs.HasKey(var1 .. arg0.playerId) then
				var0 = var0.DEFAULT_SCROLL_VALUE
			end

			scrollTo(arg0.mapTF, var0, 0)
			arg0()
		end,
		function(arg0)
			local var0 = arg0.eventAct and arg0.eventAct:getConfig("config_client").open_story

			if var0 and var0 ~= "" then
				pg.NewStoryMgr.GetInstance():Play(var0, arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0044", nil, arg0)
		end,
		function(arg0)
			if arg0.contextData.openTerminal then
				arg0:OpenTerminal({
					page = arg0.contextData.terminalPage,
					onExit = arg0
				})

				arg0.contextData.openTerminal = nil
				arg0.contextData.terminalPage = nil
			else
				arg0()
			end
		end
	}, function()
		if arg0.eventAct and arg0.contextData.eventTriggerId then
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0:emit(OtherworldMapMediator.ON_EVENT_TRIGGER, {
					actId = arg0.eventAct.id,
					eventId = arg0.contextData.eventTriggerId
				})

				arg0.contextData.eventTriggerId = nil
			end, 0.02, nil)
		end
	end)
end

function var0.SetNativeSizes(arg0)
	eachChild(arg0.bgTF, function(arg0)
		eachChild(arg0, function(arg0)
			local var0 = arg0:GetComponent(typeof(Image))

			if var0 then
				var0:SetNativeSize()
			end
		end)
	end)
	eachChild(arg0.locationsTF, function(arg0)
		if arg0.childCount > 0 then
			eachChild(arg0, function(arg0)
				local var0 = arg0:GetComponent(typeof(Image))

				if var0 then
					var0:SetNativeSize()
				end
			end)
		else
			local var0 = arg0:GetComponent(typeof(Image))

			if var0 then
				var0:SetNativeSize()
			end
		end
	end)
	eachChild(arg0.strongholdsTF, function(arg0)
		local var0 = arg0:Find("name/Image")
		local var1 = var0 and var0:GetComponent(typeof(Image))

		if var1 then
			var1:SetNativeSize()
		end
	end)
end

function var0.BindStronghold(arg0, arg1, arg2)
	onButton(arg0, arg0:findTF(arg1 .. "/icon", arg0.strongholdsTF), arg2, SFX_PANEL)
	onButton(arg0, arg0:findTF(arg1 .. "/name", arg0.strongholdsTF), arg2, SFX_PANEL)
end

function var0.InitStrongholds(arg0, arg1, arg2)
	arg0:BindStronghold("wangdu", function()
		pg.SceneAnimMgr.GetInstance():OtherWorldCoverGoScene(SCENE.OTHERWORLD_BACKHILL)
	end)

	for iter0, iter1 in pairs(var0.NAME2INDEX) do
		arg0:BindStronghold(iter0, function()
			local var0, var1 = arg0.contextData.bossActivity:CheckEntranceByIdx(iter1)

			if var0 then
				arg0:ShowNormalFleet(iter1)
			else
				pg.TipsMgr.GetInstance():ShowTips(var1)
			end
		end)
	end
end

function var0.InitStoryNodes(arg0)
	arg0.eventIds = {}
	arg0.nodeItemList = UIItemList.New(arg0.storiesTF, arg0.storyTpl)

	arg0.nodeItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0.eventIds[var0]
			local var2 = arg0.eventAct:GetEventById(var1)

			arg2.name = var2.id

			arg2:GetComponent(typeof(Animation)):Stop()

			if not arg0.playInAnimId or arg0.playInAnimId ~= var2.id then
				setLocalScale(arg2, Vector3.one)

				GetOrAddComponent(arg2, typeof(CanvasGroup)).alpha = 1
			end

			local var3, var4 = unpack(var2:GetPos())

			setAnchoredPosition(arg2, {
				x = var3,
				y = var4
			})
			setImageSprite(arg2:Find("type"), GetSpriteFromAtlas("ui/otherworldmapui_atlas", var2:GetIconName()))
			setText(arg2:Find("title"), var2:GetName())
			onButton(arg0, arg2, function()
				if arg0.eventAct:CheckTrigger(var1) then
					arg0:TriggerEvent(var1)
				end
			end, SFX_CONFIRM)
		end
	end)

	arg0.floatItemList = UIItemList.New(arg0.focusTF, arg0.focusTF:Find("tpl"))

	arg0.floatItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.eventIds[arg1]
			local var1 = arg0.eventAct:GetEventById(var0)

			arg2.name = var0

			setImageSprite(arg2:Find("type"), GetSpriteFromAtlas("ui/otherworldmapui_atlas", var1:GetIconName()))
			onButton(arg0, arg2, function()
				arg0:FocusNode(arg0.eventIds[arg1])
			end, SFX_PANEL)
		end
	end)
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

	for iter0, iter1 in ipairs(arg0.eventIds) do
		local var0 = arg0.nodeItemList.container:Find(tostring(iter1))

		if var0 then
			local var1 = arg0._tf:InverseTransformPoint(var0.position)
			local var2

			for iter2, iter3 in ipairs(var0.screenPoints) do
				local var3 = var0.screenPoints[iter2 % 4 + 1]
				local var4 = Vector2(var1.x, var1.y)

				if iter3.x < 0 then
					var4.x = var4.x + var0.STORY_TPL_HALF_WIDTH
				end

				if iter3.x > 0 then
					var4.x = var4.x - var0.STORY_TPL_HALF_WIDTH
				end

				local var5, var6, var7 = LineLine(Vector2.zero, var4, iter3, var3)

				if var5 then
					var2 = var4 * var6

					break
				end
			end

			local var8 = arg0.floatItemList.container:Find(tostring(iter1))
			local var9 = var8:GetComponent(typeof(CanvasGroup))

			var9.interactable = tobool(var2)
			var9.blocksRaycasts = tobool(var2)
			var9.alpha = tobool(var2) and 1 or 0

			if var2 then
				local var10 = var2 * (1 - 50 / var2:Magnitude())

				if var10.x < 0 and var10.y < var0.FLOAT_LEFT_MIN_Y then
					var10.y = var0.FLOAT_LEFT_MIN_Y
				end

				if var10.y >= var0.FLOAT_ARROW_LIMIT_Y[1] and var10.y <= var0.FLOAT_ARROW_LIMIT_Y[2] then
					if var10.x < 0 then
						setActive(arg0.leftArrow, false)
					end

					if var10.x > 0 then
						setActive(arg0.rightArrow, false)
					end
				end

				setAnchoredPosition(var8, var10)

				local var11 = math.rad2Deg * math.atan2(var2.y, var2.x)

				setLocalEulerAngles(var8:Find("arrow"), {
					z = var11
				})
			end
		end
	end

	if arg0.contextData.mode == var0.MODE_BATTLE then
		local var12
		local var13 = arg0._tf:InverseTransformPoint(arg0:findTF("wangdu", arg0.strongholdsTF).position)

		var13.x = var13.x + 150

		for iter4, iter5 in ipairs(var0.screenPoints) do
			local var14 = var0.screenPoints[iter4 % 4 + 1]
			local var15, var16, var17 = LineLine(Vector2.zero, var13, iter5, var14)

			if var15 then
				var12 = var13 * var16

				break
			end
		end

		setActive(arg0:findTF("tip", arg0.leftArrow), arg0.isShowWangduTip and var12)

		local var18
		local var19 = arg0._tf:InverseTransformPoint(arg0:findTF("mowangcheng", arg0.strongholdsTF).position)

		var19.x = var19.x + 100

		for iter6, iter7 in ipairs(var0.screenPoints) do
			local var20 = var0.screenPoints[iter6 % 4 + 1]
			local var21, var22, var23 = LineLine(Vector2.zero, var19, iter7, var20)

			if var21 then
				var18 = var19 * var22

				break
			end
		end

		setActive(arg0:findTF("tip", arg0.rightArrow), arg0.isShowSpTip and var18)
	end
end

function var0.FocusNode(arg0, arg1, arg2)
	local var0 = arg0.nodeItemList.container:Find(arg1).anchoredPosition * -1

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

		arg0.twFocusId = LeanTween.move(arg0.mapTF, Vector3(var0.x, var0.y), var1):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0)
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

function var0.FocusPoint(arg0, arg1, arg2)
	arg1.x = math.clamp(arg1.x, -arg0.extendLimit.x, arg0.extendLimit.x)
	arg1.y = math.clamp(arg1.y, -arg0.extendLimit.y, arg0.extendLimit.y)

	if arg0.twFocusId then
		LeanTween.cancel(arg0.twFocusId)

		arg0.twFocusId = nil
	end

	local var0 = {}

	table.insert(var0, function(arg0)
		SetCompomentEnabled(arg0.mapTF, typeof(ScrollRect), false)

		local var0 = (arg0.mapTF.anchoredPosition - arg1).magnitude
		local var1 = var0 > 0 and var0 / (40 * math.sqrt(var0)) or 0

		arg0.twFocusId = LeanTween.move(arg0.mapTF, Vector3(arg1.x, arg1.y), var1):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0)
			arg0:onDragFunction()
		end)):setOnComplete(System.Action(arg0)).uniqueId
	end)
	seriesAsync(var0, function()
		SetCompomentEnabled(arg0.mapTF, typeof(ScrollRect), true)

		if arg2 then
			arg2()
		end
	end)
end

function var0.TriggerEvent(arg0, arg1, arg2)
	local var0 = arg0.eventAct:GetEventById(arg1)

	switch(var0:GetStoryType(), {
		[SingleEvent.STORY_TYPE.STORY] = function()
			seriesAsync({
				function(arg0)
					local var0 = var0:GetStory()

					if var0 and var0 ~= "" then
						pg.NewStoryMgr.GetInstance():Play(var0, arg0, true)
					end
				end
			}, function()
				arg0:emit(OtherworldMapMediator.ON_EVENT_TRIGGER, {
					actId = arg0.eventAct.id,
					eventId = arg1
				})
			end)
		end,
		[SingleEvent.STORY_TYPE.BATTLE] = function()
			seriesAsync({
				function(arg0)
					local var0 = tonumber(var0:GetStory())

					if var0 and var0 > 0 then
						arg0:emit(OtherworldMapMediator.ON_PERFORM_COMBAT, var0)
					end

					arg0.contextData.eventTriggerId = arg1
				end
			}, function()
				existCall(arg2)
			end)
		end
	}, function()
		pg.TipsMgr.GetInstance():ShowTips("trigger unkonw story_type: " .. var0:GetStoryType())
	end)
end

function var0.UpdateToggleTip(arg0)
	if not arg0.eventAct then
		setActive(arg0:findTF("new", arg0.storyBtn), false)
		setActive(arg0:findTF("new", arg0.battleBtn), false)

		return
	end

	local var0 = arg0.eventAct:GetAllEventIds()
	local var1 = underscore.any(var0, function(arg0)
		local var0 = arg0.eventAct:GetEventById(arg0)

		return var0 and arg0.eventAct:CheckTrigger(var0.id) and var0:GetMode() == SingleEvent.MODE_TYPE.STORY
	end)
	local var2 = underscore.any(var0, function(arg0)
		local var0 = arg0.eventAct:GetEventById(arg0)

		return var0 and arg0.eventAct:CheckTrigger(var0.id) and var0:GetMode() == SingleEvent.MODE_TYPE.BATTLE
	end)

	setActive(arg0:findTF("new", arg0.storyBtn), var1)
	setActive(arg0:findTF("new", arg0.battleBtn), var2)
end

function var0.UpdateMapArea(arg0)
	if not arg0.eventAct then
		return
	end

	local var0 = arg0.contextData.mode == var0.MODE_STORY
	local var1 = arg0.eventAct:GetUnlockMapAreas()

	for iter0 = var0.MAP_AREA_START, var0.MAP_AREA_CNT do
		local var2 = table.contains(var1, iter0)

		setActive(arg0:findTF(tostring(iter0), arg0.locationsTF), not var0 or not var2)
		setActive(arg0:findTF(tostring(iter0), arg0.bgTF), var2 and var0)
	end
end

function var0.PlayMapAnim(arg0, arg1, arg2)
	local var0 = arg0.eventAct:GetEventById(arg1):GetMapOptions()
	local var1 = arg0:findTF(var0, arg0.bgTF)
	local var2 = arg0:findTF(var0, arg0.locationsTF)

	if var1 and var2 then
		setActive(var1, true)

		GetOrAddComponent(var1, typeof(CanvasGroup)).alpha = 0

		arg0:managedTween(LeanTween.value, nil, go(var1), 0, 1, var0.MAP_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0)
			GetOrAddComponent(var1, typeof(CanvasGroup)).alpha = arg0
		end)):setOnComplete(System.Action(function()
			arg2()
		end))

		GetOrAddComponent(var2, typeof(CanvasGroup)).alpha = 1

		arg0:managedTween(LeanTween.value, nil, go(var1), 1, 0, var0.MAP_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0)
			GetOrAddComponent(var2, typeof(CanvasGroup)).alpha = arg0
		end)):setOnComplete(System.Action(function()
			setActive(var2, false)
		end))
	else
		arg2()
	end
end

function var0.UpdateWangduBtn(arg0)
	arg0.isShowWangduTip = OtherworldBackHillScene.IsShowTip()

	setActive(arg0:findTF("wangdu/name/tip", arg0.strongholdsTF), arg0.isShowWangduTip)
	setActive(arg0:findTF("tip", arg0.leftArrow), arg0.isShowWangduTip and arg0.contextData.mode == var0.MODE_BATTLE)
end

function var0.UpdateEntrances(arg0)
	local var0 = arg0.contextData.bossActivity

	for iter0, iter1 in pairs(var0:GetEnemyDatas()) do
		local var1 = var0:IsUnlockByEnemyId(iter1.id)
		local var2 = iter1:GetType()
		local var3 = arg0:findTF(var0.TYPE2NAME[var2], arg0.strongholdsTF)
		local var4 = arg0:findTF("lock", var3)

		if var4 then
			setActive(var4, not var1)
		end

		if var2 == BossSingleEnemyData.TYPE.SP then
			setActive(arg0:findTF("count", var3), var1 and iter1:InTime())

			local var5, var6 = var0:GetCounts(iter1.id)

			setText(arg0:findTF("count/Text", var3), i18n("levelScene_chapter_count_tip") .. var5 .. "/" .. var6)

			local var7 = var1 and var5 > 0 and iter1:InTime()

			setActive(arg0:findTF("name/tip", var3), var7)
			setActive(arg0:findTF("tip", arg0.rightArrow), var7 and arg0.contextData.mode == var0.MODE_BATTLE)
		end
	end
end

function var0.OpenTerminal(arg0, arg1)
	arg0:emit(OtherworldMapMediator.GO_SUBLAYER, Context.New({
		mediator = OtherworldTerminalMediator,
		viewComponent = OtherworldTerminalLayer,
		data = arg1
	}))
end

function var0.UpdateEvents(arg0, arg1)
	if not arg0.eventAct then
		return
	end

	local var0 = arg0.contextData.mode == var0.MODE_STORY and SingleEvent.MODE_TYPE.STORY or SingleEvent.MODE_TYPE.BATTLE

	arg0.eventIds = underscore.select(arg0.eventAct:GetAllEventIds(), function(arg0)
		local var0 = arg0.eventAct:GetEventById(arg0)

		return var0 and arg0.eventAct:CheckTrigger(var0.id) and var0:GetMode() == var0
	end)

	local var1 = {}

	if arg1 then
		local var2 = arg0.nodeItemList.container:Find(tostring(arg1)).anchoredPosition * -1
		local var3 = arg0.contextData.mode == var0.MODE_STORY and #arg0.eventIds > 0

		if #arg0.eventAct:GetEventById(arg1):GetOptions() > 0 then
			table.insert(var1, function(arg0)
				arg0:OpenTerminal({
					upgrade = true,
					onExit = arg0
				})
			end)
		end

		if var3 then
			local var4, var5 = unpack(arg0.eventAct:GetEventById(arg0.eventIds[1]):GetPos())
			local var6 = Vector2(var4, var5) * -1

			table.insert(var1, function(arg0)
				arg0:FocusPoint({
					x = (var2.x + var6.x) / 2,
					y = (var2.y + var6.y) / 2
				}, arg0)
			end)
		end

		table.insert(var1, function(arg0)
			local var0 = arg0.nodeItemList.container:Find(tostring(arg1))
			local var1 = var0:GetComponent(typeof(Animation))
			local var2 = var0:GetComponent(typeof(DftAniEvent))

			var2:SetEndEvent(function()
				arg0()
				var2:SetEndEvent(nil)
			end)
			var1:Play("story_node_out")
		end)
		table.insert(var1, function(arg0)
			if var3 then
				arg0.playInAnimId = arg0.eventIds[1]
			end

			arg0.nodeItemList:align(#arg0.eventIds)
			arg0.floatItemList:align(#arg0.eventIds)
			arg0:UpdateToggleTip()
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0()
			end, 0.02, nil)
		end)

		if arg0.eventAct:IsShowMapAnim(arg1) then
			table.insert(var1, function(arg0)
				arg0:PlayMapAnim(arg1, arg0)
			end)
		end

		if var3 then
			table.insert(var1, function(arg0)
				local var0 = arg0.nodeItemList.container:Find(tostring(arg0.eventIds[1]))
				local var1 = var0:GetComponent(typeof(Animation))
				local var2 = var0:GetComponent(typeof(DftAniEvent))

				var2:SetEndEvent(function()
					arg0()
					var2:SetEndEvent(nil)

					arg0.playInAnimId = nil
				end)

				GetOrAddComponent(var0, typeof(CanvasGroup)).alpha = 0

				var1:Play("story_node_in")
			end)
		end
	else
		table.insert(var1, function(arg0)
			arg0.nodeItemList:align(#arg0.eventIds)

			if not arg0.first then
				eachChild(arg0.nodeItemList.container, function(arg0)
					if isActive(arg0) then
						onNextTick(function()
							arg0:GetComponent(typeof(Animation)):Play("story_node_in")
						end)
					end
				end)

				arg0.first = true
			end

			arg0.floatItemList:align(#arg0.eventIds)
			arg0:UpdateToggleTip()
			arg0()
		end)
	end

	setActive(arg0.clickMask, true)
	seriesAsync(var1, function()
		arg0:onDragFunction()
		setActive(arg0.clickMask, false)
	end)
end

function var0.UpdateRes(arg0)
	setText(arg0.ptValueTF, getProxy(PlayerProxy):getData():getResource(arg0.contextData.resId))
end

function var0.UpdateTerminalTip(arg0)
	setActive(arg0:findTF("terminal_btn/tip", arg0.leftUI), TerminalAdventurePage.IsTip())
end

function var0.ShowBattleMode(arg0)
	arg0.contextData.mode = var0.MODE_BATTLE

	setActive(arg0.battleBtn, false)
	setActive(arg0.storyBtn, true)
	setActive(arg0.strongholdsTF, true)

	for iter0, iter1 in ipairs(arg0.battleHideLocations) do
		setActive(iter1, false)
	end

	arg0:UpdateEvents()
	arg0:UpdateMapArea()

	local var0 = arg0.contextData.bossActivity
	local var1 = var0:GetEnemyDataByType(BossSingleEnemyData.TYPE.SP)

	if not var0:IsUnlockByEnemyId(var1.id) or not var1:InTime() then
		arg0.isShowSpTip = false
	else
		local var2, var3 = var0:GetCounts(var1.id)

		arg0.isShowSpTip = var2 > 0
	end

	setActive(arg0:findTF("tip", arg0.rightArrow), arg0.isShowSpTip)
	setActive(arg0:findTF("tip", arg0.leftArrow), arg0.isShowWangduTip)
	PlayerPrefs.SetInt(var2 .. arg0.playerId, arg0.contextData.mode)
	PlayerPrefs.Save()
end

function var0.ShowStoryMode(arg0)
	arg0.contextData.mode = var0.MODE_STORY

	setActive(arg0.battleBtn, true)
	setActive(arg0.storyBtn, false)
	setActive(arg0.strongholdsTF, false)

	for iter0, iter1 in ipairs(arg0.battleHideLocations) do
		setActive(iter1, true)
	end

	arg0:UpdateEvents()
	arg0:UpdateMapArea()
	setActive(arg0:findTF("tip", arg0.rightArrow), false)
	setActive(arg0:findTF("tip", arg0.leftArrow), false)
	PlayerPrefs.SetInt(var2 .. arg0.playerId, arg0.contextData.mode)
	PlayerPrefs.Save()
end

function var0.PlaySwithAnim(arg0, arg1)
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

function var0.UpdateView(arg0)
	arg0:UpdateWangduBtn()
	arg0:UpdateRes()
	arg0:UpdateEntrances()
	arg0:UpdateEvents()
	arg0:UpdateMapArea()
	arg0:UpdateTerminalTip()
	arg0:UpdateToggleTip()
end

function var0.willExit(arg0)
	var0.super.willExit(arg0)
	arg0:cleanManagedTween()
	PlayerPrefs.SetFloat(var1 .. arg0.playerId, arg0.scrollValueX or 0)
	PlayerPrefs.Save()
end

function var0.IsShowTip()
	local function var0()
		local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID)

		if not var0 or var0:isEnd() then
			return false
		end

		local var1 = var0:GetEnemyDataByType(BossSingleEnemyData.TYPE.SP)

		if not var0:IsUnlockByEnemyId(var1.id) or not var1:InTime() then
			return false
		end

		local var2, var3 = var0:GetCounts(var1.id)

		return var2 > 0
	end

	return TerminalAdventurePage.IsTip() or var0()
end

var0.personalRandomData = nil

return var0
