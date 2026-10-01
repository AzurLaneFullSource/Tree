local var0_0 = class("WSAtlasRight", import("...BaseEntity"))

var0_0.Fields = {
	isDisplay = "boolean",
	btnSwitch = "userdata",
	rtNameBg = "userdata",
	btnSettings = "userdata",
	world = "table",
	btnDeleConfirm = "userdata",
	rtWorldInfo = "userdata",
	rtMapInfo = "userdata",
	wsWorldInfo = "table",
	rtDelegatePanel = "userdata",
	rtDisplayIcon = "userdata",
	transform = "userdata",
	rtDisplayPanel = "userdata",
	btnDeleCancel = "userdata",
	rtBg = "userdata",
	btnDelegate = "userdata",
	delegateTimer = "table"
}

function var0_0.Setup(arg0_1)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init()
end

function var0_0.Dispose(arg0_2)
	if arg0_2.delegateTimer then
		arg0_2.delegateTimer:Stop()

		arg0_2.delegateTimer = nil
	end

	arg0_2.wsWorldInfo:Dispose()
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3.transform

	arg0_3.rtBg = var0_3:Find("bg")
	arg0_3.rtNameBg = var0_3:Find("name_bg")
	arg0_3.rtDisplayIcon = var0_3:Find("line/display_icon")
	arg0_3.rtDisplayPanel = var0_3:Find("line/display_panel")
	arg0_3.rtWorldInfo = arg0_3.rtDisplayPanel:Find("world_info")
	arg0_3.btnSettings = arg0_3.rtDisplayPanel:Find("btns/settings_btn")
	arg0_3.btnSwitch = arg0_3.rtDisplayPanel:Find("btns/switch_btn")
	arg0_3.btnDelegate = arg0_3.rtDisplayPanel:Find("btns/delegate_btn")
	arg0_3.rtDelegatePanel = var0_3:Find("delegate_panel")
	arg0_3.btnDeleCancel = arg0_3.rtDelegatePanel:Find("doing/cancel_btn")
	arg0_3.btnDeleConfirm = arg0_3.rtDelegatePanel:Find("finish/confirm_btn")

	setText(arg0_3.rtWorldInfo:Find("power/bg/Word"), i18n("world_total_power"))
	setText(arg0_3.rtWorldInfo:Find("explore/mileage/Text"), i18n("world_mileage"))
	setText(arg0_3.rtWorldInfo:Find("explore/pressing/Text"), i18n("world_pressing"))
	setText(arg0_3.rtDelegatePanel:Find("doing/Slider/name"), i18n("world_auto_plan_progress"))

	arg0_3.wsWorldInfo = WSWorldInfo.New()
	arg0_3.wsWorldInfo.transform = arg0_3.rtWorldInfo

	arg0_3.wsWorldInfo:Setup()
	setActive(arg0_3.rtWorldInfo, nowWorld():IsSystemOpen(WorldConst.SystemWorldInfo))
	setText(arg0_3.rtDisplayIcon:Find("name"), i18n("world_map_title_tips"))
	onButton(arg0_3, arg0_3.rtDisplayIcon, function()
		arg0_3.isDisplay = not arg0_3.isDisplay

		arg0_3:Collapse()
	end, SFX_PANEL)

	arg0_3.isDisplay = true

	arg0_3:Collapse()
	arg0_3:UpdateDelegate()
end

function var0_0.Collapse(arg0_5)
	arg0_5.rtDisplayIcon:Find("icon").localScale = arg0_5.isDisplay and Vector3.one or Vector3(-1, 1, 1)

	setActive(arg0_5.rtDisplayPanel, arg0_5.isDisplay)
	setActive(arg0_5.rtBg, arg0_5.isDisplay)
	setActive(arg0_5.rtNameBg, not arg0_5.isDisplay)
end

function var0_0.SetOverSize(arg0_6, arg1_6)
	arg0_6.rtBg.offsetMax = Vector2(-arg1_6, arg0_6.rtBg.offsetMax.y)
	arg0_6.rtNameBg.offsetMax = Vector2(-arg1_6, arg0_6.rtNameBg.offsetMax.y)
end

function var0_0.UpdateDelegate(arg0_7)
	local var0_7 = getProxy(ChapterAutoProxy)
	local var1_7 = var0_7:HasTypeCommission(ChapterAutoProxy.TYPE.WORLD)

	setActive(arg0_7.rtDelegatePanel, var1_7)

	if not var1_7 then
		if arg0_7.delegateTimer then
			arg0_7.delegateTimer:Stop()

			arg0_7.delegateTimer = nil
		end

		return
	end

	local var2_7 = var0_7:GetCommissionList()
	local var3_7 = var2_7[1]:GetStartTime()
	local var4_7 = pg.TimeMgr.GetInstance():GetServerTime()
	local var5_7 = var2_7[#var2_7]:GetFinishTime()

	setActive(arg0_7.rtDelegatePanel:Find("doing"), var4_7 < var5_7)
	setActive(arg0_7.rtDelegatePanel:Find("finish"), var5_7 <= var4_7)

	if var4_7 < var5_7 then
		if arg0_7.delegateTimer then
			arg0_7.delegateTimer:Stop()
		end

		arg0_7.delegateTimer = Timer.New(function()
			local var0_8 = 0

			var4_7 = pg.TimeMgr.GetInstance():GetServerTime()

			for iter0_8, iter1_8 in ipairs(var2_7) do
				if var4_7 < iter1_8:GetFinishTime() then
					break
				else
					var0_8 = var0_8 + 1
				end
			end

			if var0_8 < #var2_7 then
				local var1_8 = var2_7[var0_8 + 1]
				local var2_8 = var5_7 - var4_7

				setText(arg0_7.rtDelegatePanel:Find("doing/time"), string.format("%02d:%02d:%02d", calcFloor(var2_8 / 3600), calcFloor(var2_8 % 3600 / 60), var2_8 % 60))
				setText(arg0_7.rtDelegatePanel:Find("doing/Slider/Text"), string.format("%d/%d", var0_8, #var2_7))
				setText(arg0_7.rtDelegatePanel:Find("doing/name/Text"), pg.world_chapter_random[var1_8.id].name)
				setSlider(arg0_7.rtDelegatePanel:Find("doing/Slider"), 0, var5_7 - var3_7, var4_7 - var3_7)
			else
				setActive(arg0_7.rtDelegatePanel:Find("doing"), false)
				setActive(arg0_7.rtDelegatePanel:Find("finish"), true)
			end
		end, 1, var5_7 - var4_7 + 1)

		arg0_7.delegateTimer.func()
		arg0_7.delegateTimer:Start()
	end
end

return var0_0
