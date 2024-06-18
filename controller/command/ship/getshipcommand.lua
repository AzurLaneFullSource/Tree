local var0_0 = class("GetShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type or 1
	local var2_1 = var0_1.pos_list
	local var3_1 = getProxy(BuildShipProxy)
	local var4_1 = underscore.filter(var2_1, function(arg0_2)
		return var3_1:getBuildShip(arg0_2).state == BuildShip.FINISH
	end)

	if #var4_1 == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_getShip_error_notFinish"))

		return
	end

	local var5_1 = getProxy(BayProxy)
	local var6_1 = getProxy(PlayerProxy):getData():getMaxShipBag() - var5_1:getShipCount()

	if var6_1 <= 0 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

		return
	else
		var4_1 = underscore.slice(var4_1, 1, var6_1)
	end

	local var7_1 = {}

	table.insert(var7_1, function(arg0_3)
		pg.ConnectionMgr.GetInstance():Send(12043, {
			type = 0
		}, 12044, function(arg0_4)
			local var0_4 = {}

			for iter0_4, iter1_4 in ipairs(arg0_4.infoList) do
				var0_4[iter1_4.pos] = iter1_4.tid
			end

			arg0_3(underscore.map(var4_1, function(arg0_5)
				return var0_4[arg0_5]
			end))
		end)
	end)
	table.insert(var7_1, function(arg0_6, arg1_6)
		local var0_6 = {}

		for iter0_6, iter1_6 in ipairs(arg1_6) do
			PaintingGroupConst.AddPaintingNameByShipConfigID(var0_6, iter1_6)
		end

		local var1_6 = {
			isShowBox = true,
			paintingNameList = var0_6,
			finishFunc = arg0_6
		}

		PaintingGroupConst.PaintingDownload(var1_6)
	end)
	seriesAsync(var7_1, function()
		local var0_7 = var3_1:getBuildShip(var4_1[1]).type

		pg.ConnectionMgr.GetInstance():Send(12025, {
			type = var1_1,
			pos_list = var4_1
		}, 12026, function(arg0_8)
			local var0_8 = {}

			for iter0_8, iter1_8 in ipairs(arg0_8.ship_list) do
				var3_1:removeBuildShipByIndex(var4_1[1])

				local var1_8 = Ship.New(iter1_8)

				table.insert(var0_8, var1_8)

				if var1_8:isMetaShip() and not var1_8.virgin and Player.isMetaShipNeedToTrans(var1_8.configId) then
					local var2_8 = MetaCharacterConst.addReMetaTransItem(var1_8)

					if var2_8 then
						var1_8:setReMetaSpecialItemVO(var2_8)
					end
				else
					var5_1:addShip(var1_8)
				end
			end

			if #var0_8 > 0 then
				var3_1:setBuildShipState()
				arg0_1:sendNotification(GAME.GET_SHIP_DONE, {
					ships = var0_8,
					type = var0_7
				})
			end

			if arg0_8.result == 0 then
				-- block empty
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_getShip", arg0_8.result))
			end
		end)
	end)
end

return var0_0
