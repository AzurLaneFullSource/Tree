local var0_0 = class("RefluxSignView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "RefluxSignUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:updateUI()
	arg0_2:tryAutoSign()
end

function var0_0.OnDestroy(arg0_3)
	return
end

function var0_0.OnBackPress(arg0_4)
	arg0_4:Hide()
end

function var0_0.initData(arg0_5)
	arg0_5.refluxProxy = getProxy(RefluxProxy)
	arg0_5.dayAwardList = arg0_5:getAllAwardList()
	arg0_5.totalSignCount = #pg.return_sign_template.all
end

function var0_0.initUI(arg0_6)
	local var0_6 = arg0_6:findTF("DayImg")

	arg0_6.daySpriteList = {}

	for iter0_6 = 0, arg0_6.totalSignCount - 1 do
		local var1_6 = var0_6:GetChild(iter0_6)
		local var2_6 = getImageSprite(var1_6)

		table.insert(arg0_6.daySpriteList, var2_6)
	end

	arg0_6.dayTpl = arg0_6:findTF("DayTpl")
	arg0_6.scrollRectTF = arg0_6:findTF("ScrollRect")
	arg0_6.dayContainerTF = arg0_6:findTF("ScrollRect/Container")
	arg0_6.signCountText = arg0_6:findTF("DayCount/Text")
	arg0_6.dayUIItemList = UIItemList.New(arg0_6.dayContainerTF, arg0_6.dayTpl)

	arg0_6.dayUIItemList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg0_6:findTF("Item1/Icon", arg2_7)
			local var1_7 = arg0_6:findTF("Item2/Icon", arg2_7)
			local var2_7 = arg0_6:findTF("Item3/Icon", arg2_7)
			local var3_7 = arg0_6:findTF("DayImg", arg2_7)
			local var4_7 = arg0_6:findTF("Got", arg2_7)
			local var5_7 = arg0_6:findTF("GotMask", arg2_7)
			local var6_7 = {
				var0_7,
				var1_7,
				var2_7
			}

			arg1_7 = arg1_7 + 1

			local var7_7 = arg0_6.dayAwardList[arg1_7]

			for iter0_7, iter1_7 in ipairs(var6_7) do
				local var8_7 = var7_7[iter0_7]

				if var8_7.type ~= DROP_TYPE_SHIP then
					setImageSprite(iter1_7, LoadSprite(var8_7:getIcon()))
				else
					local var9_7 = Ship.New({
						configId = var8_7.id
					}):getPainting()

					setImageSprite(iter1_7, LoadSprite("QIcon/" .. var9_7))
				end
			end

			local var10_7 = arg1_7 <= arg0_6.refluxProxy.signCount

			setActive(var4_7, var10_7)
			setActive(var5_7, var10_7)
			setImageSprite(var3_7, arg0_6.daySpriteList[arg1_7])
		end
	end)

	arg0_6.scrollSC = arg0_6.scrollRectTF:GetComponent(typeof(ScrollRect))
	arg0_6.hlgSC = arg0_6.dayContainerTF:GetComponent(typeof(HorizontalLayoutGroup))
	arg0_6.hlgLeft = arg0_6.hlgSC.padding.left
	arg0_6.hlgSpacing = arg0_6.hlgSC.spacing
	arg0_6.tplWidth = arg0_6.dayTpl:GetComponent(typeof(LayoutElement)).preferredWidth
end

function var0_0.updateUI(arg0_8)
	setText(arg0_8.signCountText, arg0_8.refluxProxy.signCount)
	arg0_8.dayUIItemList:align(arg0_8.totalSignCount)
	arg0_8:autoScroll(arg0_8.refluxProxy.signCount)
end

function var0_0.updateOutline(arg0_9)
	return
end

function var0_0.getAllAwardList(arg0_10)
	local var0_10 = {}
	local var1_10 = arg0_10.refluxProxy.returnLV

	for iter0_10, iter1_10 in ipairs(pg.return_sign_template.all) do
		local var2_10 = pg.return_sign_template[iter1_10]
		local var3_10 = var2_10.level
		local var4_10 = var2_10.award_display
		local var5_10 = arg0_10:getLevelIndex(var1_10, var3_10)
		local var6_10 = {}
		local var7_10 = var4_10[var5_10]

		for iter2_10, iter3_10 in ipairs(var7_10) do
			local var8_10 = Drop.Create(iter3_10)

			table.insert(var6_10, var8_10)
		end

		table.insert(var0_10, var6_10)
	end

	return var0_10
end

function var0_0.getLevelIndex(arg0_11, arg1_11, arg2_11)
	for iter0_11, iter1_11 in ipairs(arg2_11) do
		local var0_11 = iter1_11[1]
		local var1_11 = iter1_11[2]

		if var0_11 <= arg1_11 and arg1_11 <= var1_11 then
			return iter0_11
		end
	end
end

function var0_0.tryAutoSign(arg0_12)
	if arg0_12.refluxProxy:isCanSign() then
		pg.m02:sendNotification(GAME.REFLUX_SIGN)
	end
end

function var0_0.autoScroll(arg0_13, arg1_13)
	local var0_13 = arg0_13.dayContainerTF.childCount
	local var1_13 = 0
	local var2_13 = arg1_13 == 1 and 0 or arg1_13 == arg0_13.dayContainerTF.childCount and 1 or arg1_13 / var0_13

	arg0_13.scrollSC.horizontalNormalizedPosition = math.clamp(var2_13, 0, 1)
end

return var0_0
