local var0 = class("ChangeManifestoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().manifesto
	local var1 = getProxy(PlayerProxy)
	local var2 = var1:getData()

	pg.ConnectionMgr.GetInstance():Send(11009, {
		adv = var0
	}, 11010, function(arg0)
		if arg0.result == 0 then
			var2.manifesto = var0

			var1:updatePlayer(var2)
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_changeManifesto_ok"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_changeManifesto", arg0.result))
		end
	end)
end

return var0
