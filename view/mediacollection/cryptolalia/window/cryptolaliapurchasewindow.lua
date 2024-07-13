local var0_0 = class("CryptolaliaPurchaseWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CryptolaliaPurchaseWindowui"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.icon = arg0_2:findTF("window/cover/icon"):GetComponent(typeof(Image))
	arg0_2.signature = arg0_2:findTF("window/cover/signature"):GetComponent(typeof(Image))
	arg0_2.name = arg0_2:findTF("window/cover/name"):GetComponent(typeof(Text))
	arg0_2.shipname = arg0_2:findTF("window/cover/shipname"):GetComponent(typeof(Text))
	arg0_2.gemToggle = arg0_2:findTF("window/gem")
	arg0_2.ticketToggle = arg0_2:findTF("window/ticket")
	arg0_2.gemCntTxt = arg0_2.gemToggle:Find("Text"):GetComponent(typeof(Text))
	arg0_2.ticketCntTxt = arg0_2.ticketToggle:Find("Text"):GetComponent(typeof(Text))
	arg0_2.exchangeBtn = arg0_2:findTF("exchange")

	setText(arg0_2.gemToggle:Find("title"), i18n("cryptolalia_use_gem_title"))
	setText(arg0_2.ticketToggle:Find("title"), i18n("cryptolalia_use_ticket_title"))
	setText(arg0_2.exchangeBtn:Find("Text"), i18n("cryptolalia_exchange"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)

	arg0_3.costType = Cryptolalia.COST_TYPE_GEM

	onToggle(arg0_3, arg0_3.gemToggle, function(arg0_5)
		if arg0_5 then
			arg0_3.costType = Cryptolalia.COST_TYPE_GEM
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.ticketToggle, function(arg0_6)
		if arg0_6 then
			arg0_3.costType = Cryptolalia.COST_TYPE_TICKET
		end
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
	triggerToggle(arg0_7.gemToggle, true)

	arg0_7.name.text = arg1_7:GetName()
	arg0_7.shipname.text = arg1_7:GetShipName()

	local var0_7 = arg1_7:GetShipGroupId()

	LoadSpriteAtlasAsync("CryptolaliaShip/" .. var0_7, "cd", function(arg0_8)
		if arg0_7.exited then
			return
		end

		arg0_7.icon.sprite = arg0_8

		arg0_7.icon:SetNativeSize()
	end)
	onButton(arg0_7, arg0_7.exchangeBtn, function()
		if not arg0_7.costType then
			return
		end

		arg0_7:emit(CryptolaliaMediator.UNLOCK, arg1_7.id, arg0_7.costType)
	end, SFX_PANEL)

	local var1_7 = arg1_7:GetCost(Cryptolalia.COST_TYPE_GEM)
	local var2_7 = getProxy(PlayerProxy):getRawData()
	local var3_7 = var2_7:getResource(var1_7.id)
	local var4_7 = var3_7 < var1_7.count and COLOR_RED or COLOR_GREEN

	arg0_7.gemCntTxt.text = setColorStr(var3_7, var4_7) .. setColorStr("/" .. var1_7.count, "#AFAFAF")

	local var5_7 = arg1_7:GetCost(Cryptolalia.COST_TYPE_TICKET)
	local var6_7 = var2_7:getResource(var5_7.id)
	local var7_7 = var6_7 < var5_7.count and COLOR_RED or COLOR_GREEN

	arg0_7.ticketCntTxt.text = setColorStr(var6_7, var7_7) .. setColorStr("/" .. var5_7.count, "#AFAFAF")

	triggerToggle(arg0_7.ticketToggle, true)
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, arg0_10._parentTf)
end

function var0_0.OnDestroy(arg0_11)
	arg0_11.exited = true
end

return var0_0
