local var0 = class("ModifyGuildInfoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(PlayerProxy)
	local var2 = var1:getData()
	local var3 = pg.gameset.modify_guild_cost.key_value

	if type == 1 and var3 > var2:getTotalGem() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

		return
	end

	local function var4()
		pg.ConnectionMgr.GetInstance():Send(60026, {
			type = var0.type,
			int = var0.int,
			str = var0.string
		}, 60027, function(arg0)
			if arg0.result == 0 then
				if var0.type == 1 then
					var2:consume({
						gem = var3
					})
					var1:updatePlayer(var2)
				end

				arg0:sendNotification(GAME.MODIFY_GUILD_INFO_DONE)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_info_update"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_modify_erro", arg0.result))
			end
		end)
	end

	if var0.type == 1 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_modify_info_tip", var3),
			onYes = function()
				var4()
			end
		})
	else
		var4()
	end
end

return var0
