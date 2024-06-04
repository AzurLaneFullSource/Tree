local var0 = class("GetShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type or 1
	local var2 = var0.pos_list
	local var3 = getProxy(BuildShipProxy)
	local var4 = underscore.filter(var2, function(arg0)
		return var3:getBuildShip(arg0).state == BuildShip.FINISH
	end)

	if #var4 == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_getShip_error_notFinish"))

		return
	end

	local var5 = getProxy(BayProxy)
	local var6 = getProxy(PlayerProxy):getData():getMaxShipBag() - var5:getShipCount()

	if var6 <= 0 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

		return
	else
		var4 = underscore.slice(var4, 1, var6)
	end

	local var7 = {}

	table.insert(var7, function(arg0)
		pg.ConnectionMgr.GetInstance():Send(12043, {
			type = 0
		}, 12044, function(arg0)
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.infoList) do
				var0[iter1.pos] = iter1.tid
			end

			arg0(underscore.map(var4, function(arg0)
				return var0[arg0]
			end))
		end)
	end)
	table.insert(var7, function(arg0, arg1)
		local var0 = {}

		for iter0, iter1 in ipairs(arg1) do
			PaintingGroupConst.AddPaintingNameByShipConfigID(var0, iter1)
		end

		local var1 = {
			isShowBox = true,
			paintingNameList = var0,
			finishFunc = arg0
		}

		PaintingGroupConst.PaintingDownload(var1)
	end)
	seriesAsync(var7, function()
		local var0 = var3:getBuildShip(var4[1]).type

		pg.ConnectionMgr.GetInstance():Send(12025, {
			type = var1,
			pos_list = var4
		}, 12026, function(arg0)
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.ship_list) do
				var3:removeBuildShipByIndex(var4[1])

				local var1 = Ship.New(iter1)

				table.insert(var0, var1)

				if var1:isMetaShip() and not var1.virgin and Player.isMetaShipNeedToTrans(var1.configId) then
					local var2 = MetaCharacterConst.addReMetaTransItem(var1)

					if var2 then
						var1:setReMetaSpecialItemVO(var2)
					end
				else
					var5:addShip(var1)
				end
			end

			if #var0 > 0 then
				var3:setBuildShipState()
				arg0:sendNotification(GAME.GET_SHIP_DONE, {
					ships = var0,
					type = var0
				})
			end

			if arg0.result == 0 then
				-- block empty
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_getShip", arg0.result))
			end
		end)
	end)
end

return var0
