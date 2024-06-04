local var0 = class("ActivityBossHuanChangScene", import(".ActivityBossSceneTemplate"))

function var0.getUIName(arg0)
	return "ActivityBossHuanChangUI"
end

function var0.init(arg0)
	arg0.mainTF = arg0:findTF("adapt")
	arg0.bg = arg0:findTF("bg")
	arg0.bottom = arg0:findTF("bottom", arg0.mainTF)
	arg0.hpBar = arg0:findTF("progress", arg0.bottom)
	arg0.barList = {}

	for iter0 = 1, 4 do
		arg0.barList[iter0] = arg0:findTF(iter0, arg0.hpBar)
	end

	arg0.progressDigit = arg0:findTF("digit", arg0.bottom)
	arg0.digitbig = arg0.progressDigit:Find("big")
	arg0.digitsmall = arg0.progressDigit:Find("small")
	arg0.left = arg0:findTF("left", arg0.mainTF)
	arg0.right = arg0:findTF("right", arg0.mainTF)
	arg0.rankTF = arg0:findTF("rank", arg0.right)
	arg0.rankList = CustomIndexLayer.Clone2Full(arg0.rankTF:Find("layout"), 3)

	for iter1, iter2 in ipairs(arg0.rankList) do
		setActive(iter2, false)
	end

	arg0.stageList = {}

	for iter3 = 1, 4 do
		arg0.stageList[iter3] = arg0:findTF(iter3, arg0.right)
	end

	arg0.stageSP = arg0:findTF("6", arg0.right)

	if not IsNil(arg0.stageSP) then
		setActive(arg0.stageSP, false)
	end

	arg0.awardFlash = arg0:findTF("ptaward/flash", arg0.right)
	arg0.awardBtn = arg0:findTF("ptaward/button", arg0.right)
	arg0.ptScoreTxt = arg0:findTF("ptaward/Text", arg0.right)
	arg0.top = arg0:findTF("top", arg0.mainTF)
	arg0.ticketNum = arg0:findTF("ticket/Text", arg0.top)
	arg0.helpBtn = arg0:findTF("help", arg0.top)

	onButton(arg0, arg0.top:Find("back_btn"), function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	setActive(arg0.top, false)
	setAnchoredPosition(arg0.top, {
		y = 1080
	})
	setActive(arg0.left, false)
	setAnchoredPosition(arg0.left, {
		x = -1920
	})
	setActive(arg0.right, false)
	setAnchoredPosition(arg0.right, {
		x = 1920
	})
	setActive(arg0.bottom, false)
	setAnchoredPosition(arg0.bottom, {
		y = -1080
	})
	arg0:buildCommanderPanel()
end

function var0.UpdateDropItems(arg0)
	for iter0, iter1 in ipairs(arg0.contextData.DisplayItems or {}) do
		local var0 = arg0:findTF("milestone/item", arg0.barList[iter0])
		local var1 = {
			type = arg0.contextData.DisplayItems[5 - iter0][1],
			id = arg0.contextData.DisplayItems[5 - iter0][2],
			count = arg0.contextData.DisplayItems[5 - iter0][3]
		}

		updateDrop(var0:GetChild(0), var1)
		onButton(arg0, var0, function()
			arg0:emit(var0.ON_DROP, var1)
		end, SFX_PANEL)
	end
end

function var0.UpdatePage(arg0)
	local var0 = arg0.contextData.bossHP

	setText(arg0.digitbig, math.floor(var0 / 100))
	setText(arg0.digitsmall, string.format("%02d", var0 % 100) .. "%")

	local var1 = pg.TimeMgr.GetInstance()

	for iter0 = 1, 4 do
		local var2 = arg0.barList[iter0]

		setSlider(arg0:findTF("Slider", var2), 0, 2500, math.min(math.max(var0 - (iter0 - 1) * 2500, 0), 2500))

		local var3 = arg0.contextData.mileStones[5 - iter0]

		setActive(arg0:findTF("milestone/item", var2), not var3)
		setActive(arg0:findTF("milestone/time", var2), var3)

		if var3 then
			local var4 = var1:STimeDescC(arg0.contextData.mileStones[5 - iter0], "%m/%d/%H:%M")

			setText(arg0:findTF("milestone/time/Text", var2), var4)
		end
	end

	for iter1 = 1, #arg0.stageList - 1 do
		local var5 = arg0.contextData.normalStageIDs[iter1]
		local var6 = arg0.stageList[iter1]

		for iter2, iter3 in ipairs(arg0.contextData.ticketInitPools) do
			for iter4, iter5 in ipairs(iter3[1]) do
				if iter5 == var5 then
					local var7 = iter3[2]
					local var8 = arg0.contextData.stageTickets[var5] or 0
					local var9 = var6:Find("count")

					setActive(var9, var8 > 0)
					setText(var9:Find("res"), var8)
					setText(var9:Find("max"), var7)
				end
			end
		end
	end

	setText(arg0.ptScoreTxt, arg0.contextData.ptData.count)
	setActive(arg0.awardFlash, arg0.contextData.ptData:CanGetAward())

	if arg0.bonusWindow and arg0.bonusWindow:IsShowing() then
		arg0.bonusWindow.buffer:UpdateView(arg0.contextData.ptData)
	end

	local var10 = arg0:GetEXTicket()

	setText(arg0.ticketNum, var10)
end

function var0.UpdateRank(arg0, arg1)
	arg1 = arg1 or {}

	for iter0 = 1, #arg0.rankList do
		local var0 = arg0.rankList[iter0]

		setActive(var0, iter0 <= #arg1)

		if iter0 <= #arg1 then
			local var1 = var0:Find("Text")
			local var2 = tostring(arg1[iter0].name)

			if #var2 >= 11 then
				var1:GetComponent(typeof(Text)).fontSize = 23
			else
				var1:GetComponent(typeof(Text)).fontSize = 28
			end

			setText(var1, var2)
		end
	end
end

return var0
