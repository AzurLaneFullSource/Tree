local var0_0 = class("ClassOverCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.courseID
	local var2_1 = var0_1.slotVO

	pg.ConnectionMgr.GetInstance():Send(22006, {
		room_id = var1_1,
		ship_id = var2_1:GetShip().id
	}, 22007, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy)
			local var1_2 = var2_1:GetShip()
			local var2_2 = var2_1:GetAttrList()
			local var3_2 = {}

			for iter0_2, iter1_2 in pairs(var2_2) do
				var1_2:addAttr(iter0_2, iter1_2)
				var0_2:updateShip(var1_2)

				var3_2[#var3_2 + 1] = {
					pg.attribute_info_by_type[iter0_2].condition,
					iter1_2
				}
			end

			local var4_2 = var1_2:getConfig("name")

			if #var3_2 == 2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_quest_Classover_long", var4_2, var3_2[1][1], var3_2[1][2], var3_2[2][1], var3_2[2][2]))
			else
				for iter2_2, iter3_2 in ipairs(var3_2) do
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_quest_Classover_short", var4_2, iter3_2[1], iter3_2[2]))
				end
			end

			getProxy(NavalAcademyProxy):GetReward(var1_1, var1_2.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_classOver", arg0_2.result))
		end
	end)
end

return var0_0
