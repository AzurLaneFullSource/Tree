local var0 = class("UpgradeSpWeaponCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.uid or 0
	local var2 = var0.shipId or 0
	local var3 = var0.items
	local var4 = var0.consumes
	local var5 = getProxy(BagProxy)
	local var6 = getProxy(PlayerProxy)
	local var7 = getProxy(BayProxy)
	local var8 = getProxy(EquipmentProxy)
	local var9
	local var10 = 0
	local var11 = 0
	local var12 = 0
	local var13 = 0
	local var14 = {}

	seriesAsync({
		function(arg0)
			local var0, var1 = EquipmentProxy.StaticGetSpWeapon(var2, var1)

			var10 = var0:GetPt()

			local var2 = SpWeapon.CalculateHistoryPt(var3, var4)

			var10 = var10 + var2

			local var3 = 0

			local function var4(arg0)
				for iter0, iter1 in ipairs(arg0) do
					local var0 = iter1[1]
					local var1 = underscore.detect(var14, function(arg0)
						return arg0.id == var0
					end)

					if not var1 then
						var1 = Item.New({
							id = var0
						})
						var1.count = 0

						table.insert(var14, var1)
					end

					var1.count = var1.count + iter1[2]
				end
			end

			var9 = var0:GetConfigID()

			while true do
				local var5 = SpWeapon.New({
					id = var9
				})
				local var6 = var5:GetNextUpgradeID()

				if var6 == 0 then
					break
				end

				local var7 = var5:GetUpgradeConfig()

				var11 = var12
				var12 = var12 + var7.upgrade_use_pt

				local var8 = SpWeapon.New({
					id = var6
				})

				if var3 > 0 and var8:GetRarity() > var5:GetRarity() then
					break
				end

				if var10 < var12 then
					break
				end

				var4(var7.upgrade_use_item)

				var13 = var13 + var7.upgrade_use_gold
				var3 = var3 + 1
				var9 = var6

				if var8:GetRarity() > var5:GetRarity() then
					var11 = var12

					break
				end
			end

			local var9 = var10 - var12

			var10 = math.min(var10, var12)

			if var2 == 0 and var3 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_pt_no_enough"))

				return
			end

			local var10 = var5:getRawData()
			local var11 = var6:getRawData()

			if var11.gold < var13 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						var13 - var11.gold,
						var13
					}
				})

				return
			end

			if not _.all(var14, function(arg0)
				return arg0.count <= (var10[arg0.id] and var10[arg0.id].count or 0)
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

				return
			end

			if not _.all(var3, function(arg0)
				return arg0.count <= (var10[arg0.id] and var10[arg0.id].count or 0)
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

				return
			end

			if not _.all(var4, function(arg0)
				local var0 = arg0:GetShipId()

				if var0 then
					local var1 = var7:getShipById(var0):GetSpWeapon()

					return var1 and var1:GetUID() == arg0:GetUID()
				else
					return var8:GetSpWeaponByUid(arg0:GetUID())
				end
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

				return
			end

			if var9 > 0 and var2 > 0 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("spweapon_tip_breakout_overflow", var9),
					onYes = arg0
				})
			else
				arg0()
			end
		end,
		function(arg0)
			local var0 = _.reduce(var3, {}, function(arg0, arg1)
				for iter0 = 1, arg1.count do
					table.insert(arg0, arg1.id)
				end

				return arg0
			end)
			local var1 = _.map(var4, function(arg0)
				return arg0:GetUID()
			end)

			pg.ConnectionMgr.GetInstance():Send(14203, {
				ship_id = var2,
				spweapon_id = var1,
				item_id_list = var0,
				spweapon_id_list = var1
			}, 14204, function(arg0)
				if arg0.result == 0 then
					local var0, var1 = EquipmentProxy.StaticGetSpWeapon(var2, var1)
					local var2 = var0:MigrateTo(var9)

					var2:SetPt(math.floor(var10 - var11))
					_.each(var14, function(arg0)
						var5:removeItemById(arg0.id, arg0.count)
					end)

					local var3 = var6:getData()

					var3:consume({
						gold = var13
					})
					var6:updatePlayer(var3)
					_.each(var3, function(arg0)
						var5:removeItemById(arg0.id, arg0.count)
					end)
					_.each(var4, function(arg0)
						local var0 = arg0:GetShipId()

						if var0 then
							local var1 = var7:getShipById(var0)

							var1:UpdateSpWeapon(nil)
							var7:updateShip(var1)
						else
							var8:RemoveSpWeapon(arg0)
						end
					end)

					if var1 then
						var1:UpdateSpWeapon(var2)
						getProxy(BayProxy):updateShip(var1)
					else
						getProxy(EquipmentProxy):AddSpWeapon(var2)
					end

					arg0:sendNotification(GAME.UPGRADE_SPWEAPON_DONE, var2)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_upgrade_erro", arg0.result))
				end
			end)
		end
	})
end

return var0
