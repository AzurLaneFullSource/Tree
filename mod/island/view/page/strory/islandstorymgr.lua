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
		arg0_4.player:OnStartAction(var2_4, arg0_5)
	end)

	for iter0_4, iter1_4 in ipairs(var2_4.steps) do
		table.insert(var3_4, function(arg0_6)
			if arg0_4.isStop then
				arg0_6()

				return
			end

			arg0_4.player:Play(arg0_4.recorder, iter0_4, var2_4, arg0_6)
		end)
	end

	table.insert(var3_4, function(arg0_7)
		arg0_4.player:OnEndAction(var2_4, arg0_7)
	end)
	table.insert(var3_4, function(arg0_8)
		arg0_4:PlayExitAniamtion(var2_4, arg0_8)
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

function var0_0.StartScript(arg0_10, arg1_10)
	arg0_10.isStop = false
	arg0_10.canvasGroup.blocksRaycasts = true

	arg0_10.recorder:Clear()
	setActive(arg0_10._go, true)
	arg0_10:RegisterSkipBtn()
	arg0_10:RegisterLogBtn()
	arg0_10:RegisterAutoBtn()
	arg0_10.player:OnStart(arg1_10)
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = arg1_10.id,
		callback = function()
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.STORY)
		end
	})
	arg0_10:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.STORY_START)
end

function var0_0.RegisterAutoBtn(arg0_12)
	onButton(arg0_12, arg0_12.autoBtn, function()
		if not arg0_12.script then
			return
		end

		if arg0_12.script:GetAutoPlayFlag() then
			arg0_12.script:StopAutoPlay()
			arg0_12.player:CancelAuto()
		else
			arg0_12.script:SetAutoPlay()
			arg0_12.player:NextOne()
		end

		arg0_12:UpdateAutoBtn()
	end, SFX_PANEL)
	arg0_12:UpdateAutoBtn()
end

function var0_0.UpdateAutoBtn(arg0_14)
	local var0_14 = arg0_14.script:GetAutoPlayFlag()

	arg0_14:ClearAutoBtn(var0_14)
end

function var0_0.ClearAutoBtn(arg0_15, arg1_15)
	if not arg0_15.script then
		return
	end

	arg0_15.autoBtnImg.color = arg1_15 and var4_0 or var5_0

	local var0_15 = arg1_15 and "Show" or "Hide"

	arg0_15.setSpeedPanel[var0_15](arg0_15.setSpeedPanel, arg0_15.script)
end

function var0_0.RegisterSkipBtn(arg0_16)
	onButton(arg0_16, arg0_16.skipBtn, function()
		arg0_16.script:MarkSkipAll()
		arg0_16.player:NextOne()
	end, SFX_PANEL)
end

function var0_0.RegisterLogBtn(arg0_18)
	onButton(arg0_18, arg0_18.logBtn, function()
		if not arg0_18.recordPanel:CanOpen() then
			return
		end

		if arg0_18.script:GetAutoPlayFlag() then
			arg0_18.script:StopAutoPlay()
			arg0_18.player:CancelAuto()
			arg0_18:UpdateAutoBtn()
		end

		arg0_18.recordPanel:Show(arg0_18.recorder)
	end, SFX_PANEL)
end

function var0_0.PlayExitAniamtion(arg0_20, arg1_20, arg2_20)
	if arg1_20:LastStepIsTimeline() then
		if arg2_20 then
			arg2_20()
		end

		return
	end

	arg0_20.aniDft:SetEndEvent(function()
		if arg2_20 then
			arg2_20()
		end
	end)

	arg0_20.canvasGroup.blocksRaycasts = false

	arg0_20.animator:Play("anim_IslandStoryUI_Dialogue_Out")
end

function var0_0.EndScript(arg0_22, arg1_22)
	arg0_22.isStop = false
	arg0_22.canvasGroup.blocksRaycasts = true

	arg0_22.aniDft:SetEndEvent(nil)
	setActive(arg0_22._go, false)
	removeOnButton(arg0_22.skipBtn)
	removeOnButton(arg0_22.logBtn)
	arg0_22:ClearAutoBtn(false)
	arg0_22.recorder:Clear()
	arg0_22.recordPanel:Hide()
	arg0_22.setSpeedPanel:Clear()

	arg0_22.state = var3_0
	arg0_22.script = nil

	arg0_22.player:OnEnd(arg1_22)

	local var0_22 = arg0_22.refreshNpc

	arg0_22:emit(IslandBaseScene.LINK_CORE_EVENT, IslandProxy.STORY_END, var0_22)

	arg0_22.refreshNpc = nil
end

function var0_0.IsRunning(arg0_23)
	return arg0_23.state == var2_0
end

function var0_0.Stop(arg0_24)
	if arg0_24.isStop then
		return
	end

	if not arg0_24:IsRunning() then
		return
	end

	arg0_24.isStop = true

	arg0_24.player:NextOne()
end

function var0_0.onBackPressed(arg0_25)
	if arg0_25.recordPanel and arg0_25.recordPanel:IsShowing() then
		arg0_25.recordPanel:Hide()

		return true
	end

	if arg0_25:IsRunning() then
		arg0_25:Stop()

		return true
	end

	return false
end

function var0_0.OnDestroy(arg0_26)
	arg0_26.recorder:Dispose()
	arg0_26.recordPanel:Dispose()
	arg0_26.setSpeedPanel:Dispose()
	arg0_26.player:Dispose()
end

return var0_0
