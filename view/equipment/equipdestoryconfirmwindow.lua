local var0_0 = class("EquipDestoryConfirmWindow", import("view.base.BaseSubView"))

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

function var0_0.Show(arg0_10, arg1_10, arg2_10)
	var0_0.super.Show(arg0_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)

	arg0_10.key = nil
	arg0_10.equips = arg1_10

	arg0_10:SetCallBack(arg2_10)
	arg0_10:Updatelayout()
	arg0_10:UpdateEquips()
end

function var0_0.Updatelayout(arg0_11)
	local var0_11 = {}

	if underscore.any(arg0_11.equips, function(arg0_12)
		return arg0_12:getConfig("rarity") >= 4
	end) then
		table.insert(var0_11, i18n("destroy_high_rarity_tip"))
	end

	if underscore.any(arg0_11.equips, function(arg0_13)
		return arg0_13:getConfig("level") > 1
	end) then
		table.insert(var0_11, i18n("destroy_high_intensify_tip", ""))
	end

	setText(arg0_11.title, i18n("destroy_eliteequipment_tip", table.concat(var0_11, ",")))

	local var1_11 = underscore.any(arg0_11.equips, function(arg0_14)
		return arg0_14:isImportance()
	end)

	if var1_11 and not arg0_11.key then
		arg0_11.key = math.random(100000, 999999)

		setText(arg0_11.urLabel, i18n("destroy_equip_rarity_tip", arg0_11.key))
	else
		setText(arg0_11.urLabel, "")
	end

	setActive(arg0_11.urOverflowLabel, false)
	setActive(arg0_11.urLabel, var1_11)
	setActive(arg0_11.urInput, var1_11)
end

function var0_0.UpdateEquips(arg0_15)
	mergeSort(arg0_15.equips, CompareFuncs({
		function(arg0_16)
			return -arg0_16:getConfig("rarity")
		end,
		function(arg0_17)
			return -arg0_17:getConfig("level")
		end
	}, true))

	if #arg0_15.equips > 5 then
		setActive(arg0_15._tf:Find("window/content/ships"), true)
		setActive(arg0_15._tf:Find("window/content/ships_single"), false)

		local var0_15 = arg0_15._tf:Find("window/content/ships/content"):GetComponent("LScrollRect")

		function var0_15.onUpdateItem(arg0_18, arg1_18)
			updateEquipment(tf(arg1_18), arg0_15.equips[arg0_18 + 1])
		end

		onNextTick(function()
			var0_15:SetTotalCount(#arg0_15.equips)
		end)
	else
		local var1_15 = arg0_15._tf:Find("window/content/ships_single")
		local var2_15 = UIItemList.New(var1_15, var1_15:Find("IconTpl"))

		setActive(arg0_15._tf:Find("window/content/ships"), false)
		setActive(arg0_15._tf:Find("window/content/ships_single"), true)
		var2_15:make(function(arg0_20, arg1_20, arg2_20)
			if arg0_20 == UIItemList.EventUpdate then
				updateEquipment(arg2_20, arg0_15.equips[arg1_20 + 1])
			end
		end)
		var2_15:align(#arg0_15.equips)
	end
end

function var0_0.Hide(arg0_21)
	var0_0.super.Hide(arg0_21)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21._tf, arg0_21._parentTf)

	arg0_21.key = nil
	arg0_21.callback = nil

	setInputText(arg0_21.urInput, "")
end

function var0_0.OnDestroy(arg0_22)
	if arg0_22:isShowing() then
		arg0_22:Hide()
	end
end

return var0_0
