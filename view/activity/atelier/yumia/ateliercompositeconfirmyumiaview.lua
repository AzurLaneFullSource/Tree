local var0_0 = class("AtelierCompositeConfirmYumiaView", import("view.activity.Atelier.base.AtelierCompositeConfirmView"))

function var0_0.InitCustom(arg0_1)
	setText(arg0_1._tf:Find("Window/titleBg/Name"), i18n("yumia_atelier_tip14"))
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("Window/titleBg/closeBtn"), function()
		arg0_2:HideCompositeConfirmWindow()
	end, SFX_CANCEL)
end

function var0_0.HideCompositeConfirmWindow(arg0_4)
	if not isActive(arg0_4._go) then
		return
	end

	local var0_4 = GetComponent(arg0_4._tf, typeof(Animation))

	var0_4:Play("Anim_AtelierCompositeYumiaUI_ConfirmWindow_Out")
	pg.UIMgr.GetInstance():LoadingOn(false)

	arg0_4.closeTimer = FrameTimer.New(function()
		if not var0_4:IsPlaying("Anim_AtelierCompositeYumiaUI_ConfirmWindow_Out") then
			arg0_4:StopCloseTimer()
			pg.UIMgr.GetInstance():LoadingOff()
			var0_0.super.HideCompositeConfirmWindow(arg0_4)
		end
	end, 1, -1)

	arg0_4.closeTimer:Start()

	return true
end

function var0_0.StopCloseTimer(arg0_6)
	if arg0_6.closeTimer then
		arg0_6.closeTimer:Stop()

		arg0_6.closeTimer = nil
	end
end

function var0_0.ShowCompositeConfirmWindow(arg0_7, arg1_7)
	GetComponent(arg0_7._tf, typeof(Animation)):Play("Anim_AtelierCompositeYumiaUI_ConfirmWindow_In")
	setActive(arg0_7._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)

	local var0_7 = 1
	local var1_7 = {}
	local var2_7 = {}

	_.each(arg1_7, function(arg0_8)
		local var0_8 = arg0_8.Instance:GetConfigID()

		table.insert(var1_7, {
			key = arg0_8.Data:GetConfigID(),
			value = var0_8
		})

		var2_7[var0_8] = (var2_7[var0_8] or 0) + 1
	end)
	onButton(arg0_7, arg0_7._tf:Find("Window/Confirm"), function()
		arg0_7._parentClass:emit(GAME.COMPOSITE_ATELIER_RECIPE, var1_7, var0_7)
		arg0_7._parentClass:PlaySoundEffect(arg0_7._parentClass.soundStr.compositeConfirm)
	end, SFX_PANEL)

	local var3_7 = arg0_7.activity:GetFormulas()[arg0_7.contextData.formulaId]
	local var4_7 = var3_7:GetMaxLimit() ~= 1
	local var5_7 = var3_7:GetMaxLimit() > 0 and var3_7:GetMaxLimit() - var3_7:GetUsedCount() or 10000
	local var6_7 = arg0_7.activity:GetItems()

	for iter0_7, iter1_7 in pairs(var2_7) do
		local var7_7 = var6_7[iter0_7] and var6_7[iter0_7].count or 0

		var5_7 = math.min(var5_7, math.floor(var7_7 / iter1_7))
	end

	local var8_7 = var5_7
	local var9_7 = {
		1,
		var4_7 and var8_7 or 1
	}
	local var10_7 = Drop.New({
		type = var3_7:GetProduction()[1],
		id = var3_7:GetProduction()[2]
	})
	local var11_7 = arg0_7._tf:Find("Window/Icon")
	local var12_7 = arg0_7._tf:Find("Window/AtelierCommonYumiaItem")

	if var10_7.type ~= DROP_TYPE_RYZA_DROP then
		arg0_7._parentClass:UpdateRyzaDrop(var11_7, var10_7)
		setActive(var11_7, true)
		setActive(var12_7, false)
	else
		local var13_7 = var3_7:GetProduction()[2]
		local var14_7 = AtelierMaterial.New({
			configId = var13_7
		})

		var14_7.count = 1

		arg0_7._parentClass:UpdateRyzaItem(var12_7, var14_7)
		setActive(var11_7, false)
		setActive(var12_7, true)
	end

	local var15_7 = arg0_7._tf:Find("Window/Counters")
	local var16_7 = var10_7:getConfig("name")

	setActive(var15_7, var4_7)

	if var4_7 then
		local function var17_7()
			setText(var15_7:Find("Number"), var0_7)
			setText(arg0_7._tf:Find("Window/Text"), i18n("yumia_atelier_tip20", var16_7, var0_7))
			setText(var12_7:Find("cntText"), var0_7)
		end

		var17_7()
		onButton(arg0_7, var15_7:Find("Plus"), function()
			local var0_11 = var0_7

			var0_7 = var0_7 + 1
			var0_7 = math.clamp(var0_7, var9_7[1], var9_7[2])

			if var0_11 == var0_7 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("yumia_atelier_tip21"))

				return
			end

			var17_7()
		end)
		onButton(arg0_7, var15_7:Find("Minus"), function()
			var0_7 = var0_7 - 1
			var0_7 = math.clamp(var0_7, var9_7[1], var9_7[2])

			var17_7()
		end)
		onButton(arg0_7, var15_7:Find("Plus10"), function()
			local var0_13 = var0_7

			var0_7 = var0_7 + 10
			var0_7 = math.clamp(var0_7, var9_7[1], var9_7[2])

			if var0_13 == var0_7 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("yumia_atelier_tip21"))

				return
			end

			var17_7()
		end)
		onButton(arg0_7, var15_7:Find("Minus10"), function()
			var0_7 = var0_7 - 10
			var0_7 = math.clamp(var0_7, var9_7[1], var9_7[2])

			var17_7()
		end)
	else
		setText(arg0_7._tf:Find("Window/Text"), i18n("yumia_atelier_tip19", var16_7, var0_7))
	end
end

return var0_0
