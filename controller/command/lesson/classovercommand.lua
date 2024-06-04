local var0 = class("ClassOverCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.courseID
	local var2 = var0.slotVO

	pg.ConnectionMgr.GetInstance():Send(22006, {
		room_id = var1,
		ship_id = var2:GetShip().id
	}, 22007, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(BayProxy)
			local var1 = var2:GetShip()
			local var2 = var2:GetAttrList()
			local var3 = {}

			for iter0, iter1 in pairs(var2) do
				var1:addAttr(iter0, iter1)
				var0:updateShip(var1)

				var3[#var3 + 1] = {
					pg.attribute_info_by_type[iter0].condition,
					iter1
				}
			end

			local var4 = var1:getConfig("name")

			if #var3 == 2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_quest_Classover_long", var4, var3[1][1], var3[1][2], var3[2][1], var3[2][2]))
			else
				for iter2, iter3 in ipairs(var3) do
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_quest_Classover_short", var4, iter3[1], iter3[2]))
				end
			end

			getProxy(NavalAcademyProxy):GetReward(var1, var1.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("lesson_classOver", arg0.result))
		end
	end)
end

return var0
