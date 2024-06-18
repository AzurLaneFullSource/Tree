local var0_0 = class("NewProbabilitySkinShopView", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ProbabilitySkinShopItem"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.purchaseBtn = arg0_2:findTF("frame")
	arg0_2.tipTxt = arg0_2:findTF("tip/Text"):GetComponent(typeof(Text))
	arg0_2.icon = arg0_2:findTF("frame/icon/Image"):GetComponent(typeof(Image))
	arg0_2.tag = arg0_2:findTF("frame/icon/tag"):GetComponent(typeof(Image))
	arg0_2.nameTxt = arg0_2:findTF("frame/name/Text"):GetComponent(typeof(Text))
	arg0_2.priceTxt = arg0_2:findTF("frame/price"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0_2.limitTxt = arg0_2:findTF("frame/count"):GetComponent(typeof(Text))
	arg0_2.uiList = UIItemList.New(arg0_2:findTF("frame/awards"), arg0_2:findTF("frame/awards/award"))

	arg0_2._tf:SetSiblingIndex(2)
end

function var0_0.Show(arg0_3, arg1_3)
	var0_0.super.Show(arg0_3)
	arg0_3:UpdateCommodity(arg1_3)
	arg0_3:UpdateTip()
end

function var0_0.Flush(arg0_4, arg1_4)
	arg0_4:UpdateCommodity(arg1_4)
end

local function var1_0(arg0_5)
	return ({
		"hot",
		"new_tag",
		"tuijian",
		"shuangbei_tag",
		"activity",
		"xianshi"
	})[arg0_5] or "hot"
end

local function var2_0(arg0_6, arg1_6)
	local var0_6 = arg1_6:getConfig("display")

	arg0_6.uiList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = var0_6[arg1_7 + 1]
			local var1_7 = {
				type = var0_7[1],
				id = var0_7[2],
				count = var0_7[3]
			}

			updateDrop(arg2_7, var1_7)
		end
	end)
	arg0_6.uiList:align(#var0_6)
end

function var0_0.UpdateCommodity(arg0_8, arg1_8)
	local var0_8 = arg1_8:getConfig("picture")

	arg0_8.icon.sprite = LoadSprite("ChargeIcon/" .. var0_8)

	arg0_8.icon:SetNativeSize()

	arg0_8.nameTxt.text = arg1_8:getConfig("name_display")
	arg0_8.priceTxt.text = "$" .. arg1_8:getConfig("money")
	arg0_8.limitTxt.text = arg1_8:GetLimitDesc()
	arg0_8.descTxt.text = arg1_8:getConfig("descrip")

	local var1_8 = arg1_8:getConfig("tag")

	arg0_8.tag.sprite = LoadSprite("chargeTag", var1_0(var1_8))

	arg0_8.tag:SetNativeSize()
	var2_0(arg0_8, arg1_8)
	onButton(arg0_8, arg0_8.purchaseBtn, function()
		if arg1_8:canPurchase() then
			arg0_8:OnCharge(arg1_8)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))
		end
	end, SFX_PANEL)
end

function var0_0.OnCharge(arg0_10, arg1_10)
	local var0_10 = arg1_10
	local var1_10 = underscore.map(var0_10:getConfig("extra_service_item"), function(arg0_11)
		return {
			type = arg0_11[1],
			id = arg0_11[2],
			count = arg0_11[3]
		}
	end)
	local var2_10 = var0_10:getConfig("gem") + var0_10:getConfig("extra_gem")

	if var2_10 > 0 then
		table.insert(var1_10, {
			id = 4,
			type = 1,
			count = var2_10
		})
	end

	local var3_10 = {
		isMonthCard = false,
		isChargeType = true,
		icon = "chargeicon/" .. var0_10:getConfig("picture"),
		name = var0_10:getConfig("name_display"),
		tipExtra = i18n("charge_title_getitem"),
		extraItems = var1_10,
		price = var0_10:getConfig("money"),
		isLocalPrice = var0_10:IsLocalPrice(),
		tagType = var0_10:getConfig("tag"),
		descExtra = var0_10:getConfig("descrip_extra"),
		limitArgs = var0_10:getConfig("limit_args"),
		onYes = function()
			if ChargeConst.isNeedSetBirth() then
				arg0_10:emit(NewProbabilitySkinShopMediator.OPEN_CHARGE_BIRTHDAY)
			else
				arg0_10:emit(NewProbabilitySkinShopMediator.CHARGE, var0_10.id)
			end
		end
	}

	arg0_10:emit(NewProbabilitySkinShopMediator.OPEN_CHARGE_ITEM_PANEL, var3_10)
end

function var0_0.UpdateTip(arg0_13)
	arg0_13.tipTxt.text = i18n("probabilityskinshop_tip")
end

function var0_0.OnDestroy(arg0_14)
	return
end

return var0_0
