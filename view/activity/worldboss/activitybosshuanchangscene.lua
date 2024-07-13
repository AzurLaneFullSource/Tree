local var0_0 = class("ActivityBossHuanChangScene", import(".ActivityBossSceneTemplate"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossHuanChangUI"
end

function var0_0.init(arg0_2)
	arg0_2.mainTF = arg0_2:findTF("adapt")
	arg0_2.bg = arg0_2:findTF("bg")
	arg0_2.bottom = arg0_2:findTF("bottom", arg0_2.mainTF)
	arg0_2.hpBar = arg0_2:findTF("progress", arg0_2.bottom)
	arg0_2.barList = {}

	for iter0_2 = 1, 4 do
		arg0_2.barList[iter0_2] = arg0_2:findTF(iter0_2, arg0_2.hpBar)
	end

	arg0_2.progressDigit = arg0_2:findTF("digit", arg0_2.bottom)
	arg0_2.digitbig = arg0_2.progressDigit:Find("big")
	arg0_2.digitsmall = arg0_2.progressDigit:Find("small")
	arg0_2.left = arg0_2:findTF("left", arg0_2.mainTF)
	arg0_2.right = arg0_2:findTF("right", arg0_2.mainTF)
	arg0_2.rankTF = arg0_2:findTF("rank", arg0_2.right)
	arg0_2.rankList = CustomIndexLayer.Clone2Full(arg0_2.rankTF:Find("layout"), 3)

	for iter1_2, iter2_2 in ipairs(arg0_2.rankList) do
		setActive(iter2_2, false)
	end

	arg0_2.stageList = {}

	for iter3_2 = 1, 4 do
		arg0_2.stageList[iter3_2] = arg0_2:findTF(iter3_2, arg0_2.right)
	end

	arg0_2.stageSP = arg0_2:findTF("6", arg0_2.right)

	if not IsNil(arg0_2.stageSP) then
		setActive(arg0_2.stageSP, false)
	end

	arg0_2.awardFlash = arg0_2:findTF("ptaward/flash", arg0_2.right)
	arg0_2.awardBtn = arg0_2:findTF("ptaward/button", arg0_2.right)
	arg0_2.ptScoreTxt = arg0_2:findTF("ptaward/Text", arg0_2.right)
	arg0_2.top = arg0_2:findTF("top", arg0_2.mainTF)
	arg0_2.ticketNum = arg0_2:findTF("ticket/Text", arg0_2.top)
	arg0_2.helpBtn = arg0_2:findTF("help", arg0_2.top)

	onButton(arg0_2, arg0_2.top:Find("back_btn"), function()
		arg0_2:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	setActive(arg0_2.top, false)
	setAnchoredPosition(arg0_2.top, {
		y = 1080
	})
	setActive(arg0_2.left, false)
	setAnchoredPosition(arg0_2.left, {
		x = -1920
	})
	setActive(arg0_2.right, false)
	setAnchoredPosition(arg0_2.right, {
		x = 1920
	})
	setActive(arg0_2.bottom, false)
	setAnchoredPosition(arg0_2.bottom, {
		y = -1080
	})
	arg0_2:buildCommanderPanel()
end

function var0_0.UpdateDropItems(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.contextData.DisplayItems or {}) do
		local var0_4 = arg0_4:findTF("milestone/item", arg0_4.barList[iter0_4])
		local var1_4 = {
			type = arg0_4.contextData.DisplayItems[5 - iter0_4][1],
			id = arg0_4.contextData.DisplayItems[5 - iter0_4][2],
			count = arg0_4.contextData.DisplayItems[5 - iter0_4][3]
		}

		updateDrop(var0_4:GetChild(0), var1_4)
		onButton(arg0_4, var0_4, function()
			arg0_4:emit(var0_0.ON_DROP, var1_4)
		end, SFX_PANEL)
	end
end

function var0_0.UpdatePage(arg0_6)
	local var0_6 = arg0_6.contextData.bossHP

	setText(arg0_6.digitbig, math.floor(var0_6 / 100))
	setText(arg0_6.digitsmall, string.format("%02d", var0_6 % 100) .. "%")

	local var1_6 = pg.TimeMgr.GetInstance()

	for iter0_6 = 1, 4 do
		local var2_6 = arg0_6.barList[iter0_6]

		setSlider(arg0_6:findTF("Slider", var2_6), 0, 2500, math.min(math.max(var0_6 - (iter0_6 - 1) * 2500, 0), 2500))

		local var3_6 = arg0_6.contextData.mileStones[5 - iter0_6]

		setActive(arg0_6:findTF("milestone/item", var2_6), not var3_6)
		setActive(arg0_6:findTF("milestone/time", var2_6), var3_6)

		if var3_6 then
			local var4_6 = var1_6:STimeDescC(arg0_6.contextData.mileStones[5 - iter0_6], "%m/%d/%H:%M")

			setText(arg0_6:findTF("milestone/time/Text", var2_6), var4_6)
		end
	end

	for iter1_6 = 1, #arg0_6.stageList - 1 do
		local var5_6 = arg0_6.contextData.normalStageIDs[iter1_6]
		local var6_6 = arg0_6.stageList[iter1_6]

		for iter2_6, iter3_6 in ipairs(arg0_6.contextData.ticketInitPools) do
			for iter4_6, iter5_6 in ipairs(iter3_6[1]) do
				if iter5_6 == var5_6 then
					local var7_6 = iter3_6[2]
					local var8_6 = arg0_6.contextData.stageTickets[var5_6] or 0
					local var9_6 = var6_6:Find("count")

					setActive(var9_6, var8_6 > 0)
					setText(var9_6:Find("res"), var8_6)
					setText(var9_6:Find("max"), var7_6)
				end
			end
		end
	end

	setText(arg0_6.ptScoreTxt, arg0_6.contextData.ptData.count)
	setActive(arg0_6.awardFlash, arg0_6.contextData.ptData:CanGetAward())

	if arg0_6.bonusWindow and arg0_6.bonusWindow:IsShowing() then
		arg0_6.bonusWindow.buffer:UpdateView(arg0_6.contextData.ptData)
	end

	local var10_6 = arg0_6:GetEXTicket()

	setText(arg0_6.ticketNum, var10_6)
end

function var0_0.UpdateRank(arg0_7, arg1_7)
	arg1_7 = arg1_7 or {}

	for iter0_7 = 1, #arg0_7.rankList do
		local var0_7 = arg0_7.rankList[iter0_7]

		setActive(var0_7, iter0_7 <= #arg1_7)

		if iter0_7 <= #arg1_7 then
			local var1_7 = var0_7:Find("Text")
			local var2_7 = tostring(arg1_7[iter0_7].name)

			if #var2_7 >= 11 then
				var1_7:GetComponent(typeof(Text)).fontSize = 23
			else
				var1_7:GetComponent(typeof(Text)).fontSize = 28
			end

			setText(var1_7, var2_7)
		end
	end
end

return var0_0
