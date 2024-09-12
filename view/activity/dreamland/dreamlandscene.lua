local var0_0 = class("DreamlandScene", import("view.base.BaseUI"))

var0_0.EVENT_SWITCH_TIME = "DreamlandScene:EVENT_SWITCH_TIME"
var0_0.ON_DATA_UPDATE = "DreamlandScene:ON_DATA_UPDATE"
var0_0.ON_SPRING_DATA_UPDATE = "DreamlandScene:ON_SPRING_DATA_UPDATE"
var0_0.ON_SPRING_OP = "DreamlandScene:ON_SPRING_OP"

local var1_0 = {
	DAY = 1,
	NIGHT = 3,
	DUSK = 2
}

function var0_0.getThemeName(arg0_1, arg1_1)
	if arg1_1 == var1_0.DAY then
		return "DreamlandDay", "story-fantasyland-summer"
	elseif arg1_1 == var1_0.DUSK then
		return "DreamlandDusk", "story-island-soft"
	elseif arg1_1 == var1_0.NIGHT then
		return "DreamlandNight", "story-fantasyland-light"
	end

	return ""
end

function var0_0.getUIName(arg0_2)
	return "DreamlandUI"
end

function var0_0.PlayBGM(arg0_3)
	return
end

function var0_0._PlayBGM(arg0_4)
	if arg0_4._bgm then
		arg0_4:StopBgm()

		arg0_4._bgm = nil
	end

	local var0_4, var1_4 = arg0_4:getThemeName(arg0_4.period)

	pg.BgmMgr.GetInstance():Push(arg0_4.__cname, var1_4)

	arg0_4._bgm = var1_4
end

function var0_0.init(arg0_5)
	arg0_5.cg = GetOrAddComponent(arg0_5._tf, typeof(CanvasGroup))
	arg0_5.themeContainer = arg0_5:findTF("scrollrect/content")
	arg0_5.storyTpl = arg0_5:findTF("scrollrect/content/story")
	arg0_5.storyTplSub = arg0_5:findTF("scrollrect/content/story/tpl")
	arg0_5.storyTxt = arg0_5.storyTpl:Find("tpl/Text"):GetComponent(typeof(Text))
	arg0_5.scrollContent = arg0_5:findTF("scrollrect/content")
	arg0_5.scrollrectTr = arg0_5:findTF("scrollrect")
	arg0_5.scrollrect = arg0_5.scrollrectTr:GetComponent(typeof(ScrollRect))
	arg0_5.timeBtn = arg0_5._tf:Find("adapt/time")
	arg0_5.maskTr = arg0_5._tf:Find("mask")
	arg0_5.chatPage = DreamlandChatPage.New(arg0_5._tf, arg0_5.event)
	arg0_5.switcherPage = DreamlandSwitcherPage.New(arg0_5._tf, arg0_5.event)
	arg0_5.handBookPage = DreamlandHandbookPage.New(arg0_5._tf, arg0_5.event)
	arg0_5.hotSpringPage = DreamlandHotSpringPage.New(arg0_5._tf, arg0_5.event)
	arg0_5.spinePlayer = DreamlandSpinePlayer.New()
	arg0_5.pages = {
		arg0_5.chatPage,
		arg0_5.switcherPage,
		arg0_5.handBookPage,
		arg0_5.hotSpringPage
	}
	arg0_5.shipTpl = arg0_5:findTF("root/ship")
	arg0_5.handbookTip = arg0_5._tf:Find("adapt/handbook/tip")
	arg0_5.hotSpringTip = arg0_5._tf:Find("adapt/hotspring/tip")
end

function var0_0.InitData(arg0_6)
	arg0_6.period = arg0_6:GetDefaultTheme()

	local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_DREAMLAND)
	local var1_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)

	assert(var0_6 and var1_6)

	arg0_6.gameData = DreamlandData.New(var0_6, var1_6)
	arg0_6.shipAgentList = {}
end

function var0_0.UpdateActivity(arg0_7, arg1_7, arg2_7)
	if not arg0_7.gameData then
		return
	end

	arg0_7.gameData:UpdateActivityData(arg1_7)
	arg0_7:emit(var0_0.ON_DATA_UPDATE, {
		data = arg0_7.gameData,
		cmd = arg2_7
	})

	if arg2_7 == DreamlandData.OP_RECORD_EXPLORE then
		arg0_7:InitExploreObjs()
	end

	arg0_7:UpdateTip()
end

function var0_0.UpdateSpringActivity(arg0_8, arg1_8)
	if not arg0_8.gameData then
		return
	end

	arg0_8.gameData:UpdateSpringActivityData(arg1_8)
	arg0_8:InitHotSpringCharacters()
	arg0_8:UpdateTimeBtn()
	arg0_8:UpdateTip()
	arg0_8:emit(var0_0.ON_SPRING_DATA_UPDATE, {
		data = arg0_8.gameData
	})
end

function var0_0.didEnter(arg0_9)
	arg0_9:InitData()
	arg0_9:SetUp(true)
	arg0_9:EnableUpdate()
	arg0_9:UpdateTip()
	arg0_9:UpdateTimeBtn()
end

function var0_0.UpdateTip(arg0_10)
	setActive(arg0_10.handbookTip, arg0_10.gameData:ExistAnyMapOrExploreAward())
	setActive(arg0_10.hotSpringTip, false)
end

function var0_0.EnableUpdate(arg0_11)
	if not arg0_11.handle then
		arg0_11.handle = UpdateBeat:CreateListener(arg0_11.Update, arg0_11)
	end

	UpdateBeat:AddListener(arg0_11.handle)
end

function var0_0.DisableUpdate(arg0_12)
	if arg0_12.handle then
		UpdateBeat:RemoveListener(arg0_12.handle)
	end
end

function var0_0.SetUp(arg0_13, arg1_13)
	arg0_13.cg.blocksRaycasts = false

	seriesAsync({
		function(arg0_14)
			arg0_13:SwitchTheme(arg0_13.period, arg1_13, arg0_14)
		end,
		function(arg0_15)
			if not arg1_13 then
				arg0_15()

				return
			end

			arg0_13:GenPlayableStoryPoint(arg0_15)
		end,
		function(arg0_16)
			arg0_13:InitThemeMask()
			arg0_13:InitExploreObjs()
			onNextTick(arg0_16)
		end,
		function(arg0_17)
			arg0_13:FocusStory(arg0_17)
		end,
		function(arg0_18)
			arg0_13:InitHotSpringCharacters(arg0_18)
		end
	}, function()
		arg0_13.isSetUp = true

		if arg1_13 then
			arg0_13:RegisterEvent()
		end

		arg0_13.cg.blocksRaycasts = true
	end)
end

function var0_0.RegisterEvent(arg0_20)
	arg0_20:BindEvent()
	onButton(arg0_20, arg0_20._tf:Find("adapt/back"), function()
		arg0_20:emit(BaseUI.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20._tf:Find("adapt/home"), function()
		arg0_20:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20._tf:Find("adapt/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.dream_land_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20._tf:Find("adapt/handbook"), function()
		arg0_20.handBookPage:ExecuteAction("Show", arg0_20.gameData)
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20._tf:Find("adapt/hotspring"), function()
		arg0_20.hotSpringPage:ExecuteAction("Show", arg0_20.gameData)
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20.timeBtn, function()
		arg0_20.switcherPage:ExecuteAction("Show", arg0_20.period)
	end, SFX_PANEL)

	if arg0_20.gameData:IsFirstEvent() or arg0_20.gameData:IsLastEvent() then
		triggerButton(arg0_20.storyTpl)
	end
end

function var0_0.UpdateTimeBtn(arg0_27)
	local var0_27 = arg0_27.gameData:IsFinishAllEvent()

	setActive(arg0_27.timeBtn, var0_27)
end

function var0_0.BindEvent(arg0_28)
	arg0_28:bind(var0_0.EVENT_SWITCH_TIME, function(arg0_29, arg1_29)
		if arg0_28.period == arg1_29 then
			return
		end

		arg0_28.period = arg1_29

		arg0_28:SetUp(false)
	end)
	arg0_28:bind(var0_0.ON_SPRING_OP, function(arg0_30)
		if arg0_28.spinePlayer then
			arg0_28.spinePlayer:ClearEffects()
		end
	end)
end

function var0_0.InitThemeMask(arg0_31)
	if not arg0_31.themeMask then
		return
	end

	local var0_31 = arg0_31.gameData:FindUnlockMaps()
	local var1_31 = DreamlandUtil.List2Map(var0_31, "id")

	arg0_31.themeMask.transform:SetAsLastSibling()
	eachChild(arg0_31.themeMask, function(arg0_32)
		setActive(arg0_32, var1_31[tonumber(arg0_32.name)] == nil)
	end)
end

function var0_0.InitExploreObjs(arg0_33)
	local var0_33 = arg0_33.gameData:FindCanInteractionExploreObj()
	local var1_33 = DreamlandUtil.List2Map(var0_33, "pic")

	eachChild(arg0_33.theme, function(arg0_34)
		if arg0_34.name ~= "bgs" then
			local var0_34 = string.split(arg0_34.name, "#")
			local var1_34 = var1_33[var0_34[1]]
			local var2_34 = var1_34 ~= nil

			arg0_33:EnableOrDisableInteraction(arg0_34, var1_34, var2_34)
		end
	end)
end

function var0_0.EnableOrDisableInteraction(arg0_35, arg1_35, arg2_35, arg3_35)
	removeOnButton(arg1_35)

	local var0_35 = arg0_35.spineAnimUIList[arg1_35.name]
	local var1_35 = arg1_35:Find("effect")

	if not arg3_35 or not var0_35 then
		if var1_35 then
			setActive(var1_35, false)
		end

		return
	end

	onButton(arg0_35, arg1_35, function()
		arg0_35.spinePlayer:Play(arg0_35.theme, arg1_35, arg0_35.spineAnimUIList, arg2_35)

		if arg0_35.gameData:ShouldShowChatTip(arg2_35.id) then
			arg0_35.chatPage:ExecuteAction("Show", arg2_35)

			local var0_36 = arg0_35.gameData:FindMapIdByExploreId(arg2_35.id)

			assert(var0_36)
			arg0_35:emit(DreamlandMediator.RECORD_EXPLORE, arg0_35.gameData:GetActivityId(), var0_36, arg2_35.id)
		end
	end, SFX_PANEL)

	if var1_35 then
		setActive(var1_35, arg0_35.gameData:ShouldShowChatTip(arg2_35.id))
	end
end

function var0_0.GenPlayableStoryPoint(arg0_37, arg1_37)
	arg0_37:ClearStoryPoint()

	local var0_37 = arg0_37.gameData:FindPlayableStory()

	if not var0_37 then
		arg1_37()

		return
	end

	setActive(arg0_37.storyTplSub, false)
	setActive(arg0_37.storyTpl, true)

	arg0_37.storyTpl.localPosition = Vector3(var0_37.pos.x, var0_37.pos.y, 0)
	arg0_37.storyTxt.text = var0_37.name

	onButton(arg0_37, arg0_37.storyTpl, function()
		arg0_37:PlayStory(var0_37)
	end, SFX_PANEL)

	if arg1_37 then
		arg1_37()
	end
end

function var0_0.FocusStory(arg0_39, arg1_39)
	if not isActive(arg0_39.storyTpl) then
		arg1_39()

		return
	end

	arg0_39.storyTpl:SetAsLastSibling()

	arg0_39.scrollrect.enabled = false

	local var0_39 = DreamlandUtil.CalcFocusPosition(arg0_39.scrollContent, arg0_39.scrollrectTr, arg0_39.storyTpl.localPosition)

	LeanTween.moveLocal(arg0_39.scrollContent.gameObject, var0_39, 0.5):setEase(LeanTweenType.easeOutExpo):setOnComplete(System.Action(function()
		setActive(arg0_39.storyTplSub, true)

		arg0_39.scrollrect.enabled = true

		arg1_39()
	end))
end

function var0_0.PlayStory(arg0_41, arg1_41)
	local var0_41 = {}

	table.insert(var0_41, function(arg0_42)
		pg.NewStoryMgr.GetInstance():Play(arg1_41.story, arg0_42)
	end)

	if arg1_41.bg ~= arg0_41.period then
		table.insert(var0_41, function(arg0_43)
			arg0_41:GenPlayableStoryPoint(arg0_43)
		end)
		table.insert(var0_41, function(arg0_44)
			arg0_41.period = arg1_41.bg

			arg0_41:SetUp(false)
			arg0_44()
		end)
	else
		table.insert(var0_41, function(arg0_45)
			arg0_41.cg.blocksRaycasts = false

			arg0_45()
		end)
		table.insert(var0_41, function(arg0_46)
			arg0_41:PlayUnlockAnimation(arg0_46)
		end)
		table.insert(var0_41, function(arg0_47)
			arg0_41:InitThemeMask()
			arg0_41:InitExploreObjs()
			arg0_41:GenPlayableStoryPoint(arg0_47)
		end)
		table.insert(var0_41, function(arg0_48)
			arg0_41:FocusStory(arg0_48)
		end)
		table.insert(var0_41, function(arg0_49)
			arg0_41.cg.blocksRaycasts = true

			arg0_49()
		end)
	end

	seriesAsync(var0_41, function()
		if arg0_41.gameData:IsLastEvent() then
			triggerButton(arg0_41.storyTpl)
		end
	end)
end

function var0_0.PlayUnlockAnimation(arg0_51, arg1_51)
	arg1_51()
end

function var0_0.ClearStoryPoint(arg0_52)
	setActive(arg0_52.storyTpl, false)
end

function var0_0.SetUpSpine(arg0_53, arg1_53)
	local var0_53 = arg1_53:GetComponentsInChildren(typeof(Spine.Unity.SkeletonGraphic))
	local var1_53 = {}

	for iter0_53 = 1, var0_53.Length do
		local var2_53 = var0_53[iter0_53 - 1].gameObject
		local var3_53 = GetOrAddComponent(var2_53, typeof(SpineAnimUI))
		local var4_53 = string.split(var2_53.gameObject.transform.parent.name, "#")
		local var5_53 = arg0_53.gameData:GetExploreSubType(var4_53[1])
		local var6_53 = DreamlandUtil.GetSpineNormalAction(var5_53)

		var3_53:SetAction(var6_53, 0)

		var1_53[var2_53.transform.parent.name] = var3_53
	end

	return var1_53
end

function var0_0.SwitchTheme(arg0_54, arg1_54, arg2_54, arg3_54)
	local var0_54 = false

	if arg0_54.cg.blocksRaycasts then
		arg0_54.cg.blocksRaycasts = false
		var0_54 = true
	end

	local var1_54 = arg0_54:getThemeName(arg1_54)

	if var1_54 == "" or arg0_54.theme and arg0_54.theme.name == var1_54 then
		arg3_54()

		return
	end

	arg0_54:RecordTheme(arg1_54)
	setActive(arg0_54.maskTr, true)
	seriesAsync({
		function(arg0_55)
			if arg2_54 then
				arg0_55()

				return
			end

			arg0_54:SwitchAnim(0, 1, arg0_55)
		end,
		function(arg0_56)
			arg0_54:LoadThemeMask(arg0_56)
		end,
		function(arg0_57)
			arg0_54:UnloadTheme()
			arg0_54:_PlayBGM(arg0_54.period)
			arg0_54:LoadTheme(var1_54, arg0_57)
		end,
		function(arg0_58)
			if arg2_54 then
				arg0_58()

				return
			end

			arg0_54:SwitchAnim(1, 0, arg0_58)
		end
	}, function()
		setActive(arg0_54.maskTr, fasle)

		if var0_54 then
			arg0_54.cg.blocksRaycasts = true
		end

		arg3_54()
	end)
end

function var0_0.SwitchAnim(arg0_60, arg1_60, arg2_60, arg3_60)
	LeanTween.value(arg0_60.maskTr.gameObject, arg1_60, arg2_60, 0.5):setOnUpdate(System.Action_float(function(arg0_61)
		GetOrAddComponent(arg0_60.maskTr, typeof(CanvasGroup)).alpha = arg0_61
	end)):setOnComplete(System.Action(arg3_60))
end

function var0_0.RecordTheme(arg0_62, arg1_62)
	local var0_62 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("dreamland_theme_id" .. var0_62, arg1_62)
	PlayerPrefs.Save()
end

function var0_0.GetDefaultTheme(arg0_63)
	local var0_63 = getProxy(PlayerProxy):getRawData().id

	return (PlayerPrefs.GetInt("dreamland_theme_id" .. var0_63, 1))
end

function var0_0.LoadThemeMask(arg0_64, arg1_64)
	if arg0_64.themeMask then
		arg1_64()

		return
	end

	if arg0_64.gameData:IsUnlockAll() then
		arg1_64()

		return
	end

	PoolMgr.GetInstance():GetUI("DreamlandMask", true, function(arg0_65)
		arg0_64.themeMask = arg0_65

		setParent(arg0_65, arg0_64.themeContainer)
		arg1_64()
	end)
end

function var0_0.UnLoadThemeMask(arg0_66)
	if arg0_66.themeMask then
		PoolMgr.GetInstance():ReturnUI("DreamlandMask", arg0_66.themeMask)

		arg0_66.themeMask = nil
	end
end

function var0_0.GetNodeInfoFromTheme(arg0_67, arg1_67)
	local var0_67 = {}

	eachChild(tf(arg1_67), function(arg0_68)
		if arg0_68.name ~= "bgs" then
			local var0_68 = arg0_68:GetSiblingIndex()
			local var1_68 = arg0_68.localPosition

			table.insert(var0_67, {
				tf = arg0_68,
				position = var1_68
			})
		end
	end)
	table.sort(var0_67, function(arg0_69, arg1_69)
		return arg0_69.position.y < arg1_69.position.y
	end)

	return var0_67
end

function var0_0.LoadTheme(arg0_70, arg1_70, arg2_70)
	PoolMgr.GetInstance():GetUI(arg1_70, true, function(arg0_71)
		arg0_70.theme = arg0_71
		arg0_70.theme.name = arg1_70

		arg0_70.spinePlayer:Clear()

		arg0_70.spineAnimUIList = arg0_70:SetUpSpine(arg0_71)
		arg0_70.themeNodeInfoList = arg0_70:GetNodeInfoFromTheme(arg0_71)

		setParent(arg0_71, arg0_70.themeContainer)

		for iter0_71, iter1_71 in pairs(arg0_70.shipAgentList) do
			setParent(iter1_71._tf, arg0_71)
		end

		arg2_70()
	end)
end

function var0_0.UnloadTheme(arg0_72)
	arg0_72.isSetUp = false

	for iter0_72, iter1_72 in pairs(arg0_72.shipAgentList) do
		setParent(iter1_72._tf, arg0_72._tf)
		iter1_72._tf:SetAsFirstSibling()
	end

	if arg0_72.theme then
		for iter2_72, iter3_72 in ipairs(arg0_72.spineAnimUIList) do
			iter3_72:SetActionCallBack(nil)
		end

		PoolMgr.GetInstance():ReturnUI(arg0_72.theme.name, arg0_72.theme)

		arg0_72.theme = nil
	end

	arg0_72.spineAnimUIList = {}
	arg0_72.themeNodeInfoList = {}

	arg0_72.spinePlayer:Clear()
end

function var0_0.InitHotSpringCharacters(arg0_73, arg1_73)
	local var0_73 = arg0_73.gameData:GetAllSpringShip()
	local var1_73 = {}
	local var2_73 = {}

	for iter0_73, iter1_73 in pairs(var0_73) do
		for iter2_73, iter3_73 in ipairs(iter1_73) do
			var2_73[iter3_73.id] = true

			table.insert(var1_73, function(arg0_74)
				local var0_74 = arg0_73.gameData:MapId2MapGraph(iter0_73)

				if var0_74 then
					arg0_73:InitHotSpringCharacter(iter3_73, var0_74, arg0_74)
				else
					print("不存在路径", iter0_73)
					arg0_74()
				end
			end)
		end
	end

	arg0_73:RemoveInvalidShips(var2_73)
	seriesAsync(var1_73, arg1_73)
end

function var0_0.RemoveInvalidShips(arg0_75, arg1_75)
	for iter0_75, iter1_75 in pairs(arg0_75.shipAgentList or {}) do
		if not arg1_75[iter0_75] then
			iter1_75:detach()
			Destroy(iter1_75._go)

			arg0_75.shipAgentList[iter0_75] = nil
		end
	end
end

function var0_0.InitHotSpringCharacter(arg0_76, arg1_76, arg2_76, arg3_76)
	if arg0_76.shipAgentList[arg1_76.id] then
		arg3_76()

		return
	end

	local var0_76 = cloneTplTo(arg0_76.shipTpl, arg0_76.theme)
	local var1_76 = NavalAcademyStudent.New(var0_76.gameObject)

	var1_76:attach()
	var1_76:setPathFinder(GraphPath.New(arg2_76))
	var1_76:setCallBack(function(arg0_77)
		return
	end, function()
		return
	end)
	var1_76:updateStudent(arg1_76, {})

	arg0_76.shipAgentList[arg1_76.id] = var1_76

	onNextTick(arg3_76)
end

local function var2_0(arg0_79, arg1_79)
	local var0_79 = arg0_79
	local var1_79 = {}

	for iter0_79, iter1_79 in ipairs(var0_79) do
		if iter1_79.position.y > arg1_79.y then
			local var2_79 = iter1_79.tf:GetSiblingIndex()

			table.insert(var1_79, var2_79 + 1)
		end
	end

	table.sort(var1_79, function(arg0_80, arg1_80)
		return arg1_80 < arg0_80
	end)

	return var1_79[1] or #arg0_79
end

function var0_0.UpdateShipLayer(arg0_81)
	local var0_81 = arg0_81.themeNodeInfoList or {}
	local var1_81 = arg0_81.shipAgentList or {}
	local var2_81 = {}

	for iter0_81, iter1_81 in pairs(var1_81) do
		local var3_81 = iter1_81._tf.localPosition
		local var4_81 = var2_0(var0_81, var3_81)

		table.insert(var2_81, {
			pos = var3_81,
			agent = iter1_81,
			siblingIndex = var4_81
		})
		iter1_81._tf:SetAsLastSibling()
	end

	table.sort(var2_81, function(arg0_82, arg1_82)
		if arg0_82.siblingIndex == arg1_82.siblingIndex then
			return arg0_82.pos.y < arg1_82.pos.y
		else
			return arg0_82.siblingIndex > arg1_82.siblingIndex
		end
	end)

	for iter2_81, iter3_81 in ipairs(var2_81) do
		iter3_81.agent._tf:SetSiblingIndex(iter3_81.siblingIndex)
	end
end

local var3_0 = 0

function var0_0.Update(arg0_83)
	if not arg0_83.isSetUp then
		return
	end

	var3_0 = var3_0 + Time.deltaTime

	if var3_0 > 0.3 then
		var3_0 = 0

		arg0_83:UpdateShipLayer()
	end
end

function var0_0.onBackPressed(arg0_84)
	for iter0_84, iter1_84 in ipairs(arg0_84.pages) do
		if iter1_84:isShowing() then
			iter1_84:Hide()

			return
		end
	end

	var0_0.super.onBackPressed(arg0_84)
end

function var0_0.willExit(arg0_85)
	arg0_85.isSetUp = false

	arg0_85:DisableUpdate()

	if arg0_85.gameData then
		arg0_85.gameData = nil
	end

	arg0_85:UnLoadThemeMask()
	arg0_85:UnloadTheme()
	arg0_85:ClearStoryPoint()

	for iter0_85, iter1_85 in pairs(arg0_85.shipAgentList or {}) do
		iter1_85:detach()
		Destroy(iter1_85._go)
	end

	arg0_85.shipAgentList = nil

	if arg0_85.spinePlayer then
		arg0_85.spinePlayer:Dispose()

		arg0_85.spinePlayer = nil
	end

	for iter2_85, iter3_85 in ipairs(arg0_85.pages) do
		iter3_85:Destroy()
	end

	arg0_85.pages = nil
end

return var0_0
