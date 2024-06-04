local var0 = class("EquipmentSkinInfoUIForShopWindow", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "EquipmentSkinInfoUIForShop"
end

function var0.OnLoaded(arg0)
	arg0.displayPanel = arg0:findTF("display")
	arg0.displayActions = arg0.displayPanel:Find("actions")
	arg0.displayNameTxt = arg0:findTF("info/display_panel/name_container/name", arg0.displayPanel):GetComponent(typeof(Text))
	arg0.displayDescTxt = arg0:findTF("info/display_panel/desc", arg0.displayPanel):GetComponent(typeof(Text))
	arg0.playBtn = arg0:findTF("info/play_btn", arg0.displayPanel)
	arg0.confirmBtn = arg0._tf:Find("display/actions/confirm")

	setText(arg0:findTF("display/top/bg/infomation/title"), i18n("words_information"))
	setText(arg0:findTF("display/actions/cancel/upgrade"), i18n("msgbox_text_cancel"))
	setText(arg0:findTF("display/actions/confirm/change"), i18n("shop_word_exchange"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SOUND_BACK)
	onButton(arg0, arg0._tf:Find("display/top/btnBack"), function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("display/actions/cancel"), function()
		arg0:Hide()
	end, SFX_CANCEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:UpdateSkinView(arg1)

	arg0.showing = true
end

function var0.Open(arg0, arg1, arg2)
	local var0 = arg1:getConfig("commodity_id")

	onButton(arg0, arg0.confirmBtn, function()
		local var0 = pg.equip_skin_template[var0].name

		if arg2 then
			arg2(arg1, 1, var0)
		end

		arg0:Hide()
	end, SFX_CANCEL)
	arg0:Show(var0)
end

function var0.UpdateSkinView(arg0, arg1)
	local var0 = arg0.displayPanel
	local var1 = pg.equip_skin_template[arg1]

	assert(var1, "miss config equip_skin_template >> " .. arg1)

	arg0.displayNameTxt.text = var1.name
	arg0.displayDescTxt.text = var1.desc

	local var2 = _.map(var1.equip_type, function(arg0)
		return EquipType.Type2Name2(arg0)
	end)

	setScrollText(arg0:findTF("info/display_panel/equip_type/mask/Text", var0), table.concat(var2, ","))
	onButton(arg0, arg0.playBtn, function()
		arg0:emit(NewShopsMediator.ON_ESKIN_PREVIEW, arg1)
	end, SFX_PANEL)
	updateDrop(arg0:findTF("info/equip", var0), {
		type = DROP_TYPE_EQUIPMENT_SKIN,
		id = arg1
	})
end

function var0.Hide(arg0)
	if arg0.showing then
		var0.super.Hide(arg0)
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

		arg0.showing = false
	end
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
