local var0_0 = class("ShipDestoryConfirmWindow", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "DestoryConfirmWindow"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")

	setActive(arg0_2:findTF("window/top/bg/infomation/title_en"), PLATFORM_CODE ~= PLATFORM_US)
	setText(arg0_2:findTF("window/top/bg/infomation/title"), i18n("title_info"))

	arg0_2.cancelBtn = arg0_2:findTF("window/cancel_btn")
	arg0_2.confirmBtn = arg0_2:findTF("window/confirm_btn")

	setText(findTF(arg0_2.confirmBtn, "pic"), i18n("destroy_confirm_access"))
	setText(findTF(arg0_2.cancelBtn, "pic"), i18n("destroy_confirm_cancel"))

	arg0_2.title = arg0_2:findTF("window/content/Text")
	arg0_2.label = arg0_2:findTF("window/content/desc/label")

	setText(arg0_2.label, i18n("destory_ship_before_tip"))

	arg0_2.urLabel = arg0_2:findTF("window/content/desc/label1")
	arg0_2.urInput = arg0_2:findTF("window/content/desc/InputField")
	arg0_2.urOverflowLabel = arg0_2:findTF("window/content/desc/label2")

	setText(arg0_2.urOverflowLabel, i18n("destory_ur_pt_overflowa"))

	local var0_2 = arg0_2:findTF("Placeholder", arg0_2.urInput)

	setText(var0_2, i18n("box_ship_del_click"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:Confirm()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.SetCallBack(arg0_8, arg1_8)
	arg0_8.callback = arg1_8
end

function var0_0.Confirm(arg0_9)
	if arg0_9.key then
		local var0_9 = getInputText(arg0_9.urInput)

		if arg0_9.key ~= tonumber(var0_9) then
			pg.TipsMgr:GetInstance():ShowTips(i18n("destory_ship_input_erro"))

			return
		end

		local var1_9 = arg0_9.callback

		arg0_9:Hide()
		existCall(var1_9)
	else
		local var2_9 = arg0_9.callback

		arg0_9:Hide()
		existCall(var2_9)
	end
end

function var0_0.ShowOneShipProtect(arg0_10, arg1_10, arg2_10)
	var0_0.super.Show(arg0_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)

	arg0_10.key = nil
	arg0_10.ships = arg1_10

	arg0_10:SetCallBack(arg2_10)
	setText(arg0_10.title, i18n("unique_ship_tip1"))

	arg0_10.key = math.random(100000, 999999)

	setText(arg0_10.urLabel, i18n("unique_ship_tip2", arg0_10.key))
	setActive(arg0_10.urLabel, true)
	setActive(arg0_10.urInput, true)
	setActive(arg0_10.urOverflowLabel, false)
	mergeSort(arg0_10.ships, CompareFuncs({
		function(arg0_11)
			return -arg0_11.level
		end,
		function(arg0_12)
			return -arg0_12:getRarity()
		end
	}, true))

	if #arg0_10.ships > 5 then
		setActive(arg0_10._tf:Find("window/content/ships"), true)
		setActive(arg0_10._tf:Find("window/content/ships_single"), false)

		local var0_10 = arg0_10._tf:Find("window/content/ships/content"):GetComponent("LScrollRect")

		function var0_10.onUpdateItem(arg0_13, arg1_13)
			updateShip(tf(arg1_13), arg0_10.ships[arg0_13 + 1])
		end

		onNextTick(function()
			var0_10:SetTotalCount(#arg0_10.ships)
		end)
	else
		setActive(arg0_10._tf:Find("window/content/ships"), false)
		setActive(arg0_10._tf:Find("window/content/ships_single"), true)

		local var1_10 = arg0_10._tf:Find("window/content/ships_single")
		local var2_10 = UIItemList.New(var1_10, var1_10:Find("IconTpl"))

		var2_10:make(function(arg0_15, arg1_15, arg2_15)
			if arg0_15 == UIItemList.EventUpdate then
				updateShip(arg2_15, arg0_10.ships[arg1_15 + 1])
			end
		end)
		var2_10:align(#arg0_10.ships)
	end
end

function var0_0.Show(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	var0_0.super.Show(arg0_16)
	pg.UIMgr.GetInstance():BlurPanel(arg0_16._tf)

	arg0_16.key = nil
	arg0_16.eliteShips = arg1_16
	arg0_16.highLevelShips = arg2_16
	arg0_16.overflow = arg3_16

	arg0_16:SetCallBack(arg4_16)
	arg0_16:Updatelayout()
	arg0_16:UpdateShips()
end

function var0_0.ShowEliteTag(arg0_17, arg1_17, arg2_17)
	var0_0.super.Show(arg0_17)
	pg.UIMgr.GetInstance():BlurPanel(arg0_17._tf)
	arg0_17:SetCallBack(arg2_17)
	setText(arg0_17.title, i18n("destroy_eliteship_tip", i18n("destroy_inHardFormation_tip")))
	setActive(arg0_17.urOverflowLabel, false)
	setActive(arg0_17.urLabel, false)
	setActive(arg0_17.urInput, false)

	arg0_17.ships = arg1_17

	if #arg0_17.ships > 5 then
		setActive(arg0_17._tf:Find("window/content/ships"), true)
		setActive(arg0_17._tf:Find("window/content/ships_single"), false)

		local var0_17 = arg0_17._tf:Find("window/content/ships/content"):GetComponent("LScrollRect")

		function var0_17.onUpdateItem(arg0_18, arg1_18)
			updateShip(tf(arg1_18), arg0_17.ships[arg0_18 + 1])
		end

		onNextTick(function()
			var0_17:SetTotalCount(#arg0_17.ships)
		end)
	else
		setActive(arg0_17._tf:Find("window/content/ships"), false)
		setActive(arg0_17._tf:Find("window/content/ships_single"), true)

		local var1_17 = arg0_17._tf:Find("window/content/ships_single")
		local var2_17 = UIItemList.New(var1_17, var1_17:Find("IconTpl"))

		var2_17:make(function(arg0_20, arg1_20, arg2_20)
			if arg0_20 == UIItemList.EventUpdate then
				updateShip(arg2_20, arg0_17.ships[arg1_20 + 1])
			end
		end)
		var2_17:align(#arg0_17.ships)
	end
end

function var0_0.Updatelayout(arg0_21)
	local var0_21 = arg0_21.eliteShips
	local var1_21 = arg0_21.highLevelShips
	local var2_21 = {}

	if #var0_21 > 0 then
		table.insert(var2_21, i18n("destroy_high_rarity_tip"))
	end

	if #var1_21 > 0 then
		table.insert(var2_21, i18n("destroy_high_level_tip", ""))
	end

	setText(arg0_21.title, i18n("destroy_eliteship_tip", table.concat(var2_21, "、")))

	local var3_21 = _.any(var0_21, function(arg0_22)
		return arg0_22:getConfig("rarity") >= ShipRarity.SSR
	end)

	if var3_21 and not arg0_21.key then
		arg0_21.key = math.random(100000, 999999)

		setText(arg0_21.urLabel, i18n("destroy_ur_rarity_tip", arg0_21.key))
	else
		setText(arg0_21.urLabel, "")
	end

	local var4_21 = var3_21 and arg0_21.overflow

	setActive(arg0_21.urOverflowLabel, var4_21)
	setActive(arg0_21.urLabel, var3_21)
	setActive(arg0_21.urInput, var3_21)
end

function var0_0.UpdateShips(arg0_23)
	local var0_23 = arg0_23.eliteShips
	local var1_23 = arg0_23.highLevelShips
	local var2_23 = table.mergeArray(var1_23, var0_23)

	mergeSort(var2_23, CompareFuncs({
		function(arg0_24)
			return -arg0_24.level
		end,
		function(arg0_25)
			return -arg0_25:getRarity()
		end
	}, true))

	arg0_23.ships = var2_23

	if #arg0_23.ships > 5 then
		setActive(arg0_23._tf:Find("window/content/ships"), true)
		setActive(arg0_23._tf:Find("window/content/ships_single"), false)

		local var3_23 = arg0_23._tf:Find("window/content/ships/content"):GetComponent("LScrollRect")

		function var3_23.onUpdateItem(arg0_26, arg1_26)
			updateShip(tf(arg1_26), arg0_23.ships[arg0_26 + 1])
		end

		onNextTick(function()
			var3_23:SetTotalCount(#arg0_23.ships)
		end)
	else
		setActive(arg0_23._tf:Find("window/content/ships"), false)
		setActive(arg0_23._tf:Find("window/content/ships_single"), true)

		local var4_23 = arg0_23._tf:Find("window/content/ships_single")
		local var5_23 = UIItemList.New(var4_23, var4_23:Find("IconTpl"))

		var5_23:make(function(arg0_28, arg1_28, arg2_28)
			if arg0_28 == UIItemList.EventUpdate then
				updateShip(arg2_28, arg0_23.ships[arg1_28 + 1])
			end
		end)
		var5_23:align(#arg0_23.ships)
	end
end

function var0_0.Hide(arg0_29)
	var0_0.super.Hide(arg0_29)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_29._tf, arg0_29._parentTf)

	arg0_29.key = nil
	arg0_29.callback = nil

	setInputText(arg0_29.urInput, "")
end

function var0_0.OnDestroy(arg0_30)
	if arg0_30:isShowing() then
		arg0_30:Hide()
	end
end

return var0_0
