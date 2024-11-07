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

function var0_0.SetData(arg0_5, arg1_5)
	arg0_5.playedList = {}

	for iter0_5, iter1_5 in ipairs(arg1_5) do
		local var0_5 = iter1_5

		if iter1_5 == 20008 then
			var0_5 = 1131
		end

		if iter1_5 == 20009 then
			var0_5 = 1132
		end

		if iter1_5 == 20010 then
			var0_5 = 1133
		end

		if iter1_5 == 20011 then
			var0_5 = 1134
		end

		if iter1_5 == 20012 then
			var0_5 = 1135
		end

		if iter1_5 == 20013 then
			var0_5 = 1136
		end

		if iter1_5 == 20014 then
			var0_5 = 1137
		end

		arg0_5.playedList[var0_5] = true
	end
end

function var0_0.SetPlayedFlag(arg0_6, arg1_6)
	var11_0("Update story id", arg1_6)

	arg0_6.playedList[arg1_6] = true
end

function var0_0.GetPlayedFlag(arg0_7, arg1_7)
	return arg0_7.playedList[arg1_7]
end

function var0_0.IsPlayed(arg0_8, arg1_8, arg2_8)
	local var0_8, var1_8 = arg0_8:StoryName2StoryId(arg1_8)
	local var2_8 = arg0_8:GetPlayedFlag(var0_8)
	local var3_8 = true

	if var1_8 and not arg2_8 then
		var3_8 = arg0_8:GetPlayedFlag(var1_8)
	end

	return var2_8 and var3_8
end

local function var14_0(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9) do
		var0_9[iter1_9] = iter0_9
	end

	return var0_9
end

function var0_0.StoryName2StoryId(arg0_10, arg1_10)
	if not var0_0.indexs then
		var0_0.indexs = var14_0(var13_0("index"))
	end

	if not var0_0.againIndexs then
		var0_0.againIndexs = var14_0(var13_0("index_again"))
	end

	return var0_0.indexs[arg1_10], var0_0.againIndexs[arg1_10]
end

function var0_0.StoryId2StoryName(arg0_11, arg1_11)
	if not var0_0.indexIds then
		var0_0.indexIds = var13_0("index")
	end

	if not var0_0.againIndexIds then
		var0_0.againIndexIds = var13_0("index_again")
	end

	return var0_0.indexIds[arg1_11], var0_0.againIndexIds[arg1_11]
end

function var0_0.StoryLinkNames(arg0_12, arg1_12)
	if not var0_0.linkNames then
		var0_0.linkNames = var13_0("index_link")
	end

	return var0_0.linkNames[arg1_12]
end

function var0_0._GetStoryPaintingsByName(arg0_13, arg1_13)
	return arg1_13:GetUsingPaintingNames()
end

function var0_0.GetStoryPaintingsByName(arg0_14, arg1_14)
	local var0_14 = var13_0(arg1_14)

	if not var0_14 then
		var11_0("not exist story file")

		return {}
	end

	local var1_14 = Story.New(var0_14, false)

	return arg0_14:_GetStoryPaintingsByName(var1_14)
end

function var0_0.GetStoryPaintingsByNameList(arg0_15, arg1_15)
	local var0_15 = {}
	local var1_15 = {}

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		for iter2_15, iter3_15 in ipairs(arg0_15:GetStoryPaintingsByName(iter1_15)) do
			var1_15[iter3_15] = true
		end
	end

	for iter4_15, iter5_15 in pairs(var1_15) do
		table.insert(var0_15, iter4_15)
	end

	return var0_15
end

function var0_0.GetStoryPaintingsById(arg0_16, arg1_16)
	return arg0_16:GetStoryPaintingsByIdList({
		arg1_16
	})
end

function var0_0.GetStoryPaintingsByIdList(arg0_17, arg1_17)
	local var0_17 = _.map(arg1_17, function(arg0_18)
		return arg0_17:StoryId2StoryName(arg0_18)
	end)

	return arg0_17:GetStoryPaintingsByNameList(var0_17)
end

function var0_0.ShouldDownloadRes(arg0_19, arg1_19)
	local var0_19 = arg0_19:GetStoryPaintingsByName(arg1_19)

	return _.any(var0_19, function(arg0_20)
		return PaintingGroupConst.VerifyPaintingFileName(arg0_20)
	end)
end

function var0_0.Init(arg0_21, arg1_21)
	arg0_21.state = var1_0

	LoadAndInstantiateAsync("ui", "NewStoryUI", function(arg0_22)
		arg0_21.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		arg0_22.transform:SetParent(arg0_21.UIOverlay.transform, false)
		arg0_21:_Init(arg0_22, arg1_21)
	end, true, true)
end

function var0_0._Init(arg0_23, arg1_23, arg2_23)
	arg0_23.playedList = {}
	arg0_23.playQueue = {}
	arg0_23._go = arg1_23
	arg0_23._tf = tf(arg0_23._go)
	arg0_23.frontTr = findTF(arg0_23._tf, "front")
	arg0_23.skipBtn = findTF(arg0_23._tf, "front/btns/btns/skip_button")
	arg0_23.autoBtn = findTF(arg0_23._tf, "front/btns/btns/auto_button")
	arg0_23.autoBtnImg = findTF(arg0_23._tf, "front/btns/btns/auto_button/sel"):GetComponent(typeof(Image))
	arg0_23.alphaImage = arg0_23._tf:GetComponent(typeof(Image))
	arg0_23.recordBtn = findTF(arg0_23._tf, "front/btns/record")
	arg0_23.dialogueContainer = findTF(arg0_23._tf, "front/dialogue")
	arg0_23.players = {
		AsideStoryPlayer.New(arg1_23),
		DialogueStoryPlayer.New(arg1_23),
		BgStoryPlayer.New(arg1_23),
		CarouselPlayer.New(arg1_23),
		VedioStoryPlayer.New(arg1_23),
		CastStoryPlayer.New(arg1_23),
		SpAnimStoryPlayer.New(arg1_23),
		BlinkStoryPlayer.New(arg1_23)
	}
	arg0_23.setSpeedPanel = StorySetSpeedPanel.New(arg0_23._tf)
	arg0_23.recordPanel = NewStoryRecordPanel.New()
	arg0_23.recorder = StoryRecorder.New()

	setActive(arg0_23._go, false)

	arg0_23.state = var2_0

	if arg2_23 then
		arg2_23()
	end
end

function var0_0.Play(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24, arg5_24, arg6_24)
	table.insert(arg0_24.playQueue, {
		arg1_24,
		arg2_24
	})

	if #arg0_24.playQueue == 1 then
		local var0_24

		local function var1_24()
			if #arg0_24.playQueue == 0 then
				return
			end

			local var0_25 = arg0_24.playQueue[1][1]
			local var1_25 = arg0_24.playQueue[1][2]

			arg0_24:SoloPlay(var0_25, function(arg0_26, arg1_26)
				if var1_25 then
					var1_25(arg0_26, arg1_26)
				end

				table.remove(arg0_24.playQueue, 1)
				var1_24()
			end, arg3_24, arg4_24, arg5_24, arg6_24)
		end

		var1_24()
	end
end

function var0_0.Puase(arg0_27)
	if arg0_27.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	arg0_27.state = var4_0

	for iter0_27, iter1_27 in ipairs(arg0_27.players) do
		iter1_27:Pause()
	end
end

function var0_0.Resume(arg0_28)
	if arg0_28.state ~= var4_0 then
		var11_0("state is not 'pause'")

		return
	end

	arg0_28.state = var3_0

	for iter0_28, iter1_28 in ipairs(arg0_28.players) do
		iter1_28:Resume()
	end
end

function var0_0.Stop(arg0_29)
	if arg0_29.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	if arg0_29.currPlayer and arg0_29.currPlayer:WaitForEvent() then
		return
	end

	arg0_29.state = var5_0

	for iter0_29, iter1_29 in ipairs(arg0_29.players) do
		iter1_29:Stop()
	end
end

function var0_0.PlayForWorld(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30, arg5_30, arg6_30, arg7_30)
	arg0_30.optionSelCodes = arg2_30 or {}
	arg0_30.autoPlayFlag = arg6_30

	arg0_30:Play(arg1_30, arg3_30, arg4_30, arg5_30, arg7_30, true)
end

function var0_0.ForceAutoPlay(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31)
	arg0_31.autoPlayFlag = true

	local function var0_31(arg0_32, arg1_32)
		arg2_31(arg0_32, arg1_32, arg0_31.isAutoPlay)
	end

	arg0_31:Play(arg1_31, var0_31, arg3_31, arg4_31, true)
end

function var0_0.ForceManualPlay(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	arg0_33.banPlayFlag = true

	local function var0_33(arg0_34, arg1_34)
		arg2_33(arg0_34, arg1_34, arg0_33.isAutoPlay)
	end

	arg0_33:Play(arg1_33, var0_33, arg3_33, arg4_33, true)
end

function var0_0.SeriesPlay(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35, arg5_35, arg6_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in ipairs(arg1_35) do
		table.insert(var0_35, function(arg0_36)
			arg0_35:SoloPlay(iter1_35, arg0_36, arg3_35, arg4_35, arg5_35, arg6_35)
		end)
	end

	seriesAsync(var0_35, arg2_35)
end

function var0_0.SoloPlay(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37, arg5_37, arg6_37)
	var11_0("Play Story:", arg1_37)

	local var0_37 = 1

	local function var1_37(arg0_38, arg1_38)
		var0_37 = var0_37 - 1

		if arg2_37 and var0_37 == 0 then
			onNextTick(function()
				arg2_37(arg0_38, arg1_38)
			end)
		end
	end

	local var2_37 = var13_0(arg1_37)

	if not var2_37 then
		var1_37(false)
		var11_0("not exist story file")

		return nil
	end

	if arg0_37:IsReView() then
		arg3_37 = true
	end

	arg0_37.storyScript = Story.New(var2_37, arg3_37, arg0_37.optionSelCodes, arg5_37, arg6_37)

	if not arg0_37:CheckState() then
		var11_0("story state error")
		var1_37(false)

		return nil
	end

	if not arg0_37.storyScript:CanPlay() then
		var11_0("story cant be played")
		var1_37(false)

		return nil
	end

	arg0_37:ExecuteScript(var1_37)
end

function var0_0.ExecuteScript(arg0_40, arg1_40)
	seriesAsync({
		function(arg0_41)
			arg0_40:CheckResDownload(arg0_40.storyScript, arg0_41)
		end,
		function(arg0_42)
			originalPrint("start load story window...")
			arg0_40:CheckAndLoadDialogue(arg0_40.storyScript, arg0_42)
		end
	}, function()
		originalPrint("enter story...")
		arg0_40:OnStart()

		local var0_43 = {}

		arg0_40.currPlayer = nil
		arg0_40.progress = 0

		for iter0_43, iter1_43 in ipairs(arg0_40.storyScript.steps) do
			table.insert(var0_43, function(arg0_44)
				arg0_40.progress = iter0_43

				arg0_40:SendNotification(GAME.STORY_NEXT)

				local var0_44 = arg0_40.players[iter1_43:GetMode()]

				arg0_40.currPlayer = var0_44

				var0_44:Play(arg0_40.storyScript, iter0_43, arg0_44)
			end)
		end

		seriesAsync(var0_43, function()
			arg0_40:OnEnd(arg1_40)
		end)
	end)
end

function var0_0.SendNotification(arg0_46, arg1_46, arg2_46)
	pg.m02:sendNotification(arg1_46, arg2_46)
end

function var0_0.CheckResDownload(arg0_47, arg1_47, arg2_47)
	local var0_47 = arg0_47:_GetStoryPaintingsByName(arg1_47)
	local var1_47 = table.concat(var0_47, ",")

	originalPrint("start download res " .. var1_47)

	local var2_47 = {}

	for iter0_47, iter1_47 in ipairs(var0_47) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var2_47, iter1_47)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var2_47,
		finishFunc = arg2_47
	})
end

local function var15_0(arg0_48, arg1_48)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_48, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_49)
		arg1_48(arg0_49)
	end), true, true)
end

function var0_0.CheckAndLoadDialogue(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg1_50:GetDialogueStyleName()

	if not arg0_50.dialogueContainer:Find(var0_50) then
		var15_0("NewStoryDialogue" .. var0_50, function(arg0_51)
			Object.Instantiate(arg0_51, arg0_50.dialogueContainer).name = var0_50

			arg2_50()
		end)
	else
		arg2_50()
	end
end

function var0_0.CheckState(arg0_52)
	if arg0_52.state == var3_0 or arg0_52.state == var1_0 or arg0_52.state == var4_0 then
		return false
	end

	return true
end

function var0_0.RegistSkipBtn(arg0_53)
	local function var0_53()
		arg0_53:TrackingSkip()
		arg0_53.storyScript:SkipAll()
		arg0_53.currPlayer:NextOneImmediately()
	end

	onButton(arg0_53, arg0_53.skipBtn, function()
		if arg0_53:IsStopping() or arg0_53:IsPausing() then
			return
		end

		if not arg0_53.currPlayer:CanSkip() then
			return
		end

		if arg0_53:IsReView() or arg0_53.storyScript:IsPlayed() or not arg0_53.storyScript:ShowSkipTip() then
			var0_53()

			return
		end

		arg0_53:Puase()

		arg0_53.isOpenMsgbox = true

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			parent = rtf(arg0_53._tf:Find("front")),
			content = i18n("story_skip_confirm"),
			onYes = function()
				arg0_53:Resume()
				var0_53()
			end,
			onNo = function()
				arg0_53.isOpenMsgbox = false

				arg0_53:Resume()
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
end

function var0_0.RegistAutoBtn(arg0_58)
	onButton(arg0_58, arg0_58.autoBtn, function()
		if arg0_58:IsStopping() or arg0_58:IsPausing() then
			return
		end

		if arg0_58.storyScript:GetAutoPlayFlag() then
			arg0_58.storyScript:StopAutoPlay()
			arg0_58.currPlayer:CancelAuto()
		else
			arg0_58.storyScript:SetAutoPlay()
			arg0_58.currPlayer:NextOne()
		end

		if arg0_58.storyScript then
			arg0_58:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	local var0_58 = arg0_58:IsAutoPlay()

	if var0_58 then
		arg0_58.storyScript:SetAutoPlay()
		arg0_58:UpdateAutoBtn()

		arg0_58.autoPlayFlag = false
	end

	arg0_58.banPlayFlag = false
	arg0_58.isAutoPlay = var0_58
end

function var0_0.RegistRecordBtn(arg0_60)
	onButton(arg0_60, arg0_60.recordBtn, function()
		if arg0_60.storyScript:GetAutoPlayFlag() then
			return
		end

		if not arg0_60.recordPanel:CanOpen() then
			return
		end

		local var0_61 = "Show"

		arg0_60.recordPanel[var0_61](arg0_60.recordPanel, arg0_60.recorder)
	end, SFX_PANEL)
end

function var0_0.TriggerAutoBtn(arg0_62)
	if not arg0_62:IsRunning() then
		return
	end

	triggerButton(arg0_62.autoBtn)
end

function var0_0.TriggerSkipBtn(arg0_63)
	if not arg0_63:IsRunning() then
		return
	end

	triggerButton(arg0_63.skipBtn)
end

function var0_0.ForEscPress(arg0_64)
	if arg0_64.recordPanel:IsShowing() then
		arg0_64.recordPanel:Hide()
	elseif arg0_64.currPlayer and arg0_64.currPlayer:WaitForEvent() or arg0_64.currPlayer and arg0_64.storyScript and arg0_64.storyScript.hideSkip then
		-- block empty
	else
		arg0_64:TriggerSkipBtn()
	end
end

function var0_0.UpdatePlaySpeed(arg0_65, arg1_65)
	if arg0_65:IsRunning() and arg0_65.storyScript then
		arg0_65.storyScript:SetPlaySpeed(arg1_65)
	end
end

function var0_0.GetPlaySpeed(arg0_66)
	if arg0_66:IsRunning() and arg0_66.storyScript then
		return arg0_66.storyScript:GetPlaySpeed()
	end
end

function var0_0.OnStart(arg0_67)
	arg0_67.recorder:Clear()
	removeOnButton(arg0_67._go)
	removeOnButton(arg0_67.skipBtn)
	removeOnButton(arg0_67.autoBtn)
	removeOnButton(arg0_67.recordBtn)

	arg0_67.alphaImage.color = Color(0, 0, 0, arg0_67.storyScript:GetStoryAlpha())

	setActive(arg0_67.recordBtn, not arg0_67.storyScript:ShouldHideRecord())
	arg0_67:ClearStoryEventTriggerListener()

	local var0_67 = arg0_67.storyScript:GetAllStepDispatcherRecallName()

	if #var0_67 > 0 then
		arg0_67.storyEventTriggerListener = StoryEventTriggerListener.New(var0_67)
	end

	arg0_67.state = var3_0

	arg0_67:TrackingStart()
	arg0_67:SendNotification(GAME.STORY_BEGIN, arg0_67.storyScript:GetName())
	arg0_67:SendNotification(GAME.STORY_UPDATE, {
		storyId = arg0_67.storyScript:GetName()
	})
	pg.DelegateInfo.New(arg0_67)

	for iter0_67, iter1_67 in ipairs(arg0_67.players) do
		iter1_67:StoryStart(arg0_67.storyScript)
	end

	setActive(arg0_67._go, true)
	arg0_67._tf:SetAsLastSibling()
	setActive(arg0_67.skipBtn, not arg0_67.storyScript:ShouldHideSkip())
	setActive(arg0_67.autoBtn, not arg0_67.storyScript:ShouldHideAutoBtn())

	arg0_67.bgmVolumeValue = pg.CriMgr.GetInstance():getBGMVolume()

	arg0_67:RegistSkipBtn()
	arg0_67:RegistAutoBtn()
	arg0_67:RegistRecordBtn()
end

function var0_0.TrackingStart(arg0_68)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return
	end

	arg0_68.trackFlag = false

	if not arg0_68.storyScript then
		return
	end

	local var0_68 = arg0_68:StoryName2StoryId(arg0_68.storyScript:GetName())

	if var0_68 and not arg0_68:GetPlayedFlag(var0_68) then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryStart(var0_68, 0))

		arg0_68.trackFlag = true
	end
end

function var0_0.TrackingSkip(arg0_69)
	if not arg0_69.trackFlag or not arg0_69.storyScript then
		return
	end

	local var0_69 = arg0_69:StoryName2StoryId(arg0_69.storyScript:GetName())

	if var0_69 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStorySkip(var0_69, arg0_69.progress or 0))
	end
end

function var0_0.TrackingOption(arg0_70, arg1_70, arg2_70)
	if not arg0_70.storyScript or not arg1_70 or not arg2_70 then
		return
	end

	local var0_70 = arg0_70:StoryName2StoryId(arg0_70.storyScript:GetName())

	if var0_70 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryOption(var0_70, arg1_70 .. "_" .. (arg2_70 or 0)))
	end
end

function var0_0.ClearStoryEvent(arg0_71)
	if arg0_71.storyEventTriggerListener then
		arg0_71.storyEventTriggerListener:Clear()
	end
end

function var0_0.CheckStoryEvent(arg0_72, arg1_72)
	if arg0_72.storyEventTriggerListener then
		return arg0_72.storyEventTriggerListener:ExistCache(arg1_72)
	end

	return false
end

function var0_0.GetStoryEventArg(arg0_73, arg1_73)
	if not arg0_73:CheckStoryEvent(arg1_73) then
		return nil
	end

	if arg0_73.storyEventTriggerListener and arg0_73.storyEventTriggerListener:ExistArg(arg1_73) then
		return arg0_73.storyEventTriggerListener:GetArg(arg1_73)
	end

	return nil
end

function var0_0.UpdateAutoBtn(arg0_74)
	local var0_74 = arg0_74.storyScript:GetAutoPlayFlag()

	arg0_74:ClearAutoBtn(var0_74)
end

function var0_0.ClearAutoBtn(arg0_75, arg1_75)
	arg0_75.autoBtnImg.color = arg1_75 and var8_0 or var9_0
	arg0_75.isAutoPlay = arg1_75

	local var0_75 = arg1_75 and "Show" or "Hide"

	arg0_75.setSpeedPanel[var0_75](arg0_75.setSpeedPanel)
end

function var0_0.ClearStoryEventTriggerListener(arg0_76)
	if arg0_76.storyEventTriggerListener then
		arg0_76.storyEventTriggerListener:Dispose()

		arg0_76.storyEventTriggerListener = nil
	end
end

function var0_0.Clear(arg0_77)
	arg0_77.progress = 0

	arg0_77:ClearStoryEventTriggerListener()
	arg0_77.recorder:Clear()
	arg0_77.recordPanel:Hide()

	arg0_77.autoPlayFlag = false
	arg0_77.banPlayFlag = false

	removeOnButton(arg0_77._go)
	removeOnButton(arg0_77.skipBtn)
	removeOnButton(arg0_77.recordBtn)
	removeOnButton(arg0_77.autoBtn)
	arg0_77:ClearAutoBtn(false)

	if isActive(arg0_77._go) then
		pg.DelegateInfo.Dispose(arg0_77)
	end

	if arg0_77.setSpeedPanel then
		arg0_77.setSpeedPanel:Clear()
	end

	setActive(arg0_77.skipBtn, false)
	setActive(arg0_77._go, false)

	for iter0_77, iter1_77 in ipairs(arg0_77.players) do
		iter1_77:StoryEnd(arg0_77.storyScript)
	end

	arg0_77.optionSelCodes = nil

	arg0_77:SendNotification(GAME.STORY_END)

	if arg0_77.isOpenMsgbox then
		pg.MsgboxMgr:GetInstance():hide()
	end

	arg0_77:RevertBgmVolumeValue()
end

function var0_0.RevertBgmVolumeValue(arg0_78)
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_78 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0_78.bgmVolumeValue and arg0_78.bgmVolumeValue ~= var0_78 then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_78.bgmVolumeValue)
	end

	arg0_78.bgmVolumeValue = nil
end

function var0_0.OnEnd(arg0_79, arg1_79)
	arg0_79:Clear()

	if arg0_79.state == var3_0 or arg0_79.state == var5_0 then
		arg0_79.state = var6_0

		local var0_79 = arg0_79.storyScript:GetNextScriptName()

		if var0_79 and not arg0_79:IsReView() then
			arg0_79.storyScript = nil

			arg0_79:Play(var0_79, arg1_79)
		else
			local var1_79 = arg0_79.storyScript:GetBranchCode()

			arg0_79.storyScript = nil

			if arg1_79 then
				arg1_79(true, var1_79)
			end
		end
	else
		arg0_79.state = var6_0

		local var2_79 = arg0_79.storyScript:GetBranchCode()

		if arg1_79 then
			arg1_79(true, var2_79)
		end
	end
end

function var0_0.OnSceneEnter(arg0_80, arg1_80)
	if not arg0_80.scenes then
		arg0_80.scenes = {}
	end

	arg0_80.scenes[arg1_80.view] = true
end

function var0_0.OnSceneExit(arg0_81, arg1_81)
	if not arg0_81.scenes then
		return
	end

	arg0_81.scenes[arg1_81.view] = nil
end

function var0_0.IsReView(arg0_82)
	local var0_82 = getProxy(ContextProxy):GetPrevContext(1)

	return arg0_82.scenes[WorldMediaCollectionScene.__cname] == true or var0_82 and var0_82.mediator == WorldMediaCollectionMediator
end

function var0_0.IsRunning(arg0_83)
	return arg0_83.state == var3_0
end

function var0_0.IsStopping(arg0_84)
	return arg0_84.state == var5_0
end

function var0_0.IsPausing(arg0_85)
	return arg0_85.state == var4_0
end

function var0_0.IsAutoPlay(arg0_86)
	if arg0_86.banPlayFlag then
		return false
	end

	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or arg0_86.autoPlayFlag == true
end

function var0_0.GetRectSize(arg0_87)
	return Vector2(arg0_87._tf.rect.width, arg0_87._tf.rect.height)
end

function var0_0.AddRecord(arg0_88, arg1_88)
	arg0_88.recorder:Add(arg1_88)
end

function var0_0.Quit(arg0_89)
	arg0_89.recorder:Dispose()
	arg0_89.recordPanel:Dispose()
	arg0_89.setSpeedPanel:Dispose()

	if arg0_89.currPlayer and arg0_89.currPlayer:WaitForEvent() then
		arg0_89:Clear()
	end

	arg0_89.state = var7_0
	arg0_89.storyScript = nil
	arg0_89.currPlayer = nil
	arg0_89.playQueue = {}
	arg0_89.playedList = {}
	arg0_89.scenes = {}
end

function var0_0.Fix(arg0_90)
	local var0_90 = getProxy(PlayerProxy):getRawData():GetRegisterTime()
	local var1_90 = pg.TimeMgr.GetInstance():parseTimeFromConfig({
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
	local var2_90 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if var0_90 <= var1_90 then
		_.each(var2_90, function(arg0_91)
			arg0_90.playedList[arg0_91] = true
		end)
	end

	local var3_90 = 5001
	local var4_90 = 5020
	local var5_90 = getProxy(TaskProxy)
	local var6_90 = 0

	for iter0_90 = var3_90, var4_90, -1 do
		if var5_90:getFinishTaskById(iter0_90) or var5_90:getTaskById(iter0_90) then
			var6_90 = iter0_90

			break
		end
	end

	for iter1_90 = var6_90, var4_90, -1 do
		local var7_90 = pg.task_data_template[iter1_90]

		if var7_90 then
			local var8_90 = var7_90.story_id

			if var8_90 and #var8_90 > 0 and not arg0_90:IsPlayed(var8_90) then
				arg0_90.playedList[var8_90] = true
			end
		end
	end

	local var9_90 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

	if var9_90 and not var9_90:isEnd() then
		local var10_90 = _.flatten(var9_90:getConfig("config_data"))
		local var11_90

		for iter2_90 = #var10_90, 1, -1 do
			local var12_90 = pg.task_data_template[var10_90[iter2_90]].story_id

			if var12_90 and #var12_90 > 0 then
				local var13_90 = arg0_90:IsPlayed(var12_90)

				if var11_90 then
					if not var13_90 then
						arg0_90.playedList[var12_90] = true
					end
				elseif var13_90 then
					var11_90 = iter2_90
				end
			end
		end
	end
end
