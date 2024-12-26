local var0_0 = class("RecordShipEquipmentCommand", pm.SimpleCommand)
local var1_0 = {
	"#FFFFFF",
	"#60a9ff",
	"#966af6",
	"#fff157",
	"#EE799F"
}

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.index
	local var3_1 = var0_1.type

	if not var3_1 then
		return
	end

	if not var1_1 then
		return
	end

	if not var2_1 then
		return
	end

	local var4_1 = getProxy(PlayerProxy):getData()
	local var5_1 = getProxy(BayProxy)
	local var6_1 = var5_1:getShipById(var1_1)

	var6_1:getEquipmentRecord(var4_1.id)

	local var7_1 = Clone(var6_1.equipments)
	local var8_1 = var6_1:GetSpWeaponRecord(var4_1.id)

	if var3_1 == 1 then
		for iter0_1, iter1_1 in ipairs(var7_1) do
			var6_1.equipmentRecords[var2_1][iter0_1] = iter1_1 and iter1_1.id or -1
		end

		var6_1:setEquipmentRecord(var4_1.id, var6_1.equipmentRecords)

		if not LOCK_SP_WEAPON then
			var8_1[var2_1] = var6_1:GetSpWeapon()

			var6_1:SetSpWeaponRecord(var4_1.id, var8_1)
		end

		var5_1:updateShip(var6_1)
	elseif var3_1 == 2 then
		local var9_1 = getProxy(EquipmentProxy)
		local var10_1 = Clone(var6_1.equipmentRecords[var2_1])
		local var11_1 = var8_1[var2_1]

		if #var10_1 == 0 or _.all(var10_1, function(arg0_2)
			return arg0_2 == -1
		end) and var11_1 == nil then
			return
		end

		local function var12_1(arg0_3, arg1_3)
			if var7_1[arg0_3] and var7_1[arg0_3].id == arg1_3 then
				return true
			end

			return false
		end

		local var13_1 = {}

		for iter2_1, iter3_1 in ipairs(var10_1) do
			if iter3_1 ~= -1 then
				local var14_1 = var9_1:getEquipmentById(iter3_1)

				if (not var14_1 or var14_1.count <= 0) and not var12_1(iter2_1, iter3_1) then
					local var15_1 = Equipment.New({
						id = iter3_1
					})

					var10_1[iter2_1] = var9_1:getSameTypeEquipmentId(var15_1) or 0

					local var16_1 = var1_0[var15_1.config.rarity - 1]
					local var17_1 = string.format("<color=%s>%s+%s</color>", var16_1, var15_1.config.name, var15_1.config.level - 1)

					table.insert(var13_1, var17_1)
				end
			end
		end

		local var18_1 = var6_1:GetSpWeapon()
		local var19_1 = var11_1 and var11_1:GetConfigID() or 0
		local var20_1 = var18_1 and var18_1:GetConfigID() or 0
		local var21_1

		if var11_1 and var19_1 ~= var20_1 then
			var21_1 = var9_1:GetSameTypeSpWeapon(var11_1)

			if not var21_1 or var21_1:GetConfigID() ~= var19_1 then
				local var22_1 = var1_0[var11_1:GetRarity()]
				local var23_1 = string.format("<color=%s>%s+%s</color>", var22_1, var11_1:GetName(), var11_1:GetLevel() - 1)

				table.insert(var13_1, var23_1)
			end
		end

		local function var24_1(arg0_4)
			local var0_4 = {}

			for iter0_4, iter1_4 in ipairs(arg0_4) do
				if not var7_1[iter0_4] or var7_1[iter0_4].id ~= iter1_4 then
					if iter1_4 == 0 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_noequip"))
					elseif iter1_4 == -1 and var7_1[iter0_4] then
						table.insert(var0_4, function(arg0_5)
							arg0_1:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
								shipId = var1_1,
								pos = iter0_4,
								callback = arg0_5
							})
						end)
					elseif iter1_4 ~= -1 then
						table.insert(var0_4, function(arg0_6)
							arg0_1:sendNotification(GAME.EQUIP_TO_SHIP, {
								equipmentId = iter1_4,
								shipId = var1_1,
								pos = iter0_4,
								callback = arg0_6
							})
						end)
					end
				end
			end

			if not LOCK_SP_WEAPON then
				table.insert(var0_4, function(arg0_7)
					if var11_1 then
						if var19_1 ~= var20_1 then
							if not var21_1 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("ship_quick_change_noequip"))

								return
							else
								arg0_1:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
									spWeaponUid = var21_1:GetUID(),
									shipId = var1_1,
									callback = arg0_7
								})

								return
							end
						end
					elseif var18_1 then
						arg0_1:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
							shipId = var1_1,
							callback = arg0_7
						})

						return
					end

					arg0_7()
				end)
			end

			seriesAsync(var0_4)
		end

		if #var13_1 > 0 then
			local var25_1 = ""

			if #var13_1 > 2 then
				var25_1 = table.concat(_.slice(var13_1, 1, 2), "、") .. i18n("word_wait")
			else
				var25_1 = table.concat(var13_1, "、")
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("no_found_record_equipment", var25_1),
				onYes = function()
					var24_1(var10_1)
				end
			})
		else
			var24_1(var10_1)
		end
	end

	arg0_1:sendNotification(GAME.RECORD_SHIP_EQUIPMENT_DONE, {
		shipId = var1_1,
		index = var2_1,
		type = var3_1
	})
end

return var0_0
