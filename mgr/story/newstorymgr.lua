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
	local var0_11, var1_11 = arg0_11:StoryName2StoryId(arg1_11)
	local var2_11 = arg0_11:GetPlayedFlag(var0_11)
	local var3_11 = true

	if var1_11 and not arg2_11 then
		var3_11 = arg0_11:GetPlayedFlag(var1_11)
	end

	return var2_11 and var3_11
end

local function var14_0(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12) do
		var0_12[iter1_12] = iter0_12
	end

	return var0_12
end

function var0_0.StoryName2StoryId(arg0_13, arg1_13)
	if not var0_0.indexs then
		var0_0.indexs = var14_0(var13_0("index"))
	end

	if not var0_0.againIndexs then
		var0_0.againIndexs = var14_0(var13_0("index_again"))
	end

	return var0_0.indexs[arg1_13], var0_0.againIndexs[arg1_13]
end

function var0_0.StoryId2StoryName(arg0_14, arg1_14)
	if not var0_0.indexIds then
		var0_0.indexIds = var13_0("index")
	end

	if not var0_0.againIndexIds then
		var0_0.againIndexIds = var13_0("index_again")
	end

	return var0_0.indexIds[arg1_14], var0_0.againIndexIds[arg1_14]
end

function var0_0.StoryLinkNames(arg0_15, arg1_15)
	if not var0_0.linkNames then
		var0_0.linkNames = var13_0("index_link")
	end

	return var0_0.linkNames[arg1_15]
end

function var0_0._GetStoryPaintingsByName(arg0_16, arg1_16)
	return arg1_16:GetUsingPaintingNames()
end

function var0_0.GetStoryPaintingsByName(arg0_17, arg1_17)
	local var0_17 = var13_0(arg1_17)

	if not var0_17 then
		var11_0("not exist story file")

		return {}
	end

	local var1_17 = Story.New(var0_17, false)

	return arg0_17:_GetStoryPaintingsByName(var1_17)
end

function var0_0.GetStoryPaintingsByNameList(arg0_18, arg1_18)
	local var0_18 = {}
	local var1_18 = {}

	for iter0_18, iter1_18 in ipairs(arg1_18) do
		for iter2_18, iter3_18 in ipairs(arg0_18:GetStoryPaintingsByName(iter1_18)) do
			var1_18[iter3_18] = true
		end
	end

	for iter4_18, iter5_18 in pairs(var1_18) do
		table.insert(var0_18, iter4_18)
	end

	return var0_18
end

function var0_0.GetStoryPaintingsById(arg0_19, arg1_19)
	return arg0_19:GetStoryPaintingsByIdList({
		arg1_19
	})
end

function var0_0.GetStoryPaintingsByIdList(arg0_20, arg1_20)
	local var0_20 = _.map(arg1_20, function(arg0_21)
		return arg0_20:StoryId2StoryName(arg0_21)
	end)

	return arg0_20:GetStoryPaintingsByNameList(var0_20)
end

function var0_0.ShouldDownloadRes(arg0_22, arg1_22)
	local var0_22 = arg0_22:GetStoryPaintingsByName(arg1_22)

	return _.any(var0_22, function(arg0_23)
		return PaintingGroupConst.VerifyPaintingFileName(arg0_23)
	end)
end

function var0_0.Init(arg0_24, arg1_24)
	arg0_24.state = var1_0

	LoadAndInstantiateAsync("ui", "NewStoryUI", function(arg0_25)
		arg0_24.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		arg0_25.transform:SetParent(arg0_24.UIOverlay.transform, false)
		arg0_24:_Init(arg0_25, arg1_24)
	end, true, true)
end

function var0_0._Init(arg0_26, arg1_26, arg2_26)
	arg0_26.playedList = {}
	arg0_26.playQueue = {}
	arg0_26._go = arg1_26
	arg0_26._tf = tf(arg0_26._go)
	arg0_26.frontTr = findTF(arg0_26._tf, "front")
	arg0_26.frontEvtTr = findTF(arg0_26._tf, "block")
	arg0_26.skipBtn = findTF(arg0_26._tf, "front/btns/btns/skip_button")
	arg0_26.autoBtn = findTF(arg0_26._tf, "front/btns/btns/auto_button")
	arg0_26.autoBtnImg = findTF(arg0_26._tf, "front/btns/btns/auto_button/sel"):GetComponent(typeof(Image))
	arg0_26.alphaImage = arg0_26._tf:GetComponent(typeof(Image))
	arg0_26.mainImage = arg0_26._tf:GetComponent(typeof(Image))
	arg0_26.recordBtn = findTF(arg0_26._tf, "front/btns/record")
	arg0_26.hideUIBtn = findTF(arg0_26._tf, "front/btns/btns/hide_ui_button")
	arg0_26.dialogueContainer = findTF(arg0_26._tf, "front/dialogue")
	arg0_26.players = {
		AsideStoryPlayer.New(arg1_26),
		DialogueStoryPlayer.New(arg1_26),
		BgStoryPlayer.New(arg1_26),
		CarouselPlayer.New(arg1_26),
		VedioStoryPlayer.New(arg1_26),
		CastStoryPlayer.New(arg1_26),
		SpAnimStoryPlayer.New(arg1_26),
		BlinkStoryPlayer.New(arg1_26)
	}
	arg0_26.setSpeedPanel = StorySetSpeedPanel.New(arg0_26._tf, function(arg0_27)
		arg0_26:UpdatePlaySpeed(arg0_27)
	end)
	arg0_26.recordPanel = NewStoryRecordPanel.New()
	arg0_26.recorder = StoryRecorder.New()

	setActive(arg0_26._go, false)

	arg0_26.state = var2_0

	if arg2_26 then
		arg2_26()
	end
end

function var0_0.GetPlayer(arg0_28, arg1_28)
	for iter0_28, iter1_28 in ipairs(arg0_28.players) do
		if isa(iter1_28, arg1_28) then
			return iter1_28
		end
	end

	return nil
end

function var0_0.Play(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29, arg5_29, arg6_29, arg7_29)
	table.insert(arg0_29.playQueue, {
		arg1_29,
		arg2_29,
		arg7_29
	})

	if #arg0_29.playQueue == 1 then
		local var0_29

		local function var1_29()
			if #arg0_29.playQueue == 0 then
				return
			end

			local var0_30 = arg0_29.playQueue[1][1]
			local var1_30 = arg0_29.playQueue[1][2]
			local var2_30 = arg0_29.playQueue[1][3]

			arg0_29:SoloPlay(var0_30, function(arg0_31, arg1_31)
				if var1_30 then
					var1_30(arg0_31, arg1_31)
				end

				table.remove(arg0_29.playQueue, 1)
				var1_29()
			end, arg3_29, arg4_29, arg5_29, arg6_29, var2_30)
		end

		var1_29()
	end
end

function var0_0.Pause(arg0_32)
	if arg0_32.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	arg0_32.state = var4_0

	for iter0_32, iter1_32 in ipairs(arg0_32.players) do
		iter1_32:Pause()
	end
end

function var0_0.Resume(arg0_33)
	if arg0_33.state ~= var4_0 then
		var11_0("state is not 'pause'")

		return
	end

	arg0_33.state = var3_0

	for iter0_33, iter1_33 in ipairs(arg0_33.players) do
		iter1_33:Resume()
	end
end

function var0_0.Stop(arg0_34)
	if arg0_34.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	if arg0_34.currPlayer and arg0_34.currPlayer:WaitForEvent() then
		return
	end

	arg0_34.state = var5_0

	for iter0_34, iter1_34 in ipairs(arg0_34.players) do
		iter1_34:Stop()
	end
end

function var0_0.PlayForTb(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	arg0_35:Play(arg1_35, arg3_35, arg4_35, false, false, true, arg2_35)
end

function var0_0.PlayForWorld(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36, arg5_36, arg6_36, arg7_36, arg8_36)
	arg0_36.optionSelCodes = arg2_36 or {}
	arg0_36.autoPlayFlag = arg6_36

	arg0_36:Play(arg1_36, arg3_36, arg4_36, arg5_36, arg7_36, true, arg8_36)
end

function var0_0.ForceAutoPlay(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37, arg5_37)
	arg0_37.autoPlayFlag = true

	local function var0_37(arg0_38, arg1_38)
		arg2_37(arg0_38, arg1_38, arg0_37.isAutoPlay)
	end

	arg0_37:Play(arg1_37, var0_37, arg3_37, arg4_37, true, false, arg5_37)
end

function var0_0.ForceManualPlay(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39, arg5_39)
	arg0_39.banPlayFlag = true

	local function var0_39(arg0_40, arg1_40)
		arg2_39(arg0_40, arg1_40, arg0_39.isAutoPlay)
	end

	arg0_39:Play(arg1_39, var0_39, arg3_39, arg4_39, true, false, arg5_39)
end

function var0_0.SeriesPlay(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41, arg5_41, arg6_41, arg7_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in ipairs(arg1_41) do
		table.insert(var0_41, function(arg0_42)
			arg0_41:SoloPlay(iter1_41, arg0_42, arg3_41, arg4_41, arg5_41, arg6_41, arg7_41)
		end)
	end

	seriesAsync(var0_41, arg2_41)
end

function var0_0.SoloPlay(arg0_43, arg1_43, arg2_43, arg3_43, arg4_43, arg5_43, arg6_43, arg7_43)
	var11_0("Play Story:", arg1_43)

	local var0_43 = 1

	local function var1_43(arg0_44, arg1_44)
		var0_43 = var0_43 - 1

		if arg2_43 and var0_43 == 0 then
			onNextTick(function()
				arg2_43(arg0_44, arg1_44)
			end)
		end
	end

	local var2_43 = var13_0(arg1_43)

	if not var2_43 then
		var1_43(false)
		var11_0("not exist story file")

		return nil
	end

	if arg0_43:IsReView() then
		arg3_43 = true
	end

	arg0_43.storyScript = Story.New(var2_43, arg3_43, arg0_43.optionSelCodes, arg5_43, arg6_43, arg7_43)

	if not arg0_43:CheckState() then
		var11_0("story state error")
		var1_43(false)

		return nil
	end

	if not arg0_43.storyScript:CanPlay() then
		var11_0("story cant be played")
		var1_43(false)

		return nil
	end

	arg0_43:ExecuteScript(var1_43)
end

function var0_0.ExecuteScript(arg0_46, arg1_46)
	seriesAsync({
		function(arg0_47)
			arg0_46:CheckResDownload(arg0_46.storyScript, arg0_47)
		end,
		function(arg0_48)
			originalPrint("start load story window...")
			arg0_46:CheckAndLoadDialogue(arg0_46.storyScript, arg0_48)
		end
	}, function()
		originalPrint("enter story...")
		arg0_46:OnStart()

		local var0_49 = {}

		arg0_46.currPlayer = nil
		arg0_46.progress = 0

		for iter0_49, iter1_49 in ipairs(arg0_46.storyScript.steps) do
			table.insert(var0_49, function(arg0_50)
				arg0_46.progress = iter0_49

				arg0_46:SendNotification(GAME.STORY_NEXT)

				local var0_50 = arg0_46.players[iter1_49:GetMode()]

				arg0_46.currPlayer = var0_50

				var0_50:Play(arg0_46.storyScript, iter0_49, arg0_50)
			end)
		end

		seriesAsync(var0_49, function()
			arg0_46:OnEnd(arg1_46)
		end)
	end)
end

function var0_0.SendNotification(arg0_52, arg1_52, arg2_52)
	pg.m02:sendNotification(arg1_52, arg2_52)
end

function var0_0.CheckResDownload(arg0_53, arg1_53, arg2_53)
	local var0_53 = arg0_53:_GetStoryPaintingsByName(arg1_53)
	local var1_53 = table.concat(var0_53, ",")

	originalPrint("start download res " .. var1_53)

	local var2_53 = {}

	for iter0_53, iter1_53 in ipairs(var0_53) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var2_53, iter1_53)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var2_53,
		finishFunc = arg2_53
	})
end

local function var15_0(arg0_54, arg1_54)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_54, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_55)
		arg1_54(arg0_55)
	end), true, true)
end

function var0_0.CheckAndLoadDialogue(arg0_56, arg1_56, arg2_56)
	local var0_56 = arg1_56:GetDialogueStyleName()

	if not arg0_56.dialogueContainer:Find(var0_56) then
		var15_0("NewStoryDialogue" .. var0_56, function(arg0_57)
			Object.Instantiate(arg0_57, arg0_56.dialogueContainer).name = var0_56

			arg2_56()
		end)
	else
		arg2_56()
	end
end

function var0_0.CheckState(arg0_58)
	if arg0_58.state == var3_0 or arg0_58.state == var1_0 or arg0_58.state == var4_0 then
		return false
	end

	return true
end

function var0_0.RegistSkipBtn(arg0_59)
	local function var0_59()
		arg0_59:TrackingSkip()
		arg0_59.storyScript:SkipAll()
		arg0_59.currPlayer:NextOneImmediately()
	end

	onButton(arg0_59, arg0_59.skipBtn, function()
		if arg0_59:IsStopping() or arg0_59:IsPausing() then
			return
		end

		if not arg0_59.currPlayer:CanSkip() then
			return
		end

		if arg0_59:IsReView() or arg0_59.storyScript:IsPlayed() or not arg0_59.storyScript:ShowSkipTip() then
			var0_59()

			return
		end

		arg0_59:Pause()

		arg0_59.isOpenMsgbox = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			parent = rtf(arg0_59._tf:Find("front")),
			content = i18n("story_skip_confirm"),
			onYes = function()
				arg0_59:Resume()
				var0_59()
			end,
			onNo = function()
				arg0_59.isOpenMsgbox = false

				arg0_59:Resume()
			end
		})
	end, SFX_PANEL)
end

function var0_0.RegistAutoBtn(arg0_64)
	onButton(arg0_64, arg0_64.autoBtn, function()
		if arg0_64:IsStopping() or arg0_64:IsPausing() then
			return
		end

		if arg0_64.storyScript:GetAutoPlayFlag() then
			arg0_64.storyScript:StopAutoPlay()
			arg0_64.currPlayer:CancelAuto()
		else
			arg0_64.storyScript:SetAutoPlay()
			arg0_64.currPlayer:NextOne()
		end

		if arg0_64.storyScript then
			arg0_64:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	local var0_64 = arg0_64:IsAutoPlay()

	if var0_64 then
		arg0_64.storyScript:SetAutoPlay()
		arg0_64:UpdateAutoBtn()

		arg0_64.autoPlayFlag = false
	end

	arg0_64.banPlayFlag = false
	arg0_64.isAutoPlay = var0_64
end

function var0_0.RegistRecordBtn(arg0_66)
	onButton(arg0_66, arg0_66.recordBtn, function()
		if arg0_66.storyScript:GetAutoPlayFlag() then
			return
		end

		if not arg0_66.recordPanel:CanOpen() then
			return
		end

		local var0_67 = "Show"

		arg0_66.recordPanel[var0_67](arg0_66.recordPanel, arg0_66.recorder)
	end, SFX_PANEL)
end

function var0_0.TriggerAutoBtn(arg0_68)
	if not arg0_68:IsRunning() then
		return
	end

	triggerButton(arg0_68.autoBtn)
end

function var0_0.TriggerSkipBtn(arg0_69)
	if not arg0_69:IsRunning() then
		return
	end

	triggerButton(arg0_69.skipBtn)
end

function var0_0.ForEscPress(arg0_70)
	if arg0_70.recordPanel:IsShowing() then
		arg0_70.recordPanel:Hide()
	elseif arg0_70.currPlayer and arg0_70.currPlayer:WaitForEvent() or arg0_70.currPlayer and arg0_70.storyScript and arg0_70.storyScript.hideSkip then
		-- block empty
	else
		arg0_70:TriggerSkipBtn()
	end
end

function var0_0.UpdatePlaySpeed(arg0_71, arg1_71)
	if arg0_71:IsRunning() and arg0_71.storyScript then
		arg0_71.storyScript:SetPlaySpeed(arg1_71)
	end
end

function var0_0.GetPlaySpeed(arg0_72)
	if arg0_72:IsRunning() and arg0_72.storyScript then
		return arg0_72.storyScript:GetPlaySpeed()
	end
end

function var0_0.OnStart(arg0_73)
	arg0_73.recorder:Clear()
	removeOnButton(arg0_73._go)
	removeOnButton(arg0_73.skipBtn)
	removeOnButton(arg0_73.autoBtn)
	removeOnButton(arg0_73.recordBtn)

	arg0_73.mainImage.color = Color(0, 0, 0, arg0_73.storyScript:GetStoryAlpha())

	setActive(arg0_73.recordBtn, not arg0_73.storyScript:ShouldHideRecord())
	arg0_73:ClearStoryEventTriggerListener()

	local var0_73 = arg0_73.storyScript:GetAllStepDispatcherRecallName()

	if #var0_73 > 0 then
		arg0_73.storyEventTriggerListener = StoryEventTriggerListener.New(var0_73)
	end

	arg0_73.mainImage.enabled = not arg0_73.storyScript:CanInteraction()
	arg0_73.state = var3_0

	arg0_73:TrackingStart()
	arg0_73:SendNotification(GAME.STORY_BEGIN, arg0_73.storyScript:GetName())

	if not arg0_73:IsReView() then
		arg0_73:SendNotification(GAME.STORY_UPDATE, {
			storyId = arg0_73.storyScript:GetName()
		})
	end

	pg.DelegateInfo.New(arg0_73)

	for iter0_73, iter1_73 in ipairs(arg0_73.players) do
		iter1_73:StoryStart(arg0_73.storyScript)
	end

	setActive(arg0_73._go, true)
	arg0_73._tf:SetAsLastSibling()
	setActive(arg0_73.skipBtn, not arg0_73.storyScript:ShouldHideSkip())
	setActive(arg0_73.autoBtn, not arg0_73.storyScript:ShouldHideAutoBtn())

	arg0_73.bgmVolumeValue = pg.CriMgr.GetInstance():getBGMVolume()

	arg0_73:RegistSkipBtn()
	arg0_73:RegistAutoBtn()
	arg0_73:RegistRecordBtn()
	arg0_73:RegistHideUIBtn()
end

function var0_0.RegistHideUIBtn(arg0_74)
	onButton(arg0_74, arg0_74.hideUIBtn, function()
		if arg0_74.storyScript:GetAutoPlayFlag() then
			arg0_74.storyScript:StopAutoPlay()
			arg0_74.currPlayer:CancelAuto()
			arg0_74:UpdateAutoBtn()
		end

		setActiveByCanvasGroup(arg0_74.frontTr, false)
		setActive(arg0_74.frontEvtTr, true)
	end, SFX_PANEL)
	onButton(arg0_74, arg0_74.frontEvtTr, function()
		setActiveByCanvasGroup(arg0_74.frontTr, true)
		setActive(arg0_74.frontEvtTr, false)
	end, SFX_PANEL)
end

function var0_0.TrackingStart(arg0_77)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return
	end

	arg0_77.trackFlag = false

	if not arg0_77.storyScript then
		return
	end

	local var0_77 = arg0_77:StoryName2StoryId(arg0_77.storyScript:GetName())

	if var0_77 and not arg0_77:GetPlayedFlag(var0_77) then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryStart(var0_77, 0))

		arg0_77.trackFlag = true
	end
end

function var0_0.TrackingSkip(arg0_78)
	if not arg0_78.trackFlag or not arg0_78.storyScript then
		return
	end

	local var0_78 = arg0_78:StoryName2StoryId(arg0_78.storyScript:GetName())

	if var0_78 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStorySkip(var0_78, arg0_78.progress or 0))
	end
end

function var0_0.TrackingOption(arg0_79, arg1_79, arg2_79)
	if not arg0_79.storyScript or not arg1_79 or not arg2_79 then
		return
	end

	local var0_79 = arg0_79:StoryName2StoryId(arg0_79.storyScript:GetName())

	if var0_79 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryOption(var0_79, arg1_79 .. "_" .. (arg2_79 or 0)))
	end
end

function var0_0.ClearStoryEvent(arg0_80)
	if arg0_80.storyEventTriggerListener then
		arg0_80.storyEventTriggerListener:Clear()
	end
end

function var0_0.CheckStoryEvent(arg0_81, arg1_81)
	if arg0_81.storyEventTriggerListener then
		return arg0_81.storyEventTriggerListener:ExistCache(arg1_81)
	end

	return false
end

function var0_0.GetStoryEventArg(arg0_82, arg1_82)
	if not arg0_82:CheckStoryEvent(arg1_82) then
		return nil
	end

	if arg0_82.storyEventTriggerListener and arg0_82.storyEventTriggerListener:ExistArg(arg1_82) then
		return arg0_82.storyEventTriggerListener:GetArg(arg1_82)
	end

	return nil
end

function var0_0.UpdateAutoBtn(arg0_83)
	local var0_83 = arg0_83.storyScript:GetAutoPlayFlag()

	arg0_83:ClearAutoBtn(var0_83)
end

function var0_0.ClearAutoBtn(arg0_84, arg1_84)
	arg0_84.autoBtnImg.color = arg1_84 and var8_0 or var9_0
	arg0_84.isAutoPlay = arg1_84

	local var0_84 = arg1_84 and "Show" or "Hide"

	arg0_84.setSpeedPanel[var0_84](arg0_84.setSpeedPanel, arg0_84.storyScript)
end

function var0_0.ClearStoryEventTriggerListener(arg0_85)
	if arg0_85.storyEventTriggerListener then
		arg0_85.storyEventTriggerListener:Dispose()

		arg0_85.storyEventTriggerListener = nil
	end
end

function var0_0.Clear(arg0_86)
	arg0_86.progress = 0

	arg0_86:ClearStoryEventTriggerListener()

	arg0_86.mainImage.enabled = true

	arg0_86.recorder:Clear()
	arg0_86.recordPanel:Hide()

	arg0_86.autoPlayFlag = false
	arg0_86.banPlayFlag = false

	removeOnButton(arg0_86._go)
	removeOnButton(arg0_86.skipBtn)
	removeOnButton(arg0_86.recordBtn)
	removeOnButton(arg0_86.autoBtn)
	removeOnButton(arg0_86.hideUIBtn)
	removeOnButton(arg0_86.frontEvtTr)
	arg0_86:ClearAutoBtn(false)

	if isActive(arg0_86._go) then
		pg.DelegateInfo.Dispose(arg0_86)
	end

	if arg0_86.setSpeedPanel then
		arg0_86.setSpeedPanel:Clear()
	end

	setActive(arg0_86.skipBtn, false)
	setActive(arg0_86._go, false)

	for iter0_86, iter1_86 in ipairs(arg0_86.players) do
		iter1_86:StoryEnd(arg0_86.storyScript)
	end

	arg0_86.optionSelCodes = nil

	arg0_86:SendNotification(GAME.STORY_END)

	if arg0_86.isOpenMsgbox then
		pg.MsgboxMgr.GetInstance():hide()
	end

	arg0_86:RevertBgmVolumeValue()
end

function var0_0.RevertBgmVolumeValue(arg0_87)
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_87 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0_87.bgmVolumeValue and arg0_87.bgmVolumeValue ~= var0_87 then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_87.bgmVolumeValue)
	end

	arg0_87.bgmVolumeValue = nil
end

function var0_0.OnEnd(arg0_88, arg1_88)
	arg0_88:Clear()

	if arg0_88.state == var3_0 or arg0_88.state == var5_0 then
		arg0_88.state = var6_0

		local var0_88 = arg0_88.storyScript:GetNextScriptName()

		if var0_88 and not arg0_88:IsReView() then
			arg0_88.storyScript = nil

			arg0_88:Play(var0_88, arg1_88)
		else
			local var1_88 = arg0_88.storyScript:GetBranchCode()

			arg0_88.storyScript = nil

			if arg1_88 then
				arg1_88(true, var1_88)
			end
		end
	else
		arg0_88.state = var6_0

		local var2_88 = arg0_88.storyScript:GetBranchCode()

		if arg1_88 then
			arg1_88(true, var2_88)
		end
	end
end

function var0_0.OnSceneEnter(arg0_89, arg1_89)
	if not arg0_89.scenes then
		arg0_89.scenes = {}
	end

	arg0_89.scenes[arg1_89.view] = true
end

function var0_0.OnSceneExit(arg0_90, arg1_90)
	if not arg0_90.scenes then
		return
	end

	arg0_90.scenes[arg1_90.view] = nil
end

function var0_0.IsReView(arg0_91)
	if getProxy(ContextProxy) == nil then
		return false
	end

	local var0_91 = getProxy(ContextProxy):GetPrevContext(1)

	return arg0_91.scenes[WorldMediaCollectionScene.__cname] == true or var0_91 and var0_91.mediator == WorldMediaCollectionMediator
end

function var0_0.IsRunning(arg0_92)
	return arg0_92.state == var3_0
end

function var0_0.IsStopping(arg0_93)
	return arg0_93.state == var5_0
end

function var0_0.IsPausing(arg0_94)
	return arg0_94.state == var4_0
end

function var0_0.IsAutoPlay(arg0_95)
	if arg0_95.banPlayFlag then
		return false
	end

	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or arg0_95.autoPlayFlag == true
end

function var0_0.GetRectSize(arg0_96)
	return Vector2(arg0_96._tf.rect.width, arg0_96._tf.rect.height)
end

function var0_0.AddRecord(arg0_97, arg1_97)
	arg0_97.recorder:Add(arg1_97)
end

function var0_0.Quit(arg0_98)
	arg0_98.recorder:Dispose()
	arg0_98.recordPanel:Dispose()
	arg0_98.setSpeedPanel:Dispose()

	if arg0_98.currPlayer and arg0_98.currPlayer:WaitForEvent() then
		arg0_98:Clear()
	end

	arg0_98.state = var7_0
	arg0_98.storyScript = nil
	arg0_98.currPlayer = nil
	arg0_98.playQueue = {}
	arg0_98.playedList = {}
	arg0_98.scenes = {}
end

function var0_0.Fix(arg0_99)
	local var0_99 = getProxy(PlayerProxy):getRawData():GetRegisterTime()
	local var1_99 = pg.TimeMgr.GetInstance():parseTimeFromConfig({
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
	local var2_99 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if var0_99 <= var1_99 then
		_.each(var2_99, function(arg0_100)
			arg0_99.playedList[arg0_100] = true
		end)
	end

	local var3_99 = 5001
	local var4_99 = 5020
	local var5_99 = getProxy(TaskProxy)
	local var6_99 = 0

	for iter0_99 = var3_99, var4_99, -1 do
		if var5_99:getFinishTaskById(iter0_99) or var5_99:getTaskById(iter0_99) then
			var6_99 = iter0_99

			break
		end
	end

	for iter1_99 = var6_99, var4_99, -1 do
		local var7_99 = pg.task_data_template[iter1_99]

		if var7_99 then
			local var8_99 = var7_99.story_id

			if var8_99 and #var8_99 > 0 and not arg0_99:IsPlayed(var8_99) then
				arg0_99.playedList[var8_99] = true
			end
		end
	end

	local var9_99 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

	if var9_99 and not var9_99:isEnd() then
		local var10_99 = _.flatten(var9_99:getConfig("config_data"))
		local var11_99

		for iter2_99 = #var10_99, 1, -1 do
			local var12_99 = pg.task_data_template[var10_99[iter2_99]].story_id

			if var12_99 and #var12_99 > 0 then
				local var13_99 = arg0_99:IsPlayed(var12_99)

				if var11_99 then
					if not var13_99 then
						arg0_99.playedList[var12_99] = true
					end
				elseif var13_99 then
					var11_99 = iter2_99
				end
			end
		end
	end
end
