local var0 = class("ShipDestoryConfirmWindow", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "DestoryConfirmWindow"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("window/top/btnBack")

	setActive(arg0:findTF("window/top/bg/infomation/title_en"), PLATFORM_CODE ~= PLATFORM_US)
	setText(arg0:findTF("window/top/bg/infomation/title"), i18n("title_info"))

	arg0.cancelBtn = arg0:findTF("window/cancel_btn")
	arg0.confirmBtn = arg0:findTF("window/confirm_btn")

	setText(findTF(arg0.confirmBtn, "pic"), i18n("destroy_confirm_access"))
	setText(findTF(arg0.cancelBtn, "pic"), i18n("destroy_confirm_cancel"))

	arg0.title = arg0:findTF("window/content/Text")
	arg0.label = arg0:findTF("window/content/desc/label")

	setText(arg0.label, i18n("destory_ship_before_tip"))

	arg0.urLabel = arg0:findTF("window/content/desc/label1")
	arg0.urInput = arg0:findTF("window/content/desc/InputField")
	arg0.urOverflowLabel = arg0:findTF("window/content/desc/label2")

	setText(arg0.urOverflowLabel, i18n("destory_ur_pt_overflowa"))

	local var0 = arg0:findTF("Placeholder", arg0.urInput)

	setText(var0, i18n("box_ship_del_click"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:Confirm()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.SetCallBack(arg0, arg1)
	arg0.callback = arg1
end

function var0.Confirm(arg0)
	if arg0.key then
		local var0 = getInputText(arg0.urInput)

		if arg0.key ~= tonumber(var0) then
			pg.TipsMgr:GetInstance():ShowTips(i18n("destory_ship_input_erro"))

			return
		end

		local var1 = arg0.callback

		arg0:Hide()
		existCall(var1)
	else
		local var2 = arg0.callback

		arg0:Hide()
		existCall(var2)
	end
end

function var0.Show(arg0, arg1, arg2, arg3, arg4)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0.key = nil
	arg0.eliteShips = arg1
	arg0.highLevelShips = arg2
	arg0.overflow = arg3

	arg0:SetCallBack(arg4)
	arg0:Updatelayout()
	arg0:UpdateShips()
end

function var0.ShowEliteTag(arg0, arg1, arg2)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:SetCallBack(arg2)
	setText(arg0.title, i18n("destroy_eliteship_tip", i18n("destroy_inHardFormation_tip")))
	setActive(arg0.urOverflowLabel, false)
	setActive(arg0.urLabel, false)
	setActive(arg0.urInput, false)

	arg0.ships = arg1

	if #arg0.ships > 5 then
		setActive(arg0._tf:Find("window/content/ships"), true)
		setActive(arg0._tf:Find("window/content/ships_single"), false)

		local var0 = arg0._tf:Find("window/content/ships/content"):GetComponent("LScrollRect")

		function var0.onUpdateItem(arg0, arg1)
			updateShip(tf(arg1), arg0.ships[arg0 + 1])
		end

		onNextTick(function()
			var0:SetTotalCount(#arg0.ships)
		end)
	else
		setActive(arg0._tf:Find("window/content/ships"), false)
		setActive(arg0._tf:Find("window/content/ships_single"), true)

		local var1 = arg0._tf:Find("window/content/ships_single")
		local var2 = UIItemList.New(var1, var1:Find("IconTpl"))

		var2:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				updateShip(arg2, arg0.ships[arg1 + 1])
			end
		end)
		var2:align(#arg0.ships)
	end
end

function var0.Updatelayout(arg0)
	local var0 = arg0.eliteShips
	local var1 = arg0.highLevelShips
	local var2 = {}

	if #var0 > 0 then
		table.insert(var2, i18n("destroy_high_rarity_tip"))
	end

	if #var1 > 0 then
		table.insert(var2, i18n("destroy_high_level_tip", ""))
	end

	setText(arg0.title, i18n("destroy_eliteship_tip", table.concat(var2, "、")))

	local var3 = _.any(var0, function(arg0)
		return arg0:getConfig("rarity") >= ShipRarity.SSR
	end)

	if var3 and not arg0.key then
		arg0.key = math.random(100000, 999999)

		setText(arg0.urLabel, i18n("destroy_ur_rarity_tip", arg0.key))
	else
		setText(arg0.urLabel, "")
	end

	local var4 = var3 and arg0.overflow

	setActive(arg0.urOverflowLabel, var4)
	setActive(arg0.urLabel, var3)
	setActive(arg0.urInput, var3)
end

function var0.UpdateShips(arg0)
	local var0 = arg0.eliteShips
	local var1 = arg0.highLevelShips
	local var2 = table.mergeArray(var1, var0)

	mergeSort(var2, CompareFuncs({
		function(arg0)
			return -arg0.level
		end,
		function(arg0)
			return -arg0:getRarity()
		end
	}, true))

	arg0.ships = var2

	if #arg0.ships > 5 then
		setActive(arg0._tf:Find("window/content/ships"), true)
		setActive(arg0._tf:Find("window/content/ships_single"), false)

		local var3 = arg0._tf:Find("window/content/ships/content"):GetComponent("LScrollRect")

		function var3.onUpdateItem(arg0, arg1)
			updateShip(tf(arg1), arg0.ships[arg0 + 1])
		end

		onNextTick(function()
			var3:SetTotalCount(#arg0.ships)
		end)
	else
		setActive(arg0._tf:Find("window/content/ships"), false)
		setActive(arg0._tf:Find("window/content/ships_single"), true)

		local var4 = arg0._tf:Find("window/content/ships_single")
		local var5 = UIItemList.New(var4, var4:Find("IconTpl"))

		var5:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				updateShip(arg2, arg0.ships[arg1 + 1])
			end
		end)
		var5:align(#arg0.ships)
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

	arg0.key = nil
	arg0.callback = nil

	setInputText(arg0.urInput, "")
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
