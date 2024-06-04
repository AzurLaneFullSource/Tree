local var0 = class("NewBackYardShipInfoLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "NewBackYardShipInfoUI"
end

function var0.init(arg0)
	arg0.descTxt = arg0:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0.counterTxt = arg0:findTF("frame/top/value/Text"):GetComponent(typeof(Text))
	arg0.cardContainer = arg0:findTF("frame/panel")
	arg0.closeBtn = arg0:findTF("frame/top/close")
	arg0.mainPanel = arg0:findTF("frame")
	arg0.toggles = {
		[Ship.STATE_REST] = arg0:findTF("frame/top/rest"),
		[Ship.STATE_TRAIN] = arg0:findTF("frame/top/train")
	}
	arg0.animations = {
		[Ship.STATE_REST] = arg0:findTF("frame/top/rest"):GetComponent(typeof(Animation)),
		[Ship.STATE_TRAIN] = arg0:findTF("frame/top/train"):GetComponent(typeof(Animation))
	}
	arg0.animationName = {
		[Ship.STATE_REST] = {
			"anim_backyard_shipinfo_rest_Select",
			"anim_backyard_shipinfo_rest_unSelect"
		},
		[Ship.STATE_TRAIN] = {
			"anim_backyard_shipinfo_train_Select",
			"anim_backyard_shipinfo_train_unSelect"
		}
	}
	arg0.addShipTpl = arg0.cardContainer:Find("AddShipTpl")
	arg0.extendShipTpl = arg0.cardContainer:Find("ExtendShipTpl")
	arg0.shipCardTpl = arg0.cardContainer:Find("ShipCardTpl")
	arg0.cards = {
		{},
		{},
		{}
	}

	table.insert(arg0.cards[1], BackYardShipCard.New(arg0.shipCardTpl, arg0.event))
	table.insert(arg0.cards[2], BackYardEmptyCard.New(arg0.addShipTpl, arg0.event))
	table.insert(arg0.cards[3], BackYardExtendCard.New(arg0.extendShipTpl, arg0.event))
	setText(arg0:findTF("frame/desc1"), i18n("backyard_longpress_ship_tip"))
	setText(arg0:findTF("frame/top/rest/Text"), i18n("courtyard_label_rest"))
	setText(arg0:findTF("frame/top/train/Text"), i18n("courtyard_label_train"))
	setText(arg0:findTF("frame/top/rest/Text_un"), i18n("courtyard_label_rest"))
	setText(arg0:findTF("frame/top/train/Text_un"), i18n("courtyard_label_train"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)

	local var0 = Color.New(0.2235294, 0.227451, 0.2352941, 1)
	local var1 = Color.New(0.5137255, 0.5137255, 0.5137255, 1)

	for iter0, iter1 in pairs(arg0.toggles) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				arg0:SwitchToPage(iter0)
			end

			iter1:Find("icon"):GetComponent(typeof(Image)).color = arg0 and var0 or var1

			local var0 = arg0.animations[iter0]
			local var1 = arg0.animationName[iter0]
			local var2 = arg0 and 1 or 2

			var0:Play(var1[var2])
			print(var1[var2])
		end, SFX_PANEL)
	end

	local var2 = getProxy(DormProxy):getRawData()

	setActive(arg0.toggles[2], var2:isUnlockFloor(2))
	onNextTick(function()
		if arg0.exited then
			return
		end

		local var0 = arg0.contextData.type or Ship.STATE_TRAIN
		local var1 = {
			Ship.STATE_TRAIN,
			Ship.STATE_REST
		}

		for iter0, iter1 in ipairs(var1) do
			triggerToggle(arg0.toggles[iter1], iter1 == var0)
		end
	end)
end

function var0.GetCardTypeCnt(arg0, arg1)
	local var0 = getProxy(DormProxy):getRawData()
	local var1 = 0
	local var2 = 0
	local var3 = 0

	if arg1 == Ship.STATE_TRAIN then
		var1 = var0.exp_pos
		var2 = var0:getConfig("training_ship_number")
	elseif arg1 == Ship.STATE_REST then
		var1 = var0.rest_pos
		var2 = var0:getConfig("fix_ship_number")
	end

	local var4 = var0:GetStateShipCnt(arg1)
	local var5 = var1 - var4
	local var6 = var2 - var1

	return {
		var4,
		var5,
		var6
	}
end

function var0.SwitchToPage(arg0, arg1)
	if arg0.type == arg1 then
		return
	end

	arg0.type = arg1

	arg0:UpdateSlots()

	if arg1 == Ship.STATE_TRAIN then
		arg0.descTxt.text = i18n("backyard_traning_tip")
	elseif arg1 == Ship.STATE_REST then
		arg0.descTxt.text = i18n("backyard_rest_tip")
	end
end

function var0.UpdateSlots(arg0)
	local var0 = arg0.type
	local var1 = arg0:GetCardTypeCnt(var0)
	local var2 = getProxy(DormProxy):getRawData():GetStateShips(var0)
	local var3 = 0
	local var4 = {}

	for iter0, iter1 in ipairs(var1) do
		local var5 = arg0:GetTypeCards(iter0, iter1)

		for iter2, iter3 in ipairs(var5) do
			var3 = var3 + 1

			iter3:Flush(var0, var2[iter2])
			iter3:SetSiblingIndex(var3)
		end
	end

	arg0.counterTxt.text = var1[1] .. "/" .. var1[2] + var1[1]
end

function var0.GetTypeCards(arg0, arg1, arg2)
	local var0 = arg0.cards[arg1]

	for iter0 = #var0, arg2 - 1 do
		table.insert(var0, var0[1]:Clone())
	end

	for iter1 = #var0, arg2 + 1, -1 do
		var0[iter1]:Disable()
	end

	local var1 = {}

	for iter2 = 1, arg2 do
		local var2 = var0[iter2]

		var2:Enable()

		var1[iter2] = var2
	end

	return var1
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.cards) do
		for iter2, iter3 in ipairs(iter1) do
			iter3:Dispose()
		end
	end
end

return var0
