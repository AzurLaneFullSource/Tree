local var0_0 = class("Dorm3dRTRoleTouchSubView", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

function var0_0.Init(arg0_1)
	arg0_1.touchConfigs = {}
	arg0_1.uiList = UIItemList.New(arg0_1._tf, arg0_1._tf:Find("tpl"))

	arg0_1.uiList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			arg1_2 = arg1_2 + 1

			local var0_2 = arg0_1.touchConfigs[arg1_2]

			setText(arg2_2:Find("bg/Text"), var0_2.furnitureName and i18n("dorm3d_touch2", var0_2.furnitureName) or i18n("dorm3d_touch"))
			onButton(arg0_1, arg2_2, function()
				getProxy(Dorm3dChatProxy):TriggerEvent({
					{
						value = 1,
						event_type = arg0_1.contextData.timeIndex == 1 and 111 or 116,
						ship_id = arg0_1.cacheGroupId
					},
					{
						value = 1,
						event_type = 156,
						ship_id = arg0_1.cacheGroupId
					}
				})
				arg0_1.contextData.onClick(var0_2.touchId)
			end, SFX_DORM_CLICK)
		end
	end)
end

function var0_0.Flush(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4.touchConfigs = arg1_4:GetAllTouchIDByZone(arg3_4, arg2_4)
	arg0_4.cacheGroupId = arg2_4

	arg0_4.uiList:align(#arg0_4.touchConfigs)
end

return var0_0
