local var0 = class("SupportShipPoolPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "SupportShipPoolPageUI"
end

function var0.OnLoaded(arg0)
	arg0.medalCount = arg0._tf:Find("gallery/res_items/medal")
	arg0.patingTF = arg0:findTF("painting")
	arg0.bg = arg0:findTF("gallery/bg")
	arg0.tipSTxt = arg0.bg:Find("type_intro/mask/title"):GetComponent("ScrollText")
	arg0.shopBtn = arg0._tf:Find("gallery/shop_btn")
	arg0.helpBtn = arg0:findTF("gallery/help_btn")
	arg0.startBtn = arg0:findTF("gallery/start_btn")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.shopBtn, function()
		arg0:emit(BuildShipMediator.ON_SUPPORT_SHOP)
	end, SFX_PANEL)
end

function var0.Flush(arg0)
	arg0:UpdateMedal()

	local var0 = getProxy(BuildShipProxy):getSupportShipCost()
	local var1 = pg.gametip.honor_medal_support_tips_display.tip

	setText(arg0:findTF("gallery/prints/intro/text"), var1.support_tip_consume)
	setImageSprite(arg0.bg, GetSpriteFromAtlas(var1.bg, ""))

	local var2 = var1.support_tip_ship

	arg0.tipSTxt:SetText(var2)

	local var3 = arg0:findTF("gallery/item_bg/medal")

	setText(var3:Find("name"), Drop.New({
		type = DROP_TYPE_ITEM,
		id = ITEM_ID_SILVER_HOOK
	}):getName())
	setText(var3:Find("count/Text"), var0)
	arg0:UpdateBuildPoolPaiting()
	onButton(arg0, arg0.helpBtn, function()
		arg0.contextData.helpWindow:ExecuteAction("Show", var1, "support")
	end, SFX_CANCEL)

	local var4 = getProxy(BagProxy)

	onButton(arg0, arg0.startBtn, function()
		local var0 = {
			buildType = "medal",
			itemVO = Item.New({
				id = ITEM_ID_SILVER_HOOK,
				count = var4:getItemCountById(ITEM_ID_SILVER_HOOK)
			}),
			cost = var0,
			max = MAX_BUILD_WORK_COUNT,
			onConfirm = function(arg0)
				arg0:emit(BuildShipMediator.ON_SUPPORT_EXCHANGE, arg0)
			end
		}

		arg0.contextData.msgbox:ExecuteAction("Show", var0)
	end, SFX_UI_BUILDING_STARTBUILDING)
end

function var0.UpdateMedal(arg0)
	setText(arg0.medalCount:Find("Text"), getProxy(BagProxy):getItemCountById(ITEM_ID_SILVER_HOOK))
end

function var0.UpdateBuildPoolPaiting(arg0)
	local var0 = arg0.contextData.falgShip:getPainting()

	if arg0.painting ~= var0 then
		pg.UIMgr:GetInstance():LoadingOn()
		setPaintingPrefabAsync(arg0.patingTF, var0, "build", function()
			arg0.painting = var0

			pg.UIMgr:GetInstance():LoadingOff()
		end)
	end
end

function var0.ShowOrHide(arg0, arg1)
	if arg1 then
		arg0:Show()
	else
		arg0:Hide()
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
