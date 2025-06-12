local var0_0 = class("ChangeSkinABCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().skin_id
	local var1_1 = ShipSkin.GetChangeSkinNextId(var0_1)
	local var2_1 = getProxy(PlayerProxy):getRawData():GetFlagShip()

	if var0_1 ~= var2_1:getSkinId() then
		return
	end

	if not pg.ChangeSkinMgr.GetInstance():isAble() then
		return
	end

	pg.ChangeSkinMgr.GetInstance():preloadChangeAction(var1_1, function()
		arg0_1:startChangeAction(var0_1, var1_1, var2_1)
	end)
end

function var0_0.startChangeAction(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = getProxy(SettingsProxy):getCharacterSetting(arg3_3.id, SHIP_FLAG_L2D)

	if var0_3 and Live2dConst.GetLive2DArm32MatchAble() then
		getProxy(SettingsProxy):setCharacterSetting(arg3_3.id, SHIP_FLAG_L2D, false)
	elseif not var0_3 and not Live2dConst.GetLive2DArm32MatchAble() then
		getProxy(SettingsProxy):setCharacterSetting(arg3_3.id, SHIP_FLAG_L2D, true)
	end

	arg0_3:sendNotification(GAME.PLAY_CHANGE_SKIN_OUT, {
		callback = function(arg0_4)
			local var0_4 = arg0_4.flag
			local var1_4 = arg0_4.tip

			if var0_4 then
				ShipSkin.SetStoreChangeSkinId(arg2_3)
				pg.ChangeSkinMgr.GetInstance():play(arg2_3, function()
					arg0_3:sendNotification(GAME.CHANGE_SKIN_EXCHANGE, {
						callback = function()
							return
						end
					})
				end, function()
					arg0_3:sendNotification(GAME.PLAY_CHANGE_SKIN_IN)
				end, function()
					arg0_3:sendNotification(GAME.PLAY_CHANGE_SKIN_FINISH)
				end)
			end

			if var1_4 then
				pg.TipsMgr.GetInstance():ShowTips(arg1_3)
			end
		end
	})
end

return var0_0
