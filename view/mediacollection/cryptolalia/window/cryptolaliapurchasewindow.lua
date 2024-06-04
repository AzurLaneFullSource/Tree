local var0 = class("CryptolaliaPurchaseWindow", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "CryptolaliaPurchaseWindowui"
end

function var0.OnLoaded(arg0)
	arg0.icon = arg0:findTF("window/cover/icon"):GetComponent(typeof(Image))
	arg0.signature = arg0:findTF("window/cover/signature"):GetComponent(typeof(Image))
	arg0.name = arg0:findTF("window/cover/name"):GetComponent(typeof(Text))
	arg0.shipname = arg0:findTF("window/cover/shipname"):GetComponent(typeof(Text))
	arg0.gemToggle = arg0:findTF("window/gem")
	arg0.ticketToggle = arg0:findTF("window/ticket")
	arg0.gemCntTxt = arg0.gemToggle:Find("Text"):GetComponent(typeof(Text))
	arg0.ticketCntTxt = arg0.ticketToggle:Find("Text"):GetComponent(typeof(Text))
	arg0.exchangeBtn = arg0:findTF("exchange")

	setText(arg0.gemToggle:Find("title"), i18n("cryptolalia_use_gem_title"))
	setText(arg0.ticketToggle:Find("title"), i18n("cryptolalia_use_ticket_title"))
	setText(arg0.exchangeBtn:Find("Text"), i18n("cryptolalia_exchange"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.costType = Cryptolalia.COST_TYPE_GEM

	onToggle(arg0, arg0.gemToggle, function(arg0)
		if arg0 then
			arg0.costType = Cryptolalia.COST_TYPE_GEM
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.ticketToggle, function(arg0)
		if arg0 then
			arg0.costType = Cryptolalia.COST_TYPE_TICKET
		end
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
	triggerToggle(arg0.gemToggle, true)

	arg0.name.text = arg1:GetName()
	arg0.shipname.text = arg1:GetShipName()

	local var0 = arg1:GetShipGroupId()

	LoadSpriteAtlasAsync("CryptolaliaShip/" .. var0, "cd", function(arg0)
		if arg0.exited then
			return
		end

		arg0.icon.sprite = arg0

		arg0.icon:SetNativeSize()
	end)
	onButton(arg0, arg0.exchangeBtn, function()
		if not arg0.costType then
			return
		end

		arg0:emit(CryptolaliaMediator.UNLOCK, arg1.id, arg0.costType)
	end, SFX_PANEL)

	local var1 = arg1:GetCost(Cryptolalia.COST_TYPE_GEM)
	local var2 = getProxy(PlayerProxy):getRawData()
	local var3 = var2:getResource(var1.id)
	local var4 = var3 < var1.count and COLOR_RED or COLOR_GREEN

	arg0.gemCntTxt.text = setColorStr(var3, var4) .. setColorStr("/" .. var1.count, "#AFAFAF")

	local var5 = arg1:GetCost(Cryptolalia.COST_TYPE_TICKET)
	local var6 = var2:getResource(var5.id)
	local var7 = var6 < var5.count and COLOR_RED or COLOR_GREEN

	arg0.ticketCntTxt.text = setColorStr(var6, var7) .. setColorStr("/" .. var5.count, "#AFAFAF")

	triggerToggle(arg0.ticketToggle, true)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	arg0.exited = true
end

return var0
