local var0_0 = class("CrusingDisplayActPage2", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bgBase = arg0_1._tf:Find("bg_base")
	arg0_1.bgPay = arg0_1._tf:Find("bg_pay")
	arg0_1.btnGo = arg0_1._tf:Find("AD/btn_go")

	setText(arg0_1.btnGo:Find("Text"), i18n("cruise_tip_skin"))
	onButton(arg0_1, arg0_1.btnGo, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CRUSING)
	end, SFX_CONFIRM)

	arg0_1.btnPay = arg0_1._tf:Find("AD/btn_pay")

	setText(arg0_1.btnPay:Find("Text"), i18n("cruise_btn_pay"))
	onButton(arg0_1, arg0_1.btnPay, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_GIFT
		})
	end, SFX_CONFIRM)

	local var0_1 = arg0_1._tf:Find("AD/info_panel")

	arg0_1.toggleBase = var0_1:Find("toggle_base")

	setText(arg0_1.toggleBase:Find("Text"), i18n("cruise_tip_base"))
	onToggle(arg0_1, arg0_1.toggleBase, function(arg0_4)
		setTextAlpha(arg0_1.toggleBase:Find("Text"), arg0_4 and 1 or 0.3)

		if arg0_1.LTBase then
			LeanTween.cancel(arg0_1.LTBase)
		end

		arg0_1.LTBase = LeanTween.alpha(arg0_1.bgBase, arg0_4 and 1 or 0, 0.5).uniqueId
	end, SFX_PANEL)

	arg0_1.togglePay = var0_1:Find("toggle_pay")

	setText(arg0_1.togglePay:Find("Text"), i18n("cruise_tip_upgrade"))
	onToggle(arg0_1, arg0_1.togglePay, function(arg0_5)
		setTextAlpha(arg0_1.togglePay:Find("Text"), arg0_5 and 1 or 0.3)

		if arg0_1.LTPay then
			LeanTween.cancel(arg0_1.LTPay)
		end

		arg0_1.LTPay = LeanTween.alpha(arg0_1.bgPay, arg0_5 and 1 or 0, 0.5).uniqueId
	end, SFX_PANEL)

	arg0_1.textPay = var0_1:Find("text_pay")
end

function var0_0.OnDataSetting(arg0_6)
	arg0_6.isPay = arg0_6.activity.data2 == 1
end

function var0_0.OnUpdateFlush(arg0_7)
	setActive(arg0_7.textPay:Find("before"), not arg0_7.isPay)
	setActive(arg0_7.textPay:Find("after"), arg0_7.isPay)
	setActive(arg0_7.btnPay, not arg0_7.isPay)
	setActive(arg0_7.btnGo:Find("tip"), #arg0_7.activity:GetCrusingUnreceiveAward() > 0)

	if arg0_7.isPay then
		triggerToggle(arg0_7.togglePay, true)
	else
		triggerToggle(arg0_7.toggleBase, true)

		if PlayerPrefs.GetInt("first_crusing_page_display:" .. arg0_7.activity.id, 0) == 0 then
			PlayerPrefs.SetInt("first_crusing_page_display:" .. arg0_7.activity.id, 1)

			arg0_7.LTFirst = LeanTween.delayedCall(3, System.Action(function()
				triggerToggle(arg0_7.togglePay, true)

				arg0_7.LTFirst = LeanTween.delayedCall(3, System.Action(function()
					triggerToggle(arg0_7.toggleBase, true)
				end)).uniqueId
			end)).uniqueId
		end
	end
end

function var0_0.OnHideFlush(arg0_10)
	if arg0_10.LTFirst then
		LeanTween.cancel(arg0_10.LTFirst)

		arg0_10.LTFirst = nil
	end
end

function var0_0.OnDestroy(arg0_11)
	if arg0_11.LTFirst then
		LeanTween.cancel(arg0_11.LTFirst)

		arg0_11.LTFirst = nil
	end

	if arg0_11.LTBase then
		LeanTween.cancel(arg0_11.LTBase)

		arg0_11.LTBase = nil
	end

	if arg0_11.LTPay then
		LeanTween.cancel(arg0_11.LTPay)

		arg0_11.LTPay = nil
	end
end

return var0_0
