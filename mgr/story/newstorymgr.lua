pg = pg or {}

local var0 = singletonClass("NewStoryMgr")

pg.NewStoryMgr = var0

local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 5
local var6 = 6
local var7 = 7
local var8 = Color.New(1, 0.8705, 0.4196, 1)
local var9 = Color.New(1, 1, 1, 1)

require("Mgr/Story/Include")

local var10 = true

local function var11(...)
	if var10 and IsUnityEditor then
		originalPrint(...)
	end
end

local var12 = {
	"",
	"JP",
	"KR",
	"US",
	""
}

local function var13(arg0)
	local var0 = var12[PLATFORM_CODE]

	if arg0 == "index" then
		arg0 = arg0 .. var0
	end

	local var1

	if PLATFORM_CODE == PLATFORM_JP then
		var1 = "GameCfg.story" .. var0 .. "." .. arg0
	else
		var1 = "GameCfg.story" .. "." .. arg0
	end

	local var2, var3 = pcall(function()
		return require(var1)
	end)

	if not var2 then
		local var4 = true

		if UnGamePlayState then
			local var5 = "GameCfg.dungeon." .. arg0

			if pcall(function()
				return require(var5)
			end) then
				var4 = false
			end
		end

		if var4 then
			errorMsg("不存在剧情ID对应的Lua:" .. arg0)
		end
	end

	return var2 and var3
end

function var0.SetData(arg0, arg1)
	arg0.playedList = {}

	for iter0, iter1 in ipairs(arg1) do
		local var0 = iter1

		if iter1 == 20008 then
			var0 = 1131
		end

		if iter1 == 20009 then
			var0 = 1132
		end

		if iter1 == 20010 then
			var0 = 1133
		end

		if iter1 == 20011 then
			var0 = 1134
		end

		if iter1 == 20012 then
			var0 = 1135
		end

		if iter1 == 20013 then
			var0 = 1136
		end

		if iter1 == 20014 then
			var0 = 1137
		end

		arg0.playedList[var0] = true
	end
end

function var0.SetPlayedFlag(arg0, arg1)
	var11("Update story id", arg1)

	arg0.playedList[arg1] = true
end

function var0.GetPlayedFlag(arg0, arg1)
	return arg0.playedList[arg1]
end

function var0.IsPlayed(arg0, arg1, arg2)
	local var0, var1 = arg0:StoryName2StoryId(arg1)
	local var2 = arg0:GetPlayedFlag(var0)
	local var3 = true

	if var1 and not arg2 then
		var3 = arg0:GetPlayedFlag(var1)
	end

	return var2 and var3
end

local function var14(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0) do
		var0[iter1] = iter0
	end

	return var0
end

function var0.StoryName2StoryId(arg0, arg1)
	if not var0.indexs then
		var0.indexs = var14(var13("index"))
	end

	if not var0.againIndexs then
		var0.againIndexs = var14(var13("index_again"))
	end

	return var0.indexs[arg1], var0.againIndexs[arg1]
end

function var0.StoryId2StoryName(arg0, arg1)
	if not var0.indexIds then
		var0.indexIds = var13("index")
	end

	if not var0.againIndexIds then
		var0.againIndexIds = var13("index_again")
	end

	return var0.indexIds[arg1], var0.againIndexIds[arg1]
end

function var0.StoryLinkNames(arg0, arg1)
	if not var0.linkNames then
		var0.linkNames = var13("index_link")
	end

	return var0.linkNames[arg1]
end

function var0._GetStoryPaintingsByName(arg0, arg1)
	return arg1:GetUsingPaintingNames()
end

function var0.GetStoryPaintingsByName(arg0, arg1)
	local var0 = var13(arg1)

	if not var0 then
		var11("not exist story file")

		return {}
	end

	local var1 = Story.New(var0, false)

	return arg0:_GetStoryPaintingsByName(var1)
end

function var0.GetStoryPaintingsByNameList(arg0, arg1)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		for iter2, iter3 in ipairs(arg0:GetStoryPaintingsByName(iter1)) do
			var1[iter3] = true
		end
	end

	for iter4, iter5 in pairs(var1) do
		table.insert(var0, iter4)
	end

	return var0
end

function var0.GetStoryPaintingsById(arg0, arg1)
	return arg0:GetStoryPaintingsByIdList({
		arg1
	})
end

function var0.GetStoryPaintingsByIdList(arg0, arg1)
	local var0 = _.map(arg1, function(arg0)
		return arg0:StoryId2StoryName(arg0)
	end)

	return arg0:GetStoryPaintingsByNameList(var0)
end

function var0.ShouldDownloadRes(arg0, arg1)
	local var0 = arg0:GetStoryPaintingsByName(arg1)

	return _.any(var0, function(arg0)
		return PaintingGroupConst.VerifyPaintingFileName(arg0)
	end)
end

function var0.Init(arg0, arg1)
	arg0.state = var1
	arg0.playedList = {}
	arg0.playQueue = {}

	PoolMgr.GetInstance():GetUI("NewStoryUI", true, function(arg0)
		arg0._go = arg0
		arg0._tf = tf(arg0._go)
		arg0.frontTr = findTF(arg0._tf, "front")
		arg0.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		arg0._go.transform:SetParent(arg0.UIOverlay.transform, false)

		arg0.skipBtn = findTF(arg0._tf, "front/btns/btns/skip_button")
		arg0.autoBtn = findTF(arg0._tf, "front/btns/btns/auto_button")
		arg0.autoBtnImg = findTF(arg0._tf, "front/btns/btns/auto_button/sel"):GetComponent(typeof(Image))
		arg0.alphaImage = arg0._tf:GetComponent(typeof(Image))
		arg0.recordBtn = findTF(arg0._tf, "front/btns/record")
		arg0.dialogueContainer = findTF(arg0._tf, "front/dialogue")
		arg0.players = {
			AsideStoryPlayer.New(arg0),
			DialogueStoryPlayer.New(arg0),
			BgStoryPlayer.New(arg0),
			CarouselPlayer.New(arg0),
			VedioStoryPlayer.New(arg0),
			CastStoryPlayer.New(arg0)
		}
		arg0.setSpeedPanel = StorySetSpeedPanel.New(arg0._tf)
		arg0.recordPanel = NewStoryRecordPanel.New()
		arg0.recorder = StoryRecorder.New()

		setActive(arg0._go, false)

		arg0.state = var2

		if arg1 then
			arg1()
		end
	end)
end

function var0.Play(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	table.insert(arg0.playQueue, {
		arg1,
		arg2
	})

	if #arg0.playQueue == 1 then
		local var0

		local function var1()
			if #arg0.playQueue == 0 then
				return
			end

			local var0 = arg0.playQueue[1][1]
			local var1 = arg0.playQueue[1][2]

			arg0:SoloPlay(var0, function(arg0, arg1)
				if var1 then
					var1(arg0, arg1)
				end

				table.remove(arg0.playQueue, 1)
				var1()
			end, arg3, arg4, arg5, arg6)
		end

		var1()
	end
end

function var0.Puase(arg0)
	if arg0.state ~= var3 then
		var11("state is not 'running'")

		return
	end

	arg0.state = var4

	for iter0, iter1 in ipairs(arg0.players) do
		iter1:Pause()
	end
end

function var0.Resume(arg0)
	if arg0.state ~= var4 then
		var11("state is not 'pause'")

		return
	end

	arg0.state = var3

	for iter0, iter1 in ipairs(arg0.players) do
		iter1:Resume()
	end
end

function var0.Stop(arg0)
	if arg0.state ~= var3 then
		var11("state is not 'running'")

		return
	end

	arg0.state = var5

	for iter0, iter1 in ipairs(arg0.players) do
		iter1:Stop()
	end
end

function var0.PlayForWorld(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	arg0.optionSelCodes = arg2 or {}
	arg0.autoPlayFlag = arg6

	arg0:Play(arg1, arg3, arg4, arg5, arg7, true)
end

function var0.ForceAutoPlay(arg0, arg1, arg2, arg3, arg4)
	arg0.autoPlayFlag = true

	local function var0(arg0, arg1)
		arg2(arg0, arg1, arg0.isAutoPlay)
	end

	arg0:Play(arg1, var0, arg3, arg4, true)
end

function var0.ForceManualPlay(arg0, arg1, arg2, arg3, arg4)
	arg0.banPlayFlag = true

	local function var0(arg0, arg1)
		arg2(arg0, arg1, arg0.isAutoPlay)
	end

	arg0:Play(arg1, var0, arg3, arg4, true)
end

function var0.SeriesPlay(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(var0, function(arg0)
			arg0:SoloPlay(iter1, arg0, arg3, arg4, arg5, arg6)
		end)
	end

	seriesAsync(var0, arg2)
end

function var0.SoloPlay(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	var11("Play Story:", arg1)

	local var0 = 1

	local function var1(arg0, arg1)
		var0 = var0 - 1

		if arg2 and var0 == 0 then
			onNextTick(function()
				arg2(arg0, arg1)
			end)
		end
	end

	local var2 = var13(arg1)

	if not var2 then
		var1(false)
		var11("not exist story file")

		return nil
	end

	if arg0:IsReView() then
		arg3 = true
	end

	arg0.storyScript = Story.New(var2, arg3, arg0.optionSelCodes, arg5, arg6)

	if not arg0:CheckState() then
		var11("story state error")
		var1(false)

		return nil
	end

	if not arg0.storyScript:CanPlay() then
		var11("story cant be played")
		var1(false)

		return nil
	end

	seriesAsync({
		function(arg0)
			arg0:CheckResDownload(arg0.storyScript, arg0)
		end,
		function(arg0)
			originalPrint("start load story window...")
			arg0:CheckAndLoadDialogue(arg0.storyScript, arg0)
		end
	}, function()
		originalPrint("enter story...")
		arg0:OnStart()

		local var0 = {}

		arg0.currPlayer = nil

		for iter0, iter1 in ipairs(arg0.storyScript.steps) do
			table.insert(var0, function(arg0)
				pg.m02:sendNotification(GAME.STORY_NEXT)

				local var0 = arg0.players[iter1:GetMode()]

				arg0.currPlayer = var0

				var0:Play(arg0.storyScript, iter0, arg0)
			end)
		end

		seriesAsync(var0, function()
			arg0:OnEnd(var1)
		end)
	end)
end

function var0.CheckResDownload(arg0, arg1, arg2)
	local var0 = arg0:_GetStoryPaintingsByName(arg1)
	local var1 = table.concat(var0, ",")

	originalPrint("start download res " .. var1)

	local var2 = {}

	for iter0, iter1 in ipairs(var0) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var2, iter1)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var2,
		finishFunc = arg2
	})
end

local function var15(arg0, arg1)
	ResourceMgr.Inst:getAssetAsync("ui/" .. arg0, arg0, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		arg1(arg0)
	end), true, true)
end

function var0.CheckAndLoadDialogue(arg0, arg1, arg2)
	local var0 = arg1:GetDialogueStyleName()

	if not arg0.dialogueContainer:Find(var0) then
		var15("NewStoryDialogue" .. var0, function(arg0)
			Object.Instantiate(arg0, arg0.dialogueContainer).name = var0

			arg2()
		end)
	else
		arg2()
	end
end

function var0.CheckState(arg0)
	if arg0.state == var3 or arg0.state == var1 or arg0.state == var4 then
		return false
	end

	return true
end

function var0.RegistSkipBtn(arg0)
	local function var0()
		arg0:TrackingSkip()
		arg0.storyScript:SkipAll()
		arg0.currPlayer:NextOneImmediately()
	end

	onButton(arg0, arg0.skipBtn, function()
		if arg0:IsStopping() or arg0:IsPausing() then
			return
		end

		if not arg0.currPlayer:CanSkip() then
			return
		end

		if arg0:IsReView() or arg0.storyScript:IsPlayed() or not arg0.storyScript:ShowSkipTip() then
			var0()

			return
		end

		arg0:Puase()

		arg0.isOpenMsgbox = true

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			parent = rtf(arg0._tf:Find("front")),
			content = i18n("story_skip_confirm"),
			onYes = function()
				arg0:Resume()
				var0()
			end,
			onNo = function()
				arg0.isOpenMsgbox = false

				arg0:Resume()
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
end

function var0.RegistAutoBtn(arg0)
	onButton(arg0, arg0.autoBtn, function()
		if arg0:IsStopping() or arg0:IsPausing() then
			return
		end

		if arg0.storyScript:GetAutoPlayFlag() then
			arg0.storyScript:StopAutoPlay()
			arg0.currPlayer:CancelAuto()
		else
			arg0.storyScript:SetAutoPlay()
			arg0.currPlayer:NextOne()
		end

		if arg0.storyScript then
			arg0:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	local var0 = arg0:IsAutoPlay()

	if var0 then
		arg0.storyScript:SetAutoPlay()
		arg0:UpdateAutoBtn()

		arg0.autoPlayFlag = false
	end

	arg0.banPlayFlag = false
	arg0.isAutoPlay = var0
end

function var0.RegistRecordBtn(arg0)
	onButton(arg0, arg0.recordBtn, function()
		if arg0.storyScript:GetAutoPlayFlag() then
			return
		end

		if not arg0.recordPanel:CanOpen() then
			return
		end

		local var0 = "Show"

		arg0.recordPanel[var0](arg0.recordPanel, arg0.recorder)
	end, SFX_PANEL)
end

function var0.TriggerAutoBtn(arg0)
	if not arg0:IsRunning() then
		return
	end

	triggerButton(arg0.autoBtn)
end

function var0.TriggerSkipBtn(arg0)
	if not arg0:IsRunning() then
		return
	end

	triggerButton(arg0.skipBtn)
end

function var0.ForEscPress(arg0)
	if arg0.recordPanel:IsShowing() then
		arg0.recordPanel:Hide()
	else
		arg0:TriggerSkipBtn()
	end
end

function var0.UpdatePlaySpeed(arg0, arg1)
	if arg0:IsRunning() and arg0.storyScript then
		arg0.storyScript:SetPlaySpeed(arg1)
	end
end

function var0.GetPlaySpeed(arg0)
	if arg0:IsRunning() and arg0.storyScript then
		return arg0.storyScript:GetPlaySpeed()
	end
end

function var0.OnStart(arg0)
	arg0.recorder:Clear()
	removeOnButton(arg0._go)
	removeOnButton(arg0.skipBtn)
	removeOnButton(arg0.autoBtn)
	removeOnButton(arg0.recordBtn)

	arg0.alphaImage.color = Color(0, 0, 0, arg0.storyScript:GetStoryAlpha())

	setActive(arg0.recordBtn, not arg0.storyScript:ShouldHideRecord())
	arg0:ClearStoryEventTriggerListener()

	local var0 = arg0.storyScript:GetAllStepDispatcherRecallName()

	if #var0 > 0 then
		arg0.storyEventTriggerListener = StoryEventTriggerListener.New(var0)
	end

	arg0.state = var3

	arg0:TrackingStart()
	pg.m02:sendNotification(GAME.STORY_BEGIN, arg0.storyScript:GetName())
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg0.storyScript:GetName()
	})
	pg.DelegateInfo.New(arg0)

	for iter0, iter1 in ipairs(arg0.players) do
		iter1:StoryStart(arg0.storyScript)
	end

	setActive(arg0._go, true)
	arg0._tf:SetAsLastSibling()
	setActive(arg0.skipBtn, not arg0.storyScript:ShouldHideSkip())
	setActive(arg0.autoBtn, not arg0.storyScript:ShouldHideAutoBtn())

	arg0.bgmVolumeValue = pg.CriMgr.GetInstance():getBGMVolume()

	arg0:RegistSkipBtn()
	arg0:RegistAutoBtn()
	arg0:RegistRecordBtn()
end

function var0.TrackingStart(arg0)
	arg0.trackFlag = false

	if not arg0.storyScript then
		return
	end

	local var0 = arg0:StoryName2StoryId(arg0.storyScript:GetName())

	if not arg0:GetPlayedFlag(var0) then
		TrackConst.StoryStart(var0)

		arg0.trackFlag = true
	end
end

function var0.TrackingSkip(arg0)
	if not arg0.trackFlag or not arg0.storyScript then
		return
	end

	local var0 = arg0:StoryName2StoryId(arg0.storyScript:GetName())

	TrackConst.StorySkip(var0)
end

function var0.ClearStoryEvent(arg0)
	if arg0.storyEventTriggerListener then
		arg0.storyEventTriggerListener:Clear()
	end
end

function var0.CheckStoryEvent(arg0, arg1)
	if arg0.storyEventTriggerListener then
		return arg0.storyEventTriggerListener:ExistCache(arg1)
	end

	return false
end

function var0.GetStoryEventArg(arg0, arg1)
	if not arg0:CheckStoryEvent(arg1) then
		return nil
	end

	if arg0.storyEventTriggerListener and arg0.storyEventTriggerListener:ExistArg(arg1) then
		return arg0.storyEventTriggerListener:GetArg(arg1)
	end

	return nil
end

function var0.UpdateAutoBtn(arg0)
	local var0 = arg0.storyScript:GetAutoPlayFlag()

	arg0:ClearAutoBtn(var0)
end

function var0.ClearAutoBtn(arg0, arg1)
	arg0.autoBtnImg.color = arg1 and var8 or var9
	arg0.isAutoPlay = arg1

	local var0 = arg1 and "Show" or "Hide"

	arg0.setSpeedPanel[var0](arg0.setSpeedPanel)
end

function var0.ClearStoryEventTriggerListener(arg0)
	if arg0.storyEventTriggerListener then
		arg0.storyEventTriggerListener:Dispose()

		arg0.storyEventTriggerListener = nil
	end
end

function var0.Clear(arg0)
	arg0:ClearStoryEventTriggerListener()
	arg0.recorder:Clear()
	arg0.recordPanel:Hide()

	arg0.autoPlayFlag = false
	arg0.banPlayFlag = false

	removeOnButton(arg0._go)
	removeOnButton(arg0.skipBtn)
	removeOnButton(arg0.recordBtn)
	removeOnButton(arg0.autoBtn)
	arg0:ClearAutoBtn(false)

	if isActive(arg0._go) then
		pg.DelegateInfo.Dispose(arg0)
	end

	if arg0.setSpeedPanel then
		arg0.setSpeedPanel:Clear()
	end

	setActive(arg0.skipBtn, false)
	setActive(arg0._go, false)

	for iter0, iter1 in ipairs(arg0.players) do
		iter1:StoryEnd(arg0.storyScript)
	end

	arg0.optionSelCodes = nil

	pg.BgmMgr.GetInstance():ContinuePlay()
	pg.m02:sendNotification(GAME.STORY_END)

	if arg0.isOpenMsgbox then
		pg.MsgboxMgr:GetInstance():hide()
	end

	local var0 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0.bgmVolumeValue and arg0.bgmVolumeValue ~= var0 then
		pg.CriMgr.GetInstance():setBGMVolume(arg0.bgmVolumeValue)
	end

	arg0.bgmVolumeValue = nil
end

function var0.OnEnd(arg0, arg1)
	arg0:Clear()

	if arg0.state == var3 or arg0.state == var5 then
		arg0.state = var6

		local var0 = arg0.storyScript:GetNextScriptName()

		if var0 and not arg0:IsReView() then
			arg0.storyScript = nil

			arg0:Play(var0, arg1)
		else
			local var1 = arg0.storyScript:GetBranchCode()

			arg0.storyScript = nil

			if arg1 then
				arg1(true, var1)
			end
		end
	else
		arg0.state = var6

		local var2 = arg0.storyScript:GetBranchCode()

		if arg1 then
			arg1(true, var2)
		end
	end
end

function var0.OnSceneEnter(arg0, arg1)
	if not arg0.scenes then
		arg0.scenes = {}
	end

	arg0.scenes[arg1.view] = true
end

function var0.OnSceneExit(arg0, arg1)
	if not arg0.scenes then
		return
	end

	arg0.scenes[arg1.view] = nil
end

function var0.IsReView(arg0)
	local var0 = getProxy(ContextProxy):GetPrevContext(1)

	return arg0.scenes[WorldMediaCollectionScene.__cname] == true or var0 and var0.mediator == WorldMediaCollectionMediator
end

function var0.IsRunning(arg0)
	return arg0.state == var3
end

function var0.IsStopping(arg0)
	return arg0.state == var5
end

function var0.IsPausing(arg0)
	return arg0.state == var4
end

function var0.IsAutoPlay(arg0)
	if arg0.banPlayFlag then
		return false
	end

	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or arg0.autoPlayFlag == true
end

function var0.GetRectSize(arg0)
	return Vector2(arg0._tf.rect.width, arg0._tf.rect.height)
end

function var0.AddRecord(arg0, arg1)
	arg0.recorder:Add(arg1)
end

function var0.Quit(arg0)
	arg0.recorder:Dispose()
	arg0.recordPanel:Dispose()
	arg0.setSpeedPanel:Dispose()

	arg0.state = var7
	arg0.storyScript = nil
	arg0.playQueue = {}
	arg0.playedList = {}
	arg0.scenes = {}
end

function var0.Fix(arg0)
	local var0 = getProxy(PlayerProxy):getRawData():GetRegisterTime()
	local var1 = pg.TimeMgr.GetInstance():parseTimeFromConfig({
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
	local var2 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if var0 <= var1 then
		_.each(var2, function(arg0)
			arg0.playedList[arg0] = true
		end)
	end

	local var3 = 5001
	local var4 = 5020
	local var5 = getProxy(TaskProxy)
	local var6 = 0

	for iter0 = var3, var4, -1 do
		if var5:getFinishTaskById(iter0) or var5:getTaskById(iter0) then
			var6 = iter0

			break
		end
	end

	for iter1 = var6, var4, -1 do
		local var7 = pg.task_data_template[iter1]

		if var7 then
			local var8 = var7.story_id

			if var8 and #var8 > 0 and not arg0:IsPlayed(var8) then
				arg0.playedList[var8] = true
			end
		end
	end

	local var9 = getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID)

	if var9 and not var9:isEnd() then
		local var10 = _.flatten(var9:getConfig("config_data"))
		local var11

		for iter2 = #var10, 1, -1 do
			local var12 = pg.task_data_template[var10[iter2]].story_id

			if var12 and #var12 > 0 then
				local var13 = arg0:IsPlayed(var12)

				if var11 then
					if not var13 then
						arg0.playedList[var12] = true
					end
				elseif var13 then
					var11 = iter2
				end
			end
		end
	end
end
