local var0_0 = class("StorySetSpeedPanel")
local var1_0 = Color.New(1, 0.8705, 0.4196, 1)
local var2_0 = Color.New(1, 1, 1, 1)
local var3_0 = 0
local var4_0 = 1
local var5_0 = 2

local function var6_0(arg0_1)
	return ({
		"0.5",
		"1",
		"2",
		"10"
	})[arg0_1]
end

local function var7_0()
	local var0_2 = pg.NewStoryMgr.GetInstance():GetPlaySpeed()
	local var1_2 = table.indexof(Story.STORY_AUTO_SPEED, var0_2 or 0)

	if var1_2 <= 0 or var1_2 > #Story.STORY_AUTO_SPEED then
		var1_2 = 1
	end

	return var6_0(var1_2)
end

function var0_0.Ctor(arg0_3, arg1_3)
	pg.DelegateInfo.New(arg0_3)

	arg0_3._tf = arg1_3
	arg0_3.speedBtn = findTF(arg0_3._tf, "front/btns/btns/speed")
	arg0_3.speedImg = arg0_3.speedBtn:Find("Text"):GetComponent(typeof(Image))
	arg0_3.speedAnim = arg0_3.speedBtn:GetComponent(typeof(Animation))
	arg0_3.speedAniEvent = arg0_3.speedBtn:GetComponent(typeof(DftAniEvent))
	arg0_3.speedPanel = findTF(arg0_3._tf, "front/speed_panel")
	arg0_3.speedList = {
		arg0_3.speedPanel:Find("adpter/frame/content/0.5"),
		arg0_3.speedPanel:Find("adpter/frame/content/1"),
		arg0_3.speedPanel:Find("adpter/frame/content/2"),
		arg0_3.speedPanel:Find("adpter/frame/content/10")
	}
	arg0_3.speedPanelImg = arg0_3.speedPanel:Find("adpter/frame/speed/Text"):GetComponent(typeof(Image))
	arg0_3.speedPanelAnim = arg0_3.speedPanel:GetComponent(typeof(Animation))
	arg0_3.speedPanelAniEvent = arg0_3.speedPanel:GetComponent(typeof(DftAniEvent))

	arg0_3:Init()
end

function var0_0.Init(arg0_4)
	onButton(arg0_4, arg0_4.speedBtn, function()
		arg0_4:ShowSettings()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.speedPanel, function()
		if arg0_4.speedPanelStatus == var5_0 then
			arg0_4:ShowSettings()
		elseif arg0_4.speedPanelStatus == var3_0 then
			arg0_4:HideSettings()
		end
	end, SFX_PANEL)

	for iter0_4, iter1_4 in ipairs(arg0_4.speedList) do
		onButton(arg0_4, iter1_4, function()
			local var0_7 = Story.STORY_AUTO_SPEED[iter0_4]

			pg.NewStoryMgr.GetInstance():UpdatePlaySpeed(var0_7)
			arg0_4:HideSettings()
		end, SFX_PANEL)
	end

	arg0_4.speedPanelStatus = var3_0
end

function var0_0.Show(arg0_8)
	setActive(arg0_8.speedBtn, true)

	arg0_8.speedImg.sprite = GetSpriteFromAtlas("ui/story_atlas", var7_0())

	arg0_8.speedImg:SetNativeSize()
	arg0_8.speedAniEvent:SetEndEvent(function()
		setActive(arg0_8.speedBtn, false)
		arg0_8.speedAniEvent:SetEndEvent(nil)
	end)
	arg0_8.speedAnim:Stop()
	arg0_8.speedAnim:Play("anim_newstoryUI_speed_in")
end

function var0_0.Hide(arg0_10)
	arg0_10:RemoveTimer()
	arg0_10.speedAnim:Stop()
	arg0_10.speedAnim:Play("anim_newstoryUI_speed_out")
end

function var0_0.ShowSettings(arg0_11)
	setActive(arg0_11.speedBtn, false)
	setActive(arg0_11.speedPanel, true)

	local var0_11 = var7_0()

	arg0_11.speedPanelImg.sprite = GetSpriteFromAtlas("ui/story_atlas", var0_11)

	arg0_11.speedPanelImg:SetNativeSize()

	for iter0_11, iter1_11 in ipairs(arg0_11.speedList) do
		local var1_11 = iter1_11.name == var0_11

		iter1_11:Find("Text"):GetComponent(typeof(Image)).color = var1_11 and var1_0 or var2_0
	end

	arg0_11.speedPanelAniEvent:SetEndEvent(function()
		if arg0_11.speedPanelStatus == var5_0 then
			setActive(arg0_11.speedPanel, false)
			arg0_11.speedPanelAniEvent:SetEndEvent(nil)
		elseif arg0_11.speedPanelStatus == var3_0 then
			-- block empty
		end

		arg0_11.speedPanelStatus = var3_0
	end)
	arg0_11.speedPanelAnim:Stop()
	arg0_11.speedPanelAnim:Play("anim_newstoryUI_speedpanel_in")

	arg0_11.speedPanelStatus = var4_0

	arg0_11:AddHideSettingsTimer()
end

function var0_0.AddHideSettingsTimer(arg0_13)
	arg0_13:RemoveTimer()

	arg0_13.timer = Timer.New(function()
		arg0_13:HideSettings()
	end, 5, 1)

	arg0_13.timer:Start()
end

function var0_0.RemoveTimer(arg0_15)
	if arg0_15.timer then
		arg0_15.timer:Stop()

		arg0_15.timer = nil
	end
end

function var0_0.HideSettings(arg0_16)
	arg0_16:RemoveTimer()
	arg0_16:Show()
	arg0_16.speedPanelAnim:Stop()
	arg0_16.speedPanelAnim:Play("anim_newstoryUI_speedpanel_out")

	arg0_16.speedPanelStatus = var5_0
end

function var0_0.Clear(arg0_17)
	arg0_17:RemoveTimer()
	setActive(arg0_17.speedBtn, false)
	setActive(arg0_17.speedPanel, false)
	arg0_17.speedAnim:Stop()
	arg0_17.speedPanelAnim:Stop()
end

function var0_0.Dispose(arg0_18)
	arg0_18:Clear()
end

return var0_0
