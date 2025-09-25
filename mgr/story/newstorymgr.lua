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

function var0_0.GetPlayedFlag(arg0_8, arg1_8)
	return arg0_8.playedList[arg1_8]
end

function var0_0.GetPlayedList(arg0_9)
	return arg0_9.playedList
end

function var0_0.IsPlayed(arg0_10, arg1_10, arg2_10)
	local var0_10, var1_10 = arg0_10:StoryName2StoryId(arg1_10)
	local var2_10 = arg0_10:GetPlayedFlag(var0_10)
	local var3_10 = true

	if var1_10 and not arg2_10 then
		var3_10 = arg0_10:GetPlayedFlag(var1_10)
	end

	return var2_10 and var3_10
end

local function var14_0(arg0_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11) do
		var0_11[iter1_11] = iter0_11
	end

	return var0_11
end

function var0_0.StoryName2StoryId(arg0_12, arg1_12)
	if not var0_0.indexs then
		var0_0.indexs = var14_0(var13_0("index"))
	end

	if not var0_0.againIndexs then
		var0_0.againIndexs = var14_0(var13_0("index_again"))
	end

	return var0_0.indexs[arg1_12], var0_0.againIndexs[arg1_12]
end

function var0_0.StoryId2StoryName(arg0_13, arg1_13)
	if not var0_0.indexIds then
		var0_0.indexIds = var13_0("index")
	end

	if not var0_0.againIndexIds then
		var0_0.againIndexIds = var13_0("index_again")
	end

	return var0_0.indexIds[arg1_13], var0_0.againIndexIds[arg1_13]
end

function var0_0.StoryLinkNames(arg0_14, arg1_14)
	if not var0_0.linkNames then
		var0_0.linkNames = var13_0("index_link")
	end

	return var0_0.linkNames[arg1_14]
end

function var0_0._GetStoryPaintingsByName(arg0_15, arg1_15)
	return arg1_15:GetUsingPaintingNames()
end

function var0_0.GetStoryPaintingsByName(arg0_16, arg1_16)
	local var0_16 = var13_0(arg1_16)

	if not var0_16 then
		var11_0("not exist story file")

		return {}
	end

	local var1_16 = Story.New(var0_16, false)

	return arg0_16:_GetStoryPaintingsByName(var1_16)
end

function var0_0.GetStoryPaintingsByNameList(arg0_17, arg1_17)
	local var0_17 = {}
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(arg1_17) do
		for iter2_17, iter3_17 in ipairs(arg0_17:GetStoryPaintingsByName(iter1_17)) do
			var1_17[iter3_17] = true
		end
	end

	for iter4_17, iter5_17 in pairs(var1_17) do
		table.insert(var0_17, iter4_17)
	end

	return var0_17
end

function var0_0.GetStoryPaintingsById(arg0_18, arg1_18)
	return arg0_18:GetStoryPaintingsByIdList({
		arg1_18
	})
end

function var0_0.GetStoryPaintingsByIdList(arg0_19, arg1_19)
	local var0_19 = _.map(arg1_19, function(arg0_20)
		return arg0_19:StoryId2StoryName(arg0_20)
	end)

	return arg0_19:GetStoryPaintingsByNameList(var0_19)
end

function var0_0.ShouldDownloadRes(arg0_21, arg1_21)
	local var0_21 = arg0_21:GetStoryPaintingsByName(arg1_21)

	return _.any(var0_21, function(arg0_22)
		return PaintingGroupConst.VerifyPaintingFileName(arg0_22)
	end)
end

function var0_0.Init(arg0_23, arg1_23)
	arg0_23.state = var1_0

	LoadAndInstantiateAsync("ui", "NewStoryUI", function(arg0_24)
		arg0_23.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		arg0_24.transform:SetParent(arg0_23.UIOverlay.transform, false)
		arg0_23:_Init(arg0_24, arg1_23)
	end, true, true)
end

function var0_0._Init(arg0_25, arg1_25, arg2_25)
	arg0_25.playedList = {}
	arg0_25.playQueue = {}
	arg0_25._go = arg1_25
	arg0_25._tf = tf(arg0_25._go)
	arg0_25.frontTr = findTF(arg0_25._tf, "front")
	arg0_25.skipBtn = findTF(arg0_25._tf, "front/btns/btns/skip_button")
	arg0_25.autoBtn = findTF(arg0_25._tf, "front/btns/btns/auto_button")
	arg0_25.autoBtnImg = findTF(arg0_25._tf, "front/btns/btns/auto_button/sel"):GetComponent(typeof(Image))
	arg0_25.alphaImage = arg0_25._tf:GetComponent(typeof(Image))
	arg0_25.mainImage = arg0_25._tf:GetComponent(typeof(Image))
	arg0_25.recordBtn = findTF(arg0_25._tf, "front/btns/record")
	arg0_25.dialogueContainer = findTF(arg0_25._tf, "front/dialogue")
	arg0_25.players = {
		AsideStoryPlayer.New(arg1_25),
		DialogueStoryPlayer.New(arg1_25),
		BgStoryPlayer.New(arg1_25),
		CarouselPlayer.New(arg1_25),
		VedioStoryPlayer.New(arg1_25),
		CastStoryPlayer.New(arg1_25),
		SpAnimStoryPlayer.New(arg1_25),
		BlinkStoryPlayer.New(arg1_25)
	}
	arg0_25.setSpeedPanel = StorySetSpeedPanel.New(arg0_25._tf, function(arg0_26)
		arg0_25:UpdatePlaySpeed(arg0_26)
	end)
	arg0_25.recordPanel = NewStoryRecordPanel.New()
	arg0_25.recorder = StoryRecorder.New()

	setActive(arg0_25._go, false)

	arg0_25.state = var2_0

	if arg2_25 then
		arg2_25()
	end
end

function var0_0.GetPlayer(arg0_27, arg1_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.players) do
		if isa(iter1_27, arg1_27) then
			return iter1_27
		end
	end

	return nil
end

function var0_0.Play(arg0_28, arg1_28, arg2_28, arg3_28, arg4_28, arg5_28, arg6_28, arg7_28)
	table.insert(arg0_28.playQueue, {
		arg1_28,
		arg2_28,
		arg7_28
	})

	if #arg0_28.playQueue == 1 then
		local var0_28

		local function var1_28()
			if #arg0_28.playQueue == 0 then
				return
			end

			local var0_29 = arg0_28.playQueue[1][1]
			local var1_29 = arg0_28.playQueue[1][2]
			local var2_29 = arg0_28.playQueue[1][3]

			arg0_28:SoloPlay(var0_29, function(arg0_30, arg1_30)
				if var1_29 then
					var1_29(arg0_30, arg1_30)
				end

				table.remove(arg0_28.playQueue, 1)
				var1_28()
			end, arg3_28, arg4_28, arg5_28, arg6_28, var2_29)
		end

		var1_28()
	end
end

function var0_0.Pause(arg0_31)
	if arg0_31.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	arg0_31.state = var4_0

	for iter0_31, iter1_31 in ipairs(arg0_31.players) do
		iter1_31:Pause()
	end
end

function var0_0.Resume(arg0_32)
	if arg0_32.state ~= var4_0 then
		var11_0("state is not 'pause'")

		return
	end

	arg0_32.state = var3_0

	for iter0_32, iter1_32 in ipairs(arg0_32.players) do
		iter1_32:Resume()
	end
end

function var0_0.Stop(arg0_33)
	if arg0_33.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	if arg0_33.currPlayer and arg0_33.currPlayer:WaitForEvent() then
		return
	end

	arg0_33.state = var5_0

	for iter0_33, iter1_33 in ipairs(arg0_33.players) do
		iter1_33:Stop()
	end
end

function var0_0.PlayForTb(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	arg0_34:Play(arg1_34, arg3_34, arg4_34, false, false, true, arg2_34)
end

function var0_0.PlayForWorld(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35, arg5_35, arg6_35, arg7_35, arg8_35)
	arg0_35.optionSelCodes = arg2_35 or {}
	arg0_35.autoPlayFlag = arg6_35

	arg0_35:Play(arg1_35, arg3_35, arg4_35, arg5_35, arg7_35, true, arg8_35)
end

function var0_0.ForceAutoPlay(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36, arg5_36)
	arg0_36.autoPlayFlag = true

	local function var0_36(arg0_37, arg1_37)
		arg2_36(arg0_37, arg1_37, arg0_36.isAutoPlay)
	end

	arg0_36:Play(arg1_36, var0_36, arg3_36, arg4_36, true, false, arg5_36)
end

function var0_0.ForceManualPlay(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38, arg5_38)
	arg0_38.banPlayFlag = true

	local function var0_38(arg0_39, arg1_39)
		arg2_38(arg0_39, arg1_39, arg0_38.isAutoPlay)
	end

	arg0_38:Play(arg1_38, var0_38, arg3_38, arg4_38, true, false, arg5_38)
end

function var0_0.SeriesPlay(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40, arg5_40, arg6_40, arg7_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in ipairs(arg1_40) do
		table.insert(var0_40, function(arg0_41)
			arg0_40:SoloPlay(iter1_40, arg0_41, arg3_40, arg4_40, arg5_40, arg6_40, arg7_40)
		end)
	end

	seriesAsync(var0_40, arg2_40)
end

function var0_0.SoloPlay(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42, arg5_42, arg6_42, arg7_42)
	var11_0("Play Story:", arg1_42)

	local var0_42 = 1

	local function var1_42(arg0_43, arg1_43)
		var0_42 = var0_42 - 1

		if arg2_42 and var0_42 == 0 then
			onNextTick(function()
				arg2_42(arg0_43, arg1_43)
			end)
		end
	end

	local var2_42 = var13_0(arg1_42)

	if not var2_42 then
		var1_42(false)
		var11_0("not exist story file")

		return nil
	end

	if arg0_42:IsReView() then
		arg3_42 = true
	end

	arg0_42.storyScript = Story.New(var2_42, arg3_42, arg0_42.optionSelCodes, arg5_42, arg6_42, arg7_42)

	if not arg0_42:CheckState() then
		var11_0("story state error")
		var1_42(false)

		return nil
	end

	if not arg0_42.storyScript:CanPlay() then
		var11_0("story cant be played")
		var1_42(false)

		return nil
	end

	arg0_42:ExecuteScript(var1_42)
end

function var0_0.ExecuteScript(arg0_45, arg1_45)
	seriesAsync({
		function(arg0_46)
			arg0_45:CheckResDownload(arg0_45.storyScript, arg0_46)
		end,
		function(arg0_47)
			originalPrint("start load story window...")
			arg0_45:CheckAndLoadDialogue(arg0_45.storyScript, arg0_47)
		end
	}, function()
		originalPrint("enter story...")
		arg0_45:OnStart()

		local var0_48 = {}

		arg0_45.currPlayer = nil
		arg0_45.progress = 0

		for iter0_48, iter1_48 in ipairs(arg0_45.storyScript.steps) do
			table.insert(var0_48, function(arg0_49)
				arg0_45.progress = iter0_48

				arg0_45:SendNotification(GAME.STORY_NEXT)

				local var0_49 = arg0_45.players[iter1_48:GetMode()]

				arg0_45.currPlayer = var0_49

				var0_49:Play(arg0_45.storyScript, iter0_48, arg0_49)
			end)
		end

		seriesAsync(var0_48, function()
			arg0_45:OnEnd(arg1_45)
		end)
	end)
end

function var0_0.SendNotification(arg0_51, arg1_51, arg2_51)
	pg.m02:sendNotification(arg1_51, arg2_51)
end

function var0_0.CheckResDownload(arg0_52, arg1_52, arg2_52)
	local var0_52 = arg0_52:_GetStoryPaintingsByName(arg1_52)
	local var1_52 = table.concat(var0_52, ",")

	originalPrint("start download res " .. var1_52)

	local var2_52 = {}

	for iter0_52, iter1_52 in ipairs(var0_52) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var2_52, iter1_52)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var2_52,
		finishFunc = arg2_52
	})
end

local function var15_0(arg0_53, arg1_53)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_53, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_54)
		arg1_53(arg0_54)
	end), true, true)
end

function var0_0.CheckAndLoadDialogue(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg1_55:GetDialogueStyleName()

	if not arg0_55.dialogueContainer:Find(var0_55) then
		var15_0("NewStoryDialogue" .. var0_55, function(arg0_56)
			Object.Instantiate(arg0_56, arg0_55.dialogueContainer).name = var0_55

			arg2_55()
		end)
	else
		arg2_55()
	end
end

function var0_0.CheckState(arg0_57)
	if arg0_57.state == var3_0 or arg0_57.state == var1_0 or arg0_57.state == var4_0 then
		return false
	end

	return true
end

function var0_0.RegistSkipBtn(arg0_58)
	local function var0_58()
		arg0_58:TrackingSkip()
		arg0_58.storyScript:SkipAll()
		arg0_58.currPlayer:NextOneImmediately()
	end

	onButton(arg0_58, arg0_58.skipBtn, function()
		if arg0_58:IsStopping() or arg0_58:IsPausing() then
			return
		end

		if not arg0_58.currPlayer:CanSkip() then
			return
		end

		if arg0_58:IsReView() or arg0_58.storyScript:IsPlayed() or not arg0_58.storyScript:ShowSkipTip() then
			var0_58()

			return
		end

		arg0_58:Pause()

		arg0_58.isOpenMsgbox = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			parent = rtf(arg0_58._tf:Find("front")),
			content = i18n("story_skip_confirm"),
			onYes = function()
				arg0_58:Resume()
				var0_58()
			end,
			onNo = function()
				arg0_58.isOpenMsgbox = false

				arg0_58:Resume()
			end
		})
	end, SFX_PANEL)
end

function var0_0.RegistAutoBtn(arg0_63)
	onButton(arg0_63, arg0_63.autoBtn, function()
		if arg0_63:IsStopping() or arg0_63:IsPausing() then
			return
		end

		if arg0_63.storyScript:GetAutoPlayFlag() then
			arg0_63.storyScript:StopAutoPlay()
			arg0_63.currPlayer:CancelAuto()
		else
			arg0_63.storyScript:SetAutoPlay()
			arg0_63.currPlayer:NextOne()
		end

		if arg0_63.storyScript then
			arg0_63:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	local var0_63 = arg0_63:IsAutoPlay()

	if var0_63 then
		arg0_63.storyScript:SetAutoPlay()
		arg0_63:UpdateAutoBtn()

		arg0_63.autoPlayFlag = false
	end

	arg0_63.banPlayFlag = false
	arg0_63.isAutoPlay = var0_63
end

function var0_0.RegistRecordBtn(arg0_65)
	onButton(arg0_65, arg0_65.recordBtn, function()
		if arg0_65.storyScript:GetAutoPlayFlag() then
			return
		end

		if not arg0_65.recordPanel:CanOpen() then
			return
		end

		local var0_66 = "Show"

		arg0_65.recordPanel[var0_66](arg0_65.recordPanel, arg0_65.recorder)
	end, SFX_PANEL)
end

function var0_0.TriggerAutoBtn(arg0_67)
	if not arg0_67:IsRunning() then
		return
	end

	triggerButton(arg0_67.autoBtn)
end

function var0_0.TriggerSkipBtn(arg0_68)
	if not arg0_68:IsRunning() then
		return
	end

	triggerButton(arg0_68.skipBtn)
end

function var0_0.ForEscPress(arg0_69)
	if arg0_69.recordPanel:IsShowing() then
		arg0_69.recordPanel:Hide()
	elseif arg0_69.currPlayer and arg0_69.currPlayer:WaitForEvent() or arg0_69.currPlayer and arg0_69.storyScript and arg0_69.storyScript.hideSkip then
		-- block empty
	else
		arg0_69:TriggerSkipBtn()
	end
end

function var0_0.UpdatePlaySpeed(arg0_70, arg1_70)
	if arg0_70:IsRunning() and arg0_70.storyScript then
		arg0_70.storyScript:SetPlaySpeed(arg1_70)
	end
end

function var0_0.GetPlaySpeed(arg0_71)
	if arg0_71:IsRunning() and arg0_71.storyScript then
		return arg0_71.storyScript:GetPlaySpeed()
	end
end

function var0_0.OnStart(arg0_72)
	arg0_72.recorder:Clear()
	removeOnButton(arg0_72._go)
	removeOnButton(arg0_72.skipBtn)
	removeOnButton(arg0_72.autoBtn)
	removeOnButton(arg0_72.recordBtn)

	arg0_72.mainImage.color = Color(0, 0, 0, arg0_72.storyScript:GetStoryAlpha())

	setActive(arg0_72.recordBtn, not arg0_72.storyScript:ShouldHideRecord())
	arg0_72:ClearStoryEventTriggerListener()

	local var0_72 = arg0_72.storyScript:GetAllStepDispatcherRecallName()

	if #var0_72 > 0 then
		arg0_72.storyEventTriggerListener = StoryEventTriggerListener.New(var0_72)
	end

	arg0_72.mainImage.enabled = not arg0_72.storyScript:CanInteraction()
	arg0_72.state = var3_0

	arg0_72:TrackingStart()
	arg0_72:SendNotification(GAME.STORY_BEGIN, arg0_72.storyScript:GetName())

	if not arg0_72:IsReView() then
		arg0_72:SendNotification(GAME.STORY_UPDATE, {
			storyId = arg0_72.storyScript:GetName()
		})
	end

	pg.DelegateInfo.New(arg0_72)

	for iter0_72, iter1_72 in ipairs(arg0_72.players) do
		iter1_72:StoryStart(arg0_72.storyScript)
	end

	setActive(arg0_72._go, true)
	arg0_72._tf:SetAsLastSibling()
	setActive(arg0_72.skipBtn, not arg0_72.storyScript:ShouldHideSkip())
	setActive(arg0_72.autoBtn, not arg0_72.storyScript:ShouldHideAutoBtn())

	arg0_72.bgmVolumeValue = pg.CriMgr.GetInstance():getBGMVolume()

	arg0_72:RegistSkipBtn()
	arg0_72:RegistAutoBtn()
	arg0_72:RegistRecordBtn()
end

function var0_0.TrackingStart(arg0_73)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return
	end

	arg0_73.trackFlag = false

	if not arg0_73.storyScript then
		return
	end

	local var0_73 = arg0_73:StoryName2StoryId(arg0_73.storyScript:GetName())

	if var0_73 and not arg0_73:GetPlayedFlag(var0_73) then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryStart(var0_73, 0))

		arg0_73.trackFlag = true
	end
end

function var0_0.TrackingSkip(arg0_74)
	if not arg0_74.trackFlag or not arg0_74.storyScript then
		return
	end

	local var0_74 = arg0_74:StoryName2StoryId(arg0_74.storyScript:GetName())

	if var0_74 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStorySkip(var0_74, arg0_74.progress or 0))
	end
end

function var0_0.TrackingOption(arg0_75, arg1_75, arg2_75)
	if not arg0_75.storyScript or not arg1_75 or not arg2_75 then
		return
	end

	local var0_75 = arg0_75:StoryName2StoryId(arg0_75.storyScript:GetName())

	if var0_75 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryOption(var0_75, arg1_75 .. "_" .. (arg2_75 or 0)))
	end
end

function var0_0.ClearStoryEvent(arg0_76)
	if arg0_76.storyEventTriggerListener then
		arg0_76.storyEventTriggerListener:Clear()
	end
end

function var0_0.CheckStoryEvent(arg0_77, arg1_77)
	if arg0_77.storyEventTriggerListener then
		return arg0_77.storyEventTriggerListener:ExistCache(arg1_77)
	end

	return false
end

function var0_0.GetStoryEventArg(arg0_78, arg1_78)
	if not arg0_78:CheckStoryEvent(arg1_78) then
		return nil
	end

	if arg0_78.storyEventTriggerListener and arg0_78.storyEventTriggerListener:ExistArg(arg1_78) then
		return arg0_78.storyEventTriggerListener:GetArg(arg1_78)
	end

	return nil
end

function var0_0.UpdateAutoBtn(arg0_79)
	local var0_79 = arg0_79.storyScript:GetAutoPlayFlag()

	arg0_79:ClearAutoBtn(var0_79)
end

function var0_0.ClearAutoBtn(arg0_80, arg1_80)
	arg0_80.autoBtnImg.color = arg1_80 and var8_0 or var9_0
	arg0_80.isAutoPlay = arg1_80

	local var0_80 = arg1_80 and "Show" or "Hide"

	arg0_80.setSpeedPanel[var0_80](arg0_80.setSpeedPanel, arg0_80.storyScript)
end

function var0_0.ClearStoryEventTriggerListener(arg0_81)
	if arg0_81.storyEventTriggerListener then
		arg0_81.storyEventTriggerListener:Dispose()

		arg0_81.storyEventTriggerListener = nil
	end
end

function var0_0.Clear(arg0_82)
	arg0_82.progress = 0

	arg0_82:ClearStoryEventTriggerListener()

	arg0_82.mainImage.enabled = true

	arg0_82.recorder:Clear()
	arg0_82.recordPanel:Hide()

	arg0_82.autoPlayFlag = false
	arg0_82.banPlayFlag = false

	removeOnButton(arg0_82._go)
	removeOnButton(arg0_82.skipBtn)
	removeOnButton(arg0_82.recordBtn)
	removeOnButton(arg0_82.autoBtn)
	arg0_82:ClearAutoBtn(false)

	if isActive(arg0_82._go) then
		pg.DelegateInfo.Dispose(arg0_82)
	end

	if arg0_82.setSpeedPanel then
		arg0_82.setSpeedPanel:Clear()
	end

	setActive(arg0_82.skipBtn, false)
	setActive(arg0_82._go, false)

	for iter0_82, iter1_82 in ipairs(arg0_82.players) do
		iter1_82:StoryEnd(arg0_82.storyScript)
	end

	arg0_82.optionSelCodes = nil

	arg0_82:SendNotification(GAME.STORY_END)

	if arg0_82.isOpenMsgbox then
		pg.MsgboxMgr.GetInstance():hide()
	end

	arg0_82:RevertBgmVolumeValue()
end

function var0_0.RevertBgmVolumeValue(arg0_83)
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_83 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0_83.bgmVolumeValue and arg0_83.bgmVolumeValue ~= var0_83 then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_83.bgmVolumeValue)
	end

	arg0_83.bgmVolumeValue = nil
end

function var0_0.OnEnd(arg0_84, arg1_84)
	arg0_84:Clear()

	if arg0_84.state == var3_0 or arg0_84.state == var5_0 then
		arg0_84.state = var6_0

		local var0_84 = arg0_84.storyScript:GetNextScriptName()

		if var0_84 and not arg0_84:IsReView() then
			arg0_84.storyScript = nil

			arg0_84:Play(var0_84, arg1_84)
		else
			local var1_84 = arg0_84.storyScript:GetBranchCode()

			arg0_84.storyScript = nil

			if arg1_84 then
				arg1_84(true, var1_84)
			end
		end
	else
		arg0_84.state = var6_0

		local var2_84 = arg0_84.storyScript:GetBranchCode()

		if arg1_84 then
			arg1_84(true, var2_84)
		end
	end
end

function var0_0.OnSceneEnter(arg0_85, arg1_85)
	if not arg0_85.scenes then
		arg0_85.scenes = {}
	end

	arg0_85.scenes[arg1_85.view] = true
end

function var0_0.OnSceneExit(arg0_86, arg1_86)
	if not arg0_86.scenes then
		return
	end

	arg0_86.scenes[arg1_86.view] = nil
end

function var0_0.IsReView(arg0_87)
	if getProxy(ContextProxy) == nil then
		return false
	end

	local var0_87 = getProxy(ContextProxy):GetPrevContext(1)

	return arg0_87.scenes[WorldMediaCollectionScene.__cname] == true or var0_87 and var0_87.mediator == WorldMediaCollectionMediator
end

function var0_0.IsRunning(arg0_88)
	return arg0_88.state == var3_0
end

function var0_0.IsStopping(arg0_89)
	return arg0_89.state == var5_0
end

function var0_0.IsPausing(arg0_90)
	return arg0_90.state == var4_0
end

function var0_0.IsAutoPlay(arg0_91)
	if arg0_91.banPlayFlag then
		return false
	end

	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or arg0_91.autoPlayFlag == true
end

function var0_0.GetRectSize(arg0_92)
	return Vector2(arg0_92._tf.rect.width, arg0_92._tf.rect.height)
end

function var0_0.AddRecord(arg0_93, arg1_93)
	arg0_93.recorder:Add(arg1_93)
end

function var0_0.Quit(arg0_94)
	arg0_94.recorder:Dispose()
	arg0_94.recordPanel:Dispose()
	arg0_94.setSpeedPanel:Dispose()

	if arg0_94.currPlayer and arg0_94.currPlayer:WaitForEvent() then
		arg0_94:Clear()
	end

	arg0_94.state = var7_0
	arg0_94.storyScript = nil
	arg0_94.currPlayer = nil
	arg0_94.playQueue = {}
	arg0_94.playedList = {}
	arg0_94.scenes = {}
end

function var0_0.Fix(arg0_95)
	local var0_95 = getProxy(PlayerProxy):getRawData():GetRegisterTime()
	local var1_95 = pg.TimeMgr.GetInstance():parseTimeFromConfig({
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
	local var2_95 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if var0_95 <= var1_95 then
		_.each(var2_95, function(arg0_96)
			arg0_95.playedList[arg0_96] = true
		end)
	end

	local var3_95 = 5001
	local var4_95 = 5020
	local var5_95 = getProxy(TaskProxy)
	local var6_95 = 0

	for iter0_95 = var3_95, var4_95, -1 do
		if var5_95:getFinishTaskById(iter0_95) or var5_95:getTaskById(iter0_95) then
			var6_95 = iter0_95

			break
		end
	end

	for iter1_95 = var6_95, var4_95, -1 do
		local var7_95 = pg.task_data_template[iter1_95]

		if var7_95 then
			local var8_95 = var7_95.story_id

			if var8_95 and #var8_95 > 0 and not arg0_95:IsPlayed(var8_95) then
				arg0_95.playedList[var8_95] = true
			end
		end
	end

	local var9_95 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

	if var9_95 and not var9_95:isEnd() then
		local var10_95 = _.flatten(var9_95:getConfig("config_data"))
		local var11_95

		for iter2_95 = #var10_95, 1, -1 do
			local var12_95 = pg.task_data_template[var10_95[iter2_95]].story_id

			if var12_95 and #var12_95 > 0 then
				local var13_95 = arg0_95:IsPlayed(var12_95)

				if var11_95 then
					if not var13_95 then
						arg0_95.playedList[var12_95] = true
					end
				elseif var13_95 then
					var11_95 = iter2_95
				end
			end
		end
	end
end
