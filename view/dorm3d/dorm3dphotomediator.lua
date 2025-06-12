local var0_0 = class("Dorm3dPhotoMediator", import("view.base.ContextMediator"))

var0_0.SHARE_PANEL = "Dorm3dPhotoMediator:SHARE_PANEL"
var0_0.CAMERA_LIFT_CHANGED = "CAMERA_LIFT_CHANGED"
var0_0.CAMERA_STICK_MOVE = "CAMERA_STICK_MOVE"
var0_0.GO_AR = "Dorm3dPhotoMediator:GO_AR"
var0_0.OPEN_SKIN_SELECT_LAYER = "Dorm3dPhotoMediator:OPEN_SKIN_SELECT_LAYER"

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.view

	arg0_1.viewComponent:SetSceneRoot(var0_1)
	arg0_1.viewComponent:SetRoom(var0_1.room)
	arg0_1.viewComponent:SetGroupId(arg0_1.contextData.groupId)
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
			if PermissionHelper.IsAndroid() then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("apply_permission_camera_tip3"),
					onYes = function()
						PermissionHelper.RequestCamera(var2_3, var3_3)
					end
				})
			elseif PermissionHelper.IsIOS() then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("apply_permission_camera_tip2")
				})
			end
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("apply_permission_camera_tip1"),
			onYes = function()
				PermissionHelper.RequestCamera(var2_3, var3_3)
			end
		})
	end)
	arg0_1:bind(var0_0.OPEN_SKIN_SELECT_LAYER, function(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dSkinSelectLayer,
			mediator = Dorm3dSkinSelectMediator,
			data = {
				groupId = arg1_8,
				ladyEnv = arg2_8,
				onSwitchSkin = arg3_8,
				isPublicRoom = arg4_8
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		ApartmentProxy.UPDATE_APARTMENT,
		var0_0.CAMERA_LIFT_CHANGED,
		var0_0.CAMERA_STICK_MOVE
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()

	if var0_10 == ApartmentProxy.UPDATE_APARTMENT then
		-- block empty
	elseif var0_10 == var0_0.CAMERA_LIFT_CHANGED then
		arg0_10.viewComponent:SetPhotoCameraSliderValue(var1_10.value)
	elseif var0_10 == var0_0.CAMERA_STICK_MOVE then
		arg0_10.viewComponent:SetPhotoStickDelta(var1_10)
	end
end

function var0_0.remove(arg0_11)
	return
end

return var0_0
