local var0 = class("BobingPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
		setActive(findTF(arg0._tf, "bobing"), true)
		setActive(findTF(arg0._tf, "lottery"), false)
	else
		setActive(findTF(arg0._tf, "bobing"), false)
		setActive(findTF(arg0._tf, "lottery"), true)
	end

	arg0:bind(ActivityMediator.ON_BOBING_RESULT, function(arg0, arg1, arg2)
		if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
			arg0:displayBBResult(arg1.awards, arg1.numbers, function()
				arg1.callback()
			end)
		else
			arg0:displayLotteryAni(arg1.awards, arg1.numbers, function()
				arg1.callback()
			end)
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
		arg0:bobingUpdate()
	else
		arg0:lotteryUpdate()
	end
end

function var0.lotteryUpdate(arg0)
	local var0 = arg0.activity
	local var1 = findTF(arg0._tf, "lottery/layer")
	local var2 = arg0.lotteryWrap

	if not var2 then
		var2 = {
			btnLotteryBtn = findTF(var1, "lottery_btn"),
			phase = findTF(var1, "phase"),
			nums = findTF(var1, "nums")
		}
		arg0.lotteryWrap = var2
	end

	local var3 = var0:getConfig("config_id")

	if var3 <= var0.data1 then
		setActive(findTF(var2.phase, "bg"), false)
		setActive(findTF(var2.phase, "Text"), false)
		setActive(findTF(var2.phase, "finish"), true)
	else
		setActive(findTF(var2.phase, "bg"), true)
		setActive(findTF(var2.phase, "Text"), true)
		setText(findTF(var2.phase, "Text"), setColorStr(var0.data1, "FFD43F") .. "/" .. var3)
		setActive(findTF(var2.phase, "finish"), false)
	end

	if var0.data2 < 1 then
		LeanTween.alpha(var2.btnLotteryBtn, 1, 1):setLoopPingPong()
		setActive(findTF(var2.btnLotteryBtn, "mask"), false)
		onButton(arg0, var2.btnLotteryBtn, function()
			if arg0.activity.data2 < 1 then
				arg0:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = arg0.activity.id
				})
				arg0:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
			end
		end, SFX_PANEL)
	else
		LeanTween.cancel(var2.btnLotteryBtn.gameObject)
		setActive(findTF(var2.btnLotteryBtn, "mask"), true)

		local var4 = arg0:getIndexByNumbers(var0.data1_list)

		setActive(findTF(var2.btnLotteryBtn, "mask/1"), var4 == 1)
		setActive(findTF(var2.btnLotteryBtn, "mask/2"), var4 == 2)
		setActive(findTF(var2.btnLotteryBtn, "mask/3"), var4 == 3)
		onButton(arg0, var2.btnLotteryBtn, function()
			if arg0.activity.data2 < 1 then
				arg0:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = arg0.activity.id
				})
				arg0:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
			end
		end, SFX_PANEL)
	end

	local var5 = var0.data2 == 0 and "FFD43F" or "d2d4db"

	setText(findTF(var2.nums, "text"), string.format("<color=#%s>%s</color> / %s", var5, 1 - var0.data2, 1))
end

function var0.getIndexByNumbers(arg0, arg1)
	local var0 = ActivityConst.BBRule(arg1)
	local var1 = 3

	if var0 and var0 >= 1 and var0 <= 2 then
		var1 = 1
	end

	if var0 and var0 >= 3 and var0 <= 4 then
		var1 = 2
	end

	return var1
end

function var0.displayLotteryAni(arg0, arg1, arg2, arg3)
	local var0 = arg0:getIndexByNumbers(arg2)
	local var1 = findTF(arg0._tf, "lottery")
	local var2 = arg0:findTF("omikuji_anim", var1):GetComponent(typeof(DftAniEvent))

	var2:SetEndEvent(function(arg0)
		setActive(var2.gameObject, false)

		local var0 = arg0:findTF("omikuji_result", var1)

		setActive(var0, true)

		local var1 = arg0:findTF("title", var0)

		for iter0 = 1, var1.childCount do
			setActive(var1:GetChild(iter0 - 1), iter0 == var0)
		end

		local var2 = arg0:findTF("desc", var0)
		local var3 = {
			"big",
			"medium",
			"little"
		}
		local var4 = i18n("draw_" .. var3[var0] .. "_luck_" .. math.random(1, 3))

		setText(var2, var4)

		local var5 = arg0:findTF("award", var0)
		local var6 = arg0:findTF("award_list", var0)

		setActive(var5, false)
		removeAllChildren(var6)

		if arg1 then
			for iter1, iter2 in ipairs(arg1) do
				local var7 = cloneTplTo(var5, var6)
				local var8 = {
					type = iter2.type,
					id = iter2.id,
					count = iter2.count
				}

				updateDrop(var7, var8)
				onButton(arg0, var7, function()
					arg0:emit(BaseUI.ON_DROP, var8)
				end, SFX_PANEL)
			end
		end

		arg0:emit(ActivityMainScene.LOCK_ACT_MAIN, false)
		onButton(arg0, var0, function()
			setActive(var0, false)
			arg3()
		end)
	end)
	setActive(var2.gameObject, true)
end

function var0.bobingUpdate(arg0)
	local var0 = arg0.activity
	local var1 = findTF(arg0._tf, "bobing")
	local var2 = arg0.bobingWrap

	if not var2 then
		var2 = {
			bg = arg0:findTF("AD", arg0._tf),
			progress = arg0:findTF("award/nums", var1),
			get = arg0:findTF("award/get", var1),
			nums = arg0:findTF("nums/text", var1),
			bowlDisable = arg0:findTF("bowl_disable", var1),
			bowlEnable = arg0:findTF("bowl_enable", var1)
		}
		var2.bowlShine = arg0:findTF("bowl_shine", var2.bowlEnable)
		var2.btnRule = arg0:findTF("btnRule", var1)
		var2.layerRule = arg0:findTF("rule", var1)
		var2.btnReturn = arg0:findTF("btnReturn", var2.layerRule)
		var2.item = arg0:findTF("item", var2.layerRule)
		var2.top = arg0:findTF("top", var2.layerRule)
		var2.itemRow = arg0:findTF("row", var2.layerRule)
		var2.itemColumn = arg0:findTF("column", var2.layerRule)

		setActive(var2.layerRule, false)
		setActive(var2.item, false)
		setActive(var2.itemRow, false)
		setActive(var2.itemColumn, true)

		local var3 = pg.gameset.bb_front_awards.description
		local var4 = var3[1]
		local var5 = _.slice(var3, 2, #var3 - 1)
		local var6 = UIItemList.New(var2.top, var2.item)

		var6:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				local var0 = {
					type = var4[arg1 + 1][1],
					id = var4[arg1 + 1][2],
					count = var4[arg1 + 1][3]
				}

				updateDrop(arg2, var0)
				onButton(arg0, arg2, function()
					arg0:emit(BaseUI.ON_DROP, var0)
				end, SFX_PANEL)
			end
		end)
		var6:align(#var4)

		local var7 = UIItemList.New(var2.itemColumn, var2.itemRow)

		var7:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				local var0 = var5[arg1 + 1]
				local var1 = UIItemList.New(arg2, var2.item)

				var1:make(function(arg0, arg1, arg2)
					if arg0 == UIItemList.EventUpdate then
						local var0 = {
							type = var0[arg1 + 1][1],
							id = var0[arg1 + 1][2],
							count = var0[arg1 + 1][3]
						}

						updateDrop(arg2, var0)
						onButton(arg0, arg2, function()
							arg0:emit(BaseUI.ON_DROP, var0)
						end, SFX_PANEL)
					end
				end)
				var1:align(#var0)
			end
		end)
		var7:align(#var5)
		onButton(arg0, var2.btnRule, function()
			setActive(var2.layerRule, true)
		end, SFX_PANEL)
		onButton(arg0, var2.btnReturn, function()
			setActive(var2.layerRule, false)
		end, SFX_CANCEL)
		onButton(arg0, var2.bowlEnable, function()
			arg0:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
			arg0:displayBBAnim(function()
				arg0:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = var0.id
				})
			end)
		end, SFX_PANEL)

		arg0.bobingWrap = var2
	end

	local var8 = var0:getConfig("config_id")

	setActive(var2.layerRule, false)
	setActive(var2.get, var8 <= var0.data1)
	setActive(var2.bowlDisable, var0.data2 == 0)
	setActive(var2.bowlEnable, var0.data2 > 0)

	if var0.data2 < 1 then
		LeanTween.alpha(var2.bowlShine, 1, 1):setLoopPingPong()
	else
		LeanTween.cancel(var2.bowlShine.gameObject)
	end

	setText(var2.progress, string.format("<color=#%s>%s</color> %s", "FFD43F", math.min(var0.data1, var8) .. "/", var8))

	local var9 = var0.data2 == 0 and "FFD43F" or "d2d4db"

	setActive(var2.progress, var8 > var0.data1)
	setText(var2.nums, string.format("<color=#%s>%s</color>", var9, var0.data2))
end

function var0.displayBBAnim(arg0, arg1)
	local var0 = arg0:findTF("bobing/bb_anim")
	local var1 = arg0:findTF("ship", var0)
	local var2 = arg0:findTF("bowl", var0)

	if not arg0.animBowl then
		arg0.animBowl = var2:GetComponent(typeof(SpineAnimUI))

		arg0.animBowl:SetAction("bobing", 0)
		arg0.animBowl:SetActionCallBack(function(arg0)
			if arg0 == "finsih" then
				setActive(var1, false)
				setActive(var2, false)
				arg1()
			end
		end)
	end

	local function var3()
		setActive(var1, true)
		setActive(var2, true)
		arg0.model:GetComponent(typeof(SpineAnimUI)):SetAction("victory", 0)
	end

	if not arg0.model then
		local var4 = getProxy(PlayerProxy):getRawData()
		local var5 = getProxy(BayProxy):getShipById(var4.character)

		PoolMgr.GetInstance():GetSpineChar(var5:getPrefab(), false, function(arg0)
			arg0.model = arg0
			arg0.model.transform.localScale = Vector3(0.5, 0.5, 1)

			arg0.model.transform:SetParent(var1, false)
			var3()
		end)
	else
		var3()
	end

	setActive(var0, true)
end

function var0.displayBBResult(arg0, arg1, arg2, arg3)
	arg0.animation = findTF(arg0._tf, "bobing")

	setActive(arg0:findTF("bb_anim", arg0.animation), false)

	local var0 = arg0:findTF("bb_result", arg0.animation)
	local var1 = arg0:findTF("numbers", var0)
	local var2 = arg0:findTF("number", var0)
	local var3 = arg0:findTF("rank", var0)
	local var4 = arg0:findTF("bgRank", var0)

	setActive(var2, false)

	local var5 = arg0:findTF("award", var0)
	local var6 = arg0:findTF("award_list", var0)

	setActive(var5, false)
	removeAllChildren(var6)

	if arg1 then
		for iter0, iter1 in ipairs(arg1) do
			local var7 = cloneTplTo(var5, var6)
			local var8 = {
				type = iter1.type,
				id = iter1.id,
				count = iter1.count
			}

			updateDrop(var7, var8)
			onButton(arg0, var7, function()
				arg0:emit(BaseUI.ON_DROP, var8)
			end, SFX_PANEL)
		end
	end

	local var9 = UIItemList.New(var1, var2)

	var9:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:setSpriteTo("bobing/bb_icon/dice" .. arg2[arg1 + 1], arg2)
			setImageAlpha(arg2, 0)
		end
	end)
	var9:align(#arg2)

	local var10 = ActivityConst.BBRule(arg2)

	setActive(var3, var10 < 7)
	setActive(var4, var10 < 7)

	if var10 < 7 then
		arg0:setSpriteTo("bobing/bb_icon/rank" .. var10, var3)
		setImageAlpha(var3, 0)
	end

	local var11 = false
	local var12 = LeanTween.value(go(var1), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0)
		var9:each(function(arg0, arg1)
			setImageAlpha(arg1, arg0)
		end)
	end))

	if var10 == 7 then
		var12:setOnComplete(System.Action(function()
			arg0:emit(ActivityMainScene.LOCK_ACT_MAIN, false)

			var11 = true
		end))
	else
		LeanTween.value(go(var3), 0, 1, 0.2):setDelay(1):setOnUpdate(System.Action_float(function(arg0)
			setImageAlpha(var3, arg0)

			var3.localScale = Vector3.Lerp(Vector3(2, 2, 2), Vector3.one, arg0)
		end))

		local var13 = arg0:findTF("rank_p", var0) or cloneTplTo(var3, var0, "rank_p")

		arg0:setSpriteTo("bobing/bb_icon/rank" .. var10, var13)
		arg0:setSpriteTo("bobing/bb_icon/rank" .. var10, var3)
		LeanTween.value(go(var13), 1, 0, 0.3):setDelay(1.5):setOnUpdate(System.Action_float(function(arg0)
			setImageAlpha(var13, arg0)

			var13.localScale = Vector3.Lerp(Vector3(2, 2, 2), Vector3.one, arg0)
		end)):setOnComplete(System.Action(function()
			arg0:emit(ActivityMainScene.LOCK_ACT_MAIN, false)

			var11 = true
		end))
	end

	setActive(var0, true)
	onButton(arg0, var0, function()
		if var11 then
			setActive(var0, false)
			arg3()
		end
	end)
end

function var0.setSpriteTo(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetComponent(typeof(Image))

	var0.sprite = arg0:findTF(arg1):GetComponent(typeof(Image)).sprite

	if arg3 then
		var0:SetNativeSize()
	end
end

function var0.OnDestroy(arg0)
	if arg0.bobingWrap then
		clearImageSprite(arg0.bobingWrap.bg)
		LeanTween.cancel(arg0.bobingWrap.bowlShine.gameObject)
	end
end

return var0
