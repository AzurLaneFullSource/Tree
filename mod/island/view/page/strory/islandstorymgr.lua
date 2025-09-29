local var0_0 = class("IslandStoryMgr", import("view.base.BaseSubView"))

var0_0.START_STORY = "IslandStoryMgr:START_STORY"
var0_0.END_STORY = "IslandStoryMgr:END_STORY"

local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = Color.New(1, 0.8705, 0.4196, 1)
local var5_0 = Color.New(1, 1, 1, 1)

function var0_0.getUIName(arg0_1)
	return "IslandStoryUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.skipBtn = arg0_2._tf:Find("front/btns/btns/skip_button")
	arg0_2.logBtn = arg0_2._tf:Find("front/btns/record")
	arg0_2.autoBtn = arg0_2._tf:Find("front/btns/btns/auto_button")
	arg0_2.autoBtnImg = findTF(arg0_2._tf, "front/btns/btns/auto_button/sel"):GetComponent(typeof(Image))
	arg0_2.animator = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.aniDft = arg0_2._tf:GetComponent(typeof(DftAniEvent))
	arg0_2.canvasGroup = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))
	arg0_2.player = Dialogue3DPlayer.New(arg0_2)
	arg0_2.recordPanel = IslandStoryRecordPanel.New(arg0_2)
	arg0_2.recorder = IslandStoryRecorder.New()
	arg0_2.setSpeedPanel = StorySetSpeedPanel.New(arg0_2._tf, function(arg0_3)
		if arg0_2:IsRunning() and arg0_2.script then
			arg0_2.script:SetPlaySpeed(arg0_3)
		end
	end)

	setActive(arg0_2._go, false)

	arg0_2.state = var1_0
end

function var0_0.Play(arg0_4, arg1_4, arg2_4, arg3_4)
	if not _IslandCore then
		return
	end

	if arg0_4:IsRunning() then
		arg3_4()

		return
	end

	local var0_4 = _IslandCore:GetView():GetAllUnits()

	arg0_4.refreshNpc = defaultValue(arg2_4, true)
	arg0_4.state = var2_0

	local var1_4 = pg.NewStoryMgr.GetInstance():GetScript(arg1_4)
	local var2_4 = IslandStory.New(var1_4, var0_4, IslandStory.MODE_DIALOGUE)

	arg0_4.script = var2_4

	arg0_4:StartScript(var2_4)

	local var3_4 = {}

	table.insert(var3_4, function(arg0_5)
		arg0_4:WaitForViewLoaded(_IslandCore:GetView(), arg0_5)
	end)
	table.insert(var3_4, function(arg0_6)
		arg0_4.player:OnStartAction(var2_4, arg0_6)
	end)

	for iter0_4, iter1_4 in ipairs(var2_4.steps) do
		table.insert(var3_4, function(arg0_7)
			if arg0_4.isStop then
				arg0_7()

				return
			end

			arg0_4.player:Play(arg0_4.recorder, iter0_4, var2_4, arg0_7)
		end)
	end

	table.insert(var3_4, function(arg0_8)
		arg0_4.player:OnEndAction(var2_4, arg0_8)
	end)
	table.insert(var3_4, function(arg0_9)
		arg0_4:PlayExitAniamtion(var2_4, arg0_9)
	end)
	seriesAsync(var3_4, function()
		arg0_4:EndScript(var2_4)

		if arg3_4 then
			arg3_4()
		end

		if arg1_4 == IslandGuideChecker.SIGNIN_STORY_NAME then
			IslandGuideChecker.CheckGuide("ISLAND_GUIDE_26")
		end
	end)
end

function var0_0.WaitForViewLoaded(arg0_11, arg1_11, arg2_11)
	arg0_11:RemoveTimer()

	if arg1_11:IsLoaded() then
		arg2_11()

		return
	end

	arg0_11.timer = Timer.New(function()
		if arg1_11:IsLoaded() then
			arg0_11:RemoveTimer()
			arg2_11()
		end
	end, 0.1, -1)

	arg0_11.timer:Start()
end

function var0_0.RemoveTimer(arg0_13, ...)
	if arg0_13.timer then
		arg0_13.timer:Stop()

		arg0_13.timer = nil
	end
end

function var0_0.StartScript(arg0_14, arg1_14)
	arg0_14.isStop = false
	arg0_14.canvasGroup.blocksRaycasts = true

	arg0_14.recorder:Clear()
	setActive(arg0_14._go, true)
	arg0_14:RegisterSkipBtn()
	arg0_14:RegisterLogBtn()
	arg0_14:RegisterAutoBtn()
	arg0_14.player:OnStart(arg1_14)
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg1_14.id,
		callback = function()
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.STORY)
		end
	})
	arg0_14:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.STORY_START)
end

function var0_0.RegisterAutoBtn(arg0_16)
	onButton(arg0_16, arg0_16.autoBtn, function()
		if not arg0_16.script then
			return
		end

		if arg0_16.script:GetAutoPlayFlag() then
			arg0_16.script:StopAutoPlay()
			arg0_16.player:CancelAuto()
		else
			arg0_16.script:SetAutoPlay()
			arg0_16.player:NextOne()
		end

		arg0_16:UpdateAutoBtn()
	end, SFX_PANEL)
	arg0_16:UpdateAutoBtn()
end

function var0_0.UpdateAutoBtn(arg0_18)
	local var0_18 = arg0_18.script:GetAutoPlayFlag()

	arg0_18:ClearAutoBtn(var0_18)
end

function var0_0.ClearAutoBtn(arg0_19, arg1_19)
	if not arg0_19.script then
		return
	end

	arg0_19.autoBtnImg.color = arg1_19 and var4_0 or var5_0

	local var0_19 = arg1_19 and "Show" or "Hide"

	arg0_19.setSpeedPanel[var0_19](arg0_19.setSpeedPanel, arg0_19.script)
end

function var0_0.RegisterSkipBtn(arg0_20)
	onButton(arg0_20, arg0_20.skipBtn, function()
		arg0_20.script:MarkSkipAll()
		arg0_20.player:NextOne()
	end, SFX_PANEL)
end

function var0_0.RegisterLogBtn(arg0_22)
	onButton(arg0_22, arg0_22.logBtn, function()
		if not arg0_22.recordPanel:CanOpen() then
			return
		end

		if arg0_22.script:GetAutoPlayFlag() then
			arg0_22.script:StopAutoPlay()
			arg0_22.player:CancelAuto()
			arg0_22:UpdateAutoBtn()
		end

		arg0_22.recordPanel:Show(arg0_22.recorder)
	end, SFX_PANEL)
end

function var0_0.PlayExitAniamtion(arg0_24, arg1_24, arg2_24)
	if arg1_24:LastStepIsTimeline() then
		if arg2_24 then
			arg2_24()
		end

		return
	end

	arg0_24.aniDft:SetEndEvent(function()
		if arg2_24 then
			arg2_24()
		end
	end)

	arg0_24.canvasGroup.blocksRaycasts = false

	arg0_24.animator:Play("anim_IslandStoryUI_Dialogue_Out")
end

function var0_0.EndScript(arg0_26, arg1_26)
	arg0_26.isStop = false
	arg0_26.canvasGroup.blocksRaycasts = true

	arg0_26.aniDft:SetEndEvent(nil)
	setActive(arg0_26._go, false)
	removeOnButton(arg0_26.skipBtn)
	removeOnButton(arg0_26.logBtn)
	arg0_26:ClearAutoBtn(false)
	arg0_26.recorder:Clear()
	arg0_26.recordPanel:Hide()
	arg0_26.setSpeedPanel:Clear()

	arg0_26.state = var3_0
	arg0_26.script = nil

	arg0_26:RemoveTimer()
	arg0_26.player:OnEnd(arg1_26)

	local var0_26 = arg0_26.refreshNpc

	arg0_26:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.STORY_END, var0_26)

	arg0_26.refreshNpc = nil
end

function var0_0.IsRunning(arg0_27)
	return arg0_27.state == var2_0
end

function var0_0.Stop(arg0_28)
	if arg0_28.isStop then
		return
	end

	if not arg0_28:IsRunning() then
		return
	end

	arg0_28.isStop = true

	arg0_28.player:NextOne()
end

function var0_0.onBackPressed(arg0_29)
	if arg0_29.recordPanel and arg0_29.recordPanel:IsShowing() then
		arg0_29.recordPanel:Hide()

		return true
	end

	if arg0_29:IsRunning() then
		arg0_29:Stop()

		return true
	end

	return false
end

function var0_0.OnDestroy(arg0_30)
	arg0_30.recorder:Dispose()
	arg0_30.recordPanel:Dispose()
	arg0_30.setSpeedPanel:Dispose()
	arg0_30.player:Dispose()
end

return var0_0
