local var0_0 = class("NewBackYardShipInfoLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewBackYardShipInfoUI"
end

function var0_0.init(arg0_2)
	arg0_2.descTxt = arg0_2:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0_2.counterTxt = arg0_2:findTF("frame/top/value/Text"):GetComponent(typeof(Text))
	arg0_2.cardContainer = arg0_2:findTF("frame/panel")
	arg0_2.closeBtn = arg0_2:findTF("frame/top/close")
	arg0_2.mainPanel = arg0_2:findTF("frame")
	arg0_2.toggles = {
		[Ship.STATE_REST] = arg0_2:findTF("frame/top/rest"),
		[Ship.STATE_TRAIN] = arg0_2:findTF("frame/top/train")
	}
	arg0_2.animations = {
		[Ship.STATE_REST] = arg0_2:findTF("frame/top/rest"):GetComponent(typeof(Animation)),
		[Ship.STATE_TRAIN] = arg0_2:findTF("frame/top/train"):GetComponent(typeof(Animation))
	}
	arg0_2.animationName = {
		[Ship.STATE_REST] = {
			"anim_backyard_shipinfo_rest_Select",
			"anim_backyard_shipinfo_rest_unSelect"
		},
		[Ship.STATE_TRAIN] = {
			"anim_backyard_shipinfo_train_Select",
			"anim_backyard_shipinfo_train_unSelect"
		}
	}
	arg0_2.addShipTpl = arg0_2.cardContainer:Find("AddShipTpl")
	arg0_2.extendShipTpl = arg0_2.cardContainer:Find("ExtendShipTpl")
	arg0_2.shipCardTpl = arg0_2.cardContainer:Find("ShipCardTpl")
	arg0_2.cards = {
		{},
		{},
		{}
	}

	table.insert(arg0_2.cards[1], BackYardShipCard.New(arg0_2.shipCardTpl, arg0_2.event))
	table.insert(arg0_2.cards[2], BackYardEmptyCard.New(arg0_2.addShipTpl, arg0_2.event))
	table.insert(arg0_2.cards[3], BackYardExtendCard.New(arg0_2.extendShipTpl, arg0_2.event))
	setText(arg0_2:findTF("frame/desc1"), i18n("backyard_longpress_ship_tip"))
	setText(arg0_2:findTF("frame/top/rest/Text"), i18n("courtyard_label_rest"))
	setText(arg0_2:findTF("frame/top/train/Text"), i18n("courtyard_label_train"))
	setText(arg0_2:findTF("frame/top/rest/Text_un"), i18n("courtyard_label_rest"))
	setText(arg0_2:findTF("frame/top/train/Text_un"), i18n("courtyard_label_train"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)

	local var0_3 = Color.New(0.2235294, 0.227451, 0.2352941, 1)
	local var1_3 = Color.New(0.5137255, 0.5137255, 0.5137255, 1)

	for iter0_3, iter1_3 in pairs(arg0_3.toggles) do
		onToggle(arg0_3, iter1_3, function(arg0_6)
			if arg0_6 then
				arg0_3:SwitchToPage(iter0_3)
			end

			iter1_3:Find("icon"):GetComponent(typeof(Image)).color = arg0_6 and var0_3 or var1_3

			local var0_6 = arg0_3.animations[iter0_3]
			local var1_6 = arg0_3.animationName[iter0_3]
			local var2_6 = arg0_6 and 1 or 2

			var0_6:Play(var1_6[var2_6])
			print(var1_6[var2_6])
		end, SFX_PANEL)
	end

	local var2_3 = getProxy(DormProxy):getRawData()

	setActive(arg0_3.toggles[2], var2_3:isUnlockFloor(2))
	onNextTick(function()
		if arg0_3.exited then
			return
		end

		local var0_7 = arg0_3.contextData.type or Ship.STATE_TRAIN
		local var1_7 = {
			Ship.STATE_TRAIN,
			Ship.STATE_REST
		}

		for iter0_7, iter1_7 in ipairs(var1_7) do
			triggerToggle(arg0_3.toggles[iter1_7], iter1_7 == var0_7)
		end
	end)
end

function var0_0.GetCardTypeCnt(arg0_8, arg1_8)
	local var0_8 = getProxy(DormProxy):getRawData()
	local var1_8 = 0
	local var2_8 = 0
	local var3_8 = 0

	if arg1_8 == Ship.STATE_TRAIN then
		var1_8 = var0_8.exp_pos
		var2_8 = var0_8:getConfig("training_ship_number")
	elseif arg1_8 == Ship.STATE_REST then
		var1_8 = var0_8.rest_pos
		var2_8 = var0_8:getConfig("fix_ship_number")
	end

	local var4_8 = var0_8:GetStateShipCnt(arg1_8)
	local var5_8 = var1_8 - var4_8
	local var6_8 = var2_8 - var1_8

	return {
		var4_8,
		var5_8,
		var6_8
	}
end

function var0_0.SwitchToPage(arg0_9, arg1_9)
	if arg0_9.type == arg1_9 then
		return
	end

	arg0_9.type = arg1_9

	arg0_9:UpdateSlots()

	if arg1_9 == Ship.STATE_TRAIN then
		arg0_9.descTxt.text = i18n("backyard_traning_tip")
	elseif arg1_9 == Ship.STATE_REST then
		arg0_9.descTxt.text = i18n("backyard_rest_tip")
	end
end

function var0_0.UpdateSlots(arg0_10)
	local var0_10 = arg0_10.type
	local var1_10 = arg0_10:GetCardTypeCnt(var0_10)
	local var2_10 = getProxy(DormProxy):getRawData():GetStateShips(var0_10)
	local var3_10 = 0
	local var4_10 = {}

	for iter0_10, iter1_10 in ipairs(var1_10) do
		local var5_10 = arg0_10:GetTypeCards(iter0_10, iter1_10)

		for iter2_10, iter3_10 in ipairs(var5_10) do
			var3_10 = var3_10 + 1

			iter3_10:Flush(var0_10, var2_10[iter2_10])
			iter3_10:SetSiblingIndex(var3_10)
		end
	end

	arg0_10.counterTxt.text = var1_10[1] .. "/" .. var1_10[2] + var1_10[1]
end

function var0_0.GetTypeCards(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.cards[arg1_11]

	for iter0_11 = #var0_11, arg2_11 - 1 do
		table.insert(var0_11, var0_11[1]:Clone())
	end

	for iter1_11 = #var0_11, arg2_11 + 1, -1 do
		var0_11[iter1_11]:Disable()
	end

	local var1_11 = {}

	for iter2_11 = 1, arg2_11 do
		local var2_11 = var0_11[iter2_11]

		var2_11:Enable()

		var1_11[iter2_11] = var2_11
	end

	return var1_11
end

function var0_0.willExit(arg0_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.cards) do
		for iter2_12, iter3_12 in ipairs(iter1_12) do
			iter3_12:Dispose()
		end
	end
end

return var0_0
