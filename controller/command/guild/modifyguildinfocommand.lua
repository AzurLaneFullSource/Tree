local var0_0 = class("ModifyGuildInfoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = var1_1:getData()
	local var3_1 = pg.gameset.modify_guild_cost.key_value

	if type == 1 and var3_1 > var2_1:getTotalGem() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

		return
	end

	local function var4_1()
		pg.ConnectionMgr.GetInstance():Send(60026, {
			type = var0_1.type,
			int = var0_1.int,
			str = var0_1.string
		}, 60027, function(arg0_3)
			if arg0_3.result == 0 then
				if var0_1.type == 1 then
					var2_1:consume({
						gem = var3_1
					})
					var1_1:updatePlayer(var2_1)
				end

				arg0_1:sendNotification(GAME.MODIFY_GUILD_INFO_DONE)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_info_update"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_modify_erro", arg0_3.result))
			end
		end)
	end

	if var0_1.type == 1 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_modify_info_tip", var3_1),
			onYes = function()
				var4_1()
			end
		})
	else
		var4_1()
	end
end

return var0_0
