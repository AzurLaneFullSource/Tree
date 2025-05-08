local var0_0 = class("IslandStoryMgr", import("view.base.BaseSubView"))
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

function var0_0.Play(arg0_4, arg1_4, arg2_4)
	if not _IslandCore then
		return
	end

	if arg0_4:IsRunning() then
		arg2_4()

		return
	end

	local var0_4 = _IslandCore:GetView():GetUnitList()

	arg0_4.state = var2_0

	local var1_4 = pg.NewStoryMgr.GetInstance():GetScript(arg1_4)
	local var2_4 = IslandStory.New(var1_4, var0_4, IslandStory.MODE_DIALOGUE)

	arg0_4.script = var2_4

	arg0_4:StartScript(var2_4)

	local var3_4 = {}

	for iter0_4, iter1_4 in ipairs(var2_4.steps) do
		table.insert(var3_4, function(arg0_5)
			arg0_4.player:Play(arg0_4.recorder, iter0_4, var2_4, arg0_5)
		end)
	end

	seriesAsync(var3_4, function()
		arg0_4:EndScript(var2_4)

		if arg2_4 then
			arg2_4()
		end
	end)
end

function var0_0.StartScript(arg0_7, arg1_7)
	arg0_7.recorder:Clear()
	setActive(arg0_7._go, true)
	arg0_7:RegisterSkipBtn()
	arg0_7:RegisterLogBtn()
	arg0_7:RegisterAutoBtn()
	arg0_7.player:OnStart(arg1_7)

	if _IslandCore then
		_IslandCore:Link(ISLAND_EVT.START_STORY)
	end
end

function var0_0.RegisterAutoBtn(arg0_8)
	onButton(arg0_8, arg0_8.autoBtn, function()
		if not arg0_8.script then
			return
		end

		if arg0_8.script:GetAutoPlayFlag() then
			arg0_8.script:StopAutoPlay()
			arg0_8.player:CancelAuto()
		else
			arg0_8.script:SetAutoPlay()
			arg0_8.player:NextOne()
		end

		arg0_8:UpdateAutoBtn()
	end, SFX_PANEL)
	arg0_8:UpdateAutoBtn()
end

function var0_0.UpdateAutoBtn(arg0_10)
	local var0_10 = arg0_10.script:GetAutoPlayFlag()

	arg0_10:ClearAutoBtn(var0_10)
end

function var0_0.ClearAutoBtn(arg0_11, arg1_11)
	if not arg0_11.script then
		return
	end

	arg0_11.autoBtnImg.color = arg1_11 and var4_0 or var5_0

	local var0_11 = arg1_11 and "Show" or "Hide"

	arg0_11.setSpeedPanel[var0_11](arg0_11.setSpeedPanel, arg0_11.script)
end

function var0_0.RegisterSkipBtn(arg0_12)
	onButton(arg0_12, arg0_12.skipBtn, function()
		arg0_12.script:MarkSkipAll()
		arg0_12.player:NextOne()
	end, SFX_PANEL)
end

function var0_0.RegisterLogBtn(arg0_14)
	onButton(arg0_14, arg0_14.logBtn, function()
		if not arg0_14.recordPanel:CanOpen() then
			return
		end

		arg0_14.recordPanel:Show(arg0_14.recorder)
	end, SFX_PANEL)
end

function var0_0.EndScript(arg0_16, arg1_16)
	setActive(arg0_16._go, false)
	removeOnButton(arg0_16.skipBtn)
	removeOnButton(arg0_16.logBtn)
	arg0_16:ClearAutoBtn(false)
	arg0_16.recorder:Clear()
	arg0_16.recordPanel:Hide()
	arg0_16.setSpeedPanel:Clear()

	arg0_16.state = var3_0
	arg0_16.script = nil

	arg0_16.player:OnEnd(arg1_16)

	if _IslandCore then
		_IslandCore:Link(ISLAND_EVT.END_STORY)
	end
end

function var0_0.IsRunning(arg0_17)
	return arg0_17.state == var2_0
end

function var0_0.OnDestroy(arg0_18)
	arg0_18.recorder:Dispose()
	arg0_18.recordPanel:Dispose()
	arg0_18.setSpeedPanel:Dispose()
end

return var0_0
