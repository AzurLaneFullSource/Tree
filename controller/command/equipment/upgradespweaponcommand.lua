local var0_0 = class("UpgradeSpWeaponCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.uid or 0
	local var2_1 = var0_1.shipId or 0
	local var3_1 = var0_1.items
	local var4_1 = var0_1.consumes
	local var5_1 = getProxy(BagProxy)
	local var6_1 = getProxy(PlayerProxy)
	local var7_1 = getProxy(BayProxy)
	local var8_1 = getProxy(EquipmentProxy)
	local var9_1
	local var10_1 = 0
	local var11_1 = 0
	local var12_1 = 0
	local var13_1 = 0
	local var14_1 = {}

	seriesAsync({
		function(arg0_2)
			local var0_2, var1_2 = EquipmentProxy.StaticGetSpWeapon(var2_1, var1_1)

			var10_1 = var0_2:GetPt()

			local var2_2 = SpWeapon.CalculateHistoryPt(var3_1, var4_1)

			var10_1 = var10_1 + var2_2

			local var3_2 = 0

			local function var4_2(arg0_3)
				for iter0_3, iter1_3 in ipairs(arg0_3) do
					local var0_3 = iter1_3[1]
					local var1_3 = underscore.detect(var14_1, function(arg0_4)
						return arg0_4.id == var0_3
					end)

					if not var1_3 then
						var1_3 = Item.New({
							id = var0_3
						})
						var1_3.count = 0

						table.insert(var14_1, var1_3)
					end

					var1_3.count = var1_3.count + iter1_3[2]
				end
			end

			var9_1 = var0_2:GetConfigID()

			while true do
				local var5_2 = SpWeapon.New({
					id = var9_1
				})
				local var6_2 = var5_2:GetNextUpgradeID()

				if var6_2 == 0 then
					break
				end

				local var7_2 = var5_2:GetUpgradeConfig()

				var11_1 = var12_1
				var12_1 = var12_1 + var7_2.upgrade_use_pt

				local var8_2 = SpWeapon.New({
					id = var6_2
				})

				if var3_2 > 0 and var8_2:GetRarity() > var5_2:GetRarity() then
					break
				end

				if var10_1 < var12_1 then
					break
				end

				var4_2(var7_2.upgrade_use_item)

				var13_1 = var13_1 + var7_2.upgrade_use_gold
				var3_2 = var3_2 + 1
				var9_1 = var6_2

				if var8_2:GetRarity() > var5_2:GetRarity() then
					var11_1 = var12_1

					break
				end
			end

			local var9_2 = var10_1 - var12_1

			var10_1 = math.min(var10_1, var12_1)

			if var2_2 == 0 and var3_2 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_pt_no_enough"))

				return
			end

			local var10_2 = var5_1:getRawData()
			local var11_2 = var6_1:getRawData()

			if var11_2.gold < var13_1 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						var13_1 - var11_2.gold,
						var13_1
					}
				})

				return
			end

			if not _.all(var14_1, function(arg0_5)
				return arg0_5.count <= (var10_2[arg0_5.id] and var10_2[arg0_5.id].count or 0)
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

				return
			end

			if not _.all(var3_1, function(arg0_6)
				return arg0_6.count <= (var10_2[arg0_6.id] and var10_2[arg0_6.id].count or 0)
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

				return
			end

			if not _.all(var4_1, function(arg0_7)
				local var0_7 = arg0_7:GetShipId()

				if var0_7 then
					local var1_7 = var7_1:getShipById(var0_7):GetSpWeapon()

					return var1_7 and var1_7:GetUID() == arg0_7:GetUID()
				else
					return var8_1:GetSpWeaponByUid(arg0_7:GetUID())
				end
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

				return
			end

			if var9_2 > 0 and var2_2 > 0 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("spweapon_tip_breakout_overflow", var9_2),
					onYes = arg0_2
				})
			else
				arg0_2()
			end
		end,
		function(arg0_8)
			local var0_8 = _.reduce(var3_1, {}, function(arg0_9, arg1_9)
				for iter0_9 = 1, arg1_9.count do
					table.insert(arg0_9, arg1_9.id)
				end

				return arg0_9
			end)
			local var1_8 = _.map(var4_1, function(arg0_10)
				return arg0_10:GetUID()
			end)

			pg.ConnectionMgr.GetInstance():Send(14203, {
				ship_id = var2_1,
				spweapon_id = var1_1,
				item_id_list = var0_8,
				spweapon_id_list = var1_8
			}, 14204, function(arg0_11)
				if arg0_11.result == 0 then
					local var0_11, var1_11 = EquipmentProxy.StaticGetSpWeapon(var2_1, var1_1)
					local var2_11 = var0_11:MigrateTo(var9_1)

					var2_11:SetPt(math.floor(var10_1 - var11_1))
					_.each(var14_1, function(arg0_12)
						var5_1:removeItemById(arg0_12.id, arg0_12.count)
					end)

					local var3_11 = var6_1:getData()

					var3_11:consume({
						gold = var13_1
					})
					var6_1:updatePlayer(var3_11)
					_.each(var3_1, function(arg0_13)
						var5_1:removeItemById(arg0_13.id, arg0_13.count)
					end)
					_.each(var4_1, function(arg0_14)
						local var0_14 = arg0_14:GetShipId()

						if var0_14 then
							local var1_14 = var7_1:getShipById(var0_14)

							var1_14:UpdateSpWeapon(nil)
							var7_1:updateShip(var1_14)
						else
							var8_1:RemoveSpWeapon(arg0_14)
						end
					end)

					if var1_11 then
						var1_11:UpdateSpWeapon(var2_11)
						getProxy(BayProxy):updateShip(var1_11)
					else
						getProxy(EquipmentProxy):AddSpWeapon(var2_11)
					end

					arg0_1:sendNotification(GAME.UPGRADE_SPWEAPON_DONE, var2_11)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_upgrade_erro", arg0_11.result))
				end
			end)
		end
	})
end

return var0_0
