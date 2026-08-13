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
		BlinkStoryPlayer.New(arg1_27),
		DialogueStoryPlayer.New(arg1_27),
		SubPageStoryPlayer.New(arg1_27)
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

function var0_0.PlayForAcivitySpStory(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36, arg5_36, arg6_36, arg7_36)
	local function var0_36()
		_.each(arg0_36.branchSelectCache, function(arg0_38)
			local var0_38 = ActivitySpStoryNode.GetOptionBranchByStoryName(arg1_36, arg0_38)

			if var0_38 then
				local var1_38 = var13_0(var0_38.story).id

				arg0_36:SendNotification(GAME.STORY_UPDATE, {
					storyId = var1_38
				})
			end
		end)

		arg0_36.branchSelectCache = nil

		arg2_36()
	end

	arg0_36:Play(arg1_36, var0_36, arg3_36, arg4_36, arg5_36, arg6_36, arg7_36)
end

function var0_0.PlayForTb(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39)
	arg0_39:Play(arg1_39, arg3_39, arg4_39, false, false, true, arg2_39)
end

function var0_0.PlayForWorld(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40, arg5_40, arg6_40, arg7_40, arg8_40)
	arg0_40.optionSelCodes = arg2_40 or {}
	arg0_40.autoPlayFlag = arg6_40

	arg0_40:Play(arg1_40, arg3_40, arg4_40, arg5_40, arg7_40, true, arg8_40)
end

function var0_0.ForceAutoPlay(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41, arg5_41)
	arg0_41.autoPlayFlag = true

	local function var0_41(arg0_42, arg1_42)
		arg2_41(arg0_42, arg1_42, arg0_41.isAutoPlay)
	end

	arg0_41:Play(arg1_41, var0_41, arg3_41, arg4_41, true, false, arg5_41)
end

function var0_0.ForceManualPlay(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43, arg5_43)
	arg0_43.banPlayFlag = true

	local function var0_43(arg0_44, arg1_44)
		arg2_43(arg0_44, arg1_44, arg0_43.isAutoPlay)
	end

	arg0_43:Play(arg1_43, var0_43, arg3_43, arg4_43, true, false, arg5_43)
end

function var0_0.ReViewPlay(arg0_45, ...)
	arg0_45.isReView = true

	arg0_45:Play(...)
end

function var0_0.SeriesPlay(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46, arg5_46, arg6_46, arg7_46)
	local var0_46 = {}

	for iter0_46, iter1_46 in ipairs(arg1_46) do
		table.insert(var0_46, function(arg0_47)
			arg0_46:SoloPlay(iter1_46, arg0_47, arg3_46, arg4_46, arg5_46, arg6_46, arg7_46)
		end)
	end

	seriesAsync(var0_46, arg2_46)
end

function var0_0.SoloPlay(arg0_48, arg1_48, arg2_48, arg3_48, arg4_48, arg5_48, arg6_48, arg7_48)
	var11_0("Play Story:", arg1_48)

	local var0_48 = 1

	local function var1_48(arg0_49, arg1_49)
		var0_48 = var0_48 - 1

		if arg2_48 and var0_48 == 0 then
			onNextTick(function()
				arg2_48(arg0_49, arg1_49)
			end)
		end
	end

	local var2_48 = var13_0(arg1_48)

	if not var2_48 then
		var1_48(false)
		var11_0("not exist story file")

		return nil
	end

	if arg0_48:IsReView() then
		arg3_48 = true
	end

	arg0_48.storyScript = Story.New(var2_48, arg3_48, arg0_48.optionSelCodes, arg5_48, arg6_48, arg7_48)

	if not arg0_48:CheckState() then
		var11_0("story state error")
		var1_48(false)

		return nil
	end

	if not arg0_48.storyScript:CanPlay() then
		var11_0("story cant be played")
		var1_48(false)

		return nil
	end

	arg0_48:ExecuteScript(var1_48)
end

function var0_0.ExecuteScript(arg0_51, arg1_51)
	seriesAsync({
		function(arg0_52)
			arg0_51:CheckResDownload(arg0_51.storyScript, arg0_52)
		end,
		function(arg0_53)
			originalPrint("start load story window...")
			arg0_51:CheckAndLoadDialogue(arg0_51.storyScript, arg0_53)
		end
	}, function()
		originalPrint("enter story...")
		arg0_51:OnStart()

		local var0_54 = {}

		arg0_51.currPlayer = nil
		arg0_51.progress = 0

		for iter0_54, iter1_54 in ipairs(arg0_51.storyScript.steps) do
			table.insert(var0_54, function(arg0_55)
				arg0_51.progress = iter0_54

				arg0_51:SendNotification(GAME.STORY_NEXT)

				local var0_55 = arg0_51.players[iter1_54:GetMode()]

				arg0_51.currPlayer = var0_55

				var0_55:Play(arg0_51.storyScript, iter0_54, arg0_55)
			end)
		end

		seriesAsync(var0_54, function()
			arg0_51:OnEnd(arg1_51)
		end)
	end)
end

function var0_0.SendNotification(arg0_57, arg1_57, arg2_57)
	pg.m02:sendNotification(arg1_57, arg2_57)
end

function var0_0.CheckResDownload(arg0_58, arg1_58, arg2_58)
	local var0_58 = arg0_58:_GetResList(arg1_58)

	SplitPackConst.DownloadByLuaArr(var0_58, arg2_58)
end

local function var15_0(arg0_59, arg1_59)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_59, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_60)
		arg1_59(arg0_60)
	end), true, true)
end

function var0_0.CheckAndLoadDialogue(arg0_61, arg1_61, arg2_61)
	local var0_61 = arg1_61:GetDialogueStyleName()

	if not arg0_61.dialogueContainer:Find(var0_61) then
		var15_0("NewStoryDialogue" .. var0_61, function(arg0_62)
			Object.Instantiate(arg0_62, arg0_61.dialogueContainer).name = var0_61

			arg2_61()
		end)
	else
		arg2_61()
	end
end

function var0_0.CheckState(arg0_63)
	if arg0_63.state == var3_0 or arg0_63.state == var1_0 or arg0_63.state == var4_0 then
		return false
	end

	return true
end

function var0_0.RegistSkipBtn(arg0_64)
	local function var0_64()
		arg0_64:TrackingSkip()
		arg0_64.storyScript:SkipAll()
		arg0_64.currPlayer:NextOneImmediately()
	end

	onButton(arg0_64, arg0_64.skipBtn, function()
		if arg0_64:IsStopping() or arg0_64:IsPausing() then
			return
		end

		if not arg0_64.currPlayer:CanSkip() then
			return
		end

		if arg0_64:IsReView() or arg0_64.storyScript:IsPlayed() or not arg0_64.storyScript:ShowSkipTip() then
			var0_64()

			return
		end

		arg0_64:Pause()

		arg0_64.isOpenMsgbox = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			parent = rtf(arg0_64._tf:Find("front")),
			content = i18n("story_skip_confirm"),
			onYes = function()
				arg0_64:Resume()
				var0_64()
			end,
			onNo = function()
				arg0_64.isOpenMsgbox = false

				arg0_64:Resume()
			end
		})
	end, SFX_PANEL)
end

function var0_0.RegistAutoBtn(arg0_69)
	onButton(arg0_69, arg0_69.autoBtn, function()
		if arg0_69:IsStopping() or arg0_69:IsPausing() then
			return
		end

		if arg0_69.storyScript:GetAutoPlayFlag() then
			arg0_69.storyScript:StopAutoPlay()
			arg0_69.currPlayer:CancelAuto()
		else
			arg0_69.storyScript:SetAutoPlay()
			arg0_69.currPlayer:NextOne()
		end

		if arg0_69.storyScript then
			arg0_69:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	local var0_69 = arg0_69:IsAutoPlay()

	if var0_69 then
		arg0_69.storyScript:SetAutoPlay()
		arg0_69:UpdateAutoBtn()

		arg0_69.autoPlayFlag = false
	end

	arg0_69.banPlayFlag = false
	arg0_69.isAutoPlay = var0_69
end

function var0_0.RegistRecordBtn(arg0_71)
	onButton(arg0_71, arg0_71.recordBtn, function()
		if arg0_71.storyScript:GetAutoPlayFlag() then
			return
		end

		if not arg0_71.recordPanel:CanOpen() then
			return
		end

		local var0_72 = "Show"

		arg0_71.recordPanel[var0_72](arg0_71.recordPanel, arg0_71.recorder)
	end, SFX_PANEL)
end

function var0_0.TriggerAutoBtn(arg0_73)
	if not arg0_73:IsRunning() then
		return
	end

	triggerButton(arg0_73.autoBtn)
end

function var0_0.TriggerSkipBtn(arg0_74)
	if not arg0_74:IsRunning() then
		return
	end

	triggerButton(arg0_74.skipBtn)
end

function var0_0.ForEscPress(arg0_75)
	if arg0_75.recordPanel:IsShowing() then
		arg0_75.recordPanel:Hide()
	elseif arg0_75.currPlayer and arg0_75.currPlayer:WaitForEvent() or arg0_75.currPlayer and arg0_75.storyScript and arg0_75.storyScript.hideSkip then
		-- block empty
	else
		arg0_75:TriggerSkipBtn()
	end
end

function var0_0.UpdatePlaySpeed(arg0_76, arg1_76)
	if arg0_76:IsRunning() and arg0_76.storyScript then
		arg0_76.storyScript:SetPlaySpeed(arg1_76)
	end
end

function var0_0.GetPlaySpeed(arg0_77)
	if arg0_77:IsRunning() and arg0_77.storyScript then
		return arg0_77.storyScript:GetPlaySpeed()
	end
end

function var0_0.OnStart(arg0_78)
	arg0_78.recorder:Clear()
	removeOnButton(arg0_78._go)
	removeOnButton(arg0_78.skipBtn)
	removeOnButton(arg0_78.autoBtn)
	removeOnButton(arg0_78.recordBtn)

	arg0_78.mainImage.color = Color(0, 0, 0, arg0_78.storyScript:GetStoryAlpha())

	setActive(arg0_78.recordBtn, not arg0_78.storyScript:ShouldHideRecord())
	arg0_78:ClearStoryEventTriggerListener()

	local var0_78 = arg0_78.storyScript:GetAllStepDispatcherRecallName()

	if #var0_78 > 0 then
		arg0_78.storyEventTriggerListener = StoryEventTriggerListener.New(var0_78)
	end

	arg0_78.mainImage.enabled = not arg0_78.storyScript:CanInteraction()
	arg0_78.state = var3_0

	arg0_78:TrackingStart()
	arg0_78:SendNotification(GAME.STORY_BEGIN, arg0_78.storyScript:GetName())

	if not arg0_78:IsReView() then
		arg0_78:SendNotification(GAME.STORY_UPDATE, {
			storyId = arg0_78.storyScript:GetName()
		})
	end

	pg.DelegateInfo.New(arg0_78)

	for iter0_78, iter1_78 in ipairs(arg0_78.players) do
		iter1_78:StoryStart(arg0_78.storyScript)
	end

	setActive(arg0_78._go, true)
	arg0_78._tf:SetAsLastSibling()
	setActive(arg0_78.skipBtn, not arg0_78.storyScript:ShouldHideSkip())
	setActive(arg0_78.autoBtn, not arg0_78.storyScript:ShouldHideAutoBtn())

	arg0_78.bgmVolumeValue = pg.CriMgr.GetInstance():getBGMVolume()

	arg0_78:RegistSkipBtn()
	arg0_78:RegistAutoBtn()
	arg0_78:RegistRecordBtn()
	arg0_78:RegistHideUIBtn()
end

function var0_0.RegistHideUIBtn(arg0_79)
	onButton(arg0_79, arg0_79.hideUIBtn, function()
		if arg0_79.storyScript:GetAutoPlayFlag() then
			arg0_79.storyScript:StopAutoPlay()
			arg0_79.currPlayer:CancelAuto()
			arg0_79:UpdateAutoBtn()
		end

		setActiveByCanvasGroup(arg0_79.frontTr, false)
		setActive(arg0_79.frontEvtTr, true)
	end, SFX_PANEL)
	onButton(arg0_79, arg0_79.frontEvtTr, function()
		setActiveByCanvasGroup(arg0_79.frontTr, true)
		setActive(arg0_79.frontEvtTr, false)
	end, SFX_PANEL)
end

function var0_0.TrackingStart(arg0_82)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return
	end

	arg0_82.trackFlag = false

	if not arg0_82.storyScript then
		return
	end

	local var0_82 = arg0_82:StoryName2StoryId(arg0_82.storyScript:GetName())

	if var0_82 and not arg0_82:GetPlayedFlag(var0_82) then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryStart(var0_82, 0))

		arg0_82.trackFlag = true
	end
end

function var0_0.TrackingSkip(arg0_83)
	if not arg0_83.trackFlag or not arg0_83.storyScript then
		return
	end

	local var0_83 = arg0_83:StoryName2StoryId(arg0_83.storyScript:GetName())

	if var0_83 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStorySkip(var0_83, arg0_83.progress or 0))
	end
end

function var0_0.TrackingOption(arg0_84, arg1_84, arg2_84)
	if not arg0_84.storyScript or not arg1_84 or not arg2_84 then
		return
	end

	local var0_84 = arg0_84:StoryName2StoryId(arg0_84.storyScript:GetName())

	if var0_84 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryOption(var0_84, arg1_84 .. "_" .. (arg2_84 or 0)))
	end
end

function var0_0.ClearStoryEvent(arg0_85)
	if arg0_85.storyEventTriggerListener then
		arg0_85.storyEventTriggerListener:Clear()
	end
end

function var0_0.CheckStoryEvent(arg0_86, arg1_86)
	if arg0_86.storyEventTriggerListener then
		return arg0_86.storyEventTriggerListener:ExistCache(arg1_86)
	end

	return false
end

function var0_0.GetStoryEventArg(arg0_87, arg1_87)
	if not arg0_87:CheckStoryEvent(arg1_87) then
		return nil
	end

	if arg0_87.storyEventTriggerListener and arg0_87.storyEventTriggerListener:ExistArg(arg1_87) then
		return arg0_87.storyEventTriggerListener:GetArg(arg1_87)
	end

	return nil
end

function var0_0.UpdateAutoBtn(arg0_88)
	local var0_88 = arg0_88.storyScript:GetAutoPlayFlag()

	arg0_88:ClearAutoBtn(var0_88)
end

function var0_0.ClearAutoBtn(arg0_89, arg1_89)
	arg0_89.autoBtnImg.color = arg1_89 and var8_0 or var9_0
	arg0_89.isAutoPlay = arg1_89

	local var0_89 = arg1_89 and "Show" or "Hide"

	arg0_89.setSpeedPanel[var0_89](arg0_89.setSpeedPanel, arg0_89.storyScript)
end

function var0_0.ClearStoryEventTriggerListener(arg0_90)
	if arg0_90.storyEventTriggerListener then
		arg0_90.storyEventTriggerListener:Dispose()

		arg0_90.storyEventTriggerListener = nil
	end
end

function var0_0.Clear(arg0_91)
	arg0_91.progress = 0

	arg0_91:ClearStoryEventTriggerListener()

	arg0_91.mainImage.enabled = true

	arg0_91.recorder:Clear()
	arg0_91.recordPanel:Hide()

	arg0_91.autoPlayFlag = false
	arg0_91.banPlayFlag = false
	arg0_91.isReView = false

	removeOnButton(arg0_91._go)
	removeOnButton(arg0_91.skipBtn)
	removeOnButton(arg0_91.recordBtn)
	removeOnButton(arg0_91.autoBtn)
	removeOnButton(arg0_91.hideUIBtn)
	removeOnButton(arg0_91.frontEvtTr)
	arg0_91:ClearAutoBtn(false)

	if isActive(arg0_91._go) then
		pg.DelegateInfo.Dispose(arg0_91)
	end

	if arg0_91.setSpeedPanel then
		arg0_91.setSpeedPanel:Clear()
	end

	setActive(arg0_91.skipBtn, false)
	setActive(arg0_91._go, false)

	arg0_91.branchSelectCache = {}

	_.each(arg0_91.players, function(arg0_92)
		for iter0_92, iter1_92 in pairs(arg0_92.branchCodeList) do
			_.each(iter1_92, function(arg0_93)
				table.insert(arg0_91.branchSelectCache, arg0_93)
			end)
		end
	end)

	for iter0_91, iter1_91 in ipairs(arg0_91.players) do
		iter1_91:StoryEnd(arg0_91.storyScript)
	end

	arg0_91.optionSelCodes = nil

	arg0_91:SendNotification(GAME.STORY_END)

	if arg0_91.isOpenMsgbox then
		pg.MsgboxMgr.GetInstance():hide()
	end

	arg0_91:RevertBgmVolumeValue()
end

function var0_0.RevertBgmVolumeValue(arg0_94)
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_94 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0_94.bgmVolumeValue and arg0_94.bgmVolumeValue ~= var0_94 then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_94.bgmVolumeValue)
	end

	arg0_94.bgmVolumeValue = nil
end

function var0_0.OnEnd(arg0_95, arg1_95)
	arg0_95:Clear()

	if arg0_95.state == var3_0 or arg0_95.state == var5_0 then
		arg0_95.state = var6_0

		local var0_95 = arg0_95.storyScript:GetNextScriptName()

		if var0_95 and not arg0_95:IsReView() then
			arg0_95.storyScript = nil

			arg0_95:SoloPlay(var0_95, arg1_95, true)
		else
			local var1_95 = arg0_95.storyScript:GetBranchCode()

			arg0_95.storyScript = nil

			if arg1_95 then
				arg1_95(true, var1_95)
			end
		end
	else
		arg0_95.state = var6_0

		local var2_95 = arg0_95.storyScript:GetBranchCode()

		if arg1_95 then
			arg1_95(true, var2_95)
		end
	end
end

function var0_0.OnSceneEnter(arg0_96, arg1_96)
	if not arg0_96.scenes then
		arg0_96.scenes = {}
	end

	arg0_96.scenes[arg1_96.view] = true
end

function var0_0.OnSceneExit(arg0_97, arg1_97)
	if not arg0_97.scenes then
		return
	end

	arg0_97.scenes[arg1_97.view] = nil
end

function var0_0.IsReView(arg0_98)
	return tobool(arg0_98.isReView)
end

function var0_0.IsRunning(arg0_99)
	return arg0_99.state == var3_0
end

function var0_0.IsStopping(arg0_100)
	return arg0_100.state == var5_0
end

function var0_0.IsPausing(arg0_101)
	return arg0_101.state == var4_0
end

function var0_0.IsAutoPlay(arg0_102)
	if arg0_102.banPlayFlag then
		return false
	end

	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or arg0_102.autoPlayFlag == true
end

function var0_0.GetRectSize(arg0_103)
	return Vector2(arg0_103._tf.rect.width, arg0_103._tf.rect.height)
end

function var0_0.AddRecord(arg0_104, arg1_104)
	arg0_104.recorder:Add(arg1_104)
end

function var0_0.Quit(arg0_105)
	arg0_105.recorder:Dispose()
	arg0_105.recordPanel:Dispose()
	arg0_105.setSpeedPanel:Dispose()

	if arg0_105.currPlayer and arg0_105.currPlayer:WaitForEvent() then
		arg0_105:Clear()
	end

	arg0_105.state = var7_0
	arg0_105.storyScript = nil
	arg0_105.currPlayer = nil
	arg0_105.playQueue = {}
	arg0_105.playedList = {}
	arg0_105.scenes = {}
end

function var0_0.Fix(arg0_106)
	local var0_106 = getProxy(PlayerProxy):getRawData():GetRegisterTime()
	local var1_106 = pg.TimeMgr.GetInstance():parseTimeFromConfig({
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
	local var2_106 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if var0_106 <= var1_106 then
		_.each(var2_106, function(arg0_107)
			arg0_106.playedList[arg0_107] = true
		end)
	end

	local var3_106 = 5001
	local var4_106 = 5020
	local var5_106 = getProxy(TaskProxy)
	local var6_106 = 0

	for iter0_106 = var3_106, var4_106, -1 do
		if var5_106:getFinishTaskById(iter0_106) or var5_106:getTaskById(iter0_106) then
			var6_106 = iter0_106

			break
		end
	end

	for iter1_106 = var6_106, var4_106, -1 do
		local var7_106 = pg.task_data_template[iter1_106]

		if var7_106 then
			local var8_106 = var7_106.story_id

			if var8_106 and #var8_106 > 0 and not arg0_106:IsPlayed(var8_106) then
				arg0_106.playedList[var8_106] = true
			end
		end
	end

	local var9_106 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

	if var9_106 and not var9_106:isEnd() then
		local var10_106 = _.flatten(var9_106:getConfig("config_data"))
		local var11_106

		for iter2_106 = #var10_106, 1, -1 do
			local var12_106 = pg.task_data_template[var10_106[iter2_106]].story_id

			if var12_106 and #var12_106 > 0 then
				local var13_106 = arg0_106:IsPlayed(var12_106)

				if var11_106 then
					if not var13_106 then
						arg0_106.playedList[var12_106] = true
					end
				elseif var13_106 then
					var11_106 = iter2_106
				end
			end
		end
	end
end

function var0_0._GetResList(arg0_108, arg1_108)
	local var0_108 = "ui/newstoryui"
	local var1_108 = arg1_108:GetDialogueStyleName()
	local var2_108 = "ui/newstorydialogue" .. var1_108
	local var3_108 = "ui/newstoryrecordui"
	local var4_108 = arg0_108:_GetStoryPaintingsByName(arg1_108)
	local var5_108 = {}

	_.each(var4_108, function(arg0_109)
		PaintingGroupConst.AddPaintingNameWithFilteMap(var5_108, arg0_109)
	end)

	local var6_108 = {}

	_.each(var4_108, function(arg0_110)
		table.insert(var6_108, "paintingface/" .. arg0_110)
	end)

	local var7_108 = {}

	_.each(arg1_108.steps, function(arg0_111)
		local var0_111 = arg0_111:GetResList()

		_.each(var0_111, function(arg0_112)
			table.insert(var7_108, arg0_112)
		end)
	end)

	local var8_108 = SplitPackMediatorResMap.MergeLuaArr(var5_108, var6_108, var7_108)

	table.insert(var8_108, var0_108)
	table.insert(var8_108, var2_108)
	table.insert(var8_108, var3_108)

	return var8_108
end
