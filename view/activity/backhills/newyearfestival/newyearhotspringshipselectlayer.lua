local var0_0 = class("NewYearHotSpringShipSelectLayer", import("view.base.BaseUI"))
local var1_0 = import(".NewYearHotSpringFormationCard")

function var0_0.getUIName(arg0_1)
	return "NewYearHotSpringShipSelectUI"
end

function var0_0.init(arg0_2)
	arg0_2.counterTxt = arg0_2:findTF("frame/top/value/Text"):GetComponent(typeof(Text))
	arg0_2.cardContainer = arg0_2:findTF("frame/panel")
	arg0_2.mainPanel = arg0_2:findTF("frame")
	arg0_2.addShipTpl = arg0_2.cardContainer:Find("AddShipTpl")
	arg0_2.extendShipTpl = arg0_2.cardContainer:Find("ExtendShipTpl")
	arg0_2.shipCardTpl = arg0_2.cardContainer:Find("ShipCardTpl")

	setActive(arg0_2.addShipTpl, false)
	setActive(arg0_2.extendShipTpl, false)
	setActive(arg0_2.shipCardTpl, false)

	arg0_2.cardContainer = arg0_2.cardContainer:Find("Scroll View/Content")
	arg0_2.shipCards = {}

	setText(arg0_2:findTF("frame/desc"), i18n("hotspring_tip1"))
end

function var0_0.SetActivity(arg0_3, arg1_3)
	arg0_3.activity = arg1_3
end

function var0_0.didEnter(arg0_4)
	arg0_4._tf:Find("BG"):SetSiblingIndex(0)
	onButton(arg0_4, arg0_4._tf:Find("BG"), function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)

	local function var0_4(arg0_6)
		setActive(arg0_4:findTF("frame/panel/ArrowRight"), arg0_6.x < 0.01)
		setActive(arg0_4:findTF("frame/panel/ArrowLeft"), arg0_6.x > 0.99)
	end

	onScroll(arg0_4, arg0_4.cardContainer.parent, var0_4)
	var0_4({
		x = 0
	})
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf, false, {
		weight = LayerWeightConst.BASE_LAYER
	})
	arg0_4:UpdateSlots()
end

function var0_0.UpdateSlots(arg0_7)
	local var0_7 = arg0_7.activity
	local var1_7 = 0
	local var2_7 = 0

	arg0_7:CleanCards()
	_.each(_.range(1, var0_7:GetTotalSlotCount()), function(arg0_8)
		local var0_8 = var0_7:GetShipIds()[arg0_8] or 0
		local var1_8 = math.clamp(arg0_8 - var0_7:GetSlotCount(), 0, 2)
		local var2_8 = var0_8 > 0 and getProxy(BayProxy):RawGetShipById(var0_8)

		arg0_7:AddCard(arg0_8, var1_8, var2_8)

		var1_7 = var1_7 + (var1_8 == 0 and 1 or 0)
		var2_7 = var2_7 + (var2_8 and 1 or 0)
	end)

	arg0_7.counterTxt.text = var2_7 .. "/" .. var1_7
end

function var0_0.AddCard(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9

	if arg2_9 == 0 and arg3_9 then
		var0_9 = cloneTplTo(arg0_9.shipCardTpl, arg0_9.cardContainer)

		local var1_9 = var0_9:Find("content")
		local var2_9 = var1_0.New(go(var0_9))

		onButton(arg0_9, var1_9, function()
			arg0_9:emit(NewYearHotSpringShipSelectMediator.OPEN_CHUANWU, arg1_9, arg3_9)
		end, SFX_PANEL)

		local var3_9 = GetOrAddComponent(var1_9, typeof(UILongPressTrigger))

		var3_9.onLongPressed:RemoveAllListeners()
		var3_9.onLongPressed:AddListener(function()
			if not arg3_9 then
				return
			end

			arg0_9:emit(NewYearHotSpringShipSelectMediator.LOOG_PRESS_SHIP, arg1_9, arg3_9)
		end)
		var2_9:update(arg3_9)

		local var4_9 = arg3_9:getRecoverEnergyPoint() + arg0_9.activity:GetEnergyRecoverAddition()
		local var5_9 = 0

		if arg3_9.state == Ship.STATE_REST or arg3_9.state == Ship.STATE_TRAIN then
			if arg3_9.state == Ship.STATE_TRAIN then
				var4_9 = var4_9 + Ship.BACKYARD_1F_ENERGY_ADDITION
			elseif arg3_9.state == Ship.STATE_REST then
				var4_9 = var4_9 + Ship.BACKYARD_2F_ENERGY_ADDITION
			end

			for iter0_9, iter1_9 in ipairs(getProxy(ActivityProxy):getBackyardEnergyActivityBuffs()) do
				var5_9 = var5_9 + tonumber(iter1_9:getConfig("benefit_effect"))
			end
		end

		var2_9:updateProps1({
			{
				i18n("word_lv"),
				arg3_9.level
			},
			{
				i18n("word_nowenergy"),
				arg3_9.energy
			},
			{
				i18n("word_energy_recov_speed"),
				setColorStr(10 * var4_9, COLOR_GREEN) .. (var5_9 > 0 and setColorStr("+" .. 10 * var5_9, COLOR_GREEN) or "") .. "/h"
			}
		})
		setActive(var2_9.propsTr, false)
		setActive(var2_9.propsTr1, true)
		table.insert(arg0_9.shipCards, {
			info = var2_9,
			longpressedTigger = var3_9
		})
	else
		var0_9 = cloneTplTo(arg0_9.extendShipTpl, arg0_9.cardContainer)

		local var6_9 = var0_9:Find("content")

		setActive(var6_9:Find("label/add"), arg2_9 == 0)
		setActive(var6_9:Find("label/unlock"), arg2_9 == 1)
		setActive(var6_9:Find("label/lock"), arg2_9 == 2)
		setActive(var6_9:Find("mask"), arg2_9 == 2)

		if arg2_9 == 0 then
			onButton(arg0_9, var6_9, function()
				arg0_9:emit(NewYearHotSpringShipSelectMediator.OPEN_CHUANWU, arg1_9)
			end, SFX_PANEL)
		elseif arg2_9 == 1 then
			onButton(arg0_9, var6_9, function()
				arg0_9:emit(NewYearHotSpringShipSelectMediator.EXTEND, arg1_9)
			end, SFX_PANEL)
		elseif arg2_9 == 2 then
			-- block empty
		end
	end

	setActive(var0_9, true)
end

function var0_0.CleanCards(arg0_14)
	_.each(arg0_14.shipCards, function(arg0_15)
		arg0_15.longpressedTigger.onLongPressed:RemoveAllListeners()
		arg0_15.info:clear()
	end)

	arg0_14.shipCards = {}

	removeAllChildren(arg0_14.cardContainer)
end

function var0_0.willExit(arg0_16)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf)
	arg0_16:CleanCards()
end

return var0_0
