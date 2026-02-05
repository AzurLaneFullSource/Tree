local var0_0 = class("OtherworldMapScene", import("view.activity.BossSingle.BossSingleSceneTemplate"))
local var1_0 = "otherworld_scroll_value_x"
local var2_0 = "otherworld_mode"

var0_0.MODE_STORY = 1
var0_0.MODE_BATTLE = 2
var0_0.NAME2INDEX = {
	xifangjudian = 1,
	mowangcheng = 4,
	julongchaoxue = 5,
	zhongbujudian = 2,
	dongfangjudian = 3
}
var0_0.TYPE2NAME = {
	[BossSingleEnemyData.TYPE.EAST] = "xifangjudian",
	[BossSingleEnemyData.TYPE.NORMAL] = "zhongbujudian",
	[BossSingleEnemyData.TYPE.HARD] = "dongfangjudian",
	[BossSingleEnemyData.TYPE.SP] = "mowangcheng",
	[BossSingleEnemyData.TYPE.EX] = "julongchaoxue"
}
var0_0.MAP_AREA_CNT = 5
var0_0.MAP_AREA_START = 2
var0_0.FLOAT_LEFT_MIN_Y = -100
var0_0.FLOAT_ARROW_LIMIT_Y = {
	-50,
	50
}
var0_0.STORY_TPL_HALF_WIDTH = 235
var0_0.TERMINAL_DELAY_TIME = 0.5
var0_0.MAP_ANIM_TIME = 0.8
var0_0.DEFAULT_SCROLL_VALUE = 0.36

function var0_0.getUIName(arg0_1)
	return "OtherworldMapUI"
end

function var0_0.SetEventAct(arg0_2, arg1_2)
	arg0_2.eventAct = arg1_2
end

function var0_0.init(arg0_3)
	var0_0.super.init(arg0_3)

	arg0_3.mapTF = arg0_3._tf:Find("map")
	arg0_3.bgTF = arg0_3.mapTF:Find("bg")
	arg0_3.mapContent = arg0_3.mapTF:Find("content")
	arg0_3.storiesTF = arg0_3.mapContent:Find("stories")
	arg0_3.storyTpl = arg0_3.storiesTF:Find("story_node")

	setActive(arg0_3.storyTpl, false)

	arg0_3.strongholdsTF = arg0_3.mapContent:Find("strongholds")
	arg0_3.locationsTF = arg0_3.mapContent:Find("locations")
	arg0_3.uiTF = arg0_3._tf:Find("ui")
	arg0_3.focusTF = arg0_3.uiTF:Find("focus")

	setActive(arg0_3.focusTF:Find("tpl"), false)

	arg0_3.topUI = arg0_3.uiTF:Find("top")
	arg0_3.ptIconTF = arg0_3.topUI:Find("res_panel/icon")
	arg0_3.ptValueTF = arg0_3.topUI:Find("res_panel/Text")
	arg0_3.leftUI = arg0_3.uiTF:Find("left")
	arg0_3.battleBtn = arg0_3.leftUI:Find("battle_btn")
	arg0_3.storyBtn = arg0_3.leftUI:Find("story_btn")
	arg0_3.leftArrow = arg0_3.leftUI:Find("arrow")
	arg0_3.rightArrow = arg0_3.uiTF:Find("right/arrow")
	arg0_3.playerId = getProxy(PlayerProxy):getRawData().id
	arg0_3.battleHideLocations = {
		arg0_3.locationsTF:Find("2/xifangjudian"),
		arg0_3.locationsTF:Find("3/zhongbujudian"),
		arg0_3.locationsTF:Find("4/dongfangjudian"),
		arg0_3.locationsTF:Find("5/julongchaoxue"),
		arg0_3.locationsTF:Find("5/mowangcheng"),
		arg0_3.locationsTF:Find("wangdu")
	}
	arg0_3.clickMask = arg0_3.uiTF:Find("click_mask")

	setActive(arg0_3.clickMask, false)
end

function var0_0.didEnter(arg0_4)
	var0_0.super.didEnter(arg0_4)
	arg0_4:SetNativeSizes()
	onButton(arg0_4, arg0_4.topUI:Find("return_btn"), function()
		arg0_4:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.topUI:Find("home_btn"), function()
		arg0_4:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.topUI:Find("help_btn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.otherworld_map_help.tip
		})
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.battleBtn, function()
		arg0_4:PlaySwithAnim(function()
			arg0_4:ShowBattleMode()
		end)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.storyBtn, function()
		if not arg0_4.eventAct then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_4:PlaySwithAnim(function()
			arg0_4:ShowStoryMode()
		end)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.leftUI:Find("terminal_btn"), function()
		arg0_4:OpenTerminal()
	end, SFX_CANCEL)
	onScroll(arg0_4, arg0_4.mapTF, function(arg0_13)
		setActive(arg0_4.leftArrow, arg0_13.x > 0.1)
		setActive(arg0_4.rightArrow, arg0_13.x < 0.85)

		arg0_4.scrollValueX = arg0_13.x

		arg0_4:onDragFunction()
	end)
	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0_4.contextData.resId
	}):getIcon(), "", arg0_4.ptIconTF)
	arg0_4:InitStrongholds()
	arg0_4:InitStoryNodes()

	arg0_4.bgScale = arg0_4._tf.rect.height / 1440

	setLocalScale(arg0_4.mapTF, {
		x = arg0_4.bgScale,
		y = arg0_4.bgScale,
		z = arg0_4.bgScale
	})

	local var0_4, var1_4, var2_4 = getSizeRate()

	arg0_4.delta = Vector2(var1_4 - 100, var2_4 - 100) / 2
	arg0_4.extendLimit = Vector2(arg0_4.mapTF.rect.width * arg0_4.bgScale - arg0_4._tf.rect.width, arg0_4.mapTF.rect.height * arg0_4.bgScale - arg0_4._tf.rect.height) / 2

	if not arg0_4.contextData.mode then
		local var3_4 = PlayerPrefs.GetInt(var2_0 .. arg0_4.playerId, 0)

		if var3_4 == 0 then
			arg0_4.contextData.mode = var0_0.MODE_BATTLE
		else
			arg0_4.contextData.mode = var3_4
		end
	end

	local var4_4 = arg0_4.eventAct and arg0_4.eventAct:getConfig("config_client").open_story

	if var4_4 and var4_4 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var4_4) or not pg.NewStoryMgr.GetInstance():IsPlayed("NG0044") then
		arg0_4.contextData.mode = var0_0.MODE_BATTLE
	end

	if arg0_4.contextData.mode == var0_0.MODE_BATTLE then
		arg0_4:ShowBattleMode()
	elseif arg0_4.eventAct then
		arg0_4:ShowStoryMode()
	else
		arg0_4:ShowBattleMode()
	end

	arg0_4:UpdateView()
	seriesAsync({
		function(arg0_14)
			local var0_14 = PlayerPrefs.GetFloat(var1_0 .. arg0_4.playerId, 0)

			if not PlayerPrefs.HasKey(var1_0 .. arg0_4.playerId) then
				var0_14 = var0_0.DEFAULT_SCROLL_VALUE
			end

			scrollTo(arg0_4.mapTF, var0_14, 0)
			arg0_14()
		end,
		function(arg0_15)
			local var0_15 = arg0_4.eventAct and arg0_4.eventAct:getConfig("config_client").open_story

			if var0_15 and var0_15 ~= "" then
				pg.NewStoryMgr.GetInstance():Play(var0_15, arg0_15)
			else
				arg0_15()
			end
		end,
		function(arg0_16)
			pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0044", nil, arg0_16)
		end,
		function(arg0_17)
			if arg0_4.contextData.openTerminal then
				arg0_4:OpenTerminal({
					page = arg0_4.contextData.terminalPage,
					onExit = arg0_17
				})

				arg0_4.contextData.openTerminal = nil
				arg0_4.contextData.terminalPage = nil
			else
				arg0_17()
			end
		end
	}, function()
		if arg0_4.eventAct and arg0_4.contextData.eventTriggerId then
			arg0_4:managedTween(LeanTween.delayedCall, function()
				arg0_4:emit(OtherworldMapMediator.ON_EVENT_TRIGGER, {
					actId = arg0_4.eventAct.id,
					eventId = arg0_4.contextData.eventTriggerId
				})

				arg0_4.contextData.eventTriggerId = nil
			end, 0.02, nil)
		end
	end)
end

function var0_0.SetNativeSizes(arg0_20)
	eachChild(arg0_20.bgTF, function(arg0_21)
		eachChild(arg0_21, function(arg0_22)
			local var0_22 = arg0_22:GetComponent(typeof(Image))

			if var0_22 then
				var0_22:SetNativeSize()
			end
		end)
	end)
	eachChild(arg0_20.locationsTF, function(arg0_23)
		if arg0_23.childCount > 0 then
			eachChild(arg0_23, function(arg0_24)
				local var0_24 = arg0_24:GetComponent(typeof(Image))

				if var0_24 then
					var0_24:SetNativeSize()
				end
			end)
		else
			local var0_23 = arg0_23:GetComponent(typeof(Image))

			if var0_23 then
				var0_23:SetNativeSize()
			end
		end
	end)
	eachChild(arg0_20.strongholdsTF, function(arg0_25)
		local var0_25 = arg0_25:Find("name/Image")
		local var1_25 = var0_25 and var0_25:GetComponent(typeof(Image))

		if var1_25 then
			var1_25:SetNativeSize()
		end
	end)
end

function var0_0.BindStronghold(arg0_26, arg1_26, arg2_26)
	onButton(arg0_26, arg0_26.strongholdsTF:Find(arg1_26 .. "/icon"), arg2_26, SFX_PANEL)
	onButton(arg0_26, arg0_26.strongholdsTF:Find(arg1_26 .. "/name"), arg2_26, SFX_PANEL)
end

function var0_0.InitStrongholds(arg0_27, arg1_27, arg2_27)
	arg0_27:BindStronghold("wangdu", function()
		pg.SceneAnimMgr.GetInstance():OtherWorldCoverGoScene(SCENE.OTHERWORLD_BACKHILL)
	end)

	for iter0_27, iter1_27 in pairs(var0_0.NAME2INDEX) do
		arg0_27:BindStronghold(iter0_27, function()
			local var0_29, var1_29 = arg0_27.contextData.bossActivity:CheckEntranceByIdx(iter1_27)

			if var0_29 then
				arg0_27:ShowNormalFleet(iter1_27)
			else
				pg.TipsMgr.GetInstance():ShowTips(var1_29)
			end
		end)
	end
end

function var0_0.InitStoryNodes(arg0_30)
	arg0_30.eventIds = {}
	arg0_30.nodeItemList = UIItemList.New(arg0_30.storiesTF, arg0_30.storyTpl)

	arg0_30.nodeItemList:make(function(arg0_31, arg1_31, arg2_31)
		if arg0_31 == UIItemList.EventUpdate then
			local var0_31 = arg1_31 + 1
			local var1_31 = arg0_30.eventIds[var0_31]
			local var2_31 = arg0_30.eventAct:GetEventById(var1_31)

			arg2_31.name = var2_31.id

			arg2_31:GetComponent(typeof(Animation)):Stop()

			if not arg0_30.playInAnimId or arg0_30.playInAnimId ~= var2_31.id then
				setLocalScale(arg2_31, Vector3.one)

				GetOrAddComponent(arg2_31, typeof(CanvasGroup)).alpha = 1
			end

			local var3_31, var4_31 = unpack(var2_31:GetPos())

			setAnchoredPosition(arg2_31, {
				x = var3_31,
				y = var4_31
			})
			setImageSprite(arg2_31:Find("type"), GetSpriteFromAtlas("ui/otherworldmapui_atlas", var2_31:GetIconName()))
			setText(arg2_31:Find("title"), var2_31:GetName())
			onButton(arg0_30, arg2_31, function()
				if arg0_30.eventAct:CheckTrigger(var1_31) then
					arg0_30:TriggerEvent(var1_31)
				end
			end, SFX_CONFIRM)
		end
	end)

	arg0_30.floatItemList = UIItemList.New(arg0_30.focusTF, arg0_30.focusTF:Find("tpl"))

	arg0_30.floatItemList:make(function(arg0_33, arg1_33, arg2_33)
		arg1_33 = arg1_33 + 1

		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = arg0_30.eventIds[arg1_33]
			local var1_33 = arg0_30.eventAct:GetEventById(var0_33)

			arg2_33.name = var0_33

			setImageSprite(arg2_33:Find("type"), GetSpriteFromAtlas("ui/otherworldmapui_atlas", var1_33:GetIconName()))
			onButton(arg0_30, arg2_33, function()
				arg0_30:FocusNode(arg0_30.eventIds[arg1_33])
			end, SFX_PANEL)
		end
	end)
end

function var0_0.onDragFunction(arg0_35)
	if not var0_0.screenPoints then
		var0_0.screenPoints = {
			Vector2(-arg0_35.delta.x, arg0_35.delta.y),
			Vector2(arg0_35.delta.x, arg0_35.delta.y),
			Vector2(arg0_35.delta.x, -arg0_35.delta.y),
			Vector2(-arg0_35.delta.x, -arg0_35.delta.y)
		}
	end

	for iter0_35, iter1_35 in ipairs(arg0_35.eventIds) do
		local var0_35 = arg0_35.nodeItemList.container:Find(tostring(iter1_35))

		if var0_35 then
			local var1_35 = arg0_35._tf:InverseTransformPoint(var0_35.position)
			local var2_35

			for iter2_35, iter3_35 in ipairs(var0_0.screenPoints) do
				local var3_35 = var0_0.screenPoints[iter2_35 % 4 + 1]
				local var4_35 = Vector2(var1_35.x, var1_35.y)

				if iter3_35.x < 0 then
					var4_35.x = var4_35.x + var0_0.STORY_TPL_HALF_WIDTH
				end

				if iter3_35.x > 0 then
					var4_35.x = var4_35.x - var0_0.STORY_TPL_HALF_WIDTH
				end

				local var5_35, var6_35, var7_35 = LineLine(Vector2.zero, var4_35, iter3_35, var3_35)

				if var5_35 then
					var2_35 = var4_35 * var6_35

					break
				end
			end

			local var8_35 = arg0_35.floatItemList.container:Find(tostring(iter1_35))
			local var9_35 = var8_35:GetComponent(typeof(CanvasGroup))

			var9_35.interactable = tobool(var2_35)
			var9_35.blocksRaycasts = tobool(var2_35)
			var9_35.alpha = tobool(var2_35) and 1 or 0

			if var2_35 then
				local var10_35 = var2_35 * (1 - 50 / var2_35:Magnitude())

				if var10_35.x < 0 and var10_35.y < var0_0.FLOAT_LEFT_MIN_Y then
					var10_35.y = var0_0.FLOAT_LEFT_MIN_Y
				end

				if var10_35.y >= var0_0.FLOAT_ARROW_LIMIT_Y[1] and var10_35.y <= var0_0.FLOAT_ARROW_LIMIT_Y[2] then
					if var10_35.x < 0 then
						setActive(arg0_35.leftArrow, false)
					end

					if var10_35.x > 0 then
						setActive(arg0_35.rightArrow, false)
					end
				end

				setAnchoredPosition(var8_35, var10_35)

				local var11_35 = math.rad2Deg * math.atan2(var2_35.y, var2_35.x)

				setLocalEulerAngles(var8_35:Find("arrow"), {
					z = var11_35
				})
			end
		end
	end

	if arg0_35.contextData.mode == var0_0.MODE_BATTLE then
		local var12_35
		local var13_35 = arg0_35._tf:InverseTransformPoint(arg0_35.strongholdsTF:Find("wangdu").position)

		var13_35.x = var13_35.x + 150

		for iter4_35, iter5_35 in ipairs(var0_0.screenPoints) do
			local var14_35 = var0_0.screenPoints[iter4_35 % 4 + 1]
			local var15_35, var16_35, var17_35 = LineLine(Vector2.zero, var13_35, iter5_35, var14_35)

			if var15_35 then
				var12_35 = var13_35 * var16_35

				break
			end
		end

		setActive(arg0_35.leftArrow:Find("tip"), arg0_35.isShowWangduTip and var12_35)

		local var18_35
		local var19_35 = arg0_35._tf:InverseTransformPoint(arg0_35.strongholdsTF:Find("mowangcheng").position)

		var19_35.x = var19_35.x + 100

		for iter6_35, iter7_35 in ipairs(var0_0.screenPoints) do
			local var20_35 = var0_0.screenPoints[iter6_35 % 4 + 1]
			local var21_35, var22_35, var23_35 = LineLine(Vector2.zero, var19_35, iter7_35, var20_35)

			if var21_35 then
				var18_35 = var19_35 * var22_35

				break
			end
		end

		setActive(arg0_35.rightArrow:Find("tip"), arg0_35.isShowSpTip and var18_35)
	end
end

function var0_0.FocusNode(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg0_36.nodeItemList.container:Find(arg1_36).anchoredPosition * -1

	var0_36.x = math.clamp(var0_36.x, -arg0_36.extendLimit.x, arg0_36.extendLimit.x)
	var0_36.y = math.clamp(var0_36.y, -arg0_36.extendLimit.y, arg0_36.extendLimit.y)

	if arg0_36.twFocusId then
		LeanTween.cancel(arg0_36.twFocusId)

		arg0_36.twFocusId = nil
	end

	local var1_36 = {}

	table.insert(var1_36, function(arg0_37)
		SetCompomentEnabled(arg0_36.mapTF, typeof(ScrollRect), false)

		local var0_37 = (arg0_36.mapTF.anchoredPosition - var0_36).magnitude
		local var1_37 = var0_37 > 0 and var0_37 / (40 * math.sqrt(var0_37)) or 0

		arg0_36.twFocusId = LeanTween.move(arg0_36.mapTF, Vector3(var0_36.x, var0_36.y), var1_37):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_38)
			arg0_36:onDragFunction()
		end)):setOnComplete(System.Action(arg0_37)).uniqueId
	end)
	seriesAsync(var1_36, function()
		SetCompomentEnabled(arg0_36.mapTF, typeof(ScrollRect), true)

		if arg2_36 then
			arg2_36()
		end
	end)
end

function var0_0.FocusPoint(arg0_40, arg1_40, arg2_40)
	arg1_40.x = math.clamp(arg1_40.x, -arg0_40.extendLimit.x, arg0_40.extendLimit.x)
	arg1_40.y = math.clamp(arg1_40.y, -arg0_40.extendLimit.y, arg0_40.extendLimit.y)

	if arg0_40.twFocusId then
		LeanTween.cancel(arg0_40.twFocusId)

		arg0_40.twFocusId = nil
	end

	local var0_40 = {}

	table.insert(var0_40, function(arg0_41)
		SetCompomentEnabled(arg0_40.mapTF, typeof(ScrollRect), false)

		local var0_41 = (arg0_40.mapTF.anchoredPosition - arg1_40).magnitude
		local var1_41 = var0_41 > 0 and var0_41 / (40 * math.sqrt(var0_41)) or 0

		arg0_40.twFocusId = LeanTween.move(arg0_40.mapTF, Vector3(arg1_40.x, arg1_40.y), var1_41):setEase(LeanTweenType.easeInOutSine):setOnUpdate(System.Action_float(function(arg0_42)
			arg0_40:onDragFunction()
		end)):setOnComplete(System.Action(arg0_41)).uniqueId
	end)
	seriesAsync(var0_40, function()
		SetCompomentEnabled(arg0_40.mapTF, typeof(ScrollRect), true)

		if arg2_40 then
			arg2_40()
		end
	end)
end

function var0_0.TriggerEvent(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44.eventAct:GetEventById(arg1_44)

	switch(var0_44:GetStoryType(), {
		[SingleEvent.STORY_TYPE.STORY] = function()
			seriesAsync({
				function(arg0_46)
					local var0_46 = var0_44:GetStory()

					if var0_46 and var0_46 ~= "" then
						pg.NewStoryMgr.GetInstance():Play(var0_46, arg0_46, true)
					end
				end
			}, function()
				arg0_44:emit(OtherworldMapMediator.ON_EVENT_TRIGGER, {
					actId = arg0_44.eventAct.id,
					eventId = arg1_44
				})
			end)
		end,
		[SingleEvent.STORY_TYPE.BATTLE] = function()
			seriesAsync({
				function(arg0_49)
					local var0_49 = tonumber(var0_44:GetStory())

					if var0_49 and var0_49 > 0 then
						arg0_44:emit(OtherworldMapMediator.ON_PERFORM_COMBAT, var0_49)
					end

					arg0_44.contextData.eventTriggerId = arg1_44
				end
			}, function()
				existCall(arg2_44)
			end)
		end
	}, function()
		pg.TipsMgr.GetInstance():ShowTips("trigger unkonw story_type: " .. var0_44:GetStoryType())
	end)
end

function var0_0.UpdateToggleTip(arg0_52)
	if not arg0_52.eventAct then
		setActive(arg0_52.storyBtn:Find("new"), false)
		setActive(arg0_52.battleBtn:Find("new"), false)

		return
	end

	local var0_52 = arg0_52.eventAct:GetAllEventIds()
	local var1_52 = underscore.any(var0_52, function(arg0_53)
		local var0_53 = arg0_52.eventAct:GetEventById(arg0_53)

		return var0_53 and arg0_52.eventAct:CheckTrigger(var0_53.id) and var0_53:GetMode() == SingleEvent.MODE_TYPE.STORY
	end)
	local var2_52 = underscore.any(var0_52, function(arg0_54)
		local var0_54 = arg0_52.eventAct:GetEventById(arg0_54)

		return var0_54 and arg0_52.eventAct:CheckTrigger(var0_54.id) and var0_54:GetMode() == SingleEvent.MODE_TYPE.BATTLE
	end)

	setActive(arg0_52.storyBtn:Find("new"), var1_52)
	setActive(arg0_52.battleBtn:Find("new"), var2_52)
end

function var0_0.UpdateMapArea(arg0_55)
	if not arg0_55.eventAct then
		return
	end

	local var0_55 = arg0_55.contextData.mode == var0_0.MODE_STORY
	local var1_55 = arg0_55.eventAct:GetUnlockMapAreas()

	for iter0_55 = var0_0.MAP_AREA_START, var0_0.MAP_AREA_CNT do
		local var2_55 = table.contains(var1_55, iter0_55)

		setActive(arg0_55.locationsTF:Find(tostring(iter0_55)), not var0_55 or not var2_55)
		setActive(arg0_55.bgTF:Find(tostring(iter0_55)), var2_55 and var0_55)
	end
end

function var0_0.PlayMapAnim(arg0_56, arg1_56, arg2_56)
	local var0_56 = arg0_56.eventAct:GetEventById(arg1_56):GetMapOptions()
	local var1_56 = arg0_56.bgTF:Find(var0_56)
	local var2_56 = arg0_56.locationsTF:Find(var0_56)

	if var1_56 and var2_56 then
		setActive(var1_56, true)

		GetOrAddComponent(var1_56, typeof(CanvasGroup)).alpha = 0

		arg0_56:managedTween(LeanTween.value, nil, go(var1_56), 0, 1, var0_0.MAP_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0_57)
			GetOrAddComponent(var1_56, typeof(CanvasGroup)).alpha = arg0_57
		end)):setOnComplete(System.Action(function()
			arg2_56()
		end))

		GetOrAddComponent(var2_56, typeof(CanvasGroup)).alpha = 1

		arg0_56:managedTween(LeanTween.value, nil, go(var1_56), 1, 0, var0_0.MAP_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0_59)
			GetOrAddComponent(var2_56, typeof(CanvasGroup)).alpha = arg0_59
		end)):setOnComplete(System.Action(function()
			setActive(var2_56, false)
		end))
	else
		arg2_56()
	end
end

function var0_0.UpdateWangduBtn(arg0_61)
	arg0_61.isShowWangduTip = OtherworldBackHillScene.IsShowTip()

	setActive(arg0_61.strongholdsTF:Find("wangdu/name/tip"), arg0_61.isShowWangduTip)
	setActive(arg0_61.leftArrow:Find("tip"), arg0_61.isShowWangduTip and arg0_61.contextData.mode == var0_0.MODE_BATTLE)
end

function var0_0.UpdateEntrances(arg0_62)
	local var0_62 = arg0_62.contextData.bossActivity

	if not arg0_62.lastUnlockEntrances then
		arg0_62.lastUnlockEntrances = {}

		for iter0_62, iter1_62 in pairs(var0_62:GetEnemyDatas()) do
			arg0_62.lastUnlockEntrances[iter1_62.id] = var0_62:IsUnlockByEnemyId(iter1_62.id)
		end
	end

	for iter2_62, iter3_62 in pairs(var0_62:GetEnemyDatas()) do
		local var1_62 = var0_62:IsUnlockByEnemyId(iter3_62.id)
		local var2_62 = arg0_62.lastUnlockEntrances[iter3_62.id] or false
		local var3_62 = iter3_62:GetType()
		local var4_62 = arg0_62.strongholdsTF:Find(var0_0.TYPE2NAME[var3_62])
		local var5_62 = var4_62:Find("lock")

		if var1_62 and not var2_62 then
			local var6_62 = var4_62:GetComponent(typeof(DftAniEvent))

			if var6_62 then
				var6_62:SetEndEvent(function(arg0_63)
					if var5_62 then
						setActive(var5_62, not var1_62)
					end
				end)
			end

			local var7_62 = var4_62:GetComponent(typeof(Animation))

			if var7_62 and var7_62.clip then
				var7_62:Play()
			end
		elseif var5_62 then
			setActive(var5_62, not var1_62)
		end

		if var3_62 == BossSingleEnemyData.TYPE.SP then
			setActive(var4_62:Find("count"), var1_62 and iter3_62:InTime())

			local var8_62, var9_62 = var0_62:GetCounts(iter3_62.id)

			setText(var4_62:Find("count/Text"), i18n("levelScene_chapter_count_tip") .. var8_62 .. "/" .. var9_62)

			local var10_62 = var1_62 and var8_62 > 0 and iter3_62:InTime()

			setActive(var4_62:Find("name/tip"), var10_62)
			setActive(arg0_62.rightArrow:Find("tip"), var10_62 and arg0_62.contextData.mode == var0_0.MODE_BATTLE)
		end

		setActive(var4_62:Find("exp"), false)

		arg0_62.lastUnlockEntrances[iter3_62.id] = var1_62
	end
end

function var0_0.OpenTerminal(arg0_64, arg1_64)
	arg0_64:emit(OtherworldMapMediator.GO_SUBLAYER, Context.New({
		mediator = OtherworldTerminalMediator,
		viewComponent = OtherworldTerminalLayer,
		data = arg1_64
	}))
end

function var0_0.UpdateEvents(arg0_65, arg1_65)
	if not arg0_65.eventAct then
		return
	end

	local var0_65 = arg0_65.contextData.mode == var0_0.MODE_STORY and SingleEvent.MODE_TYPE.STORY or SingleEvent.MODE_TYPE.BATTLE

	arg0_65.eventIds = underscore.select(arg0_65.eventAct:GetAllEventIds(), function(arg0_66)
		local var0_66 = arg0_65.eventAct:GetEventById(arg0_66)

		return var0_66 and arg0_65.eventAct:CheckTrigger(var0_66.id) and var0_66:GetMode() == var0_65
	end)

	local var1_65 = {}

	if arg1_65 then
		local var2_65 = arg0_65.nodeItemList.container:Find(tostring(arg1_65)).anchoredPosition * -1
		local var3_65 = arg0_65.contextData.mode == var0_0.MODE_STORY and #arg0_65.eventIds > 0

		if #arg0_65.eventAct:GetEventById(arg1_65):GetOptions() > 0 then
			table.insert(var1_65, function(arg0_67)
				arg0_65:OpenTerminal({
					upgrade = true,
					onExit = arg0_67
				})
			end)
		end

		if var3_65 then
			local var4_65, var5_65 = unpack(arg0_65.eventAct:GetEventById(arg0_65.eventIds[1]):GetPos())
			local var6_65 = Vector2(var4_65, var5_65) * -1

			table.insert(var1_65, function(arg0_68)
				arg0_65:FocusPoint({
					x = (var2_65.x + var6_65.x) / 2,
					y = (var2_65.y + var6_65.y) / 2
				}, arg0_68)
			end)
		end

		table.insert(var1_65, function(arg0_69)
			local var0_69 = arg0_65.nodeItemList.container:Find(tostring(arg1_65))
			local var1_69 = var0_69:GetComponent(typeof(Animation))
			local var2_69 = var0_69:GetComponent(typeof(DftAniEvent))

			var2_69:SetEndEvent(function()
				arg0_69()
				var2_69:SetEndEvent(nil)
			end)
			var1_69:Play("story_node_out")
		end)
		table.insert(var1_65, function(arg0_71)
			if var3_65 then
				arg0_65.playInAnimId = arg0_65.eventIds[1]
			end

			arg0_65.nodeItemList:align(#arg0_65.eventIds)
			arg0_65.floatItemList:align(#arg0_65.eventIds)
			arg0_65:UpdateToggleTip()
			arg0_65:managedTween(LeanTween.delayedCall, function()
				arg0_71()
			end, 0.02, nil)
		end)

		if arg0_65.eventAct:IsShowMapAnim(arg1_65) then
			table.insert(var1_65, function(arg0_73)
				arg0_65:PlayMapAnim(arg1_65, arg0_73)
			end)
		end

		if var3_65 then
			table.insert(var1_65, function(arg0_74)
				local var0_74 = arg0_65.nodeItemList.container:Find(tostring(arg0_65.eventIds[1]))
				local var1_74 = var0_74:GetComponent(typeof(Animation))
				local var2_74 = var0_74:GetComponent(typeof(DftAniEvent))

				var2_74:SetEndEvent(function()
					arg0_74()
					var2_74:SetEndEvent(nil)

					arg0_65.playInAnimId = nil
				end)

				GetOrAddComponent(var0_74, typeof(CanvasGroup)).alpha = 0

				var1_74:Play("story_node_in")
			end)
		end
	else
		table.insert(var1_65, function(arg0_76)
			arg0_65.nodeItemList:align(#arg0_65.eventIds)

			if not arg0_65.first then
				eachChild(arg0_65.nodeItemList.container, function(arg0_77)
					if isActive(arg0_77) then
						onNextTick(function()
							arg0_77:GetComponent(typeof(Animation)):Play("story_node_in")
						end)
					end
				end)

				arg0_65.first = true
			end

			arg0_65.floatItemList:align(#arg0_65.eventIds)
			arg0_65:UpdateToggleTip()
			arg0_76()
		end)
	end

	setActive(arg0_65.clickMask, true)
	seriesAsync(var1_65, function()
		arg0_65:onDragFunction()
		setActive(arg0_65.clickMask, false)
	end)
end

function var0_0.UpdateRes(arg0_80)
	setText(arg0_80.ptValueTF, getProxy(PlayerProxy):getData():getResource(arg0_80.contextData.resId))
end

function var0_0.UpdateTerminalTip(arg0_81)
	setActive(arg0_81.leftUI:Find("terminal_btn/tip"), TerminalAdventurePage.IsTip())
end

function var0_0.ShowBattleMode(arg0_82)
	arg0_82.contextData.mode = var0_0.MODE_BATTLE

	setActive(arg0_82.battleBtn, false)
	setActive(arg0_82.storyBtn, true)
	setActive(arg0_82.strongholdsTF, true)

	for iter0_82, iter1_82 in ipairs(arg0_82.battleHideLocations) do
		setActive(iter1_82, false)
	end

	arg0_82:UpdateEvents()
	arg0_82:UpdateMapArea()

	local var0_82 = arg0_82.contextData.bossActivity
	local var1_82 = var0_82:GetEnemyDataByType(BossSingleEnemyData.TYPE.SP)

	if not var0_82:IsUnlockByEnemyId(var1_82.id) or not var1_82:InTime() then
		arg0_82.isShowSpTip = false
	else
		local var2_82, var3_82 = var0_82:GetCounts(var1_82.id)

		arg0_82.isShowSpTip = var2_82 > 0
	end

	setActive(arg0_82.rightArrow:Find("tip"), arg0_82.isShowSpTip)
	setActive(arg0_82.leftArrow:Find("tip"), arg0_82.isShowWangduTip)
	PlayerPrefs.SetInt(var2_0 .. arg0_82.playerId, arg0_82.contextData.mode)
	PlayerPrefs.Save()
end

function var0_0.ShowStoryMode(arg0_83)
	arg0_83.contextData.mode = var0_0.MODE_STORY

	setActive(arg0_83.battleBtn, true)
	setActive(arg0_83.storyBtn, false)
	setActive(arg0_83.strongholdsTF, false)

	for iter0_83, iter1_83 in ipairs(arg0_83.battleHideLocations) do
		setActive(iter1_83, true)
	end

	arg0_83:UpdateEvents()
	arg0_83:UpdateMapArea()
	setActive(arg0_83.rightArrow:Find("tip"), false)
	setActive(arg0_83.leftArrow:Find("tip"), false)
	PlayerPrefs.SetInt(var2_0 .. arg0_83.playerId, arg0_83.contextData.mode)
	PlayerPrefs.Save()
end

function var0_0.PlaySwithAnim(arg0_84, arg1_84)
	seriesAsync({
		function(arg0_85)
			if not arg0_84.swithAnimTF then
				PoolMgr.GetInstance():GetUI("OtherworldCoverUI", true, function(arg0_86)
					arg0_84.swithAnimTF = arg0_86.transform

					setParent(arg0_84.swithAnimTF, arg0_84._tf, false)
					setActive(arg0_84.swithAnimTF, false)
					arg0_85()
				end)
			else
				arg0_85()
			end
		end,
		function(arg0_87)
			setActive(arg0_84.swithAnimTF, true)

			local var0_87 = arg0_84.swithAnimTF:Find("yuncaizhuanchang"):GetComponent(typeof(SpineAnimUI))

			var0_87:SetActionCallBack(function(arg0_88)
				if arg0_88 == "finish" then
					setActive(arg0_84.swithAnimTF, false)
				elseif arg0_88 == "action" and arg1_84 then
					arg1_84()
				end
			end)
			var0_87:SetAction("action", 0)
		end
	}, function()
		return
	end)
end

function var0_0.UpdateView(arg0_90)
	arg0_90:UpdateWangduBtn()
	arg0_90:UpdateRes()
	arg0_90:UpdateEntrances()
	arg0_90:UpdateEvents()
	arg0_90:UpdateMapArea()
	arg0_90:UpdateTerminalTip()
	arg0_90:UpdateToggleTip()
end

function var0_0.willExit(arg0_91)
	var0_0.super.willExit(arg0_91)
	arg0_91:cleanManagedTween()
	PlayerPrefs.SetFloat(var1_0 .. arg0_91.playerId, arg0_91.scrollValueX or 0)
	PlayerPrefs.Save()
end

function var0_0.IsShowTip()
	local function var0_92()
		local var0_93 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_BATTLE_ID)

		if not var0_93 or var0_93:isEnd() then
			return false
		end

		local var1_93 = var0_93:GetEnemyDataByType(BossSingleEnemyData.TYPE.SP)

		if not var0_93:IsUnlockByEnemyId(var1_93.id) or not var1_93:InTime() then
			return false
		end

		local var2_93, var3_93 = var0_93:GetCounts(var1_93.id)

		return var2_93 > 0
	end

	return TerminalAdventurePage.IsTip() or var0_92()
end

var0_0.personalRandomData = nil

return var0_0
