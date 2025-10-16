local var0_0 = class("AtelierCompositeResultYumiaView", import("view.activity.Atelier.base.AtelierCompositeResultView"))

function var0_0.ShowCompositeResult(arg0_1, arg1_1)
	GetComponent(arg0_1._tf, typeof(Animation)):Play("Anim_AtelierCompositeYumiaUI_ConfirmWindow_Resultwindow_In")
	setActive(arg0_1._go, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_1._tf)

	local var0_1 = arg1_1[1]

	if var0_1 == nil then
		return
	end

	local var1_1 = arg0_1._tf:Find("Window/itemContant")
	local var2_1 = arg0_1._tf:Find("Window/AtelierCommonYumiaItem")

	if var0_1.type ~= DROP_TYPE_RYZA_DROP then
		setActive(var2_1, false)
		setActive(var1_1, true)
		UIItemList.StaticAlign(var1_1, arg0_1._tf:Find("Window/itemContant/Icon"), #arg1_1, function(arg0_2, arg1_2, arg2_2)
			if arg0_2 == UIItemList.EventUpdate then
				local var0_2 = arg1_1[arg1_2 + 1]

				arg0_1._parentClass:UpdateRyzaDrop(arg2_2, var0_2)
				setActive(arg2_2, true)
			end
		end)

		local var3_1 = 0

		for iter0_1, iter1_1 in ipairs(arg1_1) do
			var3_1 = iter1_1:getCount() + var3_1
		end

		setText(arg0_1._tf:Find("Window/CountBG/Text"), var3_1)
	else
		local var4_1 = AtelierMaterial.New({
			configId = var0_1.id
		})

		var4_1.count = var0_1:getCount()

		arg0_1._parentClass:UpdateRyzaItem(var2_1, var4_1)
		setActive(var2_1, true)
		setActive(var1_1, false)
		setText(arg0_1._tf:Find("Window/CountBG/Text"), var0_1:getCount())
	end
end

function var0_0.HideCompositeResult(arg0_3)
	if not isActive(arg0_3._go) then
		return
	end

	local var0_3 = GetComponent(arg0_3._tf, typeof(Animation))

	var0_3:Play("Anim_AtelierCompositeYumiaUI_ConfirmWindow_Resultwindow_Out")
	pg.UIMgr.GetInstance():LoadingOn(false)

	arg0_3.closeTimer = FrameTimer.New(function()
		if not var0_3:IsPlaying("Anim_AtelierCompositeYumiaUI_ConfirmWindow_Resultwindow_Out") then
			arg0_3:StopCloseTimer()
			pg.UIMgr.GetInstance():LoadingOff()
			var0_0.super.HideCompositeResult(arg0_3)
		end
	end, 1, -1)

	arg0_3.closeTimer:Start()

	return true
end

function var0_0.StopCloseTimer(arg0_5)
	if arg0_5.closeTimer then
		arg0_5.closeTimer:Stop()

		arg0_5.closeTimer = nil
	end
end

function var0_0.PlayGuide(arg0_6)
	return
end

return var0_0
