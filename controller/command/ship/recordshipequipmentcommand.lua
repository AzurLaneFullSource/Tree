local var0 = class("RecordShipEquipmentCommand", pm.SimpleCommand)
local var1 = {
	"#FFFFFF",
	"#60a9ff",
	"#966af6",
	"#fff157",
	"#EE799F"
}

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.index
	local var3 = var0.type

	if not var3 then
		return
	end

	if not var1 then
		return
	end

	if not var2 then
		return
	end

	local var4 = getProxy(PlayerProxy):getData()
	local var5 = getProxy(BayProxy)
	local var6 = var5:getShipById(var1)

	var6:getEquipmentRecord(var4.id)

	local var7 = Clone(var6.equipments)
	local var8 = var6:GetSpWeaponRecord(var4.id)

	if var3 == 1 then
		for iter0, iter1 in ipairs(var7) do
			var6.equipmentRecords[var2][iter0] = iter1 and iter1.id or -1
		end

		var6:setEquipmentRecord(var4.id, var6.equipmentRecords)

		if not LOCK_SP_WEAPON then
			var8[var2] = var6:GetSpWeapon()

			var6:SetSpWeaponRecord(var4.id, var8)
		end

		var5:updateShip(var6)
	elseif var3 == 2 then
		local var9 = getProxy(EquipmentProxy)
		local var10 = Clone(var6.equipmentRecords[var2])
		local var11 = var8[var2]

		if #var10 == 0 or _.all(var10, function(arg0)
			return arg0 == -1
		end) and var11 == nil then
			return
		end

		local function var12(arg0, arg1)
			if var7[arg0] and var7[arg0].id == arg1 then
				return true
			end

			return false
		end

		local var13 = {}

		for iter2, iter3 in ipairs(var10) do
			if iter3 ~= -1 then
				local var14 = var9:getEquipmentById(iter3)

				if (not var14 or var14.count <= 0) and not var12(iter2, iter3) then
					local var15 = Equipment.New({
						id = iter3
					})

					var10[iter2] = var9:getSameTypeEquipmentId(var15) or 0

					local var16 = var1[var15.config.rarity - 1]
					local var17 = string.format("<color=%s>%s+%s</color>", var16, var15.config.name, var15.config.level - 1)

					table.insert(var13, var17)
				end
			end
		end

		local var18 = var11

		if var11 and (not var11:IsReal() or var11:GetShipId() ~= nil and var11:GetShipId() ~= var6.id) then
			local var19 = var1[var11:GetRarity()]
			local var20 = string.format("<color=%s>%s+%s</color>", var19, var11:GetName(), var11:GetLevel() - 1)

			table.insert(var13, var20)

			var18 = var9:GetSameTypeSpWeapon(var11)
		end

		local function var21(arg0)
			local var0 = {}

			for iter0, iter1 in ipairs(arg0) do
				if not var7[iter0] or var7[iter0].id ~= iter1 then
					if iter1 == 0 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_noequip"))
					elseif iter1 == -1 and var7[iter0] then
						table.insert(var0, function(arg0)
							arg0:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
								shipId = var1,
								pos = iter0,
								callback = arg0
							})
						end)
					elseif iter1 ~= -1 then
						table.insert(var0, function(arg0)
							arg0:sendNotification(GAME.EQUIP_TO_SHIP, {
								equipmentId = iter1,
								shipId = var1,
								pos = iter0,
								callback = arg0
							})
						end)
					end
				end
			end

			if not LOCK_SP_WEAPON then
				table.insert(var0, function(arg0)
					local var0 = var6:GetSpWeapon()

					if var11 then
						if not var18 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_noequip"))

							return
						elseif not var0 or var0:GetUID() ~= var18:GetUID() then
							arg0:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
								spWeaponUid = var18:GetUID(),
								shipId = var1,
								callback = arg0
							})

							return
						end
					elseif var0 then
						arg0:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
							shipId = var1,
							callback = arg0
						})

						return
					end

					arg0()
				end)
			end

			seriesAsync(var0)
		end

		if #var13 > 0 then
			local var22 = ""

			if #var13 > 2 then
				var22 = table.concat(_.slice(var13, 1, 2), "、") .. i18n("word_wait")
			else
				var22 = table.concat(var13, "、")
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("no_found_record_equipment", var22),
				onYes = function()
					var21(var10)
				end
			})
		else
			var21(var10)
		end
	end

	arg0:sendNotification(GAME.RECORD_SHIP_EQUIPMENT_DONE, {
		shipId = var1,
		index = var2,
		type = var3
	})
end

return var0
