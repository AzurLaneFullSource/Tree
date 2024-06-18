local var0_0 = class("SelectDorm3DScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SelectDorm3DUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("btn_back"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)

	arg0_2.ids = pg.dorm3d_dorm_template.all
	arg0_2.blurPanel = arg0_2._tf:Find("BlurPanel")

	local var0_2 = arg0_2.blurPanel:Find("window/container")

	arg0_2.itemList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	arg0_2.itemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_2.ids[arg1_4]

			setActive(arg2_4:Find("base"), var0_4)
			setActive(arg2_4:Find("empty"), not var0_4)

			if var0_4 then
				GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/%d_head", var0_4), "", arg2_4:Find("base/Image"))
				GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/%d_name", var0_4), "", arg2_4:Find("base/name"))

				local var1_4 = getProxy(ApartmentProxy):getApartment(var0_4)

				setText(arg2_4:Find("base/favor_level/Text"), var1_4 and var1_4.level or "?")
				onToggle(arg0_2, arg2_4:Find("base"), function(arg0_5)
					if arg0_5 and arg0_2.selectId ~= var0_4 then
						arg0_2:SetPage(var0_4)
					end
				end, SFX_PANEL)
				triggerToggle(arg2_4:Find("base"), arg1_4 == 1)
			else
				setText(arg2_4:Find("empty/Text"), i18n("dorm3d_waiting"))
				RemoveComponent(arg2_4, typeof(Toggle))
			end
		end
	end)
	setText(arg0_2._tf:Find("BlurPanel/window/bottom/daily/Text"), i18n("dorm3d_daily_favor"))

	arg0_2.textDic = {}
	arg0_2.btnGo = arg0_2._tf:Find("BlurPanel/window/bottom/btn_go")

	onButton(arg0_2, arg0_2.btnGo, function()
		if arg0_2.selectId ~= 20220 then
			return
		end

		arg0_2:emit(SelectDorm3DMediator.ON_DORM, arg0_2.selectId)
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_2.blurPanel, {
		pbList = {
			arg0_2.blurPanel:Find("window")
		}
	})
end

function var0_0.didEnter(arg0_7)
	local var0_7 = (math.floor(#arg0_7.ids / 3) + 1) * 3

	arg0_7.itemList:align(var0_7)
end

function var0_0.SetPage(arg0_8, arg1_8)
	arg0_8.selectId = arg1_8

	local var0_8 = arg0_8._tf:Find("Main/painting")

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/%d_painting", arg1_8), "", var0_8)

	local var1_8 = getProxy(ApartmentProxy):getApartment(arg1_8)
	local var2_8 = var1_8:getConfig("welcome_text")

	arg0_8.textDic[arg1_8] = arg0_8.textDic[arg1_8] or math.random(#var2_8)

	setText(var0_8:Find("talk/Text"), var2_8[arg0_8.textDic[arg1_8]])
	setText(arg0_8._tf:Find("BlurPanel/window/bottom/daily/count"), string.format("%d/%d", var1_8:getDailyFavor()))
end

function var0_0.willExit(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9.blurPanel, arg0_9._tf)
end

return var0_0
