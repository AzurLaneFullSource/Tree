local var0 = class("SelectDorm3DScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "SelectDorm3DUI"
end

function var0.init(arg0)
	onButton(arg0, arg0._tf:Find("btn_back"), function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.ids = pg.dorm3d_dorm_template.all
	arg0.blurPanel = arg0._tf:Find("BlurPanel")

	local var0 = arg0.blurPanel:Find("window/container")

	arg0.itemList = UIItemList.New(var0, var0:Find("tpl"))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.ids[arg1]

			setActive(arg2:Find("base"), var0)
			setActive(arg2:Find("empty"), not var0)

			if var0 then
				GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/%d_head", var0), "", arg2:Find("base/Image"))
				GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/%d_name", var0), "", arg2:Find("base/name"))

				local var1 = getProxy(ApartmentProxy):getApartment(var0)

				setText(arg2:Find("base/favor_level/Text"), var1 and var1.level or "?")
				onToggle(arg0, arg2:Find("base"), function(arg0)
					if arg0 and arg0.selectId ~= var0 then
						arg0:SetPage(var0)
					end
				end, SFX_PANEL)
				triggerToggle(arg2:Find("base"), arg1 == 1)
			else
				setText(arg2:Find("empty/Text"), i18n("dorm3d_waiting"))
				RemoveComponent(arg2, typeof(Toggle))
			end
		end
	end)
	setText(arg0._tf:Find("BlurPanel/window/bottom/daily/Text"), i18n("dorm3d_daily_favor"))

	arg0.textDic = {}
	arg0.btnGo = arg0._tf:Find("BlurPanel/window/bottom/btn_go")

	onButton(arg0, arg0.btnGo, function()
		if arg0.selectId ~= 20220 then
			return
		end

		arg0:emit(SelectDorm3DMediator.ON_DORM, arg0.selectId)
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.blurPanel, {
		pbList = {
			arg0.blurPanel:Find("window")
		}
	})
end

function var0.didEnter(arg0)
	local var0 = (math.floor(#arg0.ids / 3) + 1) * 3

	arg0.itemList:align(var0)
end

function var0.SetPage(arg0, arg1)
	arg0.selectId = arg1

	local var0 = arg0._tf:Find("Main/painting")

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/%d_painting", arg1), "", var0)

	local var1 = getProxy(ApartmentProxy):getApartment(arg1)
	local var2 = var1:getConfig("welcome_text")

	arg0.textDic[arg1] = arg0.textDic[arg1] or math.random(#var2)

	setText(var0:Find("talk/Text"), var2[arg0.textDic[arg1]])
	setText(arg0._tf:Find("BlurPanel/window/bottom/daily/count"), string.format("%d/%d", var1:getDailyFavor()))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.blurPanel, arg0._tf)
end

return var0
