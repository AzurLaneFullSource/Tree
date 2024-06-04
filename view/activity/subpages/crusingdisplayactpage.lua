local var0 = class("CrusingDisplayActPage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bgBase = arg0._tf:Find("bg_base")
	arg0.bgPay = arg0._tf:Find("bg_pay")
	arg0.btnGoBase = arg0._tf:Find("AD/btn_go_base")

	onButton(arg0, arg0.btnGoBase, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CRUSING)
	end, SFX_CONFIRM)

	arg0.btnGoPay = arg0._tf:Find("AD/btn_go_pay")

	onButton(arg0, arg0.btnGoPay, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CRUSING)
	end, SFX_CONFIRM)

	local var0 = arg0._tf:Find("AD/info_panel")

	arg0.toggleBase = var0:Find("toggle_base")

	onToggle(arg0, arg0.toggleBase, function(arg0)
		if arg0.LTBase then
			LeanTween.cancel(arg0.LTBase)
		end

		arg0.LTBase = LeanTween.alpha(arg0.bgBase, arg0 and 1 or 0, 0.5).uniqueId
	end, SFX_PANEL)

	arg0.togglePay = var0:Find("toggle_pay")

	onToggle(arg0, arg0.togglePay, function(arg0)
		if arg0.LTPay then
			LeanTween.cancel(arg0.LTPay)
		end

		arg0.LTPay = LeanTween.alpha(arg0.bgPay, arg0 and 1 or 0, 0.5).uniqueId
	end, SFX_PANEL)

	arg0.btnPay = var0:Find("unlock_panel/btn_unlock")

	onButton(arg0, arg0.btnPay, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_GIFT
		})
	end, SFX_CONFIRM)

	arg0.markPay = var0:Find("unlock_panel/mark_unlocked")
	arg0.textPay = var0:Find("text_pay")
end

function var0.OnDataSetting(arg0)
	arg0.isPay = arg0.activity.data2 == 1
end

function var0.OnUpdateFlush(arg0)
	setActive(arg0.textPay:Find("before"), not arg0.isPay)
	setActive(arg0.textPay:Find("after"), arg0.isPay)
	setActive(arg0.btnPay, not arg0.isPay)
	setActive(arg0.markPay, arg0.isPay)

	local var0 = #arg0.activity:GetCrusingUnreceiveAward() > 0

	setActive(arg0.btnGoBase:Find("tip"), var0)
	setActive(arg0.btnGoPay:Find("tip"), var0)
	onNextTick(function()
		if arg0.isPay then
			triggerToggle(arg0.togglePay, true)
		else
			triggerToggle(arg0.toggleBase, true)

			if PlayerPrefs.GetInt("first_crusing_page_display:" .. arg0.activity.id, 0) == 0 then
				PlayerPrefs.SetInt("first_crusing_page_display:" .. arg0.activity.id, 1)

				arg0.LTFirst = LeanTween.delayedCall(3, System.Action(function()
					triggerToggle(arg0.togglePay, true)

					arg0.LTFirst = LeanTween.delayedCall(3, System.Action(function()
						triggerToggle(arg0.toggleBase, true)
					end)).uniqueId
				end)).uniqueId
			end
		end
	end)
end

function var0.OnHideFlush(arg0)
	if arg0.LTFirst then
		LeanTween.cancel(arg0.LTFirst)

		arg0.LTFirst = nil
	end
end

function var0.OnDestroy(arg0)
	if arg0.LTFirst then
		LeanTween.cancel(arg0.LTFirst)

		arg0.LTFirst = nil
	end

	if arg0.LTBase then
		LeanTween.cancel(arg0.LTBase)

		arg0.LTBase = nil
	end

	if arg0.LTPay then
		LeanTween.cancel(arg0.LTPay)

		arg0.LTPay = nil
	end
end

return var0
