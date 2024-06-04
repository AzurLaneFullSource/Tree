local var0 = class("SnapshotSceneMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(SnapshotScene.SELECT_CHAR_PANEL, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = SnapshotSelectCharMediator,
			viewComponent = SnapshotSelectCharLayer
		}))
	end)
	arg0:bind(SnapshotScene.SHARE_PANEL, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = SnapshotShareMediator,
			viewComponent = SnapshotShareLayer,
			data = {
				photoTex = arg1,
				photoData = arg2
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		SnapshotSelectCharMediator.SELECT_CHAR,
		PERMISSION_GRANTED,
		PERMISSION_REJECT,
		PERMISSION_NEVER_REMIND
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == SnapshotSelectCharMediator.SELECT_CHAR then
		if pg.ship_skin_template[var1] then
			local var2 = pg.ship_skin_template[var1].ship_group
			local var3 = getProxy(BayProxy):getGroupPropose(var2)

			arg0.viewComponent.contextData.propose = var3
		end

		arg0.viewComponent:setSkin(var1)
	elseif PERMISSION_GRANTED == var0 then
		if var1 == ANDROID_RECORD_AUDIO_PERMISSION then
			arg0.viewComponent:changeToTakeVideo()
		end
	elseif PERMISSION_REJECT == var0 then
		if var1 == ANDROID_RECORD_AUDIO_PERMISSION then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("apply_permission_record_audio_tip3"),
				onYes = function()
					ApplyPermission({
						ANDROID_RECORD_AUDIO_PERMISSION
					})
				end
			})
		end
	elseif PERMISSION_NEVER_REMIND and var1 == ANDROID_RECORD_AUDIO_PERMISSION then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("apply_permission_record_audio_tip2"),
			onYes = function()
				OpenDetailSetting()
			end
		})
	end
end

return var0
