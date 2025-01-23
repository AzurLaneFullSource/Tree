local var0_0 = class("NewEducateTalentMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.ON_REFRESH_TALENT = "NewEducateTalentMediator:ON_REFRESH_TALENT"
var0_0.ON_SELECT_TALENT = "NewEducateTalentMediator:ON_SELECT_TALENT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_REFRESH_TALENT, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_REFRESH_TALENT, {
			id = arg0_1.contextData.char.id,
			talentId = arg1_2,
			idx = arg2_2
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_TALENT, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_TALENT, {
			id = arg0_1.contextData.char.id,
			talentId = arg1_3,
			idx = arg2_3
		})
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.NEW_EDUCATE_REFRESH_TALENT_DONE,
		GAME.NEW_EDUCATE_SEL_TALENT_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.NEW_EDUCATE_REFRESH_TALENT_DONE then
		arg0_5.viewComponent:OnRefreshTalent(var1_5.idx, var1_5.newId)
	elseif var0_5 == GAME.NEW_EDUCATE_SEL_TALENT_DONE then
		arg0_5.viewComponent:OnSelectedDone(var1_5.idx)
	end
end

return var0_0
