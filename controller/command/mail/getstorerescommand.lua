local var0 = class("GetStoreResCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.oil
	local var2 = var0.gold

	if var1 == 0 and var2 == 0 then
		return
	end

	local var3 = GetItemsOverflowDic({
		Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResOil,
			count = var1
		}),
		Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold,
			count = var2
		})
	})
	local var4, var5 = CheckOverflow(var3)

	if not var4 then
		switch(var5, {
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
		oil = var1,
		gold = var2
	}, 30013, function(arg0)
		if arg0.result == 0 then
			getProxy(PlayerProxy):UpdatePlayerRes({
				{
					id = PlayerConst.ResOil,
					count = var1
				},
				{
					id = PlayerConst.ResStoreOil,
					count = -var1
				},
				{
					id = PlayerConst.ResGold,
					count = var2
				},
				{
					id = PlayerConst.ResStoreGold,
					count = -var2
				}
			})
			arg0:sendNotification(GAME.GET_STORE_RES_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
