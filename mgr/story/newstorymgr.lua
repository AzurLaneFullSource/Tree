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
	arg0_21.playedList = {}
	arg0_21.playQueue = {}

	PoolMgr.GetInstance():GetUI("NewStoryUI", true, function(arg0_22)
		arg0_21._go = arg0_22
		arg0_21._tf = tf(arg0_21._go)
		arg0_21.frontTr = findTF(arg0_21._tf, "front")
		arg0_21.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		arg0_21._go.transform:SetParent(arg0_21.UIOverlay.transform, false)

		arg0_21.skipBtn = findTF(arg0_21._tf, "front/btns/btns/skip_button")
		arg0_21.autoBtn = findTF(arg0_21._tf, "front/btns/btns/auto_button")
		arg0_21.autoBtnImg = findTF(arg0_21._tf, "front/btns/btns/auto_button/sel"):GetComponent(typeof(Image))
		arg0_21.alphaImage = arg0_21._tf:GetComponent(typeof(Image))
		arg0_21.recordBtn = findTF(arg0_21._tf, "front/btns/record")
		arg0_21.dialogueContainer = findTF(arg0_21._tf, "front/dialogue")
		arg0_21.players = {
			AsideStoryPlayer.New(arg0_22),
			DialogueStoryPlayer.New(arg0_22),
			BgStoryPlayer.New(arg0_22),
			CarouselPlayer.New(arg0_22),
			VedioStoryPlayer.New(arg0_22),
			CastStoryPlayer.New(arg0_22)
		}
		arg0_21.setSpeedPanel = StorySetSpeedPanel.New(arg0_21._tf)
		arg0_21.recordPanel = NewStoryRecordPanel.New()
		arg0_21.recorder = StoryRecorder.New()

		setActive(arg0_21._go, false)

		arg0_21.state = var2_0

		if arg1_21 then
			arg1_21()
		end
	end)
end

function var0_0.Play(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23, arg5_23, arg6_23)
	table.insert(arg0_23.playQueue, {
		arg1_23,
		arg2_23
	})

	if #arg0_23.playQueue == 1 then
		local var0_23

		local function var1_23()
			if #arg0_23.playQueue == 0 then
				return
			end

			local var0_24 = arg0_23.playQueue[1][1]
			local var1_24 = arg0_23.playQueue[1][2]

			arg0_23:SoloPlay(var0_24, function(arg0_25, arg1_25)
				if var1_24 then
					var1_24(arg0_25, arg1_25)
				end

				table.remove(arg0_23.playQueue, 1)
				var1_23()
			end, arg3_23, arg4_23, arg5_23, arg6_23)
		end

		var1_23()
	end
end

function var0_0.Puase(arg0_26)
	if arg0_26.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	arg0_26.state = var4_0

	for iter0_26, iter1_26 in ipairs(arg0_26.players) do
		iter1_26:Pause()
	end
end

function var0_0.Resume(arg0_27)
	if arg0_27.state ~= var4_0 then
		var11_0("state is not 'pause'")

		return
	end

	arg0_27.state = var3_0

	for iter0_27, iter1_27 in ipairs(arg0_27.players) do
		iter1_27:Resume()
	end
end

function var0_0.Stop(arg0_28)
	if arg0_28.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	arg0_28.state = var5_0

	for iter0_28, iter1_28 in ipairs(arg0_28.players) do
		iter1_28:Stop()
	end
end

function var0_0.PlayForWorld(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29, arg5_29, arg6_29, arg7_29)
	arg0_29.optionSelCodes = arg2_29 or {}
	arg0_29.autoPlayFlag = arg6_29

	arg0_29:Play(arg1_29, arg3_29, arg4_29, arg5_29, arg7_29, true)
end

function var0_0.ForceAutoPlay(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30)
	arg0_30.autoPlayFlag = true

	local function var0_30(arg0_31, arg1_31)
		arg2_30(arg0_31, arg1_31, arg0_30.isAutoPlay)
	end

	arg0_30:Play(arg1_30, var0_30, arg3_30, arg4_30, true)
end

function var0_0.ForceManualPlay(arg0_32, arg1_32, arg2_32, arg3_32, arg4_32)
	arg0_32.banPlayFlag = true

	local function var0_32(arg0_33, arg1_33)
		arg2_32(arg0_33, arg1_33, arg0_32.isAutoPlay)
	end

	arg0_32:Play(arg1_32, var0_32, arg3_32, arg4_32, true)
end

function var0_0.SeriesPlay(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34, arg5_34, arg6_34)
	local var0_34 = {}

	for iter0_34, iter1_34 in ipairs(arg1_34) do
		table.insert(var0_34, function(arg0_35)
			arg0_34:SoloPlay(iter1_34, arg0_35, arg3_34, arg4_34, arg5_34, arg6_34)
		end)
	end

	seriesAsync(var0_34, arg2_34)
end

function var0_0.SoloPlay(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36, arg5_36, arg6_36)
	var11_0("Play Story:", arg1_36)

	local var0_36 = 1

	local function var1_36(arg0_37, arg1_37)
		var0_36 = var0_36 - 1

		if arg2_36 and var0_36 == 0 then
			onNextTick(function()
				arg2_36(arg0_37, arg1_37)
			end)
		end
	end

	local var2_36 = var13_0(arg1_36)

	if not var2_36 then
		var1_36(false)
		var11_0("not exist story file")

		return nil
	end

	if arg0_36:IsReView() then
		arg3_36 = true
	end

	arg0_36.storyScript = Story.New(var2_36, arg3_36, arg0_36.optionSelCodes, arg5_36, arg6_36)

	if not arg0_36:CheckState() then
		var11_0("story state error")
		var1_36(false)

		return nil
	end

	if not arg0_36.storyScript:CanPlay() then
		var11_0("story cant be played")
		var1_36(false)

		return nil
	end

	seriesAsync({
		function(arg0_39)
			arg0_36:CheckResDownload(arg0_36.storyScript, arg0_39)
		end,
		function(arg0_40)
			originalPrint("start load story window...")
			arg0_36:CheckAndLoadDialogue(arg0_36.storyScript, arg0_40)
		end
	}, function()
		originalPrint("enter story...")
		arg0_36:OnStart()

		local var0_41 = {}

		arg0_36.currPlayer = nil

		for iter0_41, iter1_41 in ipairs(arg0_36.storyScript.steps) do
			table.insert(var0_41, function(arg0_42)
				pg.m02:sendNotification(GAME.STORY_NEXT)

				local var0_42 = arg0_36.players[iter1_41:GetMode()]

				arg0_36.currPlayer = var0_42

				var0_42:Play(arg0_36.storyScript, iter0_41, arg0_42)
			end)
		end

		seriesAsync(var0_41, function()
			arg0_36:OnEnd(var1_36)
		end)
	end)
end

function var0_0.CheckResDownload(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44:_GetStoryPaintingsByName(arg1_44)
	local var1_44 = table.concat(var0_44, ",")

	originalPrint("start download res " .. var1_44)

	local var2_44 = {}

	for iter0_44, iter1_44 in ipairs(var0_44) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var2_44, iter1_44)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var2_44,
		finishFunc = arg2_44
	})
end

local function var15_0(arg0_45, arg1_45)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_45, arg0_45, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_46)
		arg1_45(arg0_46)
	end), true, true)
end

function var0_0.CheckAndLoadDialogue(arg0_47, arg1_47, arg2_47)
	local var0_47 = arg1_47:GetDialogueStyleName()

	if not arg0_47.dialogueContainer:Find(var0_47) then
		var15_0("NewStoryDialogue" .. var0_47, function(arg0_48)
			Object.Instantiate(arg0_48, arg0_47.dialogueContainer).name = var0_47

			arg2_47()
		end)
	else
		arg2_47()
	end
end

function var0_0.CheckState(arg0_49)
	if arg0_49.state == var3_0 or arg0_49.state == var1_0 or arg0_49.state == var4_0 then
		return false
	end

	return true
end

function var0_0.RegistSkipBtn(arg0_50)
	local function var0_50()
		arg0_50:TrackingSkip()
		arg0_50.storyScript:SkipAll()
		arg0_50.currPlayer:NextOneImmediately()
	end

	onButton(arg0_50, arg0_50.skipBtn, function()
		if arg0_50:IsStopping() or arg0_50:IsPausing() then
			return
		end

		if not arg0_50.currPlayer:CanSkip() then
			return
		end

		if arg0_50:IsReView() or arg0_50.storyScript:IsPlayed() or not arg0_50.storyScript:ShowSkipTip() then
			var0_50()

			return
		end

		arg0_50:Puase()

		arg0_50.isOpenMsgbox = true

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			parent = rtf(arg0_50._tf:Find("front")),
			content = i18n("story_skip_confirm"),
			onYes = function()
				arg0_50:Resume()
				var0_50()
			end,
			onNo = function()
				arg0_50.isOpenMsgbox = false

				arg0_50:Resume()
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
end

function var0_0.RegistAutoBtn(arg0_55)
	onButton(arg0_55, arg0_55.autoBtn, function()
		if arg0_55:IsStopping() or arg0_55:IsPausing() then
			return
		end

		if arg0_55.storyScript:GetAutoPlayFlag() then
			arg0_55.storyScript:StopAutoPlay()
			arg0_55.currPlayer:CancelAuto()
		else
			arg0_55.storyScript:SetAutoPlay()
			arg0_55.currPlayer:NextOne()
		end

		if arg0_55.storyScript then
			arg0_55:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	local var0_55 = arg0_55:IsAutoPlay()

	if var0_55 then
		arg0_55.storyScript:SetAutoPlay()
		arg0_55:UpdateAutoBtn()

		arg0_55.autoPlayFlag = false
	end

	arg0_55.banPlayFlag = false
	arg0_55.isAutoPlay = var0_55
end

function var0_0.RegistRecordBtn(arg0_57)
	onButton(arg0_57, arg0_57.recordBtn, function()
		if arg0_57.storyScript:GetAutoPlayFlag() then
			return
		end

		if not arg0_57.recordPanel:CanOpen() then
			return
		end

		local var0_58 = "Show"

		arg0_57.recordPanel[var0_58](arg0_57.recordPanel, arg0_57.recorder)
	end, SFX_PANEL)
end

function var0_0.TriggerAutoBtn(arg0_59)
	if not arg0_59:IsRunning() then
		return
	end

	triggerButton(arg0_59.autoBtn)
end

function var0_0.TriggerSkipBtn(arg0_60)
	if not arg0_60:IsRunning() then
		return
	end

	triggerButton(arg0_60.skipBtn)
end

function var0_0.ForEscPress(arg0_61)
	if arg0_61.recordPanel:IsShowing() then
		arg0_61.recordPanel:Hide()
	else
		arg0_61:TriggerSkipBtn()
	end
end

function var0_0.UpdatePlaySpeed(arg0_62, arg1_62)
	if arg0_62:IsRunning() and arg0_62.storyScript then
		arg0_62.storyScript:SetPlaySpeed(arg1_62)
	end
end

function var0_0.GetPlaySpeed(arg0_63)
	if arg0_63:IsRunning() and arg0_63.storyScript then
		return arg0_63.storyScript:GetPlaySpeed()
	end
end

function var0_0.OnStart(arg0_64)
	arg0_64.recorder:Clear()
	removeOnButton(arg0_64._go)
	removeOnButton(arg0_64.skipBtn)
	removeOnButton(arg0_64.autoBtn)
	removeOnButton(arg0_64.recordBtn)

	arg0_64.alphaImage.color = Color(0, 0, 0, arg0_64.storyScript:GetStoryAlpha())

	setActive(arg0_64.recordBtn, not arg0_64.storyScript:ShouldHideRecord())
	arg0_64:ClearStoryEventTriggerListener()

	local var0_64 = arg0_64.storyScript:GetAllStepDispatcherRecallName()

	if #var0_64 > 0 then
		arg0_64.storyEventTriggerListener = StoryEventTriggerListener.New(var0_64)
	end

	arg0_64.state = var3_0

	arg0_64:TrackingStart()
	pg.m02:sendNotification(GAME.STORY_BEGIN, arg0_64.storyScript:GetName())
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg0_64.storyScript:GetName()
	})
	pg.DelegateInfo.New(arg0_64)

	for iter0_64, iter1_64 in ipairs(arg0_64.players) do
		iter1_64:StoryStart(arg0_64.storyScript)
	end

	setActive(arg0_64._go, true)
	arg0_64._tf:SetAsLastSibling()
	setActive(arg0_64.skipBtn, not arg0_64.storyScript:ShouldHideSkip())
	setActive(arg0_64.autoBtn, not arg0_64.storyScript:ShouldHideAutoBtn())

	arg0_64.bgmVolumeValue = pg.CriMgr.GetInstance():getBGMVolume()

	arg0_64:RegistSkipBtn()
	arg0_64:RegistAutoBtn()
	arg0_64:RegistRecordBtn()
end

function var0_0.TrackingStart(arg0_65)
	arg0_65.trackFlag = false

	if not arg0_65.storyScript then
		return
	end

	local var0_65 = arg0_65:StoryName2StoryId(arg0_65.storyScript:GetName())

	if not arg0_65:GetPlayedFlag(var0_65) then
		TrackConst.StoryStart(var0_65)

		arg0_65.trackFlag = true
	end
end

function var0_0.TrackingSkip(arg0_66)
	if not arg0_66.trackFlag or not arg0_66.storyScript then
		return
	end

	local var0_66 = arg0_66:StoryName2StoryId(arg0_66.storyScript:GetName())

	TrackConst.StorySkip(var0_66)
end

function var0_0.ClearStoryEvent(arg0_67)
	if arg0_67.storyEventTriggerListener then
		arg0_67.storyEventTriggerListener:Clear()
	end
end

function var0_0.CheckStoryEvent(arg0_68, arg1_68)
	if arg0_68.storyEventTriggerListener then
		return arg0_68.storyEventTriggerListener:ExistCache(arg1_68)
	end

	return false
end

function var0_0.GetStoryEventArg(arg0_69, arg1_69)
	if not arg0_69:CheckStoryEvent(arg1_69) then
		return nil
	end

	if arg0_69.storyEventTriggerListener and arg0_69.storyEventTriggerListener:ExistArg(arg1_69) then
		return arg0_69.storyEventTriggerListener:GetArg(arg1_69)
	end

	return nil
end

function var0_0.UpdateAutoBtn(arg0_70)
	local var0_70 = arg0_70.storyScript:GetAutoPlayFlag()

	arg0_70:ClearAutoBtn(var0_70)
end

function var0_0.ClearAutoBtn(arg0_71, arg1_71)
	arg0_71.autoBtnImg.color = arg1_71 and var8_0 or var9_0
	arg0_71.isAutoPlay = arg1_71

	local var0_71 = arg1_71 and "Show" or "Hide"

	arg0_71.setSpeedPanel[var0_71](arg0_71.setSpeedPanel)
end

function var0_0.ClearStoryEventTriggerListener(arg0_72)
	if arg0_72.storyEventTriggerListener then
		arg0_72.storyEventTriggerListener:Dispose()

		arg0_72.storyEventTriggerListener = nil
	end
end

function var0_0.Clear(arg0_73)
	arg0_73:ClearStoryEventTriggerListener()
	arg0_73.recorder:Clear()
	arg0_73.recordPanel:Hide()

	arg0_73.autoPlayFlag = false
	arg0_73.banPlayFlag = false

	removeOnButton(arg0_73._go)
	removeOnButton(arg0_73.skipBtn)
	removeOnButton(arg0_73.recordBtn)
	removeOnButton(arg0_73.autoBtn)
	arg0_73:ClearAutoBtn(false)

	if isActive(arg0_73._go) then
		pg.DelegateInfo.Dispose(arg0_73)
	end

	if arg0_73.setSpeedPanel then
		arg0_73.setSpeedPanel:Clear()
	end

	setActive(arg0_73.skipBtn, false)
	setActive(arg0_73._go, false)

	for iter0_73, iter1_73 in ipairs(arg0_73.players) do
		iter1_73:StoryEnd(arg0_73.storyScript)
	end

	arg0_73.optionSelCodes = nil

	pg.BgmMgr.GetInstance():ContinuePlay()
	pg.m02:sendNotification(GAME.STORY_END)

	if arg0_73.isOpenMsgbox then
		pg.MsgboxMgr:GetInstance():hide()
	end

	local var0_73 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0_73.bgmVolumeValue and arg0_73.bgmVolumeValue ~= var0_73 then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_73.bgmVolumeValue)
	end

	arg0_73.bgmVolumeValue = nil
end

function var0_0.OnEnd(arg0_74, arg1_74)
	arg0_74:Clear()

	if arg0_74.state == var3_0 or arg0_74.state == var5_0 then
		arg0_74.state = var6_0

		local var0_74 = arg0_74.storyScript:GetNextScriptName()

		if var0_74 and not arg0_74:IsReView() then
			arg0_74.storyScript = nil

			arg0_74:Play(var0_74, arg1_74)
		else
			local var1_74 = arg0_74.storyScript:GetBranchCode()

			arg0_74.storyScript = nil

			if arg1_74 then
				arg1_74(true, var1_74)
			end
		end
	else
		arg0_74.state = var6_0

		local var2_74 = arg0_74.storyScript:GetBranchCode()

		if arg1_74 then
			arg1_74(true, var2_74)
		end
	end
end

function var0_0.OnSceneEnter(arg0_75, arg1_75)
	if not arg0_75.scenes then
		arg0_75.scenes = {}
	end

	arg0_75.scenes[arg1_75.view] = true
end

function var0_0.OnSceneExit(arg0_76, arg1_76)
	if not arg0_76.scenes then
		return
	end

	arg0_76.scenes[arg1_76.view] = nil
end

function var0_0.IsReView(arg0_77)
	local var0_77 = getProxy(ContextProxy):GetPrevContext(1)

	return arg0_77.scenes[WorldMediaCollectionScene.__cname] == true or var0_77 and var0_77.mediator == WorldMediaCollectionMediator
end

function var0_0.IsRunning(arg0_78)
	return arg0_78.state == var3_0
end

function var0_0.IsStopping(arg0_79)
	return arg0_79.state == var5_0
end

function var0_0.IsPausing(arg0_80)
	return arg0_80.state == var4_0
end

function var0_0.IsAutoPlay(arg0_81)
	if arg0_81.banPlayFlag then
		return false
	end

	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or arg0_81.autoPlayFlag == true
end

function var0_0.GetRectSize(arg0_82)
	return Vector2(arg0_82._tf.rect.width, arg0_82._tf.rect.height)
end

function var0_0.AddRecord(arg0_83, arg1_83)
	arg0_83.recorder:Add(arg1_83)
end

function var0_0.Quit(arg0_84)
	arg0_84.recorder:Dispose()
	arg0_84.recordPanel:Dispose()
	arg0_84.setSpeedPanel:Dispose()

	arg0_84.state = var7_0
	arg0_84.storyScript = nil
	arg0_84.playQueue = {}
	arg0_84.playedList = {}
	arg0_84.scenes = {}
end

function var0_0.Fix(arg0_85)
	local var0_85 = getProxy(PlayerProxy):getRawData():GetRegisterTime()
	local var1_85 = pg.TimeMgr.GetInstance():parseTimeFromConfig({
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
	local var2_85 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if var0_85 <= var1_85 then
		_.each(var2_85, function(arg0_86)
			arg0_85.playedList[arg0_86] = true
		end)
	end

	local var3_85 = 5001
	local var4_85 = 5020
	local var5_85 = getProxy(TaskProxy)
	local var6_85 = 0

	for iter0_85 = var3_85, var4_85, -1 do
		if var5_85:getFinishTaskById(iter0_85) or var5_85:getTaskById(iter0_85) then
			var6_85 = iter0_85

			break
		end
	end

	for iter1_85 = var6_85, var4_85, -1 do
		local var7_85 = pg.task_data_template[iter1_85]

		if var7_85 then
			local var8_85 = var7_85.story_id

			if var8_85 and #var8_85 > 0 and not arg0_85:IsPlayed(var8_85) then
				arg0_85.playedList[var8_85] = true
			end
		end
	end

	local var9_85 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

	if var9_85 and not var9_85:isEnd() then
		local var10_85 = _.flatten(var9_85:getConfig("config_data"))
		local var11_85

		for iter2_85 = #var10_85, 1, -1 do
			local var12_85 = pg.task_data_template[var10_85[iter2_85]].story_id

			if var12_85 and #var12_85 > 0 then
				local var13_85 = arg0_85:IsPlayed(var12_85)

				if var11_85 then
					if not var13_85 then
						arg0_85.playedList[var12_85] = true
					end
				elseif var13_85 then
					var11_85 = iter2_85
				end
			end
		end
	end
end
