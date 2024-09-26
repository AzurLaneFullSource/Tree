local var0_0 = class("Dorm3dPhotoShareLayerMediator", import("view.base.ContextMediator"))

var0_0.SELECTFRAME = "Dorm3dPhotoShareLayerMediator:SELECTFRAME"
var0_0.EXIT_SHARE = "Dorm3dPhotoShareLayerMediator:EXIT_SHARE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SELECTFRAME, function(arg0_2, arg1_2, arg2_2)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dPhotoSelectFrameMediator,
			viewComponent = Dorm3dPhotoSelectFrame,
			data = {
				photoTex = arg1_2,
				photoData = arg2_2
			}
		}))
	end)
	arg0_1:bind(var0_0.EXIT_SHARE, function()
		arg0_1:sendNotification(var0_0.EXIT_SHARE)
	end)
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[Dorm3dPhotoSelectFrameMediator.CONFIRMFRAME] = function(arg0_5, arg1_5)
			local var0_5 = arg1_5:getBody()

			arg0_5.viewComponent:AfterSelectFrame(var0_5)
		end
	}
end

return var0_0
