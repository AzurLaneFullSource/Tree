local var0_0 = class("BackYardSettlementLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BackYardStatisticsUI"
end

function var0_0.setShipVOs(arg0_2, arg1_2, arg2_2)
	arg0_2.oldShipVOs = arg1_2
	arg0_2.newShipVOs = arg2_2
end

function var0_0.setDormVO(arg0_3, arg1_3)
	arg0_3.dormVO = arg1_3
end

function var0_0.init(arg0_4)
	arg0_4.frame = arg0_4:findTF("frame")
	arg0_4.painting = arg0_4:findTF("painting")
	arg0_4.confirmBtn = arg0_4:findTF("painting/confirm_btn")
	arg0_4.timeTF = arg0_4:findTF("ship_word/text_contain1")
	arg0_4.expTF = arg0_4:findTF("ship_word/text_contain2")
	arg0_4.emptyTF = arg0_4:findTF("ship_word/Text")
	arg0_4.uilist = UIItemList.New(arg0_4:findTF("container", arg0_4.frame), arg0_4:findTF("container/ship_tpl", arg0_4.frame))
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf, false, {
		weight = LayerWeightConst.BASE_LAYER
	})
	onButton(arg0_5, arg0_5.confirmBtn, function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)

	arg0_5.cards = {}

	arg0_5.uilist:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_5.cards[arg1_7] = BackYardSettlementCard.New(arg2_7)
		end
	end)

	local var0_5, var1_5 = arg0_5:UpdateShips()

	arg0_5:InitPainting(var0_5, var1_5)
end

function var0_0.InitPainting(arg0_8, arg1_8, arg2_8)
	setPaintingPrefabAsync(arg0_8.painting, arg1_8:getPainting(), "jiesuan")
	setActive(arg0_8.timeTF, arg0_8.dormVO.food ~= 0)
	setActive(arg0_8.expTF, arg0_8.dormVO.food ~= 0)
	setActive(arg0_8.emptyTF, arg0_8.dormVO.food == 0)

	if arg0_8.dormVO.food == 0 then
		setText(arg0_8.emptyTF, i18n("backyard_backyardGranaryLayer_noFood"))
	else
		local var0_8 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_8.dormVO.load_time
		local var1_8 = i18n("backyard_addExp_Info", pg.TimeMgr.GetInstance():DescCDTime(var0_8), arg0_8.dormVO.load_food, arg2_8)
		local var2_8 = string.split(var1_8, "||")

		assert(#var2_8 > 0, "gametip ==> backyard_addExp_Info 必须用||分开")

		local var3_8 = arg0_8:findTF("ship_word/text_contain1")
		local var4_8 = 0

		while var4_8 < var3_8.childCount do
			setText(var3_8:GetChild(var4_8), var2_8[var4_8 + 1])

			var4_8 = var4_8 + 1
		end

		local var5_8 = arg0_8:findTF("ship_word/text_contain2")
		local var6_8 = 0

		while var6_8 < var5_8.childCount do
			setText(var5_8:GetChild(var6_8), var2_8[var4_8 + 1])

			var4_8 = var4_8 + 1
			var6_8 = var6_8 + 1
		end
	end
end

function var0_0.UpdateShips(arg0_9)
	local var0_9 = {}
	local var1_9 = 0

	for iter0_9, iter1_9 in pairs(arg0_9.newShipVOs) do
		table.insert(var0_9, iter0_9)

		local var2_9 = arg0_9.oldShipVOs[iter0_9]

		if var2_9.level ~= var2_9:getMaxLevel() then
			var1_9 = var1_9 + 1
		end
	end

	arg0_9.uilist:align(#var0_9)

	local var3_9 = arg0_9.dormVO.load_exp
	local var4_9 = {}

	for iter2_9, iter3_9 in pairs(arg0_9.cards) do
		table.insert(var4_9, function(arg0_10)
			if arg0_9.exited then
				return
			end

			local var0_10 = var0_9[iter2_9 + 1]

			iter3_9:Update(var3_9, arg0_9.oldShipVOs[var0_10], arg0_9.newShipVOs[var0_10])
			onNextTick(arg0_10)
		end)
	end

	seriesAsync(var4_9)

	return arg0_9.newShipVOs[var0_9[1]], var1_9 * var3_9
end

function var0_0.willExit(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, pg.UIMgr.GetInstance().UIMain)

	for iter0_11, iter1_11 in ipairs(arg0_11.cards) do
		iter1_11:Dispose()
	end
end

return var0_0
