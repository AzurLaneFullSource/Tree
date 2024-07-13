local var0_0 = class("SupportShipPoolPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SupportShipPoolPageUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.medalCount = arg0_2._tf:Find("gallery/res_items/medal")
	arg0_2.patingTF = arg0_2:findTF("painting")
	arg0_2.bg = arg0_2:findTF("gallery/bg")
	arg0_2.tipSTxt = arg0_2.bg:Find("type_intro/mask/title"):GetComponent("ScrollText")
	arg0_2.shopBtn = arg0_2._tf:Find("gallery/shop_btn")
	arg0_2.helpBtn = arg0_2:findTF("gallery/help_btn")
	arg0_2.startBtn = arg0_2:findTF("gallery/start_btn")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.shopBtn, function()
		arg0_3:emit(BuildShipMediator.ON_SUPPORT_SHOP)
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_5)
	arg0_5:UpdateMedal()

	local var0_5 = getProxy(BuildShipProxy):getSupportShipCost()
	local var1_5 = pg.gametip.honor_medal_support_tips_display.tip

	setText(arg0_5:findTF("gallery/prints/intro/text"), var1_5.support_tip_consume)
	setImageSprite(arg0_5.bg, GetSpriteFromAtlas(var1_5.bg, ""))

	local var2_5 = var1_5.support_tip_ship

	arg0_5.tipSTxt:SetText(var2_5)

	local var3_5 = arg0_5:findTF("gallery/item_bg/medal")

	setText(var3_5:Find("name"), Drop.New({
		type = DROP_TYPE_ITEM,
		id = ITEM_ID_SILVER_HOOK
	}):getName())
	setText(var3_5:Find("count/Text"), var0_5)
	arg0_5:UpdateBuildPoolPaiting()
	onButton(arg0_5, arg0_5.helpBtn, function()
		arg0_5.contextData.helpWindow:ExecuteAction("Show", var1_5, "support")
	end, SFX_CANCEL)

	local var4_5 = getProxy(BagProxy)

	onButton(arg0_5, arg0_5.startBtn, function()
		local var0_7 = {
			buildType = "medal",
			itemVO = Item.New({
				id = ITEM_ID_SILVER_HOOK,
				count = var4_5:getItemCountById(ITEM_ID_SILVER_HOOK)
			}),
			cost = var0_5,
			max = MAX_BUILD_WORK_COUNT,
			onConfirm = function(arg0_8)
				arg0_5:emit(BuildShipMediator.ON_SUPPORT_EXCHANGE, arg0_8)
			end
		}

		arg0_5.contextData.msgbox:ExecuteAction("Show", var0_7)
	end, SFX_UI_BUILDING_STARTBUILDING)
end

function var0_0.UpdateMedal(arg0_9)
	setText(arg0_9.medalCount:Find("Text"), getProxy(BagProxy):getItemCountById(ITEM_ID_SILVER_HOOK))
end

function var0_0.UpdateBuildPoolPaiting(arg0_10)
	local var0_10 = arg0_10.contextData.falgShip:getPainting()

	if arg0_10.painting ~= var0_10 then
		pg.UIMgr:GetInstance():LoadingOn()
		setPaintingPrefabAsync(arg0_10.patingTF, var0_10, "build", function()
			arg0_10.painting = var0_10

			pg.UIMgr:GetInstance():LoadingOff()
		end)
	end
end

function var0_0.ShowOrHide(arg0_12, arg1_12)
	if arg1_12 then
		arg0_12:Show()
	else
		arg0_12:Hide()
	end
end

function var0_0.OnDestroy(arg0_13)
	return
end

return var0_0
