local var0_0 = class("SnapshotSceneMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(SnapshotScene.SELECT_CHAR_PANEL, function(arg0_2)
		arg0_1:addSubLayers(Context.New({
			mediator = SnapshotSelectCharMediator,
			viewComponent = SnapshotSelectCharLayer
		}))
	end)
	arg0_1:bind(SnapshotScene.SHARE_PANEL, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(Context.New({
			mediator = SnapshotShareMediator,
			viewComponent = SnapshotShareLayer,
			data = {
				photoTex = arg1_3,
				photoData = arg2_3
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		SnapshotSelectCharMediator.SELECT_CHAR,
		PERMISSION_GRANTED,
		PERMISSION_REJECT,
		PERMISSION_NEVER_REMIND
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == SnapshotSelectCharMediator.SELECT_CHAR then
		if pg.ship_skin_template[var1_5] then
			local var2_5 = pg.ship_skin_template[var1_5].ship_group
			local var3_5 = getProxy(BayProxy):getGroupPropose(var2_5)

			arg0_5.viewComponent.contextData.propose = var3_5
		end

		arg0_5.viewComponent:setSkin(var1_5)
	elseif PERMISSION_GRANTED == var0_5 then
		if var1_5 == ANDROID_RECORD_AUDIO_PERMISSION then
			arg0_5.viewComponent:changeToTakeVideo()
		end
	elseif PERMISSION_REJECT == var0_5 then
		if var1_5 == ANDROID_RECORD_AUDIO_PERMISSION then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("apply_permission_record_audio_tip3"),
				onYes = function()
					ApplyPermission({
						ANDROID_RECORD_AUDIO_PERMISSION
					})
				end
			})
		end
	elseif PERMISSION_NEVER_REMIND and var1_5 == ANDROID_RECORD_AUDIO_PERMISSION then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("apply_permission_record_audio_tip2"),
			onYes = function()
				OpenDetailSetting()
			end
		})
	end
end

return var0_0
