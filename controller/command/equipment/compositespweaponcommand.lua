local var0 = class("CompositeSpWeaponCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.consumeItems
	local var3 = var0.consumeSpweapons
	local var4 = getProxy(BagProxy)
	local var5 = getProxy(PlayerProxy)
	local var6 = getProxy(EquipmentProxy)
	local var7 = getProxy(BayProxy)
	local var8 = var1
	local var9 = 0
	local var10 = 0
	local var11 = 0
	local var12 = 0
	local var13 = {}

	seriesAsync({
		function(arg0)
			local var0 = var4:getRawData()
			local var1 = var5:getData()

			var9 = SpWeapon.CalculateHistoryPt(var2, var3)

			local var2 = 0

			local function var3(arg0)
				for iter0, iter1 in ipairs(arg0) do
					local var0 = iter1[1]
					local var1 = underscore.detect(var13, function(arg0)
						return arg0.id == var0
					end)

					if not var1 then
						var1 = Item.New({
							id = var0
						})
						var1.count = 0

						table.insert(var13, var1)
					end

					var1.count = var1.count + iter1[2]
				end
			end

			local var4 = SpWeapon.New({
				id = var8
			}):GetUpgradeConfig()

			var11 = var11 + var4.create_use_pt

			var3(var4.create_use_item)

			var12 = var12 + var4.create_use_gold

			if var9 >= var11 then
				while true do
					local var5 = SpWeapon.New({
						id = var8
					})
					local var6 = var5:GetNextUpgradeID()

					if var6 == 0 then
						break
					end

					local var7 = var5:GetUpgradeConfig()

					var10 = var11
					var11 = var11 + var7.upgrade_use_pt

					local var8 = SpWeapon.New({
						id = var6
					})

					if var2 > 0 and var8:GetRarity() > var5:GetRarity() then
						break
					end

					if var9 < var11 then
						break
					end

					var3(var7.upgrade_use_item)

					var12 = var12 + var7.upgrade_use_gold
					var2 = var2 + 1
					var8 = var6

					if var8:GetRarity() > var5:GetRarity() then
						var10 = var11

						break
					end
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_creatept_no_enough"))

				return
			end

			local var9 = var9 - var11

			var9 = math.min(var9, var11)

			if getProxy(EquipmentProxy):GetSpWeaponCapacity() <= getProxy(EquipmentProxy):GetSpWeaponCount() then
				NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), OpenSpWeaponPage, gotoChargeScene)

				return
			end

			if var1.gold < var12 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						var12 - var1.gold,
						var12
					}
				})

				return
			end

			if not _.all(var13, function(arg0)
				return arg0.count <= (var0[arg0.id] and var0[arg0.id].count or 0)
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

				return
			end

			if not _.all(var2, function(arg0)
				return arg0.count <= (var0[arg0.id] and var0[arg0.id].count or 0)
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

				return
			end

			if not _.all(var3, function(arg0)
				local var0 = arg0:GetShipId()

				if var0 then
					local var1 = var7:getShipById(var0):GetSpWeapon()

					return var1 and var1:GetUID() == arg0:GetUID()
				else
					return var6:GetSpWeaponByUid(arg0:GetUID())
				end
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

				return
			end

			if var9 > 0 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("spweapon_tip_breakout_overflow", var9),
					onYes = arg0
				})
			else
				arg0()
			end
		end,
		function(arg0)
			local var0 = _.reduce(var2, {}, function(arg0, arg1)
				for iter0 = 1, arg1.count do
					table.insert(arg0, arg1.id)
				end

				return arg0
			end)
			local var1 = _.map(var3, function(arg0)
				return arg0:GetUID()
			end)

			pg.ConnectionMgr.GetInstance():Send(14209, {
				template_id = var1,
				item_id_list = var0,
				spweapon_id_list = var1
			}, 14210, function(arg0)
				if arg0.result == 0 then
					local var0 = SpWeapon.CreateByNet(arg0.spweapon)
					local var1 = var5:getData()

					var1:consume({
						gold = var12
					})
					var5:updatePlayer(var1)
					_.each(var13, function(arg0)
						var4:removeItemById(arg0.id, arg0.count)
					end)
					_.each(var2, function(arg0)
						var4:removeItemById(arg0.id, arg0.count)
					end)
					_.each(var3, function(arg0)
						local var0 = arg0:GetShipId()

						if var0 then
							local var1 = var7:getShipById(var0)

							var1:UpdateSpWeapon(nil)
							var7:updateShip(var1)
						else
							var6:RemoveSpWeapon(arg0)
						end
					end)
					var6:AddSpWeapon(var0)
					arg0:sendNotification(GAME.COMPOSITE_SPWEAPON_DONE, var0)
					pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_create_sussess", var0:GetName()))
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_compositeEquipment", arg0.result))
				end
			end)
		end
	})
end

return var0
