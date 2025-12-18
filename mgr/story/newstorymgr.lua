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

function var0_0.SeriesPlay(arg0_45, arg1_45, arg2_45, arg3_45, arg4_45, arg5_45, arg6_45, arg7_45)
	local var0_45 = {}

	for iter0_45, iter1_45 in ipairs(arg1_45) do
		table.insert(var0_45, function(arg0_46)
			arg0_45:SoloPlay(iter1_45, arg0_46, arg3_45, arg4_45, arg5_45, arg6_45, arg7_45)
		end)
	end

	seriesAsync(var0_45, arg2_45)
end

function var0_0.SoloPlay(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47, arg5_47, arg6_47, arg7_47)
	var11_0("Play Story:", arg1_47)

	local var0_47 = 1

	local function var1_47(arg0_48, arg1_48)
		var0_47 = var0_47 - 1

		if arg2_47 and var0_47 == 0 then
			onNextTick(function()
				arg2_47(arg0_48, arg1_48)
			end)
		end
	end

	local var2_47 = var13_0(arg1_47)

	if not var2_47 then
		var1_47(false)
		var11_0("not exist story file")

		return nil
	end

	if arg0_47:IsReView() then
		arg3_47 = true
	end

	arg0_47.storyScript = Story.New(var2_47, arg3_47, arg0_47.optionSelCodes, arg5_47, arg6_47, arg7_47)

	if not arg0_47:CheckState() then
		var11_0("story state error")
		var1_47(false)

		return nil
	end

	if not arg0_47.storyScript:CanPlay() then
		var11_0("story cant be played")
		var1_47(false)

		return nil
	end

	arg0_47:ExecuteScript(var1_47)
end

function var0_0.ExecuteScript(arg0_50, arg1_50)
	seriesAsync({
		function(arg0_51)
			arg0_50:CheckResDownload(arg0_50.storyScript, arg0_51)
		end,
		function(arg0_52)
			originalPrint("start load story window...")
			arg0_50:CheckAndLoadDialogue(arg0_50.storyScript, arg0_52)
		end
	}, function()
		originalPrint("enter story...")
		arg0_50:OnStart()

		local var0_53 = {}

		arg0_50.currPlayer = nil
		arg0_50.progress = 0

		for iter0_53, iter1_53 in ipairs(arg0_50.storyScript.steps) do
			table.insert(var0_53, function(arg0_54)
				arg0_50.progress = iter0_53

				arg0_50:SendNotification(GAME.STORY_NEXT)

				local var0_54 = arg0_50.players[iter1_53:GetMode()]

				arg0_50.currPlayer = var0_54

				var0_54:Play(arg0_50.storyScript, iter0_53, arg0_54)
			end)
		end

		seriesAsync(var0_53, function()
			arg0_50:OnEnd(arg1_50)
		end)
	end)
end

function var0_0.SendNotification(arg0_56, arg1_56, arg2_56)
	pg.m02:sendNotification(arg1_56, arg2_56)
end

function var0_0.CheckResDownload(arg0_57, arg1_57, arg2_57)
	local var0_57 = arg0_57:_GetStoryPaintingsByName(arg1_57)
	local var1_57 = table.concat(var0_57, ",")

	originalPrint("start download res " .. var1_57)

	local var2_57 = {}

	for iter0_57, iter1_57 in ipairs(var0_57) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var2_57, iter1_57)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var2_57,
		finishFunc = arg2_57
	})
end

local function var15_0(arg0_58, arg1_58)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_58, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_59)
		arg1_58(arg0_59)
	end), true, true)
end

function var0_0.CheckAndLoadDialogue(arg0_60, arg1_60, arg2_60)
	local var0_60 = arg1_60:GetDialogueStyleName()

	if not arg0_60.dialogueContainer:Find(var0_60) then
		var15_0("NewStoryDialogue" .. var0_60, function(arg0_61)
			Object.Instantiate(arg0_61, arg0_60.dialogueContainer).name = var0_60

			arg2_60()
		end)
	else
		arg2_60()
	end
end

function var0_0.CheckState(arg0_62)
	if arg0_62.state == var3_0 or arg0_62.state == var1_0 or arg0_62.state == var4_0 then
		return false
	end

	return true
end

function var0_0.RegistSkipBtn(arg0_63)
	local function var0_63()
		arg0_63:TrackingSkip()
		arg0_63.storyScript:SkipAll()
		arg0_63.currPlayer:NextOneImmediately()
	end

	onButton(arg0_63, arg0_63.skipBtn, function()
		if arg0_63:IsStopping() or arg0_63:IsPausing() then
			return
		end

		if not arg0_63.currPlayer:CanSkip() then
			return
		end

		if arg0_63:IsReView() or arg0_63.storyScript:IsPlayed() or not arg0_63.storyScript:ShowSkipTip() then
			var0_63()

			return
		end

		arg0_63:Pause()

		arg0_63.isOpenMsgbox = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			parent = rtf(arg0_63._tf:Find("front")),
			content = i18n("story_skip_confirm"),
			onYes = function()
				arg0_63:Resume()
				var0_63()
			end,
			onNo = function()
				arg0_63.isOpenMsgbox = false

				arg0_63:Resume()
			end
		})
	end, SFX_PANEL)
end

function var0_0.RegistAutoBtn(arg0_68)
	onButton(arg0_68, arg0_68.autoBtn, function()
		if arg0_68:IsStopping() or arg0_68:IsPausing() then
			return
		end

		if arg0_68.storyScript:GetAutoPlayFlag() then
			arg0_68.storyScript:StopAutoPlay()
			arg0_68.currPlayer:CancelAuto()
		else
			arg0_68.storyScript:SetAutoPlay()
			arg0_68.currPlayer:NextOne()
		end

		if arg0_68.storyScript then
			arg0_68:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	local var0_68 = arg0_68:IsAutoPlay()

	if var0_68 then
		arg0_68.storyScript:SetAutoPlay()
		arg0_68:UpdateAutoBtn()

		arg0_68.autoPlayFlag = false
	end

	arg0_68.banPlayFlag = false
	arg0_68.isAutoPlay = var0_68
end

function var0_0.RegistRecordBtn(arg0_70)
	onButton(arg0_70, arg0_70.recordBtn, function()
		if arg0_70.storyScript:GetAutoPlayFlag() then
			return
		end

		if not arg0_70.recordPanel:CanOpen() then
			return
		end

		local var0_71 = "Show"

		arg0_70.recordPanel[var0_71](arg0_70.recordPanel, arg0_70.recorder)
	end, SFX_PANEL)
end

function var0_0.TriggerAutoBtn(arg0_72)
	if not arg0_72:IsRunning() then
		return
	end

	triggerButton(arg0_72.autoBtn)
end

function var0_0.TriggerSkipBtn(arg0_73)
	if not arg0_73:IsRunning() then
		return
	end

	triggerButton(arg0_73.skipBtn)
end

function var0_0.ForEscPress(arg0_74)
	if arg0_74.recordPanel:IsShowing() then
		arg0_74.recordPanel:Hide()
	elseif arg0_74.currPlayer and arg0_74.currPlayer:WaitForEvent() or arg0_74.currPlayer and arg0_74.storyScript and arg0_74.storyScript.hideSkip then
		-- block empty
	else
		arg0_74:TriggerSkipBtn()
	end
end

function var0_0.UpdatePlaySpeed(arg0_75, arg1_75)
	if arg0_75:IsRunning() and arg0_75.storyScript then
		arg0_75.storyScript:SetPlaySpeed(arg1_75)
	end
end

function var0_0.GetPlaySpeed(arg0_76)
	if arg0_76:IsRunning() and arg0_76.storyScript then
		return arg0_76.storyScript:GetPlaySpeed()
	end
end

function var0_0.OnStart(arg0_77)
	arg0_77.recorder:Clear()
	removeOnButton(arg0_77._go)
	removeOnButton(arg0_77.skipBtn)
	removeOnButton(arg0_77.autoBtn)
	removeOnButton(arg0_77.recordBtn)

	arg0_77.mainImage.color = Color(0, 0, 0, arg0_77.storyScript:GetStoryAlpha())

	setActive(arg0_77.recordBtn, not arg0_77.storyScript:ShouldHideRecord())
	arg0_77:ClearStoryEventTriggerListener()

	local var0_77 = arg0_77.storyScript:GetAllStepDispatcherRecallName()

	if #var0_77 > 0 then
		arg0_77.storyEventTriggerListener = StoryEventTriggerListener.New(var0_77)
	end

	arg0_77.mainImage.enabled = not arg0_77.storyScript:CanInteraction()
	arg0_77.state = var3_0

	arg0_77:TrackingStart()
	arg0_77:SendNotification(GAME.STORY_BEGIN, arg0_77.storyScript:GetName())

	if not arg0_77:IsReView() then
		arg0_77:SendNotification(GAME.STORY_UPDATE, {
			storyId = arg0_77.storyScript:GetName()
		})
	end

	pg.DelegateInfo.New(arg0_77)

	for iter0_77, iter1_77 in ipairs(arg0_77.players) do
		iter1_77:StoryStart(arg0_77.storyScript)
	end

	setActive(arg0_77._go, true)
	arg0_77._tf:SetAsLastSibling()
	setActive(arg0_77.skipBtn, not arg0_77.storyScript:ShouldHideSkip())
	setActive(arg0_77.autoBtn, not arg0_77.storyScript:ShouldHideAutoBtn())

	arg0_77.bgmVolumeValue = pg.CriMgr.GetInstance():getBGMVolume()

	arg0_77:RegistSkipBtn()
	arg0_77:RegistAutoBtn()
	arg0_77:RegistRecordBtn()
	arg0_77:RegistHideUIBtn()
end

function var0_0.RegistHideUIBtn(arg0_78)
	onButton(arg0_78, arg0_78.hideUIBtn, function()
		if arg0_78.storyScript:GetAutoPlayFlag() then
			arg0_78.storyScript:StopAutoPlay()
			arg0_78.currPlayer:CancelAuto()
			arg0_78:UpdateAutoBtn()
		end

		setActiveByCanvasGroup(arg0_78.frontTr, false)
		setActive(arg0_78.frontEvtTr, true)
	end, SFX_PANEL)
	onButton(arg0_78, arg0_78.frontEvtTr, function()
		setActiveByCanvasGroup(arg0_78.frontTr, true)
		setActive(arg0_78.frontEvtTr, false)
	end, SFX_PANEL)
end

function var0_0.TrackingStart(arg0_81)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return
	end

	arg0_81.trackFlag = false

	if not arg0_81.storyScript then
		return
	end

	local var0_81 = arg0_81:StoryName2StoryId(arg0_81.storyScript:GetName())

	if var0_81 and not arg0_81:GetPlayedFlag(var0_81) then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryStart(var0_81, 0))

		arg0_81.trackFlag = true
	end
end

function var0_0.TrackingSkip(arg0_82)
	if not arg0_82.trackFlag or not arg0_82.storyScript then
		return
	end

	local var0_82 = arg0_82:StoryName2StoryId(arg0_82.storyScript:GetName())

	if var0_82 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStorySkip(var0_82, arg0_82.progress or 0))
	end
end

function var0_0.TrackingOption(arg0_83, arg1_83, arg2_83)
	if not arg0_83.storyScript or not arg1_83 or not arg2_83 then
		return
	end

	local var0_83 = arg0_83:StoryName2StoryId(arg0_83.storyScript:GetName())

	if var0_83 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryOption(var0_83, arg1_83 .. "_" .. (arg2_83 or 0)))
	end
end

function var0_0.ClearStoryEvent(arg0_84)
	if arg0_84.storyEventTriggerListener then
		arg0_84.storyEventTriggerListener:Clear()
	end
end

function var0_0.CheckStoryEvent(arg0_85, arg1_85)
	if arg0_85.storyEventTriggerListener then
		return arg0_85.storyEventTriggerListener:ExistCache(arg1_85)
	end

	return false
end

function var0_0.GetStoryEventArg(arg0_86, arg1_86)
	if not arg0_86:CheckStoryEvent(arg1_86) then
		return nil
	end

	if arg0_86.storyEventTriggerListener and arg0_86.storyEventTriggerListener:ExistArg(arg1_86) then
		return arg0_86.storyEventTriggerListener:GetArg(arg1_86)
	end

	return nil
end

function var0_0.UpdateAutoBtn(arg0_87)
	local var0_87 = arg0_87.storyScript:GetAutoPlayFlag()

	arg0_87:ClearAutoBtn(var0_87)
end

function var0_0.ClearAutoBtn(arg0_88, arg1_88)
	arg0_88.autoBtnImg.color = arg1_88 and var8_0 or var9_0
	arg0_88.isAutoPlay = arg1_88

	local var0_88 = arg1_88 and "Show" or "Hide"

	arg0_88.setSpeedPanel[var0_88](arg0_88.setSpeedPanel, arg0_88.storyScript)
end

function var0_0.ClearStoryEventTriggerListener(arg0_89)
	if arg0_89.storyEventTriggerListener then
		arg0_89.storyEventTriggerListener:Dispose()

		arg0_89.storyEventTriggerListener = nil
	end
end

function var0_0.Clear(arg0_90)
	arg0_90.progress = 0

	arg0_90:ClearStoryEventTriggerListener()

	arg0_90.mainImage.enabled = true

	arg0_90.recorder:Clear()
	arg0_90.recordPanel:Hide()

	arg0_90.autoPlayFlag = false
	arg0_90.banPlayFlag = false

	removeOnButton(arg0_90._go)
	removeOnButton(arg0_90.skipBtn)
	removeOnButton(arg0_90.recordBtn)
	removeOnButton(arg0_90.autoBtn)
	removeOnButton(arg0_90.hideUIBtn)
	removeOnButton(arg0_90.frontEvtTr)
	arg0_90:ClearAutoBtn(false)

	if isActive(arg0_90._go) then
		pg.DelegateInfo.Dispose(arg0_90)
	end

	if arg0_90.setSpeedPanel then
		arg0_90.setSpeedPanel:Clear()
	end

	setActive(arg0_90.skipBtn, false)
	setActive(arg0_90._go, false)

	arg0_90.branchSelectCache = {}

	_.each(arg0_90.players, function(arg0_91)
		for iter0_91, iter1_91 in pairs(arg0_91.branchCodeList) do
			_.each(iter1_91, function(arg0_92)
				table.insert(arg0_90.branchSelectCache, arg0_92)
			end)
		end
	end)

	for iter0_90, iter1_90 in ipairs(arg0_90.players) do
		iter1_90:StoryEnd(arg0_90.storyScript)
	end

	arg0_90.optionSelCodes = nil

	arg0_90:SendNotification(GAME.STORY_END)

	if arg0_90.isOpenMsgbox then
		pg.MsgboxMgr.GetInstance():hide()
	end

	arg0_90:RevertBgmVolumeValue()
end

function var0_0.RevertBgmVolumeValue(arg0_93)
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_93 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0_93.bgmVolumeValue and arg0_93.bgmVolumeValue ~= var0_93 then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_93.bgmVolumeValue)
	end

	arg0_93.bgmVolumeValue = nil
end

function var0_0.OnEnd(arg0_94, arg1_94)
	arg0_94:Clear()

	if arg0_94.state == var3_0 or arg0_94.state == var5_0 then
		arg0_94.state = var6_0

		local var0_94 = arg0_94.storyScript:GetNextScriptName()

		if var0_94 and not arg0_94:IsReView() then
			arg0_94.storyScript = nil

			arg0_94:SoloPlay(var0_94, arg1_94, true)
		else
			local var1_94 = arg0_94.storyScript:GetBranchCode()

			arg0_94.storyScript = nil

			if arg1_94 then
				arg1_94(true, var1_94)
			end
		end
	else
		arg0_94.state = var6_0

		local var2_94 = arg0_94.storyScript:GetBranchCode()

		if arg1_94 then
			arg1_94(true, var2_94)
		end
	end
end

function var0_0.OnSceneEnter(arg0_95, arg1_95)
	if not arg0_95.scenes then
		arg0_95.scenes = {}
	end

	arg0_95.scenes[arg1_95.view] = true
end

function var0_0.OnSceneExit(arg0_96, arg1_96)
	if not arg0_96.scenes then
		return
	end

	arg0_96.scenes[arg1_96.view] = nil
end

function var0_0.IsReView(arg0_97)
	if getProxy(ContextProxy) == nil then
		return false
	end

	local var0_97 = getProxy(ContextProxy):GetPrevContext(1)

	return arg0_97.scenes[WorldMediaCollectionScene.__cname] == true or var0_97 and var0_97.mediator == WorldMediaCollectionMediator
end

function var0_0.IsRunning(arg0_98)
	return arg0_98.state == var3_0
end

function var0_0.IsStopping(arg0_99)
	return arg0_99.state == var5_0
end

function var0_0.IsPausing(arg0_100)
	return arg0_100.state == var4_0
end

function var0_0.IsAutoPlay(arg0_101)
	if arg0_101.banPlayFlag then
		return false
	end

	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or arg0_101.autoPlayFlag == true
end

function var0_0.GetRectSize(arg0_102)
	return Vector2(arg0_102._tf.rect.width, arg0_102._tf.rect.height)
end

function var0_0.AddRecord(arg0_103, arg1_103)
	arg0_103.recorder:Add(arg1_103)
end

function var0_0.Quit(arg0_104)
	arg0_104.recorder:Dispose()
	arg0_104.recordPanel:Dispose()
	arg0_104.setSpeedPanel:Dispose()

	if arg0_104.currPlayer and arg0_104.currPlayer:WaitForEvent() then
		arg0_104:Clear()
	end

	arg0_104.state = var7_0
	arg0_104.storyScript = nil
	arg0_104.currPlayer = nil
	arg0_104.playQueue = {}
	arg0_104.playedList = {}
	arg0_104.scenes = {}
end

function var0_0.Fix(arg0_105)
	local var0_105 = getProxy(PlayerProxy):getRawData():GetRegisterTime()
	local var1_105 = pg.TimeMgr.GetInstance():parseTimeFromConfig({
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
	local var2_105 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if var0_105 <= var1_105 then
		_.each(var2_105, function(arg0_106)
			arg0_105.playedList[arg0_106] = true
		end)
	end

	local var3_105 = 5001
	local var4_105 = 5020
	local var5_105 = getProxy(TaskProxy)
	local var6_105 = 0

	for iter0_105 = var3_105, var4_105, -1 do
		if var5_105:getFinishTaskById(iter0_105) or var5_105:getTaskById(iter0_105) then
			var6_105 = iter0_105

			break
		end
	end

	for iter1_105 = var6_105, var4_105, -1 do
		local var7_105 = pg.task_data_template[iter1_105]

		if var7_105 then
			local var8_105 = var7_105.story_id

			if var8_105 and #var8_105 > 0 and not arg0_105:IsPlayed(var8_105) then
				arg0_105.playedList[var8_105] = true
			end
		end
	end

	local var9_105 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

	if var9_105 and not var9_105:isEnd() then
		local var10_105 = _.flatten(var9_105:getConfig("config_data"))
		local var11_105

		for iter2_105 = #var10_105, 1, -1 do
			local var12_105 = pg.task_data_template[var10_105[iter2_105]].story_id

			if var12_105 and #var12_105 > 0 then
				local var13_105 = arg0_105:IsPlayed(var12_105)

				if var11_105 then
					if not var13_105 then
						arg0_105.playedList[var12_105] = true
					end
				elseif var13_105 then
					var11_105 = iter2_105
				end
			end
		end
	end
end
