local var0_0 = class("Dorm3dAccompanyLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dAccompanyWindow"
end

function var0_0.init(arg0_2)
	arg0_2.rtPanel = arg0_2._tf:Find("panel")

	onButton(arg0_2, arg0_2.rtPanel:Find("bg"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.rtPanel:Find("window/btn_close"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)

	arg0_2.richText = arg0_2.rtPanel:Find("window/Text"):GetComponent("RichText")

	arg0_2.richText:AddSprite("stamina", arg0_2._tf:Find("res/stamina"):GetComponent(typeof(Image)).sprite)
end

function var0_0.HideInvitePanel(arg0_5)
	arg0_5.selectIds = nil

	setActive(arg0_5.rtPanel, false)
end

function var0_0.didEnter(arg0_6)
	arg0_6.room = getProxy(ApartmentProxy):getRoom(arg0_6.contextData.roomId)

	local var0_6 = pg.dorm3d_accompany.get_id_list_by_ship_id[arg0_6.contextData.groupId]
	local var1_6 = arg0_6.rtPanel:Find("window/content")

	UIItemList.StaticAlign(var1_6, var1_6:GetChild(0), 3, function(arg0_7, arg1_7, arg2_7)
		arg1_7 = arg1_7 + 1

		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = var0_6[arg1_7]

			setActive(arg2_7:Find("empty"), not var0_7)
			setActive(arg2_7:Find("Image"), var0_7)

			if var0_7 then
				local var1_7 = pg.dorm3d_accompany[var0_7]
				local var2_7, var3_7 = ApartmentProxy.CheckUnlockConfig(var1_7.unlock)

				GetImageSpriteFromAtlasAsync("dorm3daccompany/" .. var1_7.image, "", arg2_7:Find("Image"))
				setGray(arg2_7:Find("Image"), not var2_7, false)
				setActive(arg2_7:Find("Image/mask"), not var2_7)
				onButton(arg0_6, arg2_7:Find("Image"), function()
					if var2_7 then
						arg0_6.contextData.confirmFunc(var0_7)
						arg0_6:closeView()
					else
						pg.TipsMgr.GetInstance():ShowTips(var3_7)
					end
				end, SFX_CONFIRM)
				setText(arg0_6.rtPanel:Find("window/Text"), i18n("dorm3d_collection_cost_tip"))
			else
				setText(arg2_7:Find("empty/Image/Text"), i18n("dorm3d_accompany_locked"))
			end
		end
	end)
end

function var0_0.willExit(arg0_9)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9.rtPanel, arg0_9.rtLayer)
end

return var0_0
