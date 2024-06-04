local var0 = class("SkillInfoMediator", import("..base.ContextMediator"))

var0.WARP_TO_TACTIC = "SkillInfoMediator:WARP_TO_TACTIC"
var0.WARP_TO_META_TACTICS = "SkillInfoMediator:WARP_TO_METATASK"

function var0.register(arg0)
	arg0:bind(var0.WARP_TO_TACTIC, function(arg0)
		local var0 = getProxy(NavalAcademyProxy)
		local var1 = var0:getStudents()
		local var2 = 0
		local var3 = 0
		local var4 = var0.MAX_SKILL_CLASS_NUM

		for iter0 = 1, var4 do
			if var1[iter0] then
				var2 = var2 + 1
			else
				var3 = iter0

				break
			end
		end

		if var2 >= var0:getSkillClassNum() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_lesson_full"))
			arg0.viewComponent:close()

			return
		end

		local var5 = getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE)

		if table.getCount(var5 or {}) <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
			arg0.viewComponent:close()

			return
		end

		for iter1, iter2 in pairs(var1) do
			if iter2.shipId == arg0.contextData.shipId then
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_lesson_repeated"))
				arg0.viewComponent:close()

				return
			end
		end

		arg0.viewComponent:close()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.NAVALACADEMYSCENE, {
			warp = NavalAcademyScene.WARP_TO_TACTIC,
			shipToLesson = {
				shipId = arg0.contextData.shipId,
				skillIndex = arg0.contextData.index,
				index = var3
			}
		})
	end)
	arg0:bind(var0.WARP_TO_META_TACTICS, function(arg0, arg1)
		arg0.viewComponent:close()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
			autoOpenTactics = true,
			autoOpenShipConfigID = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
