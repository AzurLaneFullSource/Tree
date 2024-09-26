local var0_0 = class("Dorm3dPhotoMediator", import("view.base.ContextMediator"))

var0_0.SHARE_PANEL = "Dorm3dPhotoMediator:SHARE_PANEL"
var0_0.Camera_Pinch_Value_Change = "Camera_Pinch_Value_Change"
var0_0.GO_AR = "Dorm3dPhotoMediator:GO_AR"

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.view

	arg0_1.viewComponent:SetSceneRoot(var0_1)
	arg0_1.viewComponent:SetRoom(var0_1.room)
	arg0_1:bind(var0_0.SHARE_PANEL, function(arg0_2, arg1_2, arg2_2)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dPhotoShareLayerMediator,
			viewComponent = Dorm3dPhotoShareLayer,
			data = {
				photoTex = arg1_2,
				photoData = arg2_2
			}
		}))
	end)
	arg0_1:bind(var0_0.GO_AR, function(arg0_3, arg1_3)
		if LOCK_DORM3D_AR then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_AR_switch"))

			return
		end

		if pg.SdkMgr.GetInstance():IsYunPackage() then
			pg.TipsMgr.GetInstance():ShowTips("指挥官，当前平台不支持该功能哦")

			return
		end

		local var0_3
		local var1_3

		local function var2_3()
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DORM3D_AR, {
				ARCheckState = arg1_3,
				roomId = var0_1.room:GetConfigID(),
				groupId = var0_1.apartment:GetConfigID()
			})
		end

		local function var3_3()
			if CameraHelper.IsAndroid() then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("apply_permission_camera_tip3"),
					onYes = function()
						CameraHelper.RequestCamera(var2_3, var3_3)
					end
				})
			elseif CameraHelper.IsIOS() then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("apply_permission_camera_tip2")
				})
			end
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("apply_permission_camera_tip1"),
			onYes = function()
				CameraHelper.RequestCamera(var2_3, var3_3)
			end
		})
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		ApartmentProxy.UPDATE_APARTMENT,
		var0_0.Camera_Pinch_Value_Change
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == ApartmentProxy.UPDATE_APARTMENT then
		-- block empty
	elseif var0_9 == var0_0.Camera_Pinch_Value_Change then
		-- block empty
	end
end

function var0_0.remove(arg0_10)
	return
end

return var0_0
