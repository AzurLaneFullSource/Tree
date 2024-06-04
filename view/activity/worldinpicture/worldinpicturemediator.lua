local var0 = class("WorldInPictureMediator", import("...base.ContextMediator"))

var0.ON_TRAVEL = "WorldInPictureMediator:ON_TRAVEL"
var0.ON_DRAW = "WorldInPictureMediator:ON_DRAW"
var0.ON_AUTO_TRAVEL = "WorldInPictureMediator:ON_AUTO_TRAVEL"
var0.ON_AUTO_DRAW = "WorldInPictureMediator:ON_AUTO_DRAW"
var0.RESULT_ONEKEY_AWARD = "WorldInPictureMediator:RESULT_ONEKEY_AWARD"

function var0.register(arg0)
	arg0:bind(var0.ON_AUTO_TRAVEL, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.WORLDIN_PICTURE_OP, {
			auto = true,
			cmd = ActivityConst.WORLDINPICTURE_OP_TURN,
			arg1 = arg1,
			arg2 = arg2,
			index = arg3
		})
	end)
	arg0:bind(var0.ON_AUTO_DRAW, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.WORLDIN_PICTURE_OP, {
			auto = true,
			cmd = ActivityConst.WORLDINPICTURE_OP_DRAW,
			arg1 = arg1,
			arg2 = arg2,
			index = arg3
		})
	end)
	arg0:bind(var0.ON_TRAVEL, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.WORLDIN_PICTURE_OP, {
			cmd = ActivityConst.WORLDINPICTURE_OP_TURN,
			arg1 = arg1,
			arg2 = arg2,
			index = arg3
		})
	end)
	arg0:bind(var0.ON_DRAW, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.WORLDIN_PICTURE_OP, {
			cmd = ActivityConst.WORLDINPICTURE_OP_DRAW,
			arg1 = arg1,
			arg2 = arg2,
			index = arg3
		})
	end)
	arg0:bind(var0.RESULT_ONEKEY_AWARD, function(arg0)
		if #arg0.cacheAwards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, arg0.cacheAwards, function()
				arg0.cacheAwards = {}
			end)
		end
	end)

	arg0.cacheAwards = {}

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLDINPICTURE)
	local var1 = WorldInPictureActiviyData.New(var0)

	arg0.viewComponent:SetData(var1)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.WORLDIN_PICTURE_OP_DONE,
		GAME.WORLDIN_PICTURE_OP_ERRO
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.WORLDIN_PICTURE_OP_DONE then
		local var2 = WorldInPictureActiviyData.New(var1.activity)

		arg0.viewComponent:SetData(var2)

		if #var1.awards > 0 then
			if not var1.auto then
				arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
			else
				for iter0, iter1 in ipairs(var1.awards) do
					table.insert(arg0.cacheAwards, iter1)
				end
			end
		end

		if var1.cmd == ActivityConst.WORLDINPICTURE_OP_TURN then
			arg0.viewComponent:OnOpenCell(var1.arg1, var1.arg2, var1.auto)
		elseif var1.cmd == ActivityConst.WORLDINPICTURE_OP_DRAW then
			arg0.viewComponent:OnDrawArea(var1.arg1, var1.arg2, var1.auto)
		end
	elseif var0 == GAME.WORLDIN_PICTURE_OP_ERRO then
		if var1.cmd == ActivityConst.WORLDINPICTURE_OP_TURN then
			arg0.viewComponent:OnOpenCellErro(var1.auto)
		elseif var1.cmd == ActivityConst.WORLDINPICTURE_OP_DRAW then
			arg0.viewComponent:OnDrawAreaErro(var1.auto)
		end
	end
end

return var0
