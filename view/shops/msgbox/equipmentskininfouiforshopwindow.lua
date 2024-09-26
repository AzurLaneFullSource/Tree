local var0_0 = class("EquipmentSkinInfoUIForShopWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "EquipmentSkinInfoUIForShop"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.displayPanel = arg0_2:findTF("display")
	arg0_2.displayActions = arg0_2.displayPanel:Find("actions")
	arg0_2.displayNameTxt = arg0_2:findTF("info/display_panel/name_container/name", arg0_2.displayPanel):GetComponent(typeof(Text))
	arg0_2.displayDescTxt = arg0_2:findTF("info/display_panel/desc", arg0_2.displayPanel):GetComponent(typeof(Text))
	arg0_2.playBtn = arg0_2:findTF("info/play_btn", arg0_2.displayPanel)
	arg0_2.confirmBtn = arg0_2._tf:Find("display/actions/confirm")

	setText(arg0_2:findTF("display/top/bg/infomation/title"), i18n("words_information"))
	setText(arg0_2:findTF("display/actions/cancel/upgrade"), i18n("msgbox_text_cancel"))
	setText(arg0_2:findTF("display/actions/confirm/change"), i18n("shop_word_exchange"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SOUND_BACK)
	onButton(arg0_3, arg0_3._tf:Find("display/top/btnBack"), function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf:Find("display/actions/cancel"), function()
		arg0_3:Hide()
	end, SFX_CANCEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
	arg0_7:UpdateSkinView(arg1_7)

	arg0_7.showing = true
end

function var0_0.Open(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8:getConfig("commodity_id") or arg1_8:getConfig("effect_args")[1]

	onButton(arg0_8, arg0_8.confirmBtn, function()
		local var0_9 = pg.equip_skin_template[var0_8].name

		if arg2_8 then
			arg2_8(arg1_8, 1, var0_9)
		end

		arg0_8:Hide()
	end, SFX_CANCEL)
	arg0_8:Show(var0_8)
end

function var0_0.UpdateSkinView(arg0_10, arg1_10)
	local var0_10 = arg0_10.displayPanel
	local var1_10 = pg.equip_skin_template[arg1_10]

	assert(var1_10, "miss config equip_skin_template >> " .. arg1_10)

	arg0_10.displayNameTxt.text = var1_10.name
	arg0_10.displayDescTxt.text = var1_10.desc

	local var2_10 = _.map(var1_10.equip_type, function(arg0_11)
		return EquipType.Type2Name2(arg0_11)
	end)

	setScrollText(arg0_10:findTF("info/display_panel/equip_type/mask/Text", var0_10), table.concat(var2_10, ","))
	onButton(arg0_10, arg0_10.playBtn, function()
		arg0_10:emit(NewShopsMediator.ON_ESKIN_PREVIEW, arg1_10)
	end, SFX_PANEL)
	updateDrop(arg0_10:findTF("info/equip", var0_10), {
		type = DROP_TYPE_EQUIPMENT_SKIN,
		id = arg1_10
	})
end

function var0_0.Hide(arg0_13)
	if arg0_13.showing then
		var0_0.super.Hide(arg0_13)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_13._tf, arg0_13._parentTf)

		arg0_13.showing = false
	end
end

function var0_0.OnDestroy(arg0_14)
	arg0_14:Hide()
end

return var0_0
