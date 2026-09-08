local var0_0 = class("ReversePacmanInterviewMediator", import("view.base.ContextMediator"))

var0_0.CMD_HIRE = "ReversePacmanInterviewMediator::CMD_HIRE"

function var0_0.register(arg0_1)
	local var0_1 = ReversePacmanTools.GetActivity().id

	arg0_1:bind(var0_0.CMD_HIRE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.REVERSE_PACMAN_HIRE_ROLE, {
			activityID = var0_1,
			roleID = arg1_2
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.REVERSE_PACMAN_HIRE_ROLE_DONE] = function(arg0_4, arg1_4)
			local var0_4 = arg1_4:getBody()

			arg0_4.viewComponent:OnRoleHireSuccess(var0_4)
		end,
		[STORY_EVENT.OPTION_SELECTED] = function(arg0_5, arg1_5)
			arg0_5.viewComponent:OnSelectedOption()
		end,
		[GAME.REVERSE_PACMAN_REFRESH_TIP] = function(arg0_6, arg1_6)
			arg0_6.viewComponent:RefreshBtns()
		end
	}
end

return var0_0
