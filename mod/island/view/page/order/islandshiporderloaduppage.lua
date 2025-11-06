local var0_0 = class("IslandShipOrderLoadUpPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandShipOrderLoadUpUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.mainTr = arg0_2._tf:Find("main")
	arg0_2.cntTxt = arg0_2._tf:Find("main/name/count"):GetComponent(typeof(Text))
	arg0_2.submitBtn = arg0_2._tf:Find("main/btn/btn_1")
	arg0_2.noResBtn = arg0_2._tf:Find("main/btn/btn_2")
	arg0_2.disableBtn = arg0_2._tf:Find("main/btn/btn_3")
	arg0_2.awardCntTxt = arg0_2._tf:Find("main/price/Text"):GetComponent(typeof(Text))
	arg0_2.nameTxt = arg0_2._tf:Find("main/name"):GetComponent(typeof(Text))

	setText(arg0_2._tf:Find("main/title/Text"), i18n("island_order_ship_loadup_award"))
	setText(arg0_2._tf:Find("main/btn/btn_2/Text"), i18n("island_order_ship_loadup_nores"))
	setText(arg0_2._tf:Find("main/btn/btn_1/Text"), i18n("island_order_ship_loadup"))
	setText(arg0_2._tf:Find("main/btn/btn_3/Text"), i18n("island_order_ship_finish_cnt_not_enough"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(IslandShipOrderPage.EVENT_CLOSE_LOAD_UP)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.submitBtn, function()
		if not arg0_3.slot or not arg0_3.index then
			return
		end

		if not arg0_3.slot:CanTransport() then
			return
		end

		arg0_3:emit(IslandMediator.SUBMIT_SHIP_ORDER_ITME, arg0_3.slot.id, arg0_3.index)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6, arg2_6, arg3_6)
	var0_0.super.Show(arg0_6)

	arg0_6.slot = arg2_6
	arg0_6.index = arg3_6
	arg0_6.mainTr.localPosition = arg1_6

	local var0_6 = arg2_6:GetOrder():GetComsume(arg3_6)
	local var1_6 = Drop.New(var0_6)
	local var2_6 = var1_6:getOwnedCount()
	local var3_6 = var1_6.count
	local var4_6 = var3_6 <= var2_6
	local var5_6 = var4_6 and "#39beff" or "#f36c6e"

	arg0_6.cntTxt.text = setColorStr(var2_6 .. "/" .. var3_6, var5_6)
	arg0_6.nameTxt.text = var1_6:getName()
	arg0_6.awardCntTxt.text = "X" .. arg2_6:GetOrder():GetConsumeAwards(arg3_6)[1].count

	local var6_6 = arg0_6.slot:CanTransport()

	setActive(arg0_6.submitBtn, var4_6 and var6_6)
	setActive(arg0_6.noResBtn, not var4_6 and var6_6)
	setActive(arg0_6.disableBtn, not var6_6)
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
