local var0 = class("NewYearHotSpringShipSelectLayer", import("view.base.BaseUI"))
local var1 = import(".NewYearHotSpringFormationCard")

function var0.getUIName(arg0)
	return "NewYearHotSpringShipSelectUI"
end

function var0.init(arg0)
	arg0.counterTxt = arg0:findTF("frame/top/value/Text"):GetComponent(typeof(Text))
	arg0.cardContainer = arg0:findTF("frame/panel")
	arg0.mainPanel = arg0:findTF("frame")
	arg0.addShipTpl = arg0.cardContainer:Find("AddShipTpl")
	arg0.extendShipTpl = arg0.cardContainer:Find("ExtendShipTpl")
	arg0.shipCardTpl = arg0.cardContainer:Find("ShipCardTpl")

	setActive(arg0.addShipTpl, false)
	setActive(arg0.extendShipTpl, false)
	setActive(arg0.shipCardTpl, false)

	arg0.cardContainer = arg0.cardContainer:Find("Scroll View/Content")
	arg0.shipCards = {}

	setText(arg0:findTF("frame/desc"), i18n("hotspring_tip1"))
end

function var0.SetActivity(arg0, arg1)
	arg0.activity = arg1
end

function var0.didEnter(arg0)
	arg0._tf:Find("BG"):SetSiblingIndex(0)
	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)

	local function var0(arg0)
		setActive(arg0:findTF("frame/panel/ArrowRight"), arg0.x < 0.01)
		setActive(arg0:findTF("frame/panel/ArrowLeft"), arg0.x > 0.99)
	end

	onScroll(arg0, arg0.cardContainer.parent, var0)
	var0({
		x = 0
	})
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.BASE_LAYER
	})
	arg0:UpdateSlots()
end

function var0.UpdateSlots(arg0)
	local var0 = arg0.activity
	local var1 = 0
	local var2 = 0

	arg0:CleanCards()
	_.each(_.range(1, var0:GetTotalSlotCount()), function(arg0)
		local var0 = var0:GetShipIds()[arg0] or 0
		local var1 = math.clamp(arg0 - var0:GetSlotCount(), 0, 2)
		local var2 = var0 > 0 and getProxy(BayProxy):RawGetShipById(var0)

		arg0:AddCard(arg0, var1, var2)

		var1 = var1 + (var1 == 0 and 1 or 0)
		var2 = var2 + (var2 and 1 or 0)
	end)

	arg0.counterTxt.text = var2 .. "/" .. var1
end

function var0.AddCard(arg0, arg1, arg2, arg3)
	local var0

	if arg2 == 0 and arg3 then
		var0 = cloneTplTo(arg0.shipCardTpl, arg0.cardContainer)

		local var1 = var0:Find("content")
		local var2 = var1.New(go(var0))

		onButton(arg0, var1, function()
			arg0:emit(NewYearHotSpringShipSelectMediator.OPEN_CHUANWU, arg1, arg3)
		end, SFX_PANEL)

		local var3 = GetOrAddComponent(var1, typeof(UILongPressTrigger))

		var3.onLongPressed:RemoveAllListeners()
		var3.onLongPressed:AddListener(function()
			if not arg3 then
				return
			end

			arg0:emit(NewYearHotSpringShipSelectMediator.LOOG_PRESS_SHIP, arg1, arg3)
		end)
		var2:update(arg3)

		local var4 = arg3:getRecoverEnergyPoint() + arg0.activity:GetEnergyRecoverAddition()
		local var5 = 0

		if arg3.state == Ship.STATE_REST or arg3.state == Ship.STATE_TRAIN then
			if arg3.state == Ship.STATE_TRAIN then
				var4 = var4 + Ship.BACKYARD_1F_ENERGY_ADDITION
			elseif arg3.state == Ship.STATE_REST then
				var4 = var4 + Ship.BACKYARD_2F_ENERGY_ADDITION
			end

			for iter0, iter1 in ipairs(getProxy(ActivityProxy):getBackyardEnergyActivityBuffs()) do
				var5 = var5 + tonumber(iter1:getConfig("benefit_effect"))
			end
		end

		var2:updateProps1({
			{
				i18n("word_lv"),
				arg3.level
			},
			{
				i18n("word_nowenergy"),
				arg3.energy
			},
			{
				i18n("word_energy_recov_speed"),
				setColorStr(10 * var4, COLOR_GREEN) .. (var5 > 0 and setColorStr("+" .. 10 * var5, COLOR_GREEN) or "") .. "/h"
			}
		})
		setActive(var2.propsTr, false)
		setActive(var2.propsTr1, true)
		table.insert(arg0.shipCards, {
			info = var2,
			longpressedTigger = var3
		})
	else
		var0 = cloneTplTo(arg0.extendShipTpl, arg0.cardContainer)

		local var6 = var0:Find("content")

		setActive(var6:Find("label/add"), arg2 == 0)
		setActive(var6:Find("label/unlock"), arg2 == 1)
		setActive(var6:Find("label/lock"), arg2 == 2)
		setActive(var6:Find("mask"), arg2 == 2)

		if arg2 == 0 then
			onButton(arg0, var6, function()
				arg0:emit(NewYearHotSpringShipSelectMediator.OPEN_CHUANWU, arg1)
			end, SFX_PANEL)
		elseif arg2 == 1 then
			onButton(arg0, var6, function()
				arg0:emit(NewYearHotSpringShipSelectMediator.EXTEND, arg1)
			end, SFX_PANEL)
		elseif arg2 == 2 then
			-- block empty
		end
	end

	setActive(var0, true)
end

function var0.CleanCards(arg0)
	_.each(arg0.shipCards, function(arg0)
		arg0.longpressedTigger.onLongPressed:RemoveAllListeners()
		arg0.info:clear()
	end)

	arg0.shipCards = {}

	removeAllChildren(arg0.cardContainer)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0:CleanCards()
end

return var0
