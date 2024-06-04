local var0 = class("RefluxSignView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "RefluxSignUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:updateUI()
	arg0:tryAutoSign()
end

function var0.OnDestroy(arg0)
	return
end

function var0.OnBackPress(arg0)
	arg0:Hide()
end

function var0.initData(arg0)
	arg0.refluxProxy = getProxy(RefluxProxy)
	arg0.dayAwardList = arg0:getAllAwardList()
	arg0.totalSignCount = #pg.return_sign_template.all
end

function var0.initUI(arg0)
	local var0 = arg0:findTF("DayImg")

	arg0.daySpriteList = {}

	for iter0 = 0, arg0.totalSignCount - 1 do
		local var1 = var0:GetChild(iter0)
		local var2 = getImageSprite(var1)

		table.insert(arg0.daySpriteList, var2)
	end

	arg0.dayTpl = arg0:findTF("DayTpl")
	arg0.scrollRectTF = arg0:findTF("ScrollRect")
	arg0.dayContainerTF = arg0:findTF("ScrollRect/Container")
	arg0.signCountText = arg0:findTF("DayCount/Text")
	arg0.dayUIItemList = UIItemList.New(arg0.dayContainerTF, arg0.dayTpl)

	arg0.dayUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("Item1/Icon", arg2)
			local var1 = arg0:findTF("Item2/Icon", arg2)
			local var2 = arg0:findTF("Item3/Icon", arg2)
			local var3 = arg0:findTF("DayImg", arg2)
			local var4 = arg0:findTF("Got", arg2)
			local var5 = arg0:findTF("GotMask", arg2)
			local var6 = {
				var0,
				var1,
				var2
			}

			arg1 = arg1 + 1

			local var7 = arg0.dayAwardList[arg1]

			for iter0, iter1 in ipairs(var6) do
				local var8 = var7[iter0]

				if var8.type ~= DROP_TYPE_SHIP then
					setImageSprite(iter1, LoadSprite(var8:getIcon()))
				else
					local var9 = Ship.New({
						configId = var8.id
					}):getPainting()

					setImageSprite(iter1, LoadSprite("QIcon/" .. var9))
				end
			end

			local var10 = arg1 <= arg0.refluxProxy.signCount

			setActive(var4, var10)
			setActive(var5, var10)
			setImageSprite(var3, arg0.daySpriteList[arg1])
		end
	end)

	arg0.scrollSC = arg0.scrollRectTF:GetComponent(typeof(ScrollRect))
	arg0.hlgSC = arg0.dayContainerTF:GetComponent(typeof(HorizontalLayoutGroup))
	arg0.hlgLeft = arg0.hlgSC.padding.left
	arg0.hlgSpacing = arg0.hlgSC.spacing
	arg0.tplWidth = arg0.dayTpl:GetComponent(typeof(LayoutElement)).preferredWidth
end

function var0.updateUI(arg0)
	setText(arg0.signCountText, arg0.refluxProxy.signCount)
	arg0.dayUIItemList:align(arg0.totalSignCount)
	arg0:autoScroll(arg0.refluxProxy.signCount)
end

function var0.updateOutline(arg0)
	return
end

function var0.getAllAwardList(arg0)
	local var0 = {}
	local var1 = arg0.refluxProxy.returnLV

	for iter0, iter1 in ipairs(pg.return_sign_template.all) do
		local var2 = pg.return_sign_template[iter1]
		local var3 = var2.level
		local var4 = var2.award_display
		local var5 = arg0:getLevelIndex(var1, var3)
		local var6 = {}
		local var7 = var4[var5]

		for iter2, iter3 in ipairs(var7) do
			local var8 = Drop.Create(iter3)

			table.insert(var6, var8)
		end

		table.insert(var0, var6)
	end

	return var0
end

function var0.getLevelIndex(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2) do
		local var0 = iter1[1]
		local var1 = iter1[2]

		if var0 <= arg1 and arg1 <= var1 then
			return iter0
		end
	end
end

function var0.tryAutoSign(arg0)
	if arg0.refluxProxy:isCanSign() then
		pg.m02:sendNotification(GAME.REFLUX_SIGN)
	end
end

function var0.autoScroll(arg0, arg1)
	local var0 = arg0.dayContainerTF.childCount
	local var1 = 0
	local var2 = arg1 == 1 and 0 or arg1 == arg0.dayContainerTF.childCount and 1 or arg1 / var0

	arg0.scrollSC.horizontalNormalizedPosition = math.clamp(var2, 0, 1)
end

return var0
