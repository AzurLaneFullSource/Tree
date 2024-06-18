local var0_0 = class("GetStoreResCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.oil
	local var2_1 = var0_1.gold

	if var1_1 == 0 and var2_1 == 0 then
		return
	end

	local var3_1 = GetItemsOverflowDic({
		Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResOil,
			count = var1_1
		}),
		Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold,
			count = var2_1
		})
	})
	local var4_1, var5_1 = CheckOverflow(var3_1)

	if not var4_1 then
		switch(var5_1, {
			gold = function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_mail"))
			end,
			oil = function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_mail"))
			end,
			equip = function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("mail_takeAttachment_error_magazine_full"))
			end,
			ship = function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("mail_takeAttachment_error_dockYrad_full"))
			end
		})

		return
	end

	pg.ConnectionMgr.GetInstance():Send(30012, {
		oil = var1_1,
		gold = var2_1
	}, 30013, function(arg0_6)
		if arg0_6.result == 0 then
			getProxy(PlayerProxy):UpdatePlayerRes({
				{
					id = PlayerConst.ResOil,
					count = var1_1
				},
				{
					id = PlayerConst.ResStoreOil,
					count = -var1_1
				},
				{
					id = PlayerConst.ResGold,
					count = var2_1
				},
				{
					id = PlayerConst.ResStoreGold,
					count = -var2_1
				}
			})
			arg0_1:sendNotification(GAME.GET_STORE_RES_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_6.result))
		end
	end)
end

return var0_0
