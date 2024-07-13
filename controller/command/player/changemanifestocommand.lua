local var0_0 = class("ChangeManifestoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().manifesto
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = var1_1:getData()

	pg.ConnectionMgr.GetInstance():Send(11009, {
		adv = var0_1
	}, 11010, function(arg0_2)
		if arg0_2.result == 0 then
			var2_1.manifesto = var0_1

			var1_1:updatePlayer(var2_1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_changeManifesto_ok"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_changeManifesto", arg0_2.result))
		end
	end)
end

return var0_0
