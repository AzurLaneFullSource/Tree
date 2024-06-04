local var0 = class("StorySetSpeedPanel")
local var1 = Color.New(1, 0.8705, 0.4196, 1)
local var2 = Color.New(1, 1, 1, 1)
local var3 = 0
local var4 = 1
local var5 = 2

local function var6(arg0)
	return ({
		"0.5",
		"1",
		"2",
		"10"
	})[arg0]
end

local function var7()
	local var0 = pg.NewStoryMgr.GetInstance():GetPlaySpeed()
	local var1 = table.indexof(Story.STORY_AUTO_SPEED, var0 or 0)

	if var1 <= 0 or var1 > #Story.STORY_AUTO_SPEED then
		var1 = 1
	end

	return var6(var1)
end

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0._tf = arg1
	arg0.speedBtn = findTF(arg0._tf, "front/btns/btns/speed")
	arg0.speedImg = arg0.speedBtn:Find("Text"):GetComponent(typeof(Image))
	arg0.speedAnim = arg0.speedBtn:GetComponent(typeof(Animation))
	arg0.speedAniEvent = arg0.speedBtn:GetComponent(typeof(DftAniEvent))
	arg0.speedPanel = findTF(arg0._tf, "front/speed_panel")
	arg0.speedList = {
		arg0.speedPanel:Find("adpter/frame/content/0.5"),
		arg0.speedPanel:Find("adpter/frame/content/1"),
		arg0.speedPanel:Find("adpter/frame/content/2"),
		arg0.speedPanel:Find("adpter/frame/content/10")
	}
	arg0.speedPanelImg = arg0.speedPanel:Find("adpter/frame/speed/Text"):GetComponent(typeof(Image))
	arg0.speedPanelAnim = arg0.speedPanel:GetComponent(typeof(Animation))
	arg0.speedPanelAniEvent = arg0.speedPanel:GetComponent(typeof(DftAniEvent))

	arg0:Init()
end

function var0.Init(arg0)
	onButton(arg0, arg0.speedBtn, function()
		arg0:ShowSettings()
	end, SFX_PANEL)
	onButton(arg0, arg0.speedPanel, function()
		if arg0.speedPanelStatus == var5 then
			arg0:ShowSettings()
		elseif arg0.speedPanelStatus == var3 then
			arg0:HideSettings()
		end
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.speedList) do
		onButton(arg0, iter1, function()
			local var0 = Story.STORY_AUTO_SPEED[iter0]

			pg.NewStoryMgr.GetInstance():UpdatePlaySpeed(var0)
			arg0:HideSettings()
		end, SFX_PANEL)
	end

	arg0.speedPanelStatus = var3
end

function var0.Show(arg0)
	setActive(arg0.speedBtn, true)

	arg0.speedImg.sprite = GetSpriteFromAtlas("ui/story_atlas", var7())

	arg0.speedImg:SetNativeSize()
	arg0.speedAniEvent:SetEndEvent(function()
		setActive(arg0.speedBtn, false)
		arg0.speedAniEvent:SetEndEvent(nil)
	end)
	arg0.speedAnim:Stop()
	arg0.speedAnim:Play("anim_newstoryUI_speed_in")
end

function var0.Hide(arg0)
	arg0:RemoveTimer()
	arg0.speedAnim:Stop()
	arg0.speedAnim:Play("anim_newstoryUI_speed_out")
end

function var0.ShowSettings(arg0)
	setActive(arg0.speedBtn, false)
	setActive(arg0.speedPanel, true)

	local var0 = var7()

	arg0.speedPanelImg.sprite = GetSpriteFromAtlas("ui/story_atlas", var0)

	arg0.speedPanelImg:SetNativeSize()

	for iter0, iter1 in ipairs(arg0.speedList) do
		local var1 = iter1.name == var0

		iter1:Find("Text"):GetComponent(typeof(Image)).color = var1 and var1 or var2
	end

	arg0.speedPanelAniEvent:SetEndEvent(function()
		if arg0.speedPanelStatus == var5 then
			setActive(arg0.speedPanel, false)
			arg0.speedPanelAniEvent:SetEndEvent(nil)
		elseif arg0.speedPanelStatus == var3 then
			-- block empty
		end

		arg0.speedPanelStatus = var3
	end)
	arg0.speedPanelAnim:Stop()
	arg0.speedPanelAnim:Play("anim_newstoryUI_speedpanel_in")

	arg0.speedPanelStatus = var4

	arg0:AddHideSettingsTimer()
end

function var0.AddHideSettingsTimer(arg0)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		arg0:HideSettings()
	end, 5, 1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.HideSettings(arg0)
	arg0:RemoveTimer()
	arg0:Show()
	arg0.speedPanelAnim:Stop()
	arg0.speedPanelAnim:Play("anim_newstoryUI_speedpanel_out")

	arg0.speedPanelStatus = var5
end

function var0.Clear(arg0)
	arg0:RemoveTimer()
	setActive(arg0.speedBtn, false)
	setActive(arg0.speedPanel, false)
	arg0.speedAnim:Stop()
	arg0.speedPanelAnim:Stop()
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
