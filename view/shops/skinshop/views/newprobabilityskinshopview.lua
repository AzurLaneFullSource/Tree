local var0 = class("NewProbabilitySkinShopView", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "ProbabilitySkinShopItem"
end

function var0.OnLoaded(arg0)
	arg0.purchaseBtn = arg0:findTF("frame")
	arg0.tipTxt = arg0:findTF("tip/Text"):GetComponent(typeof(Text))
	arg0.icon = arg0:findTF("frame/icon/Image"):GetComponent(typeof(Image))
	arg0.tag = arg0:findTF("frame/icon/tag"):GetComponent(typeof(Image))
	arg0.nameTxt = arg0:findTF("frame/name/Text"):GetComponent(typeof(Text))
	arg0.priceTxt = arg0:findTF("frame/price"):GetComponent(typeof(Text))
	arg0.descTxt = arg0:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0.limitTxt = arg0:findTF("frame/count"):GetComponent(typeof(Text))
	arg0.uiList = UIItemList.New(arg0:findTF("frame/awards"), arg0:findTF("frame/awards/award"))

	arg0._tf:SetSiblingIndex(2)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0:UpdateCommodity(arg1)
	arg0:UpdateTip()
end

function var0.Flush(arg0, arg1)
	arg0:UpdateCommodity(arg1)
end

local function var1(arg0)
	return ({
		"hot",
		"new_tag",
		"tuijian",
		"shuangbei_tag",
		"activity",
		"xianshi"
	})[arg0] or "hot"
end

local function var2(arg0, arg1)
	local var0 = arg1:getConfig("display")

	arg0.uiList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
		end
	end)
	arg0.uiList:align(#var0)
end

function var0.UpdateCommodity(arg0, arg1)
	local var0 = arg1:getConfig("picture")

	arg0.icon.sprite = LoadSprite("ChargeIcon/" .. var0)

	arg0.icon:SetNativeSize()

	arg0.nameTxt.text = arg1:getConfig("name_display")
	arg0.priceTxt.text = "$" .. arg1:getConfig("money")
	arg0.limitTxt.text = arg1:GetLimitDesc()
	arg0.descTxt.text = arg1:getConfig("descrip")

	local var1 = arg1:getConfig("tag")

	arg0.tag.sprite = LoadSprite("chargeTag", var1(var1))

	arg0.tag:SetNativeSize()
	var2(arg0, arg1)
	onButton(arg0, arg0.purchaseBtn, function()
		if arg1:canPurchase() then
			arg0:OnCharge(arg1)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))
		end
	end, SFX_PANEL)
end

function var0.OnCharge(arg0, arg1)
	local var0 = arg1
	local var1 = underscore.map(var0:getConfig("extra_service_item"), function(arg0)
		return {
			type = arg0[1],
			id = arg0[2],
			count = arg0[3]
		}
	end)
	local var2 = var0:getConfig("gem") + var0:getConfig("extra_gem")

	if var2 > 0 then
		table.insert(var1, {
			id = 4,
			type = 1,
			count = var2
		})
	end

	local var3 = {
		isMonthCard = false,
		isChargeType = true,
		icon = "chargeicon/" .. var0:getConfig("picture"),
		name = var0:getConfig("name_display"),
		tipExtra = i18n("charge_title_getitem"),
		extraItems = var1,
		price = var0:getConfig("money"),
		isLocalPrice = var0:IsLocalPrice(),
		tagType = var0:getConfig("tag"),
		descExtra = var0:getConfig("descrip_extra"),
		limitArgs = var0:getConfig("limit_args"),
		onYes = function()
			if ChargeConst.isNeedSetBirth() then
				arg0:emit(NewProbabilitySkinShopMediator.OPEN_CHARGE_BIRTHDAY)
			else
				arg0:emit(NewProbabilitySkinShopMediator.CHARGE, var0.id)
			end
		end
	}

	arg0:emit(NewProbabilitySkinShopMediator.OPEN_CHARGE_ITEM_PANEL, var3)
end

function var0.UpdateTip(arg0)
	arg0.tipTxt.text = i18n("probabilityskinshop_tip")
end

function var0.OnDestroy(arg0)
	return
end

return var0
