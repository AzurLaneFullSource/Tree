local var0_0 = class("SkillInfoMediator", import("..base.ContextMediator"))

var0_0.WARP_TO_TACTIC = "SkillInfoMediator:WARP_TO_TACTIC"
var0_0.WARP_TO_META_TACTICS = "SkillInfoMediator:WARP_TO_METATASK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.WARP_TO_TACTIC, function(arg0_2)
		local var0_2 = getProxy(NavalAcademyProxy)
		local var1_2 = var0_2:getStudents()
		local var2_2 = 0
		local var3_2 = 0
		local var4_2 = var0_2.MAX_SKILL_CLASS_NUM

		for iter0_2 = 1, var4_2 do
			if var1_2[iter0_2] then
				var2_2 = var2_2 + 1
			else
				var3_2 = iter0_2

				break
			end
		end

		if var2_2 >= var0_2:getSkillClassNum() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_lesson_full"))
			arg0_1.viewComponent:close()

			return
		end

		local var5_2 = getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE)

		if table.getCount(var5_2 or {}) <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
			arg0_1.viewComponent:close()

			return
		end

		for iter1_2, iter2_2 in pairs(var1_2) do
			if iter2_2.shipId == arg0_1.contextData.shipId then
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_lesson_repeated"))
				arg0_1.viewComponent:close()

				return
			end
		end

		arg0_1.viewComponent:close()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE, {
			warp = NavalAcademyScene.WARP_TO_TACTIC,
			shipToLesson = {
				shipId = arg0_1.contextData.shipId,
				skillIndex = arg0_1.contextData.index,
				index = var3_2
			}
		})
	end)
	arg0_1:bind(var0_0.WARP_TO_META_TACTICS, function(arg0_3, arg1_3)
		arg0_1.viewComponent:close()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
			autoOpenTactics = true,
			autoOpenShipConfigID = arg1_3
		})
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()
end

return var0_0
