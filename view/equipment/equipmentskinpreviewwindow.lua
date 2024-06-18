local var0_0 = class("EquipmentSkinPreviewWindow", import("view.ship.ShipPreviewLayer"))

function var0_0.getUIName(arg0_1)
	return "EquipSkinPreviewUI"
end

function var0_0.init(arg0_2)
	arg0_2.buttonList = arg0_2._tf:Find("left_panel/Buttons")
	arg0_2.hitToggle = arg0_2.buttonList:Find("HitEffect")
	arg0_2.spawnToggle = arg0_2.buttonList:Find("SpawnEffect")

	var0_0.super.init(arg0_2)
	setText(arg0_2.hitToggle:Find("Text"), i18n("hit_preview"))
	setText(arg0_2.spawnToggle:Find("Text"), i18n("shoot_preview"))
end

function var0_0.didEnter(arg0_3)
	local var0_3 = pg.equip_skin_template[arg0_3.equipSkinId]
	local var1_3 = var0_3.hit_fx_name ~= ""
	local var2_3 = {
		EquipType.CannonQuZhu,
		EquipType.CannonQingXun,
		EquipType.CannonZhongXun,
		EquipType.Torpedo,
		EquipType.SubmarineTorpedo
	}

	var1_3 = var1_3 and _.any(var0_3.equip_type, function(arg0_4)
		return table.contains(var2_3, arg0_4)
	end)

	setActive(arg0_3.hitToggle, var1_3)

	if var1_3 then
		arg0_3.contextData.hitEffect = defaultValue(arg0_3.contextData.hitEffect, true)

		triggerToggle(arg0_3.hitToggle, arg0_3.contextData.hitEffect)
		onToggle(arg0_3, arg0_3.hitToggle, function(arg0_5)
			arg0_3.contextData.hitEffect = arg0_5

			arg0_3:RefreshFXMode()
		end)
	else
		arg0_3.contextData.hitEffect = defaultValue(arg0_3.contextData.hitEffect, false)
	end

	local var3_3 = var0_3.fire_fx_name ~= ""

	setActive(arg0_3.spawnToggle, var3_3)

	if var3_3 then
		arg0_3.contextData.spawnEffect = defaultValue(arg0_3.contextData.spawnEffect, true)

		triggerToggle(arg0_3.spawnToggle, arg0_3.contextData.spawnEffect)
		onToggle(arg0_3, arg0_3.spawnToggle, function(arg0_6)
			arg0_3.contextData.spawnEffect = arg0_6

			arg0_3:RefreshFXMode()
		end)
	else
		arg0_3.contextData.spawnEffect = defaultValue(arg0_3.contextData.spawnEffect, true)
	end

	var0_0.super.didEnter(arg0_3)
end

function var0_0.RefreshFXMode(arg0_7)
	if not arg0_7.previewer then
		return
	end

	arg0_7.previewer:SetFXMode(arg0_7.contextData.spawnEffect, arg0_7.contextData.hitEffect)
	arg0_7.previewer:onWeaponUpdate()
end

function var0_0.showBarrage(arg0_8)
	var0_0.super.showBarrage(arg0_8)
	arg0_8.previewer:SetFXMode(arg0_8.contextData.spawnEffect, arg0_8.contextData.hitEffect)
end

function var0_0.playLoadingAni(arg0_9)
	var0_0.super.playLoadingAni(arg0_9)
	setActive(arg0_9.buttonList, false)
end

function var0_0.stopLoadingAni(arg0_10)
	var0_0.super.stopLoadingAni(arg0_10)
	setActive(arg0_10.buttonList, true)
end

return var0_0
