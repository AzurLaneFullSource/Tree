local var0_0 = class("CrusingDisplayActPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bgBase = arg0_1._tf:Find("bg_base")
	arg0_1.bgPay = arg0_1._tf:Find("bg_pay")
	arg0_1.btnGoBase = arg0_1._tf:Find("AD/btn_go_base")

	onButton(arg0_1, arg0_1.btnGoBase, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CRUSING)
	end, SFX_CONFIRM)

	arg0_1.btnGoPay = arg0_1._tf:Find("AD/btn_go_pay")

	onButton(arg0_1, arg0_1.btnGoPay, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CRUSING)
	end, SFX_CONFIRM)

	local var0_1 = arg0_1._tf:Find("AD/info_panel")

	arg0_1.toggleBase = var0_1:Find("toggle_base")

	onToggle(arg0_1, arg0_1.toggleBase, function(arg0_4)
		if arg0_1.LTBase then
			LeanTween.cancel(arg0_1.LTBase)
		end

		arg0_1.LTBase = LeanTween.alpha(arg0_1.bgBase, arg0_4 and 1 or 0, 0.5).uniqueId
	end, SFX_PANEL)

	arg0_1.togglePay = var0_1:Find("toggle_pay")

	onToggle(arg0_1, arg0_1.togglePay, function(arg0_5)
		if arg0_1.LTPay then
			LeanTween.cancel(arg0_1.LTPay)
		end

		arg0_1.LTPay = LeanTween.alpha(arg0_1.bgPay, arg0_5 and 1 or 0, 0.5).uniqueId
	end, SFX_PANEL)

	arg0_1.btnPay = var0_1:Find("unlock_panel/btn_unlock")

	onButton(arg0_1, arg0_1.btnPay, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_GIFT
		})
	end, SFX_CONFIRM)

	arg0_1.markPay = var0_1:Find("unlock_panel/mark_unlocked")
	arg0_1.textPay = var0_1:Find("text_pay")
end

function var0_0.OnDataSetting(arg0_7)
	arg0_7.isPay = arg0_7.activity.data2 == 1
end

function var0_0.OnUpdateFlush(arg0_8)
	setActive(arg0_8.textPay:Find("before"), not arg0_8.isPay)
	setActive(arg0_8.textPay:Find("after"), arg0_8.isPay)
	setActive(arg0_8.btnPay, not arg0_8.isPay)
	setActive(arg0_8.markPay, arg0_8.isPay)

	local var0_8 = #arg0_8.activity:GetCrusingUnreceiveAward() > 0

	setActive(arg0_8.btnGoBase:Find("tip"), var0_8)
	setActive(arg0_8.btnGoPay:Find("tip"), var0_8)
	onNextTick(function()
		if arg0_8.isPay then
			triggerToggle(arg0_8.togglePay, true)
		else
			triggerToggle(arg0_8.toggleBase, true)

			if PlayerPrefs.GetInt("first_crusing_page_display:" .. arg0_8.activity.id, 0) == 0 then
				PlayerPrefs.SetInt("first_crusing_page_display:" .. arg0_8.activity.id, 1)

				arg0_8.LTFirst = LeanTween.delayedCall(3, System.Action(function()
					triggerToggle(arg0_8.togglePay, true)

					arg0_8.LTFirst = LeanTween.delayedCall(3, System.Action(function()
						triggerToggle(arg0_8.toggleBase, true)
					end)).uniqueId
				end)).uniqueId
			end
		end
	end)
end

function var0_0.OnHideFlush(arg0_12)
	if arg0_12.LTFirst then
		LeanTween.cancel(arg0_12.LTFirst)

		arg0_12.LTFirst = nil
	end
end

function var0_0.OnDestroy(arg0_13)
	if arg0_13.LTFirst then
		LeanTween.cancel(arg0_13.LTFirst)

		arg0_13.LTFirst = nil
	end

	if arg0_13.LTBase then
		LeanTween.cancel(arg0_13.LTBase)

		arg0_13.LTBase = nil
	end

	if arg0_13.LTPay then
		LeanTween.cancel(arg0_13.LTPay)

		arg0_13.LTPay = nil
	end
end

return var0_0
