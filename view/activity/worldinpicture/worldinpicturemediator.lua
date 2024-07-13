local var0_0 = class("WorldInPictureMediator", import("...base.ContextMediator"))

var0_0.ON_TRAVEL = "WorldInPictureMediator:ON_TRAVEL"
var0_0.ON_DRAW = "WorldInPictureMediator:ON_DRAW"
var0_0.ON_AUTO_TRAVEL = "WorldInPictureMediator:ON_AUTO_TRAVEL"
var0_0.ON_AUTO_DRAW = "WorldInPictureMediator:ON_AUTO_DRAW"
var0_0.RESULT_ONEKEY_AWARD = "WorldInPictureMediator:RESULT_ONEKEY_AWARD"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_AUTO_TRAVEL, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.WORLDIN_PICTURE_OP, {
			auto = true,
			cmd = ActivityConst.WORLDINPICTURE_OP_TURN,
			arg1 = arg1_2,
			arg2 = arg2_2,
			index = arg3_2
		})
	end)
	arg0_1:bind(var0_0.ON_AUTO_DRAW, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1:sendNotification(GAME.WORLDIN_PICTURE_OP, {
			auto = true,
			cmd = ActivityConst.WORLDINPICTURE_OP_DRAW,
			arg1 = arg1_3,
			arg2 = arg2_3,
			index = arg3_3
		})
	end)
	arg0_1:bind(var0_0.ON_TRAVEL, function(arg0_4, arg1_4, arg2_4, arg3_4)
		arg0_1:sendNotification(GAME.WORLDIN_PICTURE_OP, {
			cmd = ActivityConst.WORLDINPICTURE_OP_TURN,
			arg1 = arg1_4,
			arg2 = arg2_4,
			index = arg3_4
		})
	end)
	arg0_1:bind(var0_0.ON_DRAW, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_1:sendNotification(GAME.WORLDIN_PICTURE_OP, {
			cmd = ActivityConst.WORLDINPICTURE_OP_DRAW,
			arg1 = arg1_5,
			arg2 = arg2_5,
			index = arg3_5
		})
	end)
	arg0_1:bind(var0_0.RESULT_ONEKEY_AWARD, function(arg0_6)
		if #arg0_1.cacheAwards > 0 then
			arg0_1.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0_1.cacheAwards, function()
				arg0_1.cacheAwards = {}
			end)
		end
	end)

	arg0_1.cacheAwards = {}

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)
	local var1_1 = WorldInPictureActiviyData.New(var0_1)

	arg0_1.viewComponent:SetData(var1_1)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		GAME.WORLDIN_PICTURE_OP_DONE,
		GAME.WORLDIN_PICTURE_OP_ERRO
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.WORLDIN_PICTURE_OP_DONE then
		local var2_9 = WorldInPictureActiviyData.New(var1_9.activity)

		arg0_9.viewComponent:SetData(var2_9)

		if #var1_9.awards > 0 then
			if not var1_9.auto then
				arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9.awards)
			else
				for iter0_9, iter1_9 in ipairs(var1_9.awards) do
					table.insert(arg0_9.cacheAwards, iter1_9)
				end
			end
		end

		if var1_9.cmd == ActivityConst.WORLDINPICTURE_OP_TURN then
			arg0_9.viewComponent:OnOpenCell(var1_9.arg1, var1_9.arg2, var1_9.auto)
		elseif var1_9.cmd == ActivityConst.WORLDINPICTURE_OP_DRAW then
			arg0_9.viewComponent:OnDrawArea(var1_9.arg1, var1_9.arg2, var1_9.auto)
		end
	elseif var0_9 == GAME.WORLDIN_PICTURE_OP_ERRO then
		if var1_9.cmd == ActivityConst.WORLDINPICTURE_OP_TURN then
			arg0_9.viewComponent:OnOpenCellErro(var1_9.auto)
		elseif var1_9.cmd == ActivityConst.WORLDINPICTURE_OP_DRAW then
			arg0_9.viewComponent:OnDrawAreaErro(var1_9.auto)
		end
	end
end

return var0_0
