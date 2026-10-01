local var0_0 = class("SupportShipPoolPage", import("...base.BaseSubView"))

function var0_0.getResource(arg0_1)
	local var0_1 = {}
	local var1_1 = pg.gametip.honor_medal_support_tips_display.tip

	if var1_1 and noEmptyStr(var1_1.bg) then
		table.insert(var0_1, var1_1.bg)
	end

	local var2_1 = arg0_1.contextData and arg0_1.contextData.falgShip or getProxy(BayProxy):getShipById(getProxy(PlayerProxy):getData().character)

	if var2_1 then
		table.insertto(var0_1, ResPathSupport.GetPaintingListByPaintingName(var2_1:getPainting()))
	end

	return table.insertto(var0_1, var0_0.super.getResource(arg0_1))
end

function var0_0.getUIName(arg0_2)
	return "SupportShipPoolPageUI"
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.medalCount = arg0_3._tf:Find("gallery/res_items/medal")
	arg0_3.patingTF = arg0_3._tf:Find("painting")
	arg0_3.bg = arg0_3._tf:Find("gallery/bg")
	arg0_3.tipSTxt = arg0_3.bg:Find("type_intro/mask/title"):GetComponent("ScrollText")
	arg0_3.shopBtn = arg0_3._tf:Find("gallery/shop_btn")
	arg0_3.helpBtn = arg0_3._tf:Find("gallery/help_btn")
	arg0_3.startBtn = arg0_3._tf:Find("gallery/start_btn")
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.shopBtn, function()
		arg0_4:emit(BuildShipMediator.ON_SUPPORT_SHOP)
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_6)
	arg0_6:UpdateMedal()

	local var0_6 = getProxy(BuildShipProxy):getSupportShipCost()
	local var1_6 = pg.gametip.honor_medal_support_tips_display.tip

	setText(arg0_6._tf:Find("gallery/prints/intro/text"), var1_6.support_tip_consume)
	setImageSprite(arg0_6.bg, GetSpriteFromAtlas(var1_6.bg, ""))

	local var2_6 = var1_6.support_tip_ship

	arg0_6.tipSTxt:SetText(var2_6)

	local var3_6 = arg0_6._tf:Find("gallery/item_bg/medal")

	setText(var3_6:Find("name"), Drop.New({
		type = DROP_TYPE_ITEM,
		id = ITEM_ID_SILVER_HOOK
	}):getName())
	setText(var3_6:Find("count/Text"), var0_6)
	arg0_6:UpdateBuildPoolPaiting()
	onButton(arg0_6, arg0_6.helpBtn, function()
		arg0_6.contextData.helpWindow:ExecuteAction("Show", var1_6, "support")
	end, SFX_CANCEL)

	local var4_6 = getProxy(BagProxy)

	onButton(arg0_6, arg0_6.startBtn, function()
		local var0_8 = {
			buildType = "medal",
			itemVO = Item.New({
				id = ITEM_ID_SILVER_HOOK,
				count = var4_6:getItemCountById(ITEM_ID_SILVER_HOOK)
			}),
			cost = var0_6,
			max = MAX_BUILD_WORK_COUNT,
			onConfirm = function(arg0_9)
				arg0_6:emit(BuildShipMediator.ON_SUPPORT_EXCHANGE, arg0_9)
			end
		}

		arg0_6.contextData.msgbox:ExecuteAction("Show", var0_8)
	end, SFX_UI_BUILDING_STARTBUILDING)
end

function var0_0.UpdateMedal(arg0_10)
	setText(arg0_10.medalCount:Find("Text"), getProxy(BagProxy):getItemCountById(ITEM_ID_SILVER_HOOK))
end

function var0_0.UpdateBuildPoolPaiting(arg0_11)
	local var0_11 = arg0_11.contextData.falgShip:getPainting()

	if arg0_11.painting ~= var0_11 then
		pg.UIMgr.GetInstance():LoadingOn()
		setPaintingPrefabAsync(arg0_11.patingTF, var0_11, "build", function()
			arg0_11.painting = var0_11

			pg.UIMgr.GetInstance():LoadingOff()
		end)
	end
end

function var0_0.ShowOrHide(arg0_13, arg1_13)
	if arg1_13 then
		arg0_13:Show()
	else
		arg0_13:Hide()
	end
end

function var0_0.OnDestroy(arg0_14)
	return
end

return var0_0
