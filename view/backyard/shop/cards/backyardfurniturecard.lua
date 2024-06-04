local var0 = class("BackYardFurnitureCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.group = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0.icon = findTF(arg0._tf, "icon"):GetComponent(typeof(Image))
	arg0.comfortableTF = findTF(arg0._tf, "comfortable")
	arg0.comfortable = findTF(arg0._tf, "comfortable"):GetComponent(typeof(Text))
	arg0.name = findTF(arg0._tf, "name"):GetComponent(typeof(Text))
	arg0.themeName = findTF(arg0._tf, "theme"):GetComponent(typeof(Text))
	arg0.desc = findTF(arg0._tf, "desc"):GetComponent(typeof(Text))
	arg0.resGold = findTF(arg0._tf, "res/gold")
	arg0.resGoldTxt = findTF(arg0._tf, "res/gold/Text"):GetComponent(typeof(Text))
	arg0.resGemTxt = findTF(arg0._tf, "res/gem/Text"):GetComponent(typeof(Text))
	arg0.resGem = findTF(arg0._tf, "res/gem")
	arg0.cantPurchase = findTF(arg0._tf, "res/unopen")
	arg0.countTxt = findTF(arg0._tf, "count"):GetComponent(typeof(Text))
	arg0.maskTF = findTF(arg0._tf, "mask")
	arg0.hotTF = findTF(arg0._tf, "hot")
	arg0.newTF = findTF(arg0._tf, "new")
	arg0.skinMark = findTF(arg0._tf, "skin_mark")
	arg0.maskUnOpen = findTF(arg0._tf, "mask1")
	arg0.countDownTm = findTF(arg0._tf, "time/Text"):GetComponent(typeof(Text))
	arg0.timerTr = findTF(arg0._tf, "time")

	setActive(arg0.timerTr, false)
end

function var0.Update(arg0, arg1)
	if arg0.group then
		arg0.group.alpha = 1
	end

	arg0.furniture = arg1

	local var0 = HXSet.hxLan(arg1:getConfig("name"))

	arg0.name.text = shortenString(var0, 9)
	arg0.themeName.text = shortenString(arg1:GetThemeName(), 7)
	arg0.desc.text = HXSet.hxLan(arg1:getConfig("describe"))
	arg0.comfortable.text = "+" .. arg1:getConfig("comfortable")

	GetSpriteFromAtlasAsync("furnitureicon/" .. arg1:getConfig("icon"), "", function(arg0)
		if IsNil(arg0.icon) then
			return
		end

		arg0.icon.sprite = arg0
	end)

	local var1 = arg1:getConfig("count")
	local var2 = var1 > 1 and arg1.count .. "/" .. var1 or ""

	arg0.countTxt.text = var2

	local var3 = arg1:canPurchaseByGem()

	setActive(arg0.resGem, var3)

	local var4 = arg1:canPurchaseByDormMoeny()

	setActive(arg0.resGold, var4)

	local var5 = arg1:canPurchase()

	if arg0.maskUnOpen then
		setActive(arg0.maskUnOpen, var5 and (not var3 and not var4 or not arg1:inTime()))
	end

	arg0.resGoldTxt.text = arg1:getPrice(PlayerConst.ResDormMoney)
	arg0.resGemTxt.text = arg1:getPrice(PlayerConst.ResDiamond)

	setActive(arg0.maskTF, not var5)

	local var6 = false

	setActive(arg0.hotTF, var6)

	local var7 = arg1:IsNew()

	setActive(arg0.newTF, var7 and var5)

	local var8, var9 = arg1:inTime()
	local var10 = arg1:isTimeLimit() and var8

	if var10 then
		arg0:UpdateCountdown(var9)
	else
		arg0:DestoryTimer()

		arg0.countDownTm.text = ""
	end

	setActive(arg0.timerTr, var10)
	arg0:UpdateSkinType()
end

function var0.UpdateSkinType(arg0)
	if IsNil(arg0.skinMark) then
		return
	end

	local var0 = Goods.FurnitureId2Id(arg0.furniture.id)
	local var1 = Goods.ExistFurniture(var0)

	setActive(arg0.skinMark, var1)
end

function var0.UpdateCountdown(arg0, arg1)
	local var0 = pg.TimeMgr.GetInstance()

	arg0:DestoryTimer()

	local var1 = var0:Table2ServerTime(arg1)

	arg0.prevStr = ""
	arg0.updateTimer = Timer.New(function()
		local var0 = ""
		local var1 = var0:GetServerTime()

		if var1 > var1 then
			arg0.countDownTm.text = ""

			setActive(arg0.timerTr, false)
			arg0:DestoryTimer()

			return
		end

		local var2 = var1 - var1

		var2 = var2 < 0 and 0 or var2

		local var3 = math.floor(var2 / 86400)

		if var3 > 0 then
			var0 = var3 .. i18n("word_date")
		else
			local var4 = math.floor(var2 / 3600)

			if var4 > 0 then
				var0 = var4 .. i18n("word_hour")
			else
				local var5 = math.floor(var2 / 60)

				if var5 > 0 then
					var0 = var5 .. i18n("word_minute")
				else
					var0 = var2 .. i18n("word_second")
				end
			end
		end

		if var0 ~= arg0.prevStr then
			arg0.prevStr = var0
			arg0.countDownTm.text = var0
		end
	end, 1, -1)

	arg0.updateTimer:Start()
	arg0.updateTimer.func()
end

function var0.DestoryTimer(arg0)
	if arg0.updateTimer then
		arg0.updateTimer:Stop()

		arg0.updateTimer = nil
	end
end

function var0.Clear(arg0)
	arg0:DestoryTimer()
end

return var0
