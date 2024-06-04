local var0 = class("BackYardSettlementLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "BackYardStatisticsUI"
end

function var0.setShipVOs(arg0, arg1, arg2)
	arg0.oldShipVOs = arg1
	arg0.newShipVOs = arg2
end

function var0.setDormVO(arg0, arg1)
	arg0.dormVO = arg1
end

function var0.init(arg0)
	arg0.frame = arg0:findTF("frame")
	arg0.painting = arg0:findTF("painting")
	arg0.confirmBtn = arg0:findTF("painting/confirm_btn")
	arg0.timeTF = arg0:findTF("ship_word/text_contain1")
	arg0.expTF = arg0:findTF("ship_word/text_contain2")
	arg0.emptyTF = arg0:findTF("ship_word/Text")
	arg0.uilist = UIItemList.New(arg0:findTF("container", arg0.frame), arg0:findTF("container/ship_tpl", arg0.frame))
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.BASE_LAYER
	})
	onButton(arg0, arg0.confirmBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)

	arg0.cards = {}

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0.cards[arg1] = BackYardSettlementCard.New(arg2)
		end
	end)

	local var0, var1 = arg0:UpdateShips()

	arg0:InitPainting(var0, var1)
end

function var0.InitPainting(arg0, arg1, arg2)
	setPaintingPrefabAsync(arg0.painting, arg1:getPainting(), "jiesuan")
	setActive(arg0.timeTF, arg0.dormVO.food ~= 0)
	setActive(arg0.expTF, arg0.dormVO.food ~= 0)
	setActive(arg0.emptyTF, arg0.dormVO.food == 0)

	if arg0.dormVO.food == 0 then
		setText(arg0.emptyTF, i18n("backyard_backyardGranaryLayer_noFood"))
	else
		local var0 = pg.TimeMgr.GetInstance():GetServerTime() - arg0.dormVO.load_time
		local var1 = i18n("backyard_addExp_Info", pg.TimeMgr.GetInstance():DescCDTime(var0), arg0.dormVO.load_food, arg2)
		local var2 = string.split(var1, "||")

		assert(#var2 > 0, "gametip ==> backyard_addExp_Info 必须用||分开")

		local var3 = arg0:findTF("ship_word/text_contain1")
		local var4 = 0

		while var4 < var3.childCount do
			setText(var3:GetChild(var4), var2[var4 + 1])

			var4 = var4 + 1
		end

		local var5 = arg0:findTF("ship_word/text_contain2")
		local var6 = 0

		while var6 < var5.childCount do
			setText(var5:GetChild(var6), var2[var4 + 1])

			var4 = var4 + 1
			var6 = var6 + 1
		end
	end
end

function var0.UpdateShips(arg0)
	local var0 = {}
	local var1 = 0

	for iter0, iter1 in pairs(arg0.newShipVOs) do
		table.insert(var0, iter0)

		local var2 = arg0.oldShipVOs[iter0]

		if var2.level ~= var2:getMaxLevel() then
			var1 = var1 + 1
		end
	end

	arg0.uilist:align(#var0)

	local var3 = arg0.dormVO.load_exp
	local var4 = {}

	for iter2, iter3 in pairs(arg0.cards) do
		table.insert(var4, function(arg0)
			if arg0.exited then
				return
			end

			local var0 = var0[iter2 + 1]

			iter3:Update(var3, arg0.oldShipVOs[var0], arg0.newShipVOs[var0])
			onNextTick(arg0)
		end)
	end

	seriesAsync(var4)

	return arg0.newShipVOs[var0[1]], var1 * var3
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)

	for iter0, iter1 in ipairs(arg0.cards) do
		iter1:Dispose()
	end
end

return var0
