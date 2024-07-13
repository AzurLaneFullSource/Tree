local var0_0 = class("BobingPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
		setActive(findTF(arg0_1._tf, "bobing"), true)
		setActive(findTF(arg0_1._tf, "lottery"), false)
	else
		setActive(findTF(arg0_1._tf, "bobing"), false)
		setActive(findTF(arg0_1._tf, "lottery"), true)
	end

	arg0_1:bind(ActivityMediator.ON_BOBING_RESULT, function(arg0_2, arg1_2, arg2_2)
		if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
			arg0_1:displayBBResult(arg1_2.awards, arg1_2.numbers, function()
				arg1_2.callback()
			end)
		else
			arg0_1:displayLotteryAni(arg1_2.awards, arg1_2.numbers, function()
				arg1_2.callback()
			end)
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_5)
	if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
		arg0_5:bobingUpdate()
	else
		arg0_5:lotteryUpdate()
	end
end

function var0_0.lotteryUpdate(arg0_6)
	local var0_6 = arg0_6.activity
	local var1_6 = findTF(arg0_6._tf, "lottery/layer")
	local var2_6 = arg0_6.lotteryWrap

	if not var2_6 then
		var2_6 = {
			btnLotteryBtn = findTF(var1_6, "lottery_btn"),
			phase = findTF(var1_6, "phase"),
			nums = findTF(var1_6, "nums")
		}
		arg0_6.lotteryWrap = var2_6
	end

	local var3_6 = var0_6:getConfig("config_id")

	if var3_6 <= var0_6.data1 then
		setActive(findTF(var2_6.phase, "bg"), false)
		setActive(findTF(var2_6.phase, "Text"), false)
		setActive(findTF(var2_6.phase, "finish"), true)
	else
		setActive(findTF(var2_6.phase, "bg"), true)
		setActive(findTF(var2_6.phase, "Text"), true)
		setText(findTF(var2_6.phase, "Text"), setColorStr(var0_6.data1, "FFD43F") .. "/" .. var3_6)
		setActive(findTF(var2_6.phase, "finish"), false)
	end

	if var0_6.data2 < 1 then
		LeanTween.alpha(var2_6.btnLotteryBtn, 1, 1):setLoopPingPong()
		setActive(findTF(var2_6.btnLotteryBtn, "mask"), false)
		onButton(arg0_6, var2_6.btnLotteryBtn, function()
			if arg0_6.activity.data2 < 1 then
				arg0_6:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = arg0_6.activity.id
				})
				arg0_6:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
			end
		end, SFX_PANEL)
	else
		LeanTween.cancel(var2_6.btnLotteryBtn.gameObject)
		setActive(findTF(var2_6.btnLotteryBtn, "mask"), true)

		local var4_6 = arg0_6:getIndexByNumbers(var0_6.data1_list)

		setActive(findTF(var2_6.btnLotteryBtn, "mask/1"), var4_6 == 1)
		setActive(findTF(var2_6.btnLotteryBtn, "mask/2"), var4_6 == 2)
		setActive(findTF(var2_6.btnLotteryBtn, "mask/3"), var4_6 == 3)
		onButton(arg0_6, var2_6.btnLotteryBtn, function()
			if arg0_6.activity.data2 < 1 then
				arg0_6:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = arg0_6.activity.id
				})
				arg0_6:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
			end
		end, SFX_PANEL)
	end

	local var5_6 = var0_6.data2 == 0 and "FFD43F" or "d2d4db"

	setText(findTF(var2_6.nums, "text"), string.format("<color=#%s>%s</color> / %s", var5_6, 1 - var0_6.data2, 1))
end

function var0_0.getIndexByNumbers(arg0_9, arg1_9)
	local var0_9 = ActivityConst.BBRule(arg1_9)
	local var1_9 = 3

	if var0_9 and var0_9 >= 1 and var0_9 <= 2 then
		var1_9 = 1
	end

	if var0_9 and var0_9 >= 3 and var0_9 <= 4 then
		var1_9 = 2
	end

	return var1_9
end

function var0_0.displayLotteryAni(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg0_10:getIndexByNumbers(arg2_10)
	local var1_10 = findTF(arg0_10._tf, "lottery")
	local var2_10 = arg0_10:findTF("omikuji_anim", var1_10):GetComponent(typeof(DftAniEvent))

	var2_10:SetEndEvent(function(arg0_11)
		setActive(var2_10.gameObject, false)

		local var0_11 = arg0_10:findTF("omikuji_result", var1_10)

		setActive(var0_11, true)

		local var1_11 = arg0_10:findTF("title", var0_11)

		for iter0_11 = 1, var1_11.childCount do
			setActive(var1_11:GetChild(iter0_11 - 1), iter0_11 == var0_10)
		end

		local var2_11 = arg0_10:findTF("desc", var0_11)
		local var3_11 = {
			"big",
			"medium",
			"little"
		}
		local var4_11 = i18n("draw_" .. var3_11[var0_10] .. "_luck_" .. math.random(1, 3))

		setText(var2_11, var4_11)

		local var5_11 = arg0_10:findTF("award", var0_11)
		local var6_11 = arg0_10:findTF("award_list", var0_11)

		setActive(var5_11, false)
		removeAllChildren(var6_11)

		if arg1_10 then
			for iter1_11, iter2_11 in ipairs(arg1_10) do
				local var7_11 = cloneTplTo(var5_11, var6_11)
				local var8_11 = {
					type = iter2_11.type,
					id = iter2_11.id,
					count = iter2_11.count
				}

				updateDrop(var7_11, var8_11)
				onButton(arg0_10, var7_11, function()
					arg0_10:emit(BaseUI.ON_DROP, var8_11)
				end, SFX_PANEL)
			end
		end

		arg0_10:emit(ActivityMainScene.LOCK_ACT_MAIN, false)
		onButton(arg0_10, var0_11, function()
			setActive(var0_11, false)
			arg3_10()
		end)
	end)
	setActive(var2_10.gameObject, true)
end

function var0_0.bobingUpdate(arg0_14)
	local var0_14 = arg0_14.activity
	local var1_14 = findTF(arg0_14._tf, "bobing")
	local var2_14 = arg0_14.bobingWrap

	if not var2_14 then
		var2_14 = {
			bg = arg0_14:findTF("AD", arg0_14._tf),
			progress = arg0_14:findTF("award/nums", var1_14),
			get = arg0_14:findTF("award/get", var1_14),
			nums = arg0_14:findTF("nums/text", var1_14),
			bowlDisable = arg0_14:findTF("bowl_disable", var1_14),
			bowlEnable = arg0_14:findTF("bowl_enable", var1_14)
		}
		var2_14.bowlShine = arg0_14:findTF("bowl_shine", var2_14.bowlEnable)
		var2_14.btnRule = arg0_14:findTF("btnRule", var1_14)
		var2_14.layerRule = arg0_14:findTF("rule", var1_14)
		var2_14.btnReturn = arg0_14:findTF("btnReturn", var2_14.layerRule)
		var2_14.item = arg0_14:findTF("item", var2_14.layerRule)
		var2_14.top = arg0_14:findTF("top", var2_14.layerRule)
		var2_14.itemRow = arg0_14:findTF("row", var2_14.layerRule)
		var2_14.itemColumn = arg0_14:findTF("column", var2_14.layerRule)

		setActive(var2_14.layerRule, false)
		setActive(var2_14.item, false)
		setActive(var2_14.itemRow, false)
		setActive(var2_14.itemColumn, true)

		local var3_14 = pg.gameset.bb_front_awards.description
		local var4_14 = var3_14[1]
		local var5_14 = _.slice(var3_14, 2, #var3_14 - 1)
		local var6_14 = UIItemList.New(var2_14.top, var2_14.item)

		var6_14:make(function(arg0_15, arg1_15, arg2_15)
			if arg0_15 == UIItemList.EventUpdate then
				local var0_15 = {
					type = var4_14[arg1_15 + 1][1],
					id = var4_14[arg1_15 + 1][2],
					count = var4_14[arg1_15 + 1][3]
				}

				updateDrop(arg2_15, var0_15)
				onButton(arg0_14, arg2_15, function()
					arg0_14:emit(BaseUI.ON_DROP, var0_15)
				end, SFX_PANEL)
			end
		end)
		var6_14:align(#var4_14)

		local var7_14 = UIItemList.New(var2_14.itemColumn, var2_14.itemRow)

		var7_14:make(function(arg0_17, arg1_17, arg2_17)
			if arg0_17 == UIItemList.EventUpdate then
				local var0_17 = var5_14[arg1_17 + 1]
				local var1_17 = UIItemList.New(arg2_17, var2_14.item)

				var1_17:make(function(arg0_18, arg1_18, arg2_18)
					if arg0_18 == UIItemList.EventUpdate then
						local var0_18 = {
							type = var0_17[arg1_18 + 1][1],
							id = var0_17[arg1_18 + 1][2],
							count = var0_17[arg1_18 + 1][3]
						}

						updateDrop(arg2_18, var0_18)
						onButton(arg0_14, arg2_18, function()
							arg0_14:emit(BaseUI.ON_DROP, var0_18)
						end, SFX_PANEL)
					end
				end)
				var1_17:align(#var0_17)
			end
		end)
		var7_14:align(#var5_14)
		onButton(arg0_14, var2_14.btnRule, function()
			setActive(var2_14.layerRule, true)
		end, SFX_PANEL)
		onButton(arg0_14, var2_14.btnReturn, function()
			setActive(var2_14.layerRule, false)
		end, SFX_CANCEL)
		onButton(arg0_14, var2_14.bowlEnable, function()
			arg0_14:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
			arg0_14:displayBBAnim(function()
				arg0_14:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = var0_14.id
				})
			end)
		end, SFX_PANEL)

		arg0_14.bobingWrap = var2_14
	end

	local var8_14 = var0_14:getConfig("config_id")

	setActive(var2_14.layerRule, false)
	setActive(var2_14.get, var8_14 <= var0_14.data1)
	setActive(var2_14.bowlDisable, var0_14.data2 == 0)
	setActive(var2_14.bowlEnable, var0_14.data2 > 0)

	if var0_14.data2 < 1 then
		LeanTween.alpha(var2_14.bowlShine, 1, 1):setLoopPingPong()
	else
		LeanTween.cancel(var2_14.bowlShine.gameObject)
	end

	setText(var2_14.progress, string.format("<color=#%s>%s</color> %s", "FFD43F", math.min(var0_14.data1, var8_14) .. "/", var8_14))

	local var9_14 = var0_14.data2 == 0 and "FFD43F" or "d2d4db"

	setActive(var2_14.progress, var8_14 > var0_14.data1)
	setText(var2_14.nums, string.format("<color=#%s>%s</color>", var9_14, var0_14.data2))
end

function var0_0.displayBBAnim(arg0_24, arg1_24)
	local var0_24 = arg0_24:findTF("bobing/bb_anim")
	local var1_24 = arg0_24:findTF("ship", var0_24)
	local var2_24 = arg0_24:findTF("bowl", var0_24)

	if not arg0_24.animBowl then
		arg0_24.animBowl = var2_24:GetComponent(typeof(SpineAnimUI))

		arg0_24.animBowl:SetAction("bobing", 0)
		arg0_24.animBowl:SetActionCallBack(function(arg0_25)
			if arg0_25 == "finsih" then
				setActive(var1_24, false)
				setActive(var2_24, false)
				arg1_24()
			end
		end)
	end

	local function var3_24()
		setActive(var1_24, true)
		setActive(var2_24, true)
		arg0_24.model:GetComponent(typeof(SpineAnimUI)):SetAction("victory", 0)
	end

	if not arg0_24.model then
		local var4_24 = getProxy(PlayerProxy):getRawData()
		local var5_24 = getProxy(BayProxy):getShipById(var4_24.character)

		PoolMgr.GetInstance():GetSpineChar(var5_24:getPrefab(), false, function(arg0_27)
			arg0_24.model = arg0_27
			arg0_24.model.transform.localScale = Vector3(0.5, 0.5, 1)

			arg0_24.model.transform:SetParent(var1_24, false)
			var3_24()
		end)
	else
		var3_24()
	end

	setActive(var0_24, true)
end

function var0_0.displayBBResult(arg0_28, arg1_28, arg2_28, arg3_28)
	arg0_28.animation = findTF(arg0_28._tf, "bobing")

	setActive(arg0_28:findTF("bb_anim", arg0_28.animation), false)

	local var0_28 = arg0_28:findTF("bb_result", arg0_28.animation)
	local var1_28 = arg0_28:findTF("numbers", var0_28)
	local var2_28 = arg0_28:findTF("number", var0_28)
	local var3_28 = arg0_28:findTF("rank", var0_28)
	local var4_28 = arg0_28:findTF("bgRank", var0_28)

	setActive(var2_28, false)

	local var5_28 = arg0_28:findTF("award", var0_28)
	local var6_28 = arg0_28:findTF("award_list", var0_28)

	setActive(var5_28, false)
	removeAllChildren(var6_28)

	if arg1_28 then
		for iter0_28, iter1_28 in ipairs(arg1_28) do
			local var7_28 = cloneTplTo(var5_28, var6_28)
			local var8_28 = {
				type = iter1_28.type,
				id = iter1_28.id,
				count = iter1_28.count
			}

			updateDrop(var7_28, var8_28)
			onButton(arg0_28, var7_28, function()
				arg0_28:emit(BaseUI.ON_DROP, var8_28)
			end, SFX_PANEL)
		end
	end

	local var9_28 = UIItemList.New(var1_28, var2_28)

	var9_28:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			arg0_28:setSpriteTo("bobing/bb_icon/dice" .. arg2_28[arg1_30 + 1], arg2_30)
			setImageAlpha(arg2_30, 0)
		end
	end)
	var9_28:align(#arg2_28)

	local var10_28 = ActivityConst.BBRule(arg2_28)

	setActive(var3_28, var10_28 < 7)
	setActive(var4_28, var10_28 < 7)

	if var10_28 < 7 then
		arg0_28:setSpriteTo("bobing/bb_icon/rank" .. var10_28, var3_28)
		setImageAlpha(var3_28, 0)
	end

	local var11_28 = false
	local var12_28 = LeanTween.value(go(var1_28), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_31)
		var9_28:each(function(arg0_32, arg1_32)
			setImageAlpha(arg1_32, arg0_31)
		end)
	end))

	if var10_28 == 7 then
		var12_28:setOnComplete(System.Action(function()
			arg0_28:emit(ActivityMainScene.LOCK_ACT_MAIN, false)

			var11_28 = true
		end))
	else
		LeanTween.value(go(var3_28), 0, 1, 0.2):setDelay(1):setOnUpdate(System.Action_float(function(arg0_34)
			setImageAlpha(var3_28, arg0_34)

			var3_28.localScale = Vector3.Lerp(Vector3(2, 2, 2), Vector3.one, arg0_34)
		end))

		local var13_28 = arg0_28:findTF("rank_p", var0_28) or cloneTplTo(var3_28, var0_28, "rank_p")

		arg0_28:setSpriteTo("bobing/bb_icon/rank" .. var10_28, var13_28)
		arg0_28:setSpriteTo("bobing/bb_icon/rank" .. var10_28, var3_28)
		LeanTween.value(go(var13_28), 1, 0, 0.3):setDelay(1.5):setOnUpdate(System.Action_float(function(arg0_35)
			setImageAlpha(var13_28, arg0_35)

			var13_28.localScale = Vector3.Lerp(Vector3(2, 2, 2), Vector3.one, arg0_35)
		end)):setOnComplete(System.Action(function()
			arg0_28:emit(ActivityMainScene.LOCK_ACT_MAIN, false)

			var11_28 = true
		end))
	end

	setActive(var0_28, true)
	onButton(arg0_28, var0_28, function()
		if var11_28 then
			setActive(var0_28, false)
			arg3_28()
		end
	end)
end

function var0_0.setSpriteTo(arg0_38, arg1_38, arg2_38, arg3_38)
	local var0_38 = arg2_38:GetComponent(typeof(Image))

	var0_38.sprite = arg0_38:findTF(arg1_38):GetComponent(typeof(Image)).sprite

	if arg3_38 then
		var0_38:SetNativeSize()
	end
end

function var0_0.OnDestroy(arg0_39)
	if arg0_39.bobingWrap then
		clearImageSprite(arg0_39.bobingWrap.bg)
		LeanTween.cancel(arg0_39.bobingWrap.bowlShine.gameObject)
	end
end

return var0_0
