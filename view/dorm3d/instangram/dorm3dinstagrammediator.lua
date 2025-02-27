local var0_0 = class("Dorm3dInstagramMediator", import("view.base.ContextMediator"))

var0_0.ON_DISCUSS = "Dorm3dInstagramMediator:ON_DISCUSS"
var0_0.ON_READ = "Dorm3dInstagramMediator:ON_READ"
var0_0.ON_LIKE = "Dorm3dInstagramMediator:ON_LIKE"
var0_0.ON_SHARE = "Dorm3dInstagramMediator:ON_SHARE"
var0_0.ON_EXIT = "Dorm3dInstagramMediator:ON_EXIT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_DISCUSS, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.APARTMENT_INS_OP, {
			shipId = arg0_1.contextData.apartmentGroupId,
			op = Instagram3Dorm.OP_DISCUSS,
			id = arg1_2,
			commentId = arg2_2,
			index = arg3_2
		})
	end)
	arg0_1:bind(var0_0.ON_READ, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.APARTMENT_INS_OP, {
			shipId = arg0_1.contextData.apartmentGroupId,
			op = Instagram3Dorm.OP_READ,
			id = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_LIKE, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.APARTMENT_INS_OP, {
			shipId = arg0_1.contextData.apartmentGroupId,
			op = Instagram3Dorm.OP_LIKE,
			id = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_SHARE, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.APARTMENT_INS_OP, {
			shipId = arg0_1.contextData.apartmentGroupId,
			op = Instagram3Dorm.OP_SHARE,
			id = arg1_5
		})
	end)
	arg0_1:bind(var0_0.ON_EXIT, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.APARTMENT_INS_OP, {
			shipId = arg0_1.contextData.apartmentGroupId,
			op = Instagram3Dorm.OP_EXIT,
			id = arg1_6
		})
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.APARTMENT_INS_OP_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.APARTMENT_INS_OP_DONE then
		if var1_8.op == Instagram3Dorm.OP_DISCUSS then
			arg0_8.viewComponent:UpdateCommentList()
		elseif var1_8.op == Instagram3Dorm.OP_READ then
			-- block empty
		elseif var1_8.op == Instagram3Dorm.OP_LIKE then
			arg0_8.viewComponent:OnLikeInstagram()
		elseif var1_8.op == Instagram3Dorm.OP_SHARE then
			-- block empty
		elseif var1_8.op == Instagram3Dorm.OP_EXIT then
			-- block empty
		end
	end
end

return var0_0
