pg = pg or {}

local var0_0 = singletonClass("NewStoryMgr")

pg.NewStoryMgr = var0_0

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5
local var6_0 = 6
local var7_0 = 7
local var8_0 = Color.New(1, 0.8705, 0.4196, 1)
local var9_0 = Color.New(1, 1, 1, 1)

require("Mgr/Story/Include")

local var10_0 = true

local function var11_0(...)
	if var10_0 and IsUnityEditor then
		originalPrint(...)
	end
end

local var12_0 = {
	"",
	"JP",
	"KR",
	"US",
	""
}

local function var13_0(arg0_2)
	local var0_2 = var12_0[PLATFORM_CODE]

	if arg0_2 == "index" then
		arg0_2 = arg0_2 .. var0_2
	end

	local var1_2

	if PLATFORM_CODE == PLATFORM_JP then
		var1_2 = "GameCfg.story" .. var0_2 .. "." .. arg0_2
	else
		var1_2 = "GameCfg.story" .. "." .. arg0_2
	end

	local var2_2, var3_2 = pcall(function()
		return require(var1_2)
	end)

	if not var2_2 then
		local var4_2 = true

		if UnGamePlayState then
			local var5_2 = "GameCfg.dungeon." .. arg0_2

			if pcall(function()
				return require(var5_2)
			end) then
				var4_2 = false
			end
		end

		if var4_2 then
			errorMsg("不存在剧情ID对应的Lua:" .. arg0_2)
		end
	end

	return var2_2 and var3_2
end

function var0_0.GetScript(arg0_5, arg1_5)
	return var13_0(arg1_5)
end

function var0_0.SetData(arg0_6, arg1_6)
	arg0_6.playedList = {}

	for iter0_6, iter1_6 in ipairs(arg1_6) do
		local var0_6 = iter1_6

		if iter1_6 == 20008 then
			var0_6 = 1131
		end

		if iter1_6 == 20009 then
			var0_6 = 1132
		end

		if iter1_6 == 20010 then
			var0_6 = 1133
		end

		if iter1_6 == 20011 then
			var0_6 = 1134
		end

		if iter1_6 == 20012 then
			var0_6 = 1135
		end

		if iter1_6 == 20013 then
			var0_6 = 1136
		end

		if iter1_6 == 20014 then
			var0_6 = 1137
		end

		arg0_6.playedList[var0_6] = true
	end
end

function var0_0.SetPlayedFlag(arg0_7, arg1_7)
	var11_0("Update story id", arg1_7)

	arg0_7.playedList[arg1_7] = true
end

function var0_0.SetPlayedFlagList(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg1_8) do
		arg0_8.playedList[iter1_8] = true
	end
end

function var0_0.GetPlayedFlag(arg0_9, arg1_9)
	return arg0_9.playedList[arg1_9]
end

function var0_0.GetPlayedList(arg0_10)
	return arg0_10.playedList
end

function var0_0.IsPlayed(arg0_11, arg1_11, arg2_11)
	if type(arg1_11) ~= "table" then
		arg1_11 = {
			arg1_11
		}
	end

	return underscore.any(arg1_11, function(arg0_12)
		local var0_12, var1_12 = arg0_11:StoryName2StoryId(arg0_12)
		local var2_12 = arg0_11:GetPlayedFlag(var0_12)
		local var3_12 = true

		if var1_12 and not arg2_11 then
			var3_12 = arg0_11:GetPlayedFlag(var1_12)
		end

		return var2_12 and var3_12
	end)
end

local function var14_0(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13) do
		var0_13[iter1_13] = iter0_13
	end

	return var0_13
end

function var0_0.StoryName2StoryId(arg0_14, arg1_14)
	if not var0_0.indexs then
		var0_0.indexs = var14_0(var13_0("index"))
	end

	if not var0_0.againIndexs then
		var0_0.againIndexs = var14_0(var13_0("index_again"))
	end

	return var0_0.indexs[arg1_14], var0_0.againIndexs[arg1_14]
end

function var0_0.StoryId2StoryName(arg0_15, arg1_15)
	if not var0_0.indexIds then
		var0_0.indexIds = var13_0("index")
	end

	if not var0_0.againIndexIds then
		var0_0.againIndexIds = var13_0("index_again")
	end

	return var0_0.indexIds[arg1_15], var0_0.againIndexIds[arg1_15]
end

function var0_0.StoryLinkNames(arg0_16, arg1_16)
	if not var0_0.linkNames then
		var0_0.linkNames = var13_0("index_link")
	end

	return var0_0.linkNames[arg1_16]
end

function var0_0._GetStoryPaintingsByName(arg0_17, arg1_17)
	return arg1_17:GetUsingPaintingNames()
end

function var0_0.GetStoryPaintingsByName(arg0_18, arg1_18)
	local var0_18 = var13_0(arg1_18)

	if not var0_18 then
		var11_0("not exist story file")

		return {}
	end

	local var1_18 = Story.New(var0_18, false)

	return arg0_18:_GetStoryPaintingsByName(var1_18)
end

function var0_0.GetStoryPaintingsByNameList(arg0_19, arg1_19)
	local var0_19 = {}
	local var1_19 = {}

	for iter0_19, iter1_19 in ipairs(arg1_19) do
		for iter2_19, iter3_19 in ipairs(arg0_19:GetStoryPaintingsByName(iter1_19)) do
			var1_19[iter3_19] = true
		end
	end

	for iter4_19, iter5_19 in pairs(var1_19) do
		table.insert(var0_19, iter4_19)
	end

	return var0_19
end

function var0_0.GetStoryPaintingsById(arg0_20, arg1_20)
	return arg0_20:GetStoryPaintingsByIdList({
		arg1_20
	})
end

function var0_0.GetStoryPaintingsByIdList(arg0_21, arg1_21)
	local var0_21 = _.map(arg1_21, function(arg0_22)
		return arg0_21:StoryId2StoryName(arg0_22)
	end)

	return arg0_21:GetStoryPaintingsByNameList(var0_21)
end

function var0_0.ShouldDownloadRes(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetStoryPaintingsByName(arg1_23)

	return _.any(var0_23, function(arg0_24)
		return PaintingGroupConst.VerifyPaintingFileName(arg0_24)
	end)
end

function var0_0.Init(arg0_25, arg1_25)
	arg0_25.state = var1_0

	LoadAndInstantiateAsync("ui", "NewStoryUI", function(arg0_26)
		arg0_25.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		arg0_26.transform:SetParent(arg0_25.UIOverlay.transform, false)
		arg0_25:_Init(arg0_26, arg1_25)
	end, true, true)
end

function var0_0._Init(arg0_27, arg1_27, arg2_27)
	arg0_27.playedList = {}
	arg0_27.playQueue = {}
	arg0_27._go = arg1_27
	arg0_27._tf = tf(arg0_27._go)
	arg0_27.frontTr = findTF(arg0_27._tf, "front")
	arg0_27.frontEvtTr = findTF(arg0_27._tf, "block")
	arg0_27.skipBtn = findTF(arg0_27._tf, "front/btns/btns/skip_button")
	arg0_27.autoBtn = findTF(arg0_27._tf, "front/btns/btns/auto_button")
	arg0_27.autoBtnImg = findTF(arg0_27._tf, "front/btns/btns/auto_button/sel"):GetComponent(typeof(Image))
	arg0_27.alphaImage = arg0_27._tf:GetComponent(typeof(Image))
	arg0_27.mainImage = arg0_27._tf:GetComponent(typeof(Image))
	arg0_27.recordBtn = findTF(arg0_27._tf, "front/btns/record")
	arg0_27.hideUIBtn = findTF(arg0_27._tf, "front/btns/btns/hide_ui_button")
	arg0_27.dialogueContainer = findTF(arg0_27._tf, "front/dialogue")
	arg0_27.players = {
		AsideStoryPlayer.New(arg1_27),
		DialogueStoryPlayer.New(arg1_27),
		BgStoryPlayer.New(arg1_27),
		CarouselPlayer.New(arg1_27),
		VedioStoryPlayer.New(arg1_27),
		CastStoryPlayer.New(arg1_27),
		SpAnimStoryPlayer.New(arg1_27),
		BlinkStoryPlayer.New(arg1_27)
	}
	arg0_27.setSpeedPanel = StorySetSpeedPanel.New(arg0_27._tf, function(arg0_28)
		arg0_27:UpdatePlaySpeed(arg0_28)
	end)
	arg0_27.recordPanel = NewStoryRecordPanel.New()
	arg0_27.recorder = StoryRecorder.New()

	setActive(arg0_27._go, false)

	arg0_27.state = var2_0

	if arg2_27 then
		arg2_27()
	end
end

function var0_0.GetPlayer(arg0_29, arg1_29)
	for iter0_29, iter1_29 in ipairs(arg0_29.players) do
		if isa(iter1_29, arg1_29) then
			return iter1_29
		end
	end

	return nil
end

function var0_0.Play(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30, arg5_30, arg6_30, arg7_30)
	table.insert(arg0_30.playQueue, {
		arg1_30,
		arg2_30,
		arg7_30
	})

	if #arg0_30.playQueue == 1 then
		local var0_30

		local function var1_30()
			if #arg0_30.playQueue == 0 then
				return
			end

			local var0_31 = arg0_30.playQueue[1][1]
			local var1_31 = arg0_30.playQueue[1][2]
			local var2_31 = arg0_30.playQueue[1][3]

			arg0_30:SoloPlay(var0_31, function(arg0_32, arg1_32)
				if var1_31 then
					var1_31(arg0_32, arg1_32)
				end

				table.remove(arg0_30.playQueue, 1)
				var1_30()
			end, arg3_30, arg4_30, arg5_30, arg6_30, var2_31)
		end

		var1_30()
	end
end

function var0_0.Pause(arg0_33)
	if arg0_33.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	arg0_33.state = var4_0

	for iter0_33, iter1_33 in ipairs(arg0_33.players) do
		iter1_33:Pause()
	end
end

function var0_0.Resume(arg0_34)
	if arg0_34.state ~= var4_0 then
		var11_0("state is not 'pause'")

		return
	end

	arg0_34.state = var3_0

	for iter0_34, iter1_34 in ipairs(arg0_34.players) do
		iter1_34:Resume()
	end
end

function var0_0.Stop(arg0_35)
	if arg0_35.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	if arg0_35.currPlayer and arg0_35.currPlayer:WaitForEvent() then
		return
	end

	arg0_35.state = var5_0

	for iter0_35, iter1_35 in ipairs(arg0_35.players) do
		iter1_35:Stop()
	end
end

function var0_0.PlayForTb(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	arg0_36:Play(arg1_36, arg3_36, arg4_36, false, false, true, arg2_36)
end

function var0_0.PlayForWorld(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37, arg5_37, arg6_37, arg7_37, arg8_37)
	arg0_37.optionSelCodes = arg2_37 or {}
	arg0_37.autoPlayFlag = arg6_37

	arg0_37:Play(arg1_37, arg3_37, arg4_37, arg5_37, arg7_37, true, arg8_37)
end

function var0_0.ForceAutoPlay(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38, arg5_38)
	arg0_38.autoPlayFlag = true

	local function var0_38(arg0_39, arg1_39)
		arg2_38(arg0_39, arg1_39, arg0_38.isAutoPlay)
	end

	arg0_38:Play(arg1_38, var0_38, arg3_38, arg4_38, true, false, arg5_38)
end

function var0_0.ForceManualPlay(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40, arg5_40)
	arg0_40.banPlayFlag = true

	local function var0_40(arg0_41, arg1_41)
		arg2_40(arg0_41, arg1_41, arg0_40.isAutoPlay)
	end

	arg0_40:Play(arg1_40, var0_40, arg3_40, arg4_40, true, false, arg5_40)
end

function var0_0.SeriesPlay(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42, arg5_42, arg6_42, arg7_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in ipairs(arg1_42) do
		table.insert(var0_42, function(arg0_43)
			arg0_42:SoloPlay(iter1_42, arg0_43, arg3_42, arg4_42, arg5_42, arg6_42, arg7_42)
		end)
	end

	seriesAsync(var0_42, arg2_42)
end

function var0_0.SoloPlay(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44, arg5_44, arg6_44, arg7_44)
	var11_0("Play Story:", arg1_44)

	local var0_44 = 1

	local function var1_44(arg0_45, arg1_45)
		var0_44 = var0_44 - 1

		if arg2_44 and var0_44 == 0 then
			onNextTick(function()
				arg2_44(arg0_45, arg1_45)
			end)
		end
	end

	local var2_44 = var13_0(arg1_44)

	if not var2_44 then
		var1_44(false)
		var11_0("not exist story file")

		return nil
	end

	if arg0_44:IsReView() then
		arg3_44 = true
	end

	arg0_44.storyScript = Story.New(var2_44, arg3_44, arg0_44.optionSelCodes, arg5_44, arg6_44, arg7_44)

	if not arg0_44:CheckState() then
		var11_0("story state error")
		var1_44(false)

		return nil
	end

	if not arg0_44.storyScript:CanPlay() then
		var11_0("story cant be played")
		var1_44(false)

		return nil
	end

	arg0_44:ExecuteScript(var1_44)
end

function var0_0.ExecuteScript(arg0_47, arg1_47)
	seriesAsync({
		function(arg0_48)
			arg0_47:CheckResDownload(arg0_47.storyScript, arg0_48)
		end,
		function(arg0_49)
			originalPrint("start load story window...")
			arg0_47:CheckAndLoadDialogue(arg0_47.storyScript, arg0_49)
		end
	}, function()
		originalPrint("enter story...")
		arg0_47:OnStart()

		local var0_50 = {}

		arg0_47.currPlayer = nil
		arg0_47.progress = 0

		for iter0_50, iter1_50 in ipairs(arg0_47.storyScript.steps) do
			table.insert(var0_50, function(arg0_51)
				arg0_47.progress = iter0_50

				arg0_47:SendNotification(GAME.STORY_NEXT)

				local var0_51 = arg0_47.players[iter1_50:GetMode()]

				arg0_47.currPlayer = var0_51

				var0_51:Play(arg0_47.storyScript, iter0_50, arg0_51)
			end)
		end

		seriesAsync(var0_50, function()
			arg0_47:OnEnd(arg1_47)
		end)
	end)
end

function var0_0.SendNotification(arg0_53, arg1_53, arg2_53)
	pg.m02:sendNotification(arg1_53, arg2_53)
end

function var0_0.CheckResDownload(arg0_54, arg1_54, arg2_54)
	local var0_54 = arg0_54:_GetStoryPaintingsByName(arg1_54)
	local var1_54 = table.concat(var0_54, ",")

	originalPrint("start download res " .. var1_54)

	local var2_54 = {}

	for iter0_54, iter1_54 in ipairs(var0_54) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var2_54, iter1_54)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var2_54,
		finishFunc = arg2_54
	})
end

local function var15_0(arg0_55, arg1_55)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_55, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_56)
		arg1_55(arg0_56)
	end), true, true)
end

function var0_0.CheckAndLoadDialogue(arg0_57, arg1_57, arg2_57)
	local var0_57 = arg1_57:GetDialogueStyleName()

	if not arg0_57.dialogueContainer:Find(var0_57) then
		var15_0("NewStoryDialogue" .. var0_57, function(arg0_58)
			Object.Instantiate(arg0_58, arg0_57.dialogueContainer).name = var0_57

			arg2_57()
		end)
	else
		arg2_57()
	end
end

function var0_0.CheckState(arg0_59)
	if arg0_59.state == var3_0 or arg0_59.state == var1_0 or arg0_59.state == var4_0 then
		return false
	end

	return true
end

function var0_0.RegistSkipBtn(arg0_60)
	local function var0_60()
		arg0_60:TrackingSkip()
		arg0_60.storyScript:SkipAll()
		arg0_60.currPlayer:NextOneImmediately()
	end

	onButton(arg0_60, arg0_60.skipBtn, function()
		if arg0_60:IsStopping() or arg0_60:IsPausing() then
			return
		end

		if not arg0_60.currPlayer:CanSkip() then
			return
		end

		if arg0_60:IsReView() or arg0_60.storyScript:IsPlayed() or not arg0_60.storyScript:ShowSkipTip() then
			var0_60()

			return
		end

		arg0_60:Pause()

		arg0_60.isOpenMsgbox = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			parent = rtf(arg0_60._tf:Find("front")),
			content = i18n("story_skip_confirm"),
			onYes = function()
				arg0_60:Resume()
				var0_60()
			end,
			onNo = function()
				arg0_60.isOpenMsgbox = false

				arg0_60:Resume()
			end
		})
	end, SFX_PANEL)
end

function var0_0.RegistAutoBtn(arg0_65)
	onButton(arg0_65, arg0_65.autoBtn, function()
		if arg0_65:IsStopping() or arg0_65:IsPausing() then
			return
		end

		if arg0_65.storyScript:GetAutoPlayFlag() then
			arg0_65.storyScript:StopAutoPlay()
			arg0_65.currPlayer:CancelAuto()
		else
			arg0_65.storyScript:SetAutoPlay()
			arg0_65.currPlayer:NextOne()
		end

		if arg0_65.storyScript then
			arg0_65:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	local var0_65 = arg0_65:IsAutoPlay()

	if var0_65 then
		arg0_65.storyScript:SetAutoPlay()
		arg0_65:UpdateAutoBtn()

		arg0_65.autoPlayFlag = false
	end

	arg0_65.banPlayFlag = false
	arg0_65.isAutoPlay = var0_65
end

function var0_0.RegistRecordBtn(arg0_67)
	onButton(arg0_67, arg0_67.recordBtn, function()
		if arg0_67.storyScript:GetAutoPlayFlag() then
			return
		end

		if not arg0_67.recordPanel:CanOpen() then
			return
		end

		local var0_68 = "Show"

		arg0_67.recordPanel[var0_68](arg0_67.recordPanel, arg0_67.recorder)
	end, SFX_PANEL)
end

function var0_0.TriggerAutoBtn(arg0_69)
	if not arg0_69:IsRunning() then
		return
	end

	triggerButton(arg0_69.autoBtn)
end

function var0_0.TriggerSkipBtn(arg0_70)
	if not arg0_70:IsRunning() then
		return
	end

	triggerButton(arg0_70.skipBtn)
end

function var0_0.ForEscPress(arg0_71)
	if arg0_71.recordPanel:IsShowing() then
		arg0_71.recordPanel:Hide()
	elseif arg0_71.currPlayer and arg0_71.currPlayer:WaitForEvent() or arg0_71.currPlayer and arg0_71.storyScript and arg0_71.storyScript.hideSkip then
		-- block empty
	else
		arg0_71:TriggerSkipBtn()
	end
end

function var0_0.UpdatePlaySpeed(arg0_72, arg1_72)
	if arg0_72:IsRunning() and arg0_72.storyScript then
		arg0_72.storyScript:SetPlaySpeed(arg1_72)
	end
end

function var0_0.GetPlaySpeed(arg0_73)
	if arg0_73:IsRunning() and arg0_73.storyScript then
		return arg0_73.storyScript:GetPlaySpeed()
	end
end

function var0_0.OnStart(arg0_74)
	arg0_74.recorder:Clear()
	removeOnButton(arg0_74._go)
	removeOnButton(arg0_74.skipBtn)
	removeOnButton(arg0_74.autoBtn)
	removeOnButton(arg0_74.recordBtn)

	arg0_74.mainImage.color = Color(0, 0, 0, arg0_74.storyScript:GetStoryAlpha())

	setActive(arg0_74.recordBtn, not arg0_74.storyScript:ShouldHideRecord())
	arg0_74:ClearStoryEventTriggerListener()

	local var0_74 = arg0_74.storyScript:GetAllStepDispatcherRecallName()

	if #var0_74 > 0 then
		arg0_74.storyEventTriggerListener = StoryEventTriggerListener.New(var0_74)
	end

	arg0_74.mainImage.enabled = not arg0_74.storyScript:CanInteraction()
	arg0_74.state = var3_0

	arg0_74:TrackingStart()
	arg0_74:SendNotification(GAME.STORY_BEGIN, arg0_74.storyScript:GetName())

	if not arg0_74:IsReView() then
		arg0_74:SendNotification(GAME.STORY_UPDATE, {
			storyId = arg0_74.storyScript:GetName()
		})
	end

	pg.DelegateInfo.New(arg0_74)

	for iter0_74, iter1_74 in ipairs(arg0_74.players) do
		iter1_74:StoryStart(arg0_74.storyScript)
	end

	setActive(arg0_74._go, true)
	arg0_74._tf:SetAsLastSibling()
	setActive(arg0_74.skipBtn, not arg0_74.storyScript:ShouldHideSkip())
	setActive(arg0_74.autoBtn, not arg0_74.storyScript:ShouldHideAutoBtn())

	arg0_74.bgmVolumeValue = pg.CriMgr.GetInstance():getBGMVolume()

	arg0_74:RegistSkipBtn()
	arg0_74:RegistAutoBtn()
	arg0_74:RegistRecordBtn()
	arg0_74:RegistHideUIBtn()
end

function var0_0.RegistHideUIBtn(arg0_75)
	onButton(arg0_75, arg0_75.hideUIBtn, function()
		if arg0_75.storyScript:GetAutoPlayFlag() then
			arg0_75.storyScript:StopAutoPlay()
			arg0_75.currPlayer:CancelAuto()
			arg0_75:UpdateAutoBtn()
		end

		setActiveByCanvasGroup(arg0_75.frontTr, false)
		setActive(arg0_75.frontEvtTr, true)
	end, SFX_PANEL)
	onButton(arg0_75, arg0_75.frontEvtTr, function()
		setActiveByCanvasGroup(arg0_75.frontTr, true)
		setActive(arg0_75.frontEvtTr, false)
	end, SFX_PANEL)
end

function var0_0.TrackingStart(arg0_78)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return
	end

	arg0_78.trackFlag = false

	if not arg0_78.storyScript then
		return
	end

	local var0_78 = arg0_78:StoryName2StoryId(arg0_78.storyScript:GetName())

	if var0_78 and not arg0_78:GetPlayedFlag(var0_78) then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryStart(var0_78, 0))

		arg0_78.trackFlag = true
	end
end

function var0_0.TrackingSkip(arg0_79)
	if not arg0_79.trackFlag or not arg0_79.storyScript then
		return
	end

	local var0_79 = arg0_79:StoryName2StoryId(arg0_79.storyScript:GetName())

	if var0_79 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStorySkip(var0_79, arg0_79.progress or 0))
	end
end

function var0_0.TrackingOption(arg0_80, arg1_80, arg2_80)
	if not arg0_80.storyScript or not arg1_80 or not arg2_80 then
		return
	end

	local var0_80 = arg0_80:StoryName2StoryId(arg0_80.storyScript:GetName())

	if var0_80 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryOption(var0_80, arg1_80 .. "_" .. (arg2_80 or 0)))
	end
end

function var0_0.ClearStoryEvent(arg0_81)
	if arg0_81.storyEventTriggerListener then
		arg0_81.storyEventTriggerListener:Clear()
	end
end

function var0_0.CheckStoryEvent(arg0_82, arg1_82)
	if arg0_82.storyEventTriggerListener then
		return arg0_82.storyEventTriggerListener:ExistCache(arg1_82)
	end

	return false
end

function var0_0.GetStoryEventArg(arg0_83, arg1_83)
	if not arg0_83:CheckStoryEvent(arg1_83) then
		return nil
	end

	if arg0_83.storyEventTriggerListener and arg0_83.storyEventTriggerListener:ExistArg(arg1_83) then
		return arg0_83.storyEventTriggerListener:GetArg(arg1_83)
	end

	return nil
end

function var0_0.UpdateAutoBtn(arg0_84)
	local var0_84 = arg0_84.storyScript:GetAutoPlayFlag()

	arg0_84:ClearAutoBtn(var0_84)
end

function var0_0.ClearAutoBtn(arg0_85, arg1_85)
	arg0_85.autoBtnImg.color = arg1_85 and var8_0 or var9_0
	arg0_85.isAutoPlay = arg1_85

	local var0_85 = arg1_85 and "Show" or "Hide"

	arg0_85.setSpeedPanel[var0_85](arg0_85.setSpeedPanel, arg0_85.storyScript)
end

function var0_0.ClearStoryEventTriggerListener(arg0_86)
	if arg0_86.storyEventTriggerListener then
		arg0_86.storyEventTriggerListener:Dispose()

		arg0_86.storyEventTriggerListener = nil
	end
end

function var0_0.Clear(arg0_87)
	arg0_87.progress = 0

	arg0_87:ClearStoryEventTriggerListener()

	arg0_87.mainImage.enabled = true

	arg0_87.recorder:Clear()
	arg0_87.recordPanel:Hide()

	arg0_87.autoPlayFlag = false
	arg0_87.banPlayFlag = false

	removeOnButton(arg0_87._go)
	removeOnButton(arg0_87.skipBtn)
	removeOnButton(arg0_87.recordBtn)
	removeOnButton(arg0_87.autoBtn)
	removeOnButton(arg0_87.hideUIBtn)
	removeOnButton(arg0_87.frontEvtTr)
	arg0_87:ClearAutoBtn(false)

	if isActive(arg0_87._go) then
		pg.DelegateInfo.Dispose(arg0_87)
	end

	if arg0_87.setSpeedPanel then
		arg0_87.setSpeedPanel:Clear()
	end

	setActive(arg0_87.skipBtn, false)
	setActive(arg0_87._go, false)

	for iter0_87, iter1_87 in ipairs(arg0_87.players) do
		iter1_87:StoryEnd(arg0_87.storyScript)
	end

	arg0_87.optionSelCodes = nil

	arg0_87:SendNotification(GAME.STORY_END)

	if arg0_87.isOpenMsgbox then
		pg.MsgboxMgr.GetInstance():hide()
	end

	arg0_87:RevertBgmVolumeValue()
end

function var0_0.RevertBgmVolumeValue(arg0_88)
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_88 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0_88.bgmVolumeValue and arg0_88.bgmVolumeValue ~= var0_88 then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_88.bgmVolumeValue)
	end

	arg0_88.bgmVolumeValue = nil
end

function var0_0.OnEnd(arg0_89, arg1_89)
	arg0_89:Clear()

	if arg0_89.state == var3_0 or arg0_89.state == var5_0 then
		arg0_89.state = var6_0

		local var0_89 = arg0_89.storyScript:GetNextScriptName()

		if var0_89 and not arg0_89:IsReView() then
			arg0_89.storyScript = nil

			arg0_89:SoloPlay(var0_89, arg1_89, true)
		else
			local var1_89 = arg0_89.storyScript:GetBranchCode()

			arg0_89.storyScript = nil

			if arg1_89 then
				arg1_89(true, var1_89)
			end
		end
	else
		arg0_89.state = var6_0

		local var2_89 = arg0_89.storyScript:GetBranchCode()

		if arg1_89 then
			arg1_89(true, var2_89)
		end
	end
end

function var0_0.OnSceneEnter(arg0_90, arg1_90)
	if not arg0_90.scenes then
		arg0_90.scenes = {}
	end

	arg0_90.scenes[arg1_90.view] = true
end

function var0_0.OnSceneExit(arg0_91, arg1_91)
	if not arg0_91.scenes then
		return
	end

	arg0_91.scenes[arg1_91.view] = nil
end

function var0_0.IsReView(arg0_92)
	if getProxy(ContextProxy) == nil then
		return false
	end

	local var0_92 = getProxy(ContextProxy):GetPrevContext(1)

	return arg0_92.scenes[WorldMediaCollectionScene.__cname] == true or var0_92 and var0_92.mediator == WorldMediaCollectionMediator
end

function var0_0.IsRunning(arg0_93)
	return arg0_93.state == var3_0
end

function var0_0.IsStopping(arg0_94)
	return arg0_94.state == var5_0
end

function var0_0.IsPausing(arg0_95)
	return arg0_95.state == var4_0
end

function var0_0.IsAutoPlay(arg0_96)
	if arg0_96.banPlayFlag then
		return false
	end

	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or arg0_96.autoPlayFlag == true
end

function var0_0.GetRectSize(arg0_97)
	return Vector2(arg0_97._tf.rect.width, arg0_97._tf.rect.height)
end

function var0_0.AddRecord(arg0_98, arg1_98)
	arg0_98.recorder:Add(arg1_98)
end

function var0_0.Quit(arg0_99)
	arg0_99.recorder:Dispose()
	arg0_99.recordPanel:Dispose()
	arg0_99.setSpeedPanel:Dispose()

	if arg0_99.currPlayer and arg0_99.currPlayer:WaitForEvent() then
		arg0_99:Clear()
	end

	arg0_99.state = var7_0
	arg0_99.storyScript = nil
	arg0_99.currPlayer = nil
	arg0_99.playQueue = {}
	arg0_99.playedList = {}
	arg0_99.scenes = {}
end

function var0_0.Fix(arg0_100)
	local var0_100 = getProxy(PlayerProxy):getRawData():GetRegisterTime()
	local var1_100 = pg.TimeMgr.GetInstance():parseTimeFromConfig({
		{
			2021,
			4,
			8
		},
		{
			9,
			0,
			0
		}
	})
	local var2_100 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if var0_100 <= var1_100 then
		_.each(var2_100, function(arg0_101)
			arg0_100.playedList[arg0_101] = true
		end)
	end

	local var3_100 = 5001
	local var4_100 = 5020
	local var5_100 = getProxy(TaskProxy)
	local var6_100 = 0

	for iter0_100 = var3_100, var4_100, -1 do
		if var5_100:getFinishTaskById(iter0_100) or var5_100:getTaskById(iter0_100) then
			var6_100 = iter0_100

			break
		end
	end

	for iter1_100 = var6_100, var4_100, -1 do
		local var7_100 = pg.task_data_template[iter1_100]

		if var7_100 then
			local var8_100 = var7_100.story_id

			if var8_100 and #var8_100 > 0 and not arg0_100:IsPlayed(var8_100) then
				arg0_100.playedList[var8_100] = true
			end
		end
	end

	local var9_100 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

	if var9_100 and not var9_100:isEnd() then
		local var10_100 = _.flatten(var9_100:getConfig("config_data"))
		local var11_100

		for iter2_100 = #var10_100, 1, -1 do
			local var12_100 = pg.task_data_template[var10_100[iter2_100]].story_id

			if var12_100 and #var12_100 > 0 then
				local var13_100 = arg0_100:IsPlayed(var12_100)

				if var11_100 then
					if not var13_100 then
						arg0_100.playedList[var12_100] = true
					end
				elseif var13_100 then
					var11_100 = iter2_100
				end
			end
		end
	end
end
