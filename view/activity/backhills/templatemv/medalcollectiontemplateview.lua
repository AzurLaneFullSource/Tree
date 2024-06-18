local var0_0 = class("MedalCollectionTemplateView", import("view.base.BaseUI"))

var0_0.MEDAL_STATUS_UNACTIVATED = 1
var0_0.MEDAL_STATUS_ACTIVATED = 2
var0_0.MEDAL_STATUS_ACTIVATABLE = 3

function var0_0.UpdateActivity(arg0_1, arg1_1)
	arg0_1.activityData = arg1_1
	arg0_1.allIDList = arg0_1.activityData:GetPicturePuzzleIds()
	arg0_1.activatableIDList = arg0_1.activityData.data1_list
	arg0_1.activeIDList = arg0_1.activityData.data2_list
end

function var0_0.didEnter(arg0_2)
	arg0_2:CheckAward()
end

function var0_0.UpdateAfterSubmit(arg0_3, arg1_3)
	arg0_3:CheckAward()
end

function var0_0.UpdateAfterFinalMedal(arg0_4)
	return
end

function var0_0.CheckAward(arg0_5)
	if #arg0_5.activeIDList == #arg0_5.allIDList and arg0_5.activityData.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_5.activityData.id
		})
	end
end

return var0_0
