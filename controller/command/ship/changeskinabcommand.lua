local var0_0 = class("ChangeSkinABCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.ship_id
	local var2_1 = var0_1.skin_id
	local var3_1 = ShipGroup.GetChangeSkinNextId(var2_1)
	local var4_1 = ShipGroup.GetChangeSkinGroupId(var2_1)
	local var5_1 = getProxy(PlayerProxy):getRawData():GetFlagShip()

	if var2_1 ~= var5_1:getSkinId() then
		return
	end

	if not pg.ChangeSkinMgr.GetInstance():isAble() then
		return
	end

	pg.ChangeSkinMgr.GetInstance():preloadChangeAction(var3_1, function()
		arg0_1:startChangeAction(var1_1, var2_1, var3_1, var4_1, var5_1)
	end)
end

function var0_0.startChangeAction(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	arg0_3:sendNotification(GAME.PLAY_CHANGE_SKIN_OUT, {
		callback = function(arg0_4)
			local var0_4 = arg0_4.flag
			local var1_4 = arg0_4.tip

			if var0_4 then
				ShipGroup.SetStoreChangeSkinId(arg4_3, arg1_3, arg3_3)
				arg5_3:updateSkinId(arg3_3)
				getProxy(BayProxy):updateShip(arg5_3)

				if not getProxy(SettingsProxy):getCharacterSetting(arg1_3, SHIP_FLAG_L2D) then
					arg0_3:sendNotification(GAME.CHANGE_SKIN_EXCHANGE, {
						callback = function()
							return
						end
					})
					arg0_3:sendNotification(GAME.PLAY_CHANGE_SKIN_IN)
					arg0_3:sendNotification(GAME.PLAY_CHANGE_SKIN_FINISH)
				else
					pg.ChangeSkinMgr.GetInstance():play(arg3_3, function()
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
			end

			if var1_4 then
				pg.TipsMgr.GetInstance():ShowTips(arg2_3)
			end
		end
	})
end

return var0_0
