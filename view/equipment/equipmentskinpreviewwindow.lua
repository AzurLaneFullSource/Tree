local var0 = class("EquipmentSkinPreviewWindow", import("view.ship.ShipPreviewLayer"))

function var0.getUIName(arg0)
	return "EquipSkinPreviewUI"
end

function var0.init(arg0)
	arg0.buttonList = arg0._tf:Find("left_panel/Buttons")
	arg0.hitToggle = arg0.buttonList:Find("HitEffect")
	arg0.spawnToggle = arg0.buttonList:Find("SpawnEffect")

	var0.super.init(arg0)
	setText(arg0.hitToggle:Find("Text"), i18n("hit_preview"))
	setText(arg0.spawnToggle:Find("Text"), i18n("shoot_preview"))
end

function var0.didEnter(arg0)
	local var0 = pg.equip_skin_template[arg0.equipSkinId]
	local var1 = var0.hit_fx_name ~= ""
	local var2 = {
		EquipType.CannonQuZhu,
		EquipType.CannonQingXun,
		EquipType.CannonZhongXun,
		EquipType.Torpedo,
		EquipType.SubmarineTorpedo
	}

	var1 = var1 and _.any(var0.equip_type, function(arg0)
		return table.contains(var2, arg0)
	end)

	setActive(arg0.hitToggle, var1)

	if var1 then
		arg0.contextData.hitEffect = defaultValue(arg0.contextData.hitEffect, true)

		triggerToggle(arg0.hitToggle, arg0.contextData.hitEffect)
		onToggle(arg0, arg0.hitToggle, function(arg0)
			arg0.contextData.hitEffect = arg0

			arg0:RefreshFXMode()
		end)
	else
		arg0.contextData.hitEffect = defaultValue(arg0.contextData.hitEffect, false)
	end

	local var3 = var0.fire_fx_name ~= ""

	setActive(arg0.spawnToggle, var3)

	if var3 then
		arg0.contextData.spawnEffect = defaultValue(arg0.contextData.spawnEffect, true)

		triggerToggle(arg0.spawnToggle, arg0.contextData.spawnEffect)
		onToggle(arg0, arg0.spawnToggle, function(arg0)
			arg0.contextData.spawnEffect = arg0

			arg0:RefreshFXMode()
		end)
	else
		arg0.contextData.spawnEffect = defaultValue(arg0.contextData.spawnEffect, true)
	end

	var0.super.didEnter(arg0)
end

function var0.RefreshFXMode(arg0)
	if not arg0.previewer then
		return
	end

	arg0.previewer:SetFXMode(arg0.contextData.spawnEffect, arg0.contextData.hitEffect)
	arg0.previewer:onWeaponUpdate()
end

function var0.showBarrage(arg0)
	var0.super.showBarrage(arg0)
	arg0.previewer:SetFXMode(arg0.contextData.spawnEffect, arg0.contextData.hitEffect)
end

function var0.playLoadingAni(arg0)
	var0.super.playLoadingAni(arg0)
	setActive(arg0.buttonList, false)
end

function var0.stopLoadingAni(arg0)
	var0.super.stopLoadingAni(arg0)
	setActive(arg0.buttonList, true)
end

return var0
