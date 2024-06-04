local var0 = class("MedalCollectionTemplateView", import("view.base.BaseUI"))

var0.MEDAL_STATUS_UNACTIVATED = 1
var0.MEDAL_STATUS_ACTIVATED = 2
var0.MEDAL_STATUS_ACTIVATABLE = 3

function var0.UpdateActivity(arg0, arg1)
	arg0.activityData = arg1
	arg0.allIDList = arg0.activityData:GetPicturePuzzleIds()
	arg0.activatableIDList = arg0.activityData.data1_list
	arg0.activeIDList = arg0.activityData.data2_list
end

function var0.didEnter(arg0)
	arg0:CheckAward()
end

function var0.UpdateAfterSubmit(arg0, arg1)
	arg0:CheckAward()
end

function var0.UpdateAfterFinalMedal(arg0)
	return
end

function var0.CheckAward(arg0)
	if #arg0.activeIDList == #arg0.allIDList and arg0.activityData.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0.activityData.id
		})
	end
end

return var0
