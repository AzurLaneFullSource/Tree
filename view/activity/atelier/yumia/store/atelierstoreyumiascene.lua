local var0_0 = class("AtelierStoreYumiaScene", import("view.activity.Atelier.Store.AtelierStoreBaseScene"))

function var0_0.getUIName(arg0_1)
	return "AtelierStoreYumiaUI"
end

function var0_0.InitCustom(arg0_2)
	setText(arg0_2._tf:Find("Window/Text"), i18n("yumia_atelier_tip13"))
	setText(arg0_2._tf:Find("Window/textBg/Name"), i18n("yumia_atelier_tip16"))
end

function var0_0.didEnter(arg0_3)
	arg0_3.activity = arg0_3.contextData.activity

	onButton(arg0_3, arg0_3._tf:Find("Window/textBg/closeBtn"), function()
		arg0_3:PlayCloseAni()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("BG"), function()
		arg0_3:PlayCloseAni()
	end, SFX_CANCEL)
	arg0_3:ShowStoreHouseWindow()
end

function var0_0.PlayCloseAni(arg0_6)
	local var0_6 = GetComponent(arg0_6._tf, typeof(Animation))

	var0_6:Play("Anim_AtelierStoreYumiaUI_Out")
	pg.UIMgr.GetInstance():LoadingOn(false)

	arg0_6.closeTimer = FrameTimer.New(function()
		if not var0_6:IsPlaying("Anim_AtelierStoreYumiaUI_Out") then
			arg0_6:StopCloseTimer()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_6:closeView()
		end
	end, 1, -1)

	arg0_6.closeTimer:Start()
end

function var0_0.StopCloseTimer(arg0_8)
	if arg0_8.closeTimer then
		arg0_8.closeTimer:Stop()

		arg0_8.closeTimer = nil
	end
end

function var0_0.ShowStoreHouseWindow(arg0_9)
	local var0_9 = arg0_9.contextData.versionIndex or 2

	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)

	local var1_9 = _.filter(_.values(arg0_9.activity:GetItems()), function(arg0_10)
		return arg0_10.count > 0 and arg0_10:GetVersion() == var0_9 and arg0_10:IsShow() ~= 0
	end)

	table.sort(var1_9, function(arg0_11, arg1_11)
		return arg0_11:GetConfigID() < arg1_11:GetConfigID()
	end)
	setActive(arg0_9._tf:Find("Window/Empty"), #var1_9 == 0)
	setActive(arg0_9._tf:Find("Window/ScrollView"), #var1_9 > 0)

	if #var1_9 == 0 then
		return
	end

	function arg0_9.storehouseRect.onUpdateItem(arg0_12, arg1_12)
		arg0_12 = arg0_12 + 1

		local var0_12 = tf(arg1_12)
		local var1_12 = var1_9[arg0_12]

		arg0_9:UpdateRyzaItem(var0_12, var1_12)
		onButton(arg0_9, var0_12, function()
			arg0_9:ShowItemDetail(var1_12)
		end, SFX_PANEL)
	end

	arg0_9.storehouseRect:SetTotalCount(#var1_9)
	arg0_9:AddTimer(#var1_9)
end

function var0_0.UpdateRyzaItem(arg0_14, arg1_14, arg2_14)
	AtelierTools.UpdateYumiaItem(arg1_14, arg2_14)
end

function var0_0.ShowItemDetail(arg0_15, arg1_15)
	arg0_15:emit(AtelierMaterialDetailMediator.SHOW_DETAIL, arg1_15)
end

function var0_0.AddTimer(arg0_16, arg1_16)
	local var0_16 = 0
	local var1_16 = arg0_16._tf:Find("Window/ScrollView/Viewport/Content")

	arg0_16.timer = FrameTimer.New(function()
		if math.min(var1_16.childCount, 15) <= arg1_16 then
			arg0_16:StopTimer()
			arg0_16:AddTimer2()
		end
	end, 1, -1)

	arg0_16.timer:Start()
end

function var0_0.AddTimer2(arg0_18)
	local var0_18 = arg0_18._tf:Find("Window/ScrollView/Viewport/Content")
	local var1_18 = var0_18.childCount

	SetComponentEnabled(arg0_18._tf:Find("Window/ScrollView"), "LScrollRect", false)

	for iter0_18 = 0, var1_18 - 1 do
		SetComponentEnabled(var0_18:GetChild(iter0_18), typeof(Animation), false)

		GetComponent(var0_18:GetChild(iter0_18), typeof(CanvasGroup)).alpha = 0
	end

	local var2_18 = 0

	arg0_18.timer = Timer.New(function()
		if var2_18 >= var1_18 then
			arg0_18:StopTimer()
			SetComponentEnabled(arg0_18._tf:Find("Window/ScrollView"), "LScrollRect", true)

			return
		end

		local var0_19 = GetComponent(var0_18:GetChild(var2_18), typeof(Animation))

		var0_19.enabled = true

		var0_19:Stop()
		var0_19:Play("Anim_AtelierStoreYumiaUI_Tpl_In")

		var2_18 = var2_18 + 1
	end, 0.08, -1)

	arg0_18.timer:Start()
end

function var0_0.StopTimer(arg0_20)
	if arg0_20.timer then
		arg0_20.timer:Stop()

		arg0_20.timer = nil
	end
end

function var0_0.willExit(arg0_21)
	arg0_21:StopTimer()
	var0_0.super.willExit(arg0_21)
end

return var0_0
