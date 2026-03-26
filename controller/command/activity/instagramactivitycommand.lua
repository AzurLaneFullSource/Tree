local var0_0 = class("InstagramActivityCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(InstagramProxy)

	if ActivityConst.INSTAGRAM_OP_ACTIVE == var0_1.cmd then
		pg.ConnectionMgr.GetInstance():Send(11701, {
			cmd = 1,
			id = var0_1.arg1
		}, 11702, function(arg0_2)
			if arg0_2.result == 0 then
				local var0_2 = Instagram.New(arg0_2.data)

				var1_1:UpdateMessage(var0_2)
				var1_1:AddInstagramTimer()
				arg0_1:sendNotification(GAME.ACT_INSTAGRAM_OP_DONE, {
					cmd = var0_1.cmd,
					id = var0_1.arg1
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
			end
		end)
	elseif ActivityConst.INSTAGRAM_OP_LIKE == var0_1.cmd or ActivityConst.INSTAGRAM_OP_MARK_READ == var0_1.cmd or ActivityConst.INSTAGRAM_OP_UPDATE == var0_1.cmd or ActivityConst.INSTAGRAM_OP_SHARE == var0_1.cmd then
		pg.ConnectionMgr.GetInstance():Send(11701, {
			id = var0_1.arg1,
			cmd = var0_1.cmd
		}, 11702, function(arg0_3)
			if arg0_3.result == 0 then
				if ActivityConst.INSTAGRAM_OP_MARK_READ == var0_1.cmd then
					local var0_3

					if pg.activity_ins_template[var0_1.arg1].type == InstagramConst.INSTAGRAM_TYPE.OFFICIAL_ACCOUNT then
						var0_3 = var1_1:GetOfficialAccounts()[var0_1.arg1]
					else
						var0_3 = var1_1:GetMessageById(var0_1.arg1)
					end

					var0_3.isRead = true

					var1_1:UpdateMessage(var0_3)
				elseif ActivityConst.INSTAGRAM_OP_SHARE ~= var0_1.cmd then
					local var1_3 = Instagram.New(arg0_3.data)

					var1_1:UpdateMessage(var1_3)
				end

				arg0_1:sendNotification(GAME.ACT_INSTAGRAM_OP_DONE, {
					cmd = var0_1.cmd,
					id = var0_1.arg1
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
			end
		end)
	elseif ActivityConst.INSTAGRAM_OP_COMMENT == var0_1.cmd then
		pg.ConnectionMgr.GetInstance():Send(11703, {
			id = var0_1.arg1,
			discuss = var0_1.arg2,
			index = var0_1.arg3
		}, 11704, function(arg0_4)
			if arg0_4.result == 0 then
				local var0_4 = Instagram.New(arg0_4.data)

				var1_1:UpdateMessage(var0_4)
				arg0_1:sendNotification(GAME.ACT_INSTAGRAM_OP_DONE, {
					cmd = var0_1.cmd,
					id = var0_1.arg1
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
			end
		end)
	end
end

return var0_0
