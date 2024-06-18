local var0_0 = class("BackYardFurnitureCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.group = arg0_1._tf:GetComponent(typeof(CanvasGroup))
	arg0_1.icon = findTF(arg0_1._tf, "icon"):GetComponent(typeof(Image))
	arg0_1.comfortableTF = findTF(arg0_1._tf, "comfortable")
	arg0_1.comfortable = findTF(arg0_1._tf, "comfortable"):GetComponent(typeof(Text))
	arg0_1.name = findTF(arg0_1._tf, "name"):GetComponent(typeof(Text))
	arg0_1.themeName = findTF(arg0_1._tf, "theme"):GetComponent(typeof(Text))
	arg0_1.desc = findTF(arg0_1._tf, "desc"):GetComponent(typeof(Text))
	arg0_1.resGold = findTF(arg0_1._tf, "res/gold")
	arg0_1.resGoldTxt = findTF(arg0_1._tf, "res/gold/Text"):GetComponent(typeof(Text))
	arg0_1.resGemTxt = findTF(arg0_1._tf, "res/gem/Text"):GetComponent(typeof(Text))
	arg0_1.resGem = findTF(arg0_1._tf, "res/gem")
	arg0_1.cantPurchase = findTF(arg0_1._tf, "res/unopen")
	arg0_1.countTxt = findTF(arg0_1._tf, "count"):GetComponent(typeof(Text))
	arg0_1.maskTF = findTF(arg0_1._tf, "mask")
	arg0_1.hotTF = findTF(arg0_1._tf, "hot")
	arg0_1.newTF = findTF(arg0_1._tf, "new")
	arg0_1.skinMark = findTF(arg0_1._tf, "skin_mark")
	arg0_1.maskUnOpen = findTF(arg0_1._tf, "mask1")
	arg0_1.countDownTm = findTF(arg0_1._tf, "time/Text"):GetComponent(typeof(Text))
	arg0_1.timerTr = findTF(arg0_1._tf, "time")

	setActive(arg0_1.timerTr, false)
end

function var0_0.Update(arg0_2, arg1_2)
	if arg0_2.group then
		arg0_2.group.alpha = 1
	end

	arg0_2.furniture = arg1_2

	local var0_2 = HXSet.hxLan(arg1_2:getConfig("name"))

	arg0_2.name.text = shortenString(var0_2, 9)
	arg0_2.themeName.text = shortenString(arg1_2:GetThemeName(), 7)
	arg0_2.desc.text = HXSet.hxLan(arg1_2:getConfig("describe"))
	arg0_2.comfortable.text = "+" .. arg1_2:getConfig("comfortable")

	GetSpriteFromAtlasAsync("furnitureicon/" .. arg1_2:getConfig("icon"), "", function(arg0_3)
		if IsNil(arg0_2.icon) then
			return
		end

		arg0_2.icon.sprite = arg0_3
	end)

	local var1_2 = arg1_2:getConfig("count")
	local var2_2 = var1_2 > 1 and arg1_2.count .. "/" .. var1_2 or ""

	arg0_2.countTxt.text = var2_2

	local var3_2 = arg1_2:canPurchaseByGem()

	setActive(arg0_2.resGem, var3_2)

	local var4_2 = arg1_2:canPurchaseByDormMoeny()

	setActive(arg0_2.resGold, var4_2)

	local var5_2 = arg1_2:canPurchase()

	if arg0_2.maskUnOpen then
		setActive(arg0_2.maskUnOpen, var5_2 and (not var3_2 and not var4_2 or not arg1_2:inTime()))
	end

	arg0_2.resGoldTxt.text = arg1_2:getPrice(PlayerConst.ResDormMoney)
	arg0_2.resGemTxt.text = arg1_2:getPrice(PlayerConst.ResDiamond)

	setActive(arg0_2.maskTF, not var5_2)

	local var6_2 = false

	setActive(arg0_2.hotTF, var6_2)

	local var7_2 = arg1_2:IsNew()

	setActive(arg0_2.newTF, var7_2 and var5_2)

	local var8_2, var9_2 = arg1_2:inTime()
	local var10_2 = arg1_2:isTimeLimit() and var8_2

	if var10_2 then
		arg0_2:UpdateCountdown(var9_2)
	else
		arg0_2:DestoryTimer()

		arg0_2.countDownTm.text = ""
	end

	setActive(arg0_2.timerTr, var10_2)
	arg0_2:UpdateSkinType()
end

function var0_0.UpdateSkinType(arg0_4)
	if IsNil(arg0_4.skinMark) then
		return
	end

	local var0_4 = Goods.FurnitureId2Id(arg0_4.furniture.id)
	local var1_4 = Goods.ExistFurniture(var0_4)

	setActive(arg0_4.skinMark, var1_4)
end

function var0_0.UpdateCountdown(arg0_5, arg1_5)
	local var0_5 = pg.TimeMgr.GetInstance()

	arg0_5:DestoryTimer()

	local var1_5 = var0_5:Table2ServerTime(arg1_5)

	arg0_5.prevStr = ""
	arg0_5.updateTimer = Timer.New(function()
		local var0_6 = ""
		local var1_6 = var0_5:GetServerTime()

		if var1_6 > var1_5 then
			arg0_5.countDownTm.text = ""

			setActive(arg0_5.timerTr, false)
			arg0_5:DestoryTimer()

			return
		end

		local var2_6 = var1_5 - var1_6

		var2_6 = var2_6 < 0 and 0 or var2_6

		local var3_6 = math.floor(var2_6 / 86400)

		if var3_6 > 0 then
			var0_6 = var3_6 .. i18n("word_date")
		else
			local var4_6 = math.floor(var2_6 / 3600)

			if var4_6 > 0 then
				var0_6 = var4_6 .. i18n("word_hour")
			else
				local var5_6 = math.floor(var2_6 / 60)

				if var5_6 > 0 then
					var0_6 = var5_6 .. i18n("word_minute")
				else
					var0_6 = var2_6 .. i18n("word_second")
				end
			end
		end

		if var0_6 ~= arg0_5.prevStr then
			arg0_5.prevStr = var0_6
			arg0_5.countDownTm.text = var0_6
		end
	end, 1, -1)

	arg0_5.updateTimer:Start()
	arg0_5.updateTimer.func()
end

function var0_0.DestoryTimer(arg0_7)
	if arg0_7.updateTimer then
		arg0_7.updateTimer:Stop()

		arg0_7.updateTimer = nil
	end
end

function var0_0.Clear(arg0_8)
	arg0_8:DestoryTimer()
end

return var0_0
