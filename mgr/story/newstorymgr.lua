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

function var0_0.Play(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24, arg5_24, arg6_24, arg7_24)
	table.insert(arg0_24.playQueue, {
		arg1_24,
		arg2_24,
		arg7_24
	})

	if #arg0_24.playQueue == 1 then
		local var0_24

		local function var1_24()
			if #arg0_24.playQueue == 0 then
				return
			end

			local var0_25 = arg0_24.playQueue[1][1]
			local var1_25 = arg0_24.playQueue[1][2]
			local var2_25 = arg0_24.playQueue[1][3]

			arg0_24:SoloPlay(var0_25, function(arg0_26, arg1_26)
				if var1_25 then
					var1_25(arg0_26, arg1_26)
				end

				table.remove(arg0_24.playQueue, 1)
				var1_24()
			end, arg3_24, arg4_24, arg5_24, arg6_24, var2_25)
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

function var0_0.PlayForTb(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30)
	arg0_30:Play(arg1_30, arg3_30, arg4_30, false, false, true, arg2_30)
end

function var0_0.PlayForWorld(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31, arg5_31, arg6_31, arg7_31, arg8_31)
	arg0_31.optionSelCodes = arg2_31 or {}
	arg0_31.autoPlayFlag = arg6_31

	arg0_31:Play(arg1_31, arg3_31, arg4_31, arg5_31, arg7_31, true, arg8_31)
end

function var0_0.ForceAutoPlay(arg0_32, arg1_32, arg2_32, arg3_32, arg4_32, arg5_32)
	arg0_32.autoPlayFlag = true

	local function var0_32(arg0_33, arg1_33)
		arg2_32(arg0_33, arg1_33, arg0_32.isAutoPlay)
	end

	arg0_32:Play(arg1_32, var0_32, arg3_32, arg4_32, true, false, arg5_32)
end

function var0_0.ForceManualPlay(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34, arg5_34)
	arg0_34.banPlayFlag = true

	local function var0_34(arg0_35, arg1_35)
		arg2_34(arg0_35, arg1_35, arg0_34.isAutoPlay)
	end

	arg0_34:Play(arg1_34, var0_34, arg3_34, arg4_34, true, false, arg5_34)
end

function var0_0.SeriesPlay(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36, arg5_36, arg6_36, arg7_36)
	local var0_36 = {}

	for iter0_36, iter1_36 in ipairs(arg1_36) do
		table.insert(var0_36, function(arg0_37)
			arg0_36:SoloPlay(iter1_36, arg0_37, arg3_36, arg4_36, arg5_36, arg6_36, arg7_36)
		end)
	end

	seriesAsync(var0_36, arg2_36)
end

function var0_0.SoloPlay(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38, arg5_38, arg6_38, arg7_38)
	var11_0("Play Story:", arg1_38)

	local var0_38 = 1

	local function var1_38(arg0_39, arg1_39)
		var0_38 = var0_38 - 1

		if arg2_38 and var0_38 == 0 then
			onNextTick(function()
				arg2_38(arg0_39, arg1_39)
			end)
		end
	end

	local var2_38 = var13_0(arg1_38)

	if not var2_38 then
		var1_38(false)
		var11_0("not exist story file")

		return nil
	end

	if arg0_38:IsReView() then
		arg3_38 = true
	end

	arg0_38.storyScript = Story.New(var2_38, arg3_38, arg0_38.optionSelCodes, arg5_38, arg6_38, arg7_38)

	if not arg0_38:CheckState() then
		var11_0("story state error")
		var1_38(false)

		return nil
	end

	if not arg0_38.storyScript:CanPlay() then
		var11_0("story cant be played")
		var1_38(false)

		return nil
	end

	arg0_38:ExecuteScript(var1_38)
end

function var0_0.ExecuteScript(arg0_41, arg1_41)
	seriesAsync({
		function(arg0_42)
			arg0_41:CheckResDownload(arg0_41.storyScript, arg0_42)
		end,
		function(arg0_43)
			originalPrint("start load story window...")
			arg0_41:CheckAndLoadDialogue(arg0_41.storyScript, arg0_43)
		end
	}, function()
		originalPrint("enter story...")
		arg0_41:OnStart()

		local var0_44 = {}

		arg0_41.currPlayer = nil
		arg0_41.progress = 0

		for iter0_44, iter1_44 in ipairs(arg0_41.storyScript.steps) do
			table.insert(var0_44, function(arg0_45)
				arg0_41.progress = iter0_44

				arg0_41:SendNotification(GAME.STORY_NEXT)

				local var0_45 = arg0_41.players[iter1_44:GetMode()]

				arg0_41.currPlayer = var0_45

				var0_45:Play(arg0_41.storyScript, iter0_44, arg0_45)
			end)
		end

		seriesAsync(var0_44, function()
			arg0_41:OnEnd(arg1_41)
		end)
	end)
end

function var0_0.SendNotification(arg0_47, arg1_47, arg2_47)
	pg.m02:sendNotification(arg1_47, arg2_47)
end

function var0_0.CheckResDownload(arg0_48, arg1_48, arg2_48)
	local var0_48 = arg0_48:_GetStoryPaintingsByName(arg1_48)
	local var1_48 = table.concat(var0_48, ",")

	originalPrint("start download res " .. var1_48)

	local var2_48 = {}

	for iter0_48, iter1_48 in ipairs(var0_48) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var2_48, iter1_48)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var2_48,
		finishFunc = arg2_48
	})
end

local function var15_0(arg0_49, arg1_49)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_49, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_50)
		arg1_49(arg0_50)
	end), true, true)
end

function var0_0.CheckAndLoadDialogue(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg1_51:GetDialogueStyleName()

	if not arg0_51.dialogueContainer:Find(var0_51) then
		var15_0("NewStoryDialogue" .. var0_51, function(arg0_52)
			Object.Instantiate(arg0_52, arg0_51.dialogueContainer).name = var0_51

			arg2_51()
		end)
	else
		arg2_51()
	end
end

function var0_0.CheckState(arg0_53)
	if arg0_53.state == var3_0 or arg0_53.state == var1_0 or arg0_53.state == var4_0 then
		return false
	end

	return true
end

function var0_0.RegistSkipBtn(arg0_54)
	local function var0_54()
		arg0_54:TrackingSkip()
		arg0_54.storyScript:SkipAll()
		arg0_54.currPlayer:NextOneImmediately()
	end

	onButton(arg0_54, arg0_54.skipBtn, function()
		if arg0_54:IsStopping() or arg0_54:IsPausing() then
			return
		end

		if not arg0_54.currPlayer:CanSkip() then
			return
		end

		if arg0_54:IsReView() or arg0_54.storyScript:IsPlayed() or not arg0_54.storyScript:ShowSkipTip() then
			var0_54()

			return
		end

		arg0_54:Puase()

		arg0_54.isOpenMsgbox = true

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			parent = rtf(arg0_54._tf:Find("front")),
			content = i18n("story_skip_confirm"),
			onYes = function()
				arg0_54:Resume()
				var0_54()
			end,
			onNo = function()
				arg0_54.isOpenMsgbox = false

				arg0_54:Resume()
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
end

function var0_0.RegistAutoBtn(arg0_59)
	onButton(arg0_59, arg0_59.autoBtn, function()
		if arg0_59:IsStopping() or arg0_59:IsPausing() then
			return
		end

		if arg0_59.storyScript:GetAutoPlayFlag() then
			arg0_59.storyScript:StopAutoPlay()
			arg0_59.currPlayer:CancelAuto()
		else
			arg0_59.storyScript:SetAutoPlay()
			arg0_59.currPlayer:NextOne()
		end

		if arg0_59.storyScript then
			arg0_59:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	local var0_59 = arg0_59:IsAutoPlay()

	if var0_59 then
		arg0_59.storyScript:SetAutoPlay()
		arg0_59:UpdateAutoBtn()

		arg0_59.autoPlayFlag = false
	end

	arg0_59.banPlayFlag = false
	arg0_59.isAutoPlay = var0_59
end

function var0_0.RegistRecordBtn(arg0_61)
	onButton(arg0_61, arg0_61.recordBtn, function()
		if arg0_61.storyScript:GetAutoPlayFlag() then
			return
		end

		if not arg0_61.recordPanel:CanOpen() then
			return
		end

		local var0_62 = "Show"

		arg0_61.recordPanel[var0_62](arg0_61.recordPanel, arg0_61.recorder)
	end, SFX_PANEL)
end

function var0_0.TriggerAutoBtn(arg0_63)
	if not arg0_63:IsRunning() then
		return
	end

	triggerButton(arg0_63.autoBtn)
end

function var0_0.TriggerSkipBtn(arg0_64)
	if not arg0_64:IsRunning() then
		return
	end

	triggerButton(arg0_64.skipBtn)
end

function var0_0.ForEscPress(arg0_65)
	if arg0_65.recordPanel:IsShowing() then
		arg0_65.recordPanel:Hide()
	elseif arg0_65.currPlayer and arg0_65.currPlayer:WaitForEvent() or arg0_65.currPlayer and arg0_65.storyScript and arg0_65.storyScript.hideSkip then
		-- block empty
	else
		arg0_65:TriggerSkipBtn()
	end
end

function var0_0.UpdatePlaySpeed(arg0_66, arg1_66)
	if arg0_66:IsRunning() and arg0_66.storyScript then
		arg0_66.storyScript:SetPlaySpeed(arg1_66)
	end
end

function var0_0.GetPlaySpeed(arg0_67)
	if arg0_67:IsRunning() and arg0_67.storyScript then
		return arg0_67.storyScript:GetPlaySpeed()
	end
end

function var0_0.OnStart(arg0_68)
	arg0_68.recorder:Clear()
	removeOnButton(arg0_68._go)
	removeOnButton(arg0_68.skipBtn)
	removeOnButton(arg0_68.autoBtn)
	removeOnButton(arg0_68.recordBtn)

	arg0_68.alphaImage.color = Color(0, 0, 0, arg0_68.storyScript:GetStoryAlpha())

	setActive(arg0_68.recordBtn, not arg0_68.storyScript:ShouldHideRecord())
	arg0_68:ClearStoryEventTriggerListener()

	local var0_68 = arg0_68.storyScript:GetAllStepDispatcherRecallName()

	if #var0_68 > 0 then
		arg0_68.storyEventTriggerListener = StoryEventTriggerListener.New(var0_68)
	end

	arg0_68.state = var3_0

	arg0_68:TrackingStart()
	arg0_68:SendNotification(GAME.STORY_BEGIN, arg0_68.storyScript:GetName())
	arg0_68:SendNotification(GAME.STORY_UPDATE, {
		storyId = arg0_68.storyScript:GetName()
	})
	pg.DelegateInfo.New(arg0_68)

	for iter0_68, iter1_68 in ipairs(arg0_68.players) do
		iter1_68:StoryStart(arg0_68.storyScript)
	end

	setActive(arg0_68._go, true)
	arg0_68._tf:SetAsLastSibling()
	setActive(arg0_68.skipBtn, not arg0_68.storyScript:ShouldHideSkip())
	setActive(arg0_68.autoBtn, not arg0_68.storyScript:ShouldHideAutoBtn())

	arg0_68.bgmVolumeValue = pg.CriMgr.GetInstance():getBGMVolume()

	arg0_68:RegistSkipBtn()
	arg0_68:RegistAutoBtn()
	arg0_68:RegistRecordBtn()
end

function var0_0.TrackingStart(arg0_69)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return
	end

	arg0_69.trackFlag = false

	if not arg0_69.storyScript then
		return
	end

	local var0_69 = arg0_69:StoryName2StoryId(arg0_69.storyScript:GetName())

	if var0_69 and not arg0_69:GetPlayedFlag(var0_69) then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryStart(var0_69, 0))

		arg0_69.trackFlag = true
	end
end

function var0_0.TrackingSkip(arg0_70)
	if not arg0_70.trackFlag or not arg0_70.storyScript then
		return
	end

	local var0_70 = arg0_70:StoryName2StoryId(arg0_70.storyScript:GetName())

	if var0_70 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStorySkip(var0_70, arg0_70.progress or 0))
	end
end

function var0_0.TrackingOption(arg0_71, arg1_71, arg2_71)
	if not arg0_71.storyScript or not arg1_71 or not arg2_71 then
		return
	end

	local var0_71 = arg0_71:StoryName2StoryId(arg0_71.storyScript:GetName())

	if var0_71 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryOption(var0_71, arg1_71 .. "_" .. (arg2_71 or 0)))
	end
end

function var0_0.ClearStoryEvent(arg0_72)
	if arg0_72.storyEventTriggerListener then
		arg0_72.storyEventTriggerListener:Clear()
	end
end

function var0_0.CheckStoryEvent(arg0_73, arg1_73)
	if arg0_73.storyEventTriggerListener then
		return arg0_73.storyEventTriggerListener:ExistCache(arg1_73)
	end

	return false
end

function var0_0.GetStoryEventArg(arg0_74, arg1_74)
	if not arg0_74:CheckStoryEvent(arg1_74) then
		return nil
	end

	if arg0_74.storyEventTriggerListener and arg0_74.storyEventTriggerListener:ExistArg(arg1_74) then
		return arg0_74.storyEventTriggerListener:GetArg(arg1_74)
	end

	return nil
end

function var0_0.UpdateAutoBtn(arg0_75)
	local var0_75 = arg0_75.storyScript:GetAutoPlayFlag()

	arg0_75:ClearAutoBtn(var0_75)
end

function var0_0.ClearAutoBtn(arg0_76, arg1_76)
	arg0_76.autoBtnImg.color = arg1_76 and var8_0 or var9_0
	arg0_76.isAutoPlay = arg1_76

	local var0_76 = arg1_76 and "Show" or "Hide"

	arg0_76.setSpeedPanel[var0_76](arg0_76.setSpeedPanel)
end

function var0_0.ClearStoryEventTriggerListener(arg0_77)
	if arg0_77.storyEventTriggerListener then
		arg0_77.storyEventTriggerListener:Dispose()

		arg0_77.storyEventTriggerListener = nil
	end
end

function var0_0.Clear(arg0_78)
	arg0_78.progress = 0

	arg0_78:ClearStoryEventTriggerListener()
	arg0_78.recorder:Clear()
	arg0_78.recordPanel:Hide()

	arg0_78.autoPlayFlag = false
	arg0_78.banPlayFlag = false

	removeOnButton(arg0_78._go)
	removeOnButton(arg0_78.skipBtn)
	removeOnButton(arg0_78.recordBtn)
	removeOnButton(arg0_78.autoBtn)
	arg0_78:ClearAutoBtn(false)

	if isActive(arg0_78._go) then
		pg.DelegateInfo.Dispose(arg0_78)
	end

	if arg0_78.setSpeedPanel then
		arg0_78.setSpeedPanel:Clear()
	end

	setActive(arg0_78.skipBtn, false)
	setActive(arg0_78._go, false)

	for iter0_78, iter1_78 in ipairs(arg0_78.players) do
		iter1_78:StoryEnd(arg0_78.storyScript)
	end

	arg0_78.optionSelCodes = nil

	arg0_78:SendNotification(GAME.STORY_END)

	if arg0_78.isOpenMsgbox then
		pg.MsgboxMgr:GetInstance():hide()
	end

	arg0_78:RevertBgmVolumeValue()
end

function var0_0.RevertBgmVolumeValue(arg0_79)
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_79 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0_79.bgmVolumeValue and arg0_79.bgmVolumeValue ~= var0_79 then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_79.bgmVolumeValue)
	end

	arg0_79.bgmVolumeValue = nil
end

function var0_0.OnEnd(arg0_80, arg1_80)
	arg0_80:Clear()

	if arg0_80.state == var3_0 or arg0_80.state == var5_0 then
		arg0_80.state = var6_0

		local var0_80 = arg0_80.storyScript:GetNextScriptName()

		if var0_80 and not arg0_80:IsReView() then
			arg0_80.storyScript = nil

			arg0_80:Play(var0_80, arg1_80)
		else
			local var1_80 = arg0_80.storyScript:GetBranchCode()

			arg0_80.storyScript = nil

			if arg1_80 then
				arg1_80(true, var1_80)
			end
		end
	else
		arg0_80.state = var6_0

		local var2_80 = arg0_80.storyScript:GetBranchCode()

		if arg1_80 then
			arg1_80(true, var2_80)
		end
	end
end

function var0_0.OnSceneEnter(arg0_81, arg1_81)
	if not arg0_81.scenes then
		arg0_81.scenes = {}
	end

	arg0_81.scenes[arg1_81.view] = true
end

function var0_0.OnSceneExit(arg0_82, arg1_82)
	if not arg0_82.scenes then
		return
	end

	arg0_82.scenes[arg1_82.view] = nil
end

function var0_0.IsReView(arg0_83)
	local var0_83 = getProxy(ContextProxy):GetPrevContext(1)

	return arg0_83.scenes[WorldMediaCollectionScene.__cname] == true or var0_83 and var0_83.mediator == WorldMediaCollectionMediator
end

function var0_0.IsRunning(arg0_84)
	return arg0_84.state == var3_0
end

function var0_0.IsStopping(arg0_85)
	return arg0_85.state == var5_0
end

function var0_0.IsPausing(arg0_86)
	return arg0_86.state == var4_0
end

function var0_0.IsAutoPlay(arg0_87)
	if arg0_87.banPlayFlag then
		return false
	end

	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or arg0_87.autoPlayFlag == true
end

function var0_0.GetRectSize(arg0_88)
	return Vector2(arg0_88._tf.rect.width, arg0_88._tf.rect.height)
end

function var0_0.AddRecord(arg0_89, arg1_89)
	arg0_89.recorder:Add(arg1_89)
end

function var0_0.Quit(arg0_90)
	arg0_90.recorder:Dispose()
	arg0_90.recordPanel:Dispose()
	arg0_90.setSpeedPanel:Dispose()

	if arg0_90.currPlayer and arg0_90.currPlayer:WaitForEvent() then
		arg0_90:Clear()
	end

	arg0_90.state = var7_0
	arg0_90.storyScript = nil
	arg0_90.currPlayer = nil
	arg0_90.playQueue = {}
	arg0_90.playedList = {}
	arg0_90.scenes = {}
end

function var0_0.Fix(arg0_91)
	local var0_91 = getProxy(PlayerProxy):getRawData():GetRegisterTime()
	local var1_91 = pg.TimeMgr.GetInstance():parseTimeFromConfig({
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
	local var2_91 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if var0_91 <= var1_91 then
		_.each(var2_91, function(arg0_92)
			arg0_91.playedList[arg0_92] = true
		end)
	end

	local var3_91 = 5001
	local var4_91 = 5020
	local var5_91 = getProxy(TaskProxy)
	local var6_91 = 0

	for iter0_91 = var3_91, var4_91, -1 do
		if var5_91:getFinishTaskById(iter0_91) or var5_91:getTaskById(iter0_91) then
			var6_91 = iter0_91

			break
		end
	end

	for iter1_91 = var6_91, var4_91, -1 do
		local var7_91 = pg.task_data_template[iter1_91]

		if var7_91 then
			local var8_91 = var7_91.story_id

			if var8_91 and #var8_91 > 0 and not arg0_91:IsPlayed(var8_91) then
				arg0_91.playedList[var8_91] = true
			end
		end
	end

	local var9_91 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

	if var9_91 and not var9_91:isEnd() then
		local var10_91 = _.flatten(var9_91:getConfig("config_data"))
		local var11_91

		for iter2_91 = #var10_91, 1, -1 do
			local var12_91 = pg.task_data_template[var10_91[iter2_91]].story_id

			if var12_91 and #var12_91 > 0 then
				local var13_91 = arg0_91:IsPlayed(var12_91)

				if var11_91 then
					if not var13_91 then
						arg0_91.playedList[var12_91] = true
					end
				elseif var13_91 then
					var11_91 = iter2_91
				end
			end
		end
	end
end
