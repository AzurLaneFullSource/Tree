local var0_0 = class("ShipDestoryConfirmWindow", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "DestoryConfirmWindow"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"shiptype",
		"ui/iconcolorful"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.getShipResList(arg0_3, arg1_3)
	local var0_3 = {}

	_.each(arg1_3 or {}, function(arg0_4)
		if arg0_4 then
			local var0_4 = ResPathSupport.GetPaintingSquareIconListByPaintingName(arg0_4:getPainting())

			table.insertto(var0_3, var0_4)
		end
	end)

	return var0_3
end

function var0_0.downloadShipResList(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:getShipResList(arg1_5)

	SplitPackConst.DownloadByLuaArr(var0_5, function()
		if arg0_5._state == var0_0.STATES.DESTROY then
			return
		end

		arg2_5()
	end)
end

function var0_0.OnLoaded(arg0_7)
	arg0_7.closeBtn = arg0_7._tf:Find("window/top/btnBack")

	setActive(arg0_7._tf:Find("window/top/bg/infomation/title_en"), PLATFORM_CODE ~= PLATFORM_US)
	setText(arg0_7._tf:Find("window/top/bg/infomation/title"), i18n("title_info"))

	arg0_7.cancelBtn = arg0_7._tf:Find("window/cancel_btn")
	arg0_7.confirmBtn = arg0_7._tf:Find("window/confirm_btn")

	setText(findTF(arg0_7.confirmBtn, "pic"), i18n("destroy_confirm_access"))
	setText(findTF(arg0_7.cancelBtn, "pic"), i18n("destroy_confirm_cancel"))

	arg0_7.title = arg0_7._tf:Find("window/content/Text")
	arg0_7.label = arg0_7._tf:Find("window/content/desc/label")

	setText(arg0_7.label, i18n("destory_ship_before_tip"))

	arg0_7.urLabel = arg0_7._tf:Find("window/content/desc/label1")
	arg0_7.urInput = arg0_7._tf:Find("window/content/desc/InputField")
	arg0_7.urOverflowLabel = arg0_7._tf:Find("window/content/desc/label2")

	setText(arg0_7.urOverflowLabel, i18n("destory_ur_pt_overflowa"))

	local var0_7 = arg0_7.urInput:Find("Placeholder")

	setText(var0_7, i18n("box_ship_del_click"))
end

function var0_0.OnInit(arg0_8)
	onButton(arg0_8, arg0_8.cancelBtn, function()
		arg0_8:Hide()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		arg0_8:Confirm()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf:Find("bg"), function()
		arg0_8:Hide()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.closeBtn, function()
		arg0_8:Hide()
	end, SFX_PANEL)
end

function var0_0.SetCallBack(arg0_13, arg1_13)
	arg0_13.callback = arg1_13
end

function var0_0.Confirm(arg0_14)
	if arg0_14.key then
		local var0_14 = getInputText(arg0_14.urInput)

		if arg0_14.key ~= tonumber(var0_14) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destory_ship_input_erro"))

			return
		end

		local var1_14 = arg0_14.callback

		arg0_14:Hide()
		existCall(var1_14)
	else
		local var2_14 = arg0_14.callback

		arg0_14:Hide()
		existCall(var2_14)
	end
end

function var0_0.ShowOneShipProtect(arg0_15, arg1_15, arg2_15)
	arg0_15:downloadShipResList(arg1_15, function()
		arg0_15:ShowOneShipProtectAfterResDownload(arg1_15, arg2_15)
	end)
end

function var0_0.ShowOneShipProtectAfterResDownload(arg0_17, arg1_17, arg2_17)
	var0_0.super.Show(arg0_17)
	pg.UIMgr.GetInstance():BlurPanel(arg0_17._tf)

	arg0_17.key = nil
	arg0_17.ships = arg1_17

	arg0_17:SetCallBack(arg2_17)
	setText(arg0_17.title, i18n("unique_ship_tip1"))

	arg0_17.key = math.random(100000, 999999)

	setText(arg0_17.urLabel, i18n("unique_ship_tip2", arg0_17.key))
	setActive(arg0_17.urLabel, true)
	setActive(arg0_17.urInput, true)
	setActive(arg0_17.urOverflowLabel, false)
	mergeSort(arg0_17.ships, CompareFuncs({
		function(arg0_18)
			return -arg0_18.level
		end,
		function(arg0_19)
			return -arg0_19:getRarity()
		end
	}, true))

	if #arg0_17.ships > 5 then
		setActive(arg0_17._tf:Find("window/content/ships"), true)
		setActive(arg0_17._tf:Find("window/content/ships_single"), false)

		local var0_17 = arg0_17._tf:Find("window/content/ships/content"):GetComponent("LScrollRect")

		function var0_17.onUpdateItem(arg0_20, arg1_20)
			updateShip(tf(arg1_20), arg0_17.ships[arg0_20 + 1])
		end

		onNextTick(function()
			var0_17:SetTotalCount(#arg0_17.ships)
		end)
	else
		setActive(arg0_17._tf:Find("window/content/ships"), false)
		setActive(arg0_17._tf:Find("window/content/ships_single"), true)

		local var1_17 = arg0_17._tf:Find("window/content/ships_single")
		local var2_17 = UIItemList.New(var1_17, var1_17:Find("IconTpl"))

		var2_17:make(function(arg0_22, arg1_22, arg2_22)
			if arg0_22 == UIItemList.EventUpdate then
				updateShip(arg2_22, arg0_17.ships[arg1_22 + 1])
			end
		end)
		var2_17:align(#arg0_17.ships)
	end
end

function var0_0.Show(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	local var0_23 = table.mergeArray(arg2_23 or {}, arg1_23 or {})

	arg0_23:downloadShipResList(var0_23, function()
		arg0_23:ShowAfterResDownload(arg1_23, arg2_23, arg3_23, arg4_23)
	end)
end

function var0_0.ShowAfterResDownload(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	var0_0.super.Show(arg0_25)
	pg.UIMgr.GetInstance():BlurPanel(arg0_25._tf)

	arg0_25.key = nil
	arg0_25.eliteShips = arg1_25
	arg0_25.highLevelShips = arg2_25
	arg0_25.overflow = arg3_25

	arg0_25:SetCallBack(arg4_25)
	arg0_25:Updatelayout()
	arg0_25:UpdateShips()
end

function var0_0.ShowEliteTag(arg0_26, arg1_26, arg2_26)
	arg0_26:downloadShipResList(arg1_26, function()
		arg0_26:ShowEliteTagAfterResDownload(arg1_26, arg2_26)
	end)
end

function var0_0.ShowEliteTagAfterResDownload(arg0_28, arg1_28, arg2_28)
	var0_0.super.Show(arg0_28)
	pg.UIMgr.GetInstance():BlurPanel(arg0_28._tf)
	arg0_28:SetCallBack(arg2_28)
	setText(arg0_28.title, i18n("destroy_eliteship_tip", i18n("destroy_inHardFormation_tip")))
	setActive(arg0_28.urOverflowLabel, false)
	setActive(arg0_28.urLabel, false)
	setActive(arg0_28.urInput, false)

	arg0_28.ships = arg1_28

	if #arg0_28.ships > 5 then
		setActive(arg0_28._tf:Find("window/content/ships"), true)
		setActive(arg0_28._tf:Find("window/content/ships_single"), false)

		local var0_28 = arg0_28._tf:Find("window/content/ships/content"):GetComponent("LScrollRect")

		function var0_28.onUpdateItem(arg0_29, arg1_29)
			updateShip(tf(arg1_29), arg0_28.ships[arg0_29 + 1])
		end

		onNextTick(function()
			var0_28:SetTotalCount(#arg0_28.ships)
		end)
	else
		setActive(arg0_28._tf:Find("window/content/ships"), false)
		setActive(arg0_28._tf:Find("window/content/ships_single"), true)

		local var1_28 = arg0_28._tf:Find("window/content/ships_single")
		local var2_28 = UIItemList.New(var1_28, var1_28:Find("IconTpl"))

		var2_28:make(function(arg0_31, arg1_31, arg2_31)
			if arg0_31 == UIItemList.EventUpdate then
				updateShip(arg2_31, arg0_28.ships[arg1_31 + 1])
			end
		end)
		var2_28:align(#arg0_28.ships)
	end
end

function var0_0.Updatelayout(arg0_32)
	local var0_32 = arg0_32.eliteShips
	local var1_32 = arg0_32.highLevelShips
	local var2_32 = {}

	if #var0_32 > 0 then
		table.insert(var2_32, i18n("destroy_high_rarity_tip"))
	end

	if #var1_32 > 0 then
		table.insert(var2_32, i18n("destroy_high_level_tip", ""))
	end

	setText(arg0_32.title, i18n("destroy_eliteship_tip", table.concat(var2_32, "、")))

	local var3_32 = _.any(var0_32, function(arg0_33)
		return arg0_33:getConfig("rarity") >= ShipRarity.SSR
	end)

	if var3_32 and not arg0_32.key then
		arg0_32.key = math.random(100000, 999999)

		setText(arg0_32.urLabel, i18n("destroy_ur_rarity_tip", arg0_32.key))
	else
		setText(arg0_32.urLabel, "")
	end

	local var4_32 = var3_32 and arg0_32.overflow

	setActive(arg0_32.urOverflowLabel, var4_32)
	setActive(arg0_32.urLabel, var3_32)
	setActive(arg0_32.urInput, var3_32)
end

function var0_0.UpdateShips(arg0_34)
	local var0_34 = arg0_34.eliteShips
	local var1_34 = arg0_34.highLevelShips
	local var2_34 = table.mergeArray(var1_34, var0_34)

	mergeSort(var2_34, CompareFuncs({
		function(arg0_35)
			return -arg0_35.level
		end,
		function(arg0_36)
			return -arg0_36:getRarity()
		end
	}, true))

	arg0_34.ships = var2_34

	if #arg0_34.ships > 5 then
		setActive(arg0_34._tf:Find("window/content/ships"), true)
		setActive(arg0_34._tf:Find("window/content/ships_single"), false)

		local var3_34 = arg0_34._tf:Find("window/content/ships/content"):GetComponent("LScrollRect")

		function var3_34.onUpdateItem(arg0_37, arg1_37)
			updateShip(tf(arg1_37), arg0_34.ships[arg0_37 + 1])
		end

		onNextTick(function()
			var3_34:SetTotalCount(#arg0_34.ships)
		end)
	else
		setActive(arg0_34._tf:Find("window/content/ships"), false)
		setActive(arg0_34._tf:Find("window/content/ships_single"), true)

		local var4_34 = arg0_34._tf:Find("window/content/ships_single")
		local var5_34 = UIItemList.New(var4_34, var4_34:Find("IconTpl"))

		var5_34:make(function(arg0_39, arg1_39, arg2_39)
			if arg0_39 == UIItemList.EventUpdate then
				updateShip(arg2_39, arg0_34.ships[arg1_39 + 1])
			end
		end)
		var5_34:align(#arg0_34.ships)
	end
end

function var0_0.Hide(arg0_40)
	var0_0.super.Hide(arg0_40)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_40._tf, arg0_40._parentTf)

	arg0_40.key = nil
	arg0_40.callback = nil

	setInputText(arg0_40.urInput, "")
end

function var0_0.OnDestroy(arg0_41)
	if arg0_41:isShowing() then
		arg0_41:Hide()
	end
end

return var0_0
