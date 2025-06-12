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

function var0_0.IsPlayed(arg0_9, arg1_9, arg2_9)
	local var0_9, var1_9 = arg0_9:StoryName2StoryId(arg1_9)
	local var2_9 = arg0_9:GetPlayedFlag(var0_9)
	local var3_9 = true

	if var1_9 and not arg2_9 then
		var3_9 = arg0_9:GetPlayedFlag(var1_9)
	end

	return var2_9 and var3_9
end

local function var14_0(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10) do
		var0_10[iter1_10] = iter0_10
	end

	return var0_10
end

function var0_0.StoryName2StoryId(arg0_11, arg1_11)
	if not var0_0.indexs then
		var0_0.indexs = var14_0(var13_0("index"))
	end

	if not var0_0.againIndexs then
		var0_0.againIndexs = var14_0(var13_0("index_again"))
	end

	return var0_0.indexs[arg1_11], var0_0.againIndexs[arg1_11]
end

function var0_0.StoryId2StoryName(arg0_12, arg1_12)
	if not var0_0.indexIds then
		var0_0.indexIds = var13_0("index")
	end

	if not var0_0.againIndexIds then
		var0_0.againIndexIds = var13_0("index_again")
	end

	return var0_0.indexIds[arg1_12], var0_0.againIndexIds[arg1_12]
end

function var0_0.StoryLinkNames(arg0_13, arg1_13)
	if not var0_0.linkNames then
		var0_0.linkNames = var13_0("index_link")
	end

	return var0_0.linkNames[arg1_13]
end

function var0_0._GetStoryPaintingsByName(arg0_14, arg1_14)
	return arg1_14:GetUsingPaintingNames()
end

function var0_0.GetStoryPaintingsByName(arg0_15, arg1_15)
	local var0_15 = var13_0(arg1_15)

	if not var0_15 then
		var11_0("not exist story file")

		return {}
	end

	local var1_15 = Story.New(var0_15, false)

	return arg0_15:_GetStoryPaintingsByName(var1_15)
end

function var0_0.GetStoryPaintingsByNameList(arg0_16, arg1_16)
	local var0_16 = {}
	local var1_16 = {}

	for iter0_16, iter1_16 in ipairs(arg1_16) do
		for iter2_16, iter3_16 in ipairs(arg0_16:GetStoryPaintingsByName(iter1_16)) do
			var1_16[iter3_16] = true
		end
	end

	for iter4_16, iter5_16 in pairs(var1_16) do
		table.insert(var0_16, iter4_16)
	end

	return var0_16
end

function var0_0.GetStoryPaintingsById(arg0_17, arg1_17)
	return arg0_17:GetStoryPaintingsByIdList({
		arg1_17
	})
end

function var0_0.GetStoryPaintingsByIdList(arg0_18, arg1_18)
	local var0_18 = _.map(arg1_18, function(arg0_19)
		return arg0_18:StoryId2StoryName(arg0_19)
	end)

	return arg0_18:GetStoryPaintingsByNameList(var0_18)
end

function var0_0.ShouldDownloadRes(arg0_20, arg1_20)
	local var0_20 = arg0_20:GetStoryPaintingsByName(arg1_20)

	return _.any(var0_20, function(arg0_21)
		return PaintingGroupConst.VerifyPaintingFileName(arg0_21)
	end)
end

function var0_0.Init(arg0_22, arg1_22)
	arg0_22.state = var1_0

	LoadAndInstantiateAsync("ui", "NewStoryUI", function(arg0_23)
		arg0_22.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		arg0_23.transform:SetParent(arg0_22.UIOverlay.transform, false)
		arg0_22:_Init(arg0_23, arg1_22)
	end, true, true)
end

function var0_0._Init(arg0_24, arg1_24, arg2_24)
	arg0_24.playedList = {}
	arg0_24.playQueue = {}
	arg0_24._go = arg1_24
	arg0_24._tf = tf(arg0_24._go)
	arg0_24.frontTr = findTF(arg0_24._tf, "front")
	arg0_24.skipBtn = findTF(arg0_24._tf, "front/btns/btns/skip_button")
	arg0_24.autoBtn = findTF(arg0_24._tf, "front/btns/btns/auto_button")
	arg0_24.autoBtnImg = findTF(arg0_24._tf, "front/btns/btns/auto_button/sel"):GetComponent(typeof(Image))
	arg0_24.alphaImage = arg0_24._tf:GetComponent(typeof(Image))
	arg0_24.mainImage = arg0_24._tf:GetComponent(typeof(Image))
	arg0_24.recordBtn = findTF(arg0_24._tf, "front/btns/record")
	arg0_24.dialogueContainer = findTF(arg0_24._tf, "front/dialogue")
	arg0_24.players = {
		AsideStoryPlayer.New(arg1_24),
		DialogueStoryPlayer.New(arg1_24),
		BgStoryPlayer.New(arg1_24),
		CarouselPlayer.New(arg1_24),
		VedioStoryPlayer.New(arg1_24),
		CastStoryPlayer.New(arg1_24),
		SpAnimStoryPlayer.New(arg1_24),
		BlinkStoryPlayer.New(arg1_24)
	}
	arg0_24.setSpeedPanel = StorySetSpeedPanel.New(arg0_24._tf, function(arg0_25)
		arg0_24:UpdatePlaySpeed(arg0_25)
	end)
	arg0_24.recordPanel = NewStoryRecordPanel.New()
	arg0_24.recorder = StoryRecorder.New()

	setActive(arg0_24._go, false)

	arg0_24.state = var2_0

	if arg2_24 then
		arg2_24()
	end
end

function var0_0.GetPlayer(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.players) do
		if isa(iter1_26, arg1_26) then
			return iter1_26
		end
	end

	return nil
end

function var0_0.Play(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27, arg5_27, arg6_27, arg7_27)
	table.insert(arg0_27.playQueue, {
		arg1_27,
		arg2_27,
		arg7_27
	})

	if #arg0_27.playQueue == 1 then
		local var0_27

		local function var1_27()
			if #arg0_27.playQueue == 0 then
				return
			end

			local var0_28 = arg0_27.playQueue[1][1]
			local var1_28 = arg0_27.playQueue[1][2]
			local var2_28 = arg0_27.playQueue[1][3]

			arg0_27:SoloPlay(var0_28, function(arg0_29, arg1_29)
				if var1_28 then
					var1_28(arg0_29, arg1_29)
				end

				table.remove(arg0_27.playQueue, 1)
				var1_27()
			end, arg3_27, arg4_27, arg5_27, arg6_27, var2_28)
		end

		var1_27()
	end
end

function var0_0.Puase(arg0_30)
	if arg0_30.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	arg0_30.state = var4_0

	for iter0_30, iter1_30 in ipairs(arg0_30.players) do
		iter1_30:Pause()
	end
end

function var0_0.Resume(arg0_31)
	if arg0_31.state ~= var4_0 then
		var11_0("state is not 'pause'")

		return
	end

	arg0_31.state = var3_0

	for iter0_31, iter1_31 in ipairs(arg0_31.players) do
		iter1_31:Resume()
	end
end

function var0_0.Stop(arg0_32)
	if arg0_32.state ~= var3_0 then
		var11_0("state is not 'running'")

		return
	end

	if arg0_32.currPlayer and arg0_32.currPlayer:WaitForEvent() then
		return
	end

	arg0_32.state = var5_0

	for iter0_32, iter1_32 in ipairs(arg0_32.players) do
		iter1_32:Stop()
	end
end

function var0_0.PlayForTb(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	arg0_33:Play(arg1_33, arg3_33, arg4_33, false, false, true, arg2_33)
end

function var0_0.PlayForWorld(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34, arg5_34, arg6_34, arg7_34, arg8_34)
	arg0_34.optionSelCodes = arg2_34 or {}
	arg0_34.autoPlayFlag = arg6_34

	arg0_34:Play(arg1_34, arg3_34, arg4_34, arg5_34, arg7_34, true, arg8_34)
end

function var0_0.ForceAutoPlay(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35, arg5_35)
	arg0_35.autoPlayFlag = true

	local function var0_35(arg0_36, arg1_36)
		arg2_35(arg0_36, arg1_36, arg0_35.isAutoPlay)
	end

	arg0_35:Play(arg1_35, var0_35, arg3_35, arg4_35, true, false, arg5_35)
end

function var0_0.ForceManualPlay(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37, arg5_37)
	arg0_37.banPlayFlag = true

	local function var0_37(arg0_38, arg1_38)
		arg2_37(arg0_38, arg1_38, arg0_37.isAutoPlay)
	end

	arg0_37:Play(arg1_37, var0_37, arg3_37, arg4_37, true, false, arg5_37)
end

function var0_0.SeriesPlay(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39, arg5_39, arg6_39, arg7_39)
	local var0_39 = {}

	for iter0_39, iter1_39 in ipairs(arg1_39) do
		table.insert(var0_39, function(arg0_40)
			arg0_39:SoloPlay(iter1_39, arg0_40, arg3_39, arg4_39, arg5_39, arg6_39, arg7_39)
		end)
	end

	seriesAsync(var0_39, arg2_39)
end

function var0_0.SoloPlay(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41, arg5_41, arg6_41, arg7_41)
	var11_0("Play Story:", arg1_41)

	local var0_41 = 1

	local function var1_41(arg0_42, arg1_42)
		var0_41 = var0_41 - 1

		if arg2_41 and var0_41 == 0 then
			onNextTick(function()
				arg2_41(arg0_42, arg1_42)
			end)
		end
	end

	local var2_41 = var13_0(arg1_41)

	if not var2_41 then
		var1_41(false)
		var11_0("not exist story file")

		return nil
	end

	if arg0_41:IsReView() then
		arg3_41 = true
	end

	arg0_41.storyScript = Story.New(var2_41, arg3_41, arg0_41.optionSelCodes, arg5_41, arg6_41, arg7_41)

	if not arg0_41:CheckState() then
		var11_0("story state error")
		var1_41(false)

		return nil
	end

	if not arg0_41.storyScript:CanPlay() then
		var11_0("story cant be played")
		var1_41(false)

		return nil
	end

	arg0_41:ExecuteScript(var1_41)
end

function var0_0.ExecuteScript(arg0_44, arg1_44)
	seriesAsync({
		function(arg0_45)
			arg0_44:CheckResDownload(arg0_44.storyScript, arg0_45)
		end,
		function(arg0_46)
			originalPrint("start load story window...")
			arg0_44:CheckAndLoadDialogue(arg0_44.storyScript, arg0_46)
		end
	}, function()
		originalPrint("enter story...")
		arg0_44:OnStart()

		local var0_47 = {}

		arg0_44.currPlayer = nil
		arg0_44.progress = 0

		for iter0_47, iter1_47 in ipairs(arg0_44.storyScript.steps) do
			table.insert(var0_47, function(arg0_48)
				arg0_44.progress = iter0_47

				arg0_44:SendNotification(GAME.STORY_NEXT)

				local var0_48 = arg0_44.players[iter1_47:GetMode()]

				arg0_44.currPlayer = var0_48

				var0_48:Play(arg0_44.storyScript, iter0_47, arg0_48)
			end)
		end

		seriesAsync(var0_47, function()
			arg0_44:OnEnd(arg1_44)
		end)
	end)
end

function var0_0.SendNotification(arg0_50, arg1_50, arg2_50)
	pg.m02:sendNotification(arg1_50, arg2_50)
end

function var0_0.CheckResDownload(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg0_51:_GetStoryPaintingsByName(arg1_51)
	local var1_51 = table.concat(var0_51, ",")

	originalPrint("start download res " .. var1_51)

	local var2_51 = {}

	for iter0_51, iter1_51 in ipairs(var0_51) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var2_51, iter1_51)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var2_51,
		finishFunc = arg2_51
	})
end

local function var15_0(arg0_52, arg1_52)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0_52, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_53)
		arg1_52(arg0_53)
	end), true, true)
end

function var0_0.CheckAndLoadDialogue(arg0_54, arg1_54, arg2_54)
	local var0_54 = arg1_54:GetDialogueStyleName()

	if not arg0_54.dialogueContainer:Find(var0_54) then
		var15_0("NewStoryDialogue" .. var0_54, function(arg0_55)
			Object.Instantiate(arg0_55, arg0_54.dialogueContainer).name = var0_54

			arg2_54()
		end)
	else
		arg2_54()
	end
end

function var0_0.CheckState(arg0_56)
	if arg0_56.state == var3_0 or arg0_56.state == var1_0 or arg0_56.state == var4_0 then
		return false
	end

	return true
end

function var0_0.RegistSkipBtn(arg0_57)
	local function var0_57()
		arg0_57:TrackingSkip()
		arg0_57.storyScript:SkipAll()
		arg0_57.currPlayer:NextOneImmediately()
	end

	onButton(arg0_57, arg0_57.skipBtn, function()
		if arg0_57:IsStopping() or arg0_57:IsPausing() then
			return
		end

		if not arg0_57.currPlayer:CanSkip() then
			return
		end

		if arg0_57:IsReView() or arg0_57.storyScript:IsPlayed() or not arg0_57.storyScript:ShowSkipTip() then
			var0_57()

			return
		end

		arg0_57:Puase()

		arg0_57.isOpenMsgbox = true

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			parent = rtf(arg0_57._tf:Find("front")),
			content = i18n("story_skip_confirm"),
			onYes = function()
				arg0_57:Resume()
				var0_57()
			end,
			onNo = function()
				arg0_57.isOpenMsgbox = false

				arg0_57:Resume()
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
end

function var0_0.RegistAutoBtn(arg0_62)
	onButton(arg0_62, arg0_62.autoBtn, function()
		if arg0_62:IsStopping() or arg0_62:IsPausing() then
			return
		end

		if arg0_62.storyScript:GetAutoPlayFlag() then
			arg0_62.storyScript:StopAutoPlay()
			arg0_62.currPlayer:CancelAuto()
		else
			arg0_62.storyScript:SetAutoPlay()
			arg0_62.currPlayer:NextOne()
		end

		if arg0_62.storyScript then
			arg0_62:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	local var0_62 = arg0_62:IsAutoPlay()

	if var0_62 then
		arg0_62.storyScript:SetAutoPlay()
		arg0_62:UpdateAutoBtn()

		arg0_62.autoPlayFlag = false
	end

	arg0_62.banPlayFlag = false
	arg0_62.isAutoPlay = var0_62
end

function var0_0.RegistRecordBtn(arg0_64)
	onButton(arg0_64, arg0_64.recordBtn, function()
		if arg0_64.storyScript:GetAutoPlayFlag() then
			return
		end

		if not arg0_64.recordPanel:CanOpen() then
			return
		end

		local var0_65 = "Show"

		arg0_64.recordPanel[var0_65](arg0_64.recordPanel, arg0_64.recorder)
	end, SFX_PANEL)
end

function var0_0.TriggerAutoBtn(arg0_66)
	if not arg0_66:IsRunning() then
		return
	end

	triggerButton(arg0_66.autoBtn)
end

function var0_0.TriggerSkipBtn(arg0_67)
	if not arg0_67:IsRunning() then
		return
	end

	triggerButton(arg0_67.skipBtn)
end

function var0_0.ForEscPress(arg0_68)
	if arg0_68.recordPanel:IsShowing() then
		arg0_68.recordPanel:Hide()
	elseif arg0_68.currPlayer and arg0_68.currPlayer:WaitForEvent() or arg0_68.currPlayer and arg0_68.storyScript and arg0_68.storyScript.hideSkip then
		-- block empty
	else
		arg0_68:TriggerSkipBtn()
	end
end

function var0_0.UpdatePlaySpeed(arg0_69, arg1_69)
	if arg0_69:IsRunning() and arg0_69.storyScript then
		arg0_69.storyScript:SetPlaySpeed(arg1_69)
	end
end

function var0_0.GetPlaySpeed(arg0_70)
	if arg0_70:IsRunning() and arg0_70.storyScript then
		return arg0_70.storyScript:GetPlaySpeed()
	end
end

function var0_0.OnStart(arg0_71)
	arg0_71.recorder:Clear()
	removeOnButton(arg0_71._go)
	removeOnButton(arg0_71.skipBtn)
	removeOnButton(arg0_71.autoBtn)
	removeOnButton(arg0_71.recordBtn)

	arg0_71.mainImage.color = Color(0, 0, 0, arg0_71.storyScript:GetStoryAlpha())

	setActive(arg0_71.recordBtn, not arg0_71.storyScript:ShouldHideRecord())
	arg0_71:ClearStoryEventTriggerListener()

	local var0_71 = arg0_71.storyScript:GetAllStepDispatcherRecallName()

	if #var0_71 > 0 then
		arg0_71.storyEventTriggerListener = StoryEventTriggerListener.New(var0_71)
	end

	arg0_71.mainImage.enabled = not arg0_71.storyScript:CanInteraction()
	arg0_71.state = var3_0

	arg0_71:TrackingStart()
	arg0_71:SendNotification(GAME.STORY_BEGIN, arg0_71.storyScript:GetName())

	if not arg0_71:IsReView() then
		arg0_71:SendNotification(GAME.STORY_UPDATE, {
			storyId = arg0_71.storyScript:GetName()
		})
	end

	pg.DelegateInfo.New(arg0_71)

	for iter0_71, iter1_71 in ipairs(arg0_71.players) do
		iter1_71:StoryStart(arg0_71.storyScript)
	end

	setActive(arg0_71._go, true)
	arg0_71._tf:SetAsLastSibling()
	setActive(arg0_71.skipBtn, not arg0_71.storyScript:ShouldHideSkip())
	setActive(arg0_71.autoBtn, not arg0_71.storyScript:ShouldHideAutoBtn())

	arg0_71.bgmVolumeValue = pg.CriMgr.GetInstance():getBGMVolume()

	arg0_71:RegistSkipBtn()
	arg0_71:RegistAutoBtn()
	arg0_71:RegistRecordBtn()
end

function var0_0.TrackingStart(arg0_72)
	if not getProxy(PlayerProxy) or not getProxy(PlayerProxy):getRawData() then
		return
	end

	arg0_72.trackFlag = false

	if not arg0_72.storyScript then
		return
	end

	local var0_72 = arg0_72:StoryName2StoryId(arg0_72.storyScript:GetName())

	if var0_72 and not arg0_72:GetPlayedFlag(var0_72) then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryStart(var0_72, 0))

		arg0_72.trackFlag = true
	end
end

function var0_0.TrackingSkip(arg0_73)
	if not arg0_73.trackFlag or not arg0_73.storyScript then
		return
	end

	local var0_73 = arg0_73:StoryName2StoryId(arg0_73.storyScript:GetName())

	if var0_73 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStorySkip(var0_73, arg0_73.progress or 0))
	end
end

function var0_0.TrackingOption(arg0_74, arg1_74, arg2_74)
	if not arg0_74.storyScript or not arg1_74 or not arg2_74 then
		return
	end

	local var0_74 = arg0_74:StoryName2StoryId(arg0_74.storyScript:GetName())

	if var0_74 then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildStoryOption(var0_74, arg1_74 .. "_" .. (arg2_74 or 0)))
	end
end

function var0_0.ClearStoryEvent(arg0_75)
	if arg0_75.storyEventTriggerListener then
		arg0_75.storyEventTriggerListener:Clear()
	end
end

function var0_0.CheckStoryEvent(arg0_76, arg1_76)
	if arg0_76.storyEventTriggerListener then
		return arg0_76.storyEventTriggerListener:ExistCache(arg1_76)
	end

	return false
end

function var0_0.GetStoryEventArg(arg0_77, arg1_77)
	if not arg0_77:CheckStoryEvent(arg1_77) then
		return nil
	end

	if arg0_77.storyEventTriggerListener and arg0_77.storyEventTriggerListener:ExistArg(arg1_77) then
		return arg0_77.storyEventTriggerListener:GetArg(arg1_77)
	end

	return nil
end

function var0_0.UpdateAutoBtn(arg0_78)
	local var0_78 = arg0_78.storyScript:GetAutoPlayFlag()

	arg0_78:ClearAutoBtn(var0_78)
end

function var0_0.ClearAutoBtn(arg0_79, arg1_79)
	arg0_79.autoBtnImg.color = arg1_79 and var8_0 or var9_0
	arg0_79.isAutoPlay = arg1_79

	local var0_79 = arg1_79 and "Show" or "Hide"

	arg0_79.setSpeedPanel[var0_79](arg0_79.setSpeedPanel, arg0_79.storyScript)
end

function var0_0.ClearStoryEventTriggerListener(arg0_80)
	if arg0_80.storyEventTriggerListener then
		arg0_80.storyEventTriggerListener:Dispose()

		arg0_80.storyEventTriggerListener = nil
	end
end

function var0_0.Clear(arg0_81)
	arg0_81.progress = 0

	arg0_81:ClearStoryEventTriggerListener()

	arg0_81.mainImage.enabled = true

	arg0_81.recorder:Clear()
	arg0_81.recordPanel:Hide()

	arg0_81.autoPlayFlag = false
	arg0_81.banPlayFlag = false

	removeOnButton(arg0_81._go)
	removeOnButton(arg0_81.skipBtn)
	removeOnButton(arg0_81.recordBtn)
	removeOnButton(arg0_81.autoBtn)
	arg0_81:ClearAutoBtn(false)

	if isActive(arg0_81._go) then
		pg.DelegateInfo.Dispose(arg0_81)
	end

	if arg0_81.setSpeedPanel then
		arg0_81.setSpeedPanel:Clear()
	end

	setActive(arg0_81.skipBtn, false)
	setActive(arg0_81._go, false)

	for iter0_81, iter1_81 in ipairs(arg0_81.players) do
		iter1_81:StoryEnd(arg0_81.storyScript)
	end

	arg0_81.optionSelCodes = nil

	arg0_81:SendNotification(GAME.STORY_END)

	if arg0_81.isOpenMsgbox then
		pg.MsgboxMgr:GetInstance():hide()
	end

	arg0_81:RevertBgmVolumeValue()
end

function var0_0.RevertBgmVolumeValue(arg0_82)
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_82 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0_82.bgmVolumeValue and arg0_82.bgmVolumeValue ~= var0_82 then
		pg.CriMgr.GetInstance():setBGMVolume(arg0_82.bgmVolumeValue)
	end

	arg0_82.bgmVolumeValue = nil
end

function var0_0.OnEnd(arg0_83, arg1_83)
	arg0_83:Clear()

	if arg0_83.state == var3_0 or arg0_83.state == var5_0 then
		arg0_83.state = var6_0

		local var0_83 = arg0_83.storyScript:GetNextScriptName()

		if var0_83 and not arg0_83:IsReView() then
			arg0_83.storyScript = nil

			arg0_83:Play(var0_83, arg1_83)
		else
			local var1_83 = arg0_83.storyScript:GetBranchCode()

			arg0_83.storyScript = nil

			if arg1_83 then
				arg1_83(true, var1_83)
			end
		end
	else
		arg0_83.state = var6_0

		local var2_83 = arg0_83.storyScript:GetBranchCode()

		if arg1_83 then
			arg1_83(true, var2_83)
		end
	end
end

function var0_0.OnSceneEnter(arg0_84, arg1_84)
	if not arg0_84.scenes then
		arg0_84.scenes = {}
	end

	arg0_84.scenes[arg1_84.view] = true
end

function var0_0.OnSceneExit(arg0_85, arg1_85)
	if not arg0_85.scenes then
		return
	end

	arg0_85.scenes[arg1_85.view] = nil
end

function var0_0.IsReView(arg0_86)
	if getProxy(ContextProxy) == nil then
		return false
	end

	local var0_86 = getProxy(ContextProxy):GetPrevContext(1)

	return arg0_86.scenes[WorldMediaCollectionScene.__cname] == true or var0_86 and var0_86.mediator == WorldMediaCollectionMediator
end

function var0_0.IsRunning(arg0_87)
	return arg0_87.state == var3_0
end

function var0_0.IsStopping(arg0_88)
	return arg0_88.state == var5_0
end

function var0_0.IsPausing(arg0_89)
	return arg0_89.state == var4_0
end

function var0_0.IsAutoPlay(arg0_90)
	if arg0_90.banPlayFlag then
		return false
	end

	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or arg0_90.autoPlayFlag == true
end

function var0_0.GetRectSize(arg0_91)
	return Vector2(arg0_91._tf.rect.width, arg0_91._tf.rect.height)
end

function var0_0.AddRecord(arg0_92, arg1_92)
	arg0_92.recorder:Add(arg1_92)
end

function var0_0.Quit(arg0_93)
	arg0_93.recorder:Dispose()
	arg0_93.recordPanel:Dispose()
	arg0_93.setSpeedPanel:Dispose()

	if arg0_93.currPlayer and arg0_93.currPlayer:WaitForEvent() then
		arg0_93:Clear()
	end

	arg0_93.state = var7_0
	arg0_93.storyScript = nil
	arg0_93.currPlayer = nil
	arg0_93.playQueue = {}
	arg0_93.playedList = {}
	arg0_93.scenes = {}
end

function var0_0.Fix(arg0_94)
	local var0_94 = getProxy(PlayerProxy):getRawData():GetRegisterTime()
	local var1_94 = pg.TimeMgr.GetInstance():parseTimeFromConfig({
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
	local var2_94 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if var0_94 <= var1_94 then
		_.each(var2_94, function(arg0_95)
			arg0_94.playedList[arg0_95] = true
		end)
	end

	local var3_94 = 5001
	local var4_94 = 5020
	local var5_94 = getProxy(TaskProxy)
	local var6_94 = 0

	for iter0_94 = var3_94, var4_94, -1 do
		if var5_94:getFinishTaskById(iter0_94) or var5_94:getTaskById(iter0_94) then
			var6_94 = iter0_94

			break
		end
	end

	for iter1_94 = var6_94, var4_94, -1 do
		local var7_94 = pg.task_data_template[iter1_94]

		if var7_94 then
			local var8_94 = var7_94.story_id

			if var8_94 and #var8_94 > 0 and not arg0_94:IsPlayed(var8_94) then
				arg0_94.playedList[var8_94] = true
			end
		end
	end

	local var9_94 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

	if var9_94 and not var9_94:isEnd() then
		local var10_94 = _.flatten(var9_94:getConfig("config_data"))
		local var11_94

		for iter2_94 = #var10_94, 1, -1 do
			local var12_94 = pg.task_data_template[var10_94[iter2_94]].story_id

			if var12_94 and #var12_94 > 0 then
				local var13_94 = arg0_94:IsPlayed(var12_94)

				if var11_94 then
					if not var13_94 then
						arg0_94.playedList[var12_94] = true
					end
				elseif var13_94 then
					var11_94 = iter2_94
				end
			end
		end
	end
end
