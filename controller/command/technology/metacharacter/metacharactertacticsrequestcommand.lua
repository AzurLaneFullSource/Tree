local var0 = class("MetaCharacterTacticsRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id

	print("63313 request tactics info")
	pg.ConnectionMgr.GetInstance():Send(63313, {
		ship_id = var0
	}, 63314, function(arg0)
		print("63314 requset success")

		local var0 = {}

		for iter0, iter1 in ipairs(arg0.tasks or {}) do
			local var1 = iter1.skill_id

			if not var0[var1] then
				var0[var1] = {}
			end

			table.insert(var0[var1], {
				taskID = iter1.task_id,
				finishCount = iter1.finish_cnt
			})
		end

		local var2 = {}

		for iter2, iter3 in ipairs(arg0.skill_exp or {}) do
			var2[iter3.skill_id] = iter3.exp

			print("skill", iter3.skill_id, iter3.exp)
		end

		local var3 = {
			shipID = arg0.ship_id,
			doubleExp = arg0.double_exp,
			normalExp = arg0.exp,
			curSkillID = arg0.skill_id or 0,
			switchCount = arg0.switch_cnt,
			taskInfoTable = var0,
			skillExpTable = var2
		}

		getProxy(MetaCharacterProxy):setMetaTacticsInfo(arg0)
		arg0:sendNotification(GAME.TACTICS_META_INFO_REQUEST_DONE, var3)
	end)
end

return var0
