local var0_0 = class("MetaCharacterTacticsRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	print("63313 request tactics info")
	pg.ConnectionMgr.GetInstance():Send(63313, {
		ship_id = var0_1
	}, 63314, function(arg0_2)
		print("63314 requset success")

		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.tasks or {}) do
			local var1_2 = iter1_2.skill_id

			if not var0_2[var1_2] then
				var0_2[var1_2] = {}
			end

			table.insert(var0_2[var1_2], {
				taskID = iter1_2.task_id,
				finishCount = iter1_2.finish_cnt
			})
		end

		local var2_2 = {}

		for iter2_2, iter3_2 in ipairs(arg0_2.skill_exp or {}) do
			var2_2[iter3_2.skill_id] = iter3_2.exp

			print("skill", iter3_2.skill_id, iter3_2.exp)
		end

		local var3_2 = {
			shipID = arg0_2.ship_id,
			doubleExp = arg0_2.double_exp,
			normalExp = arg0_2.exp,
			curSkillID = arg0_2.skill_id or 0,
			switchCount = arg0_2.switch_cnt,
			taskInfoTable = var0_2,
			skillExpTable = var2_2
		}

		getProxy(MetaCharacterProxy):setMetaTacticsInfo(arg0_2)
		arg0_1:sendNotification(GAME.TACTICS_META_INFO_REQUEST_DONE, var3_2)
	end)
end

return var0_0
