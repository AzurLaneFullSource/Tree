local var0 = class("PizzahutPTPage", import(".TemplatePage.PtTemplatePage"))

var0.FADE_TIME = 0.5
var0.SHOW_TIME = 1
var0.FADE_OUT_TIME = 0.5
var0.Menu_Ani_Open_Time = 0.5
var0.Menu_Ani_Close_Time = 0.3
var0.PosList = {
	-256,
	-150,
	-50,
	55,
	160,
	263
}
var0.Pizza_Save_Tag_Pre = "Pizza_Tag_"

function var0.OnDataSetting(arg0)
	var0.super.OnDataSetting(arg0)

	arg0.specialPhaseList = arg0.activity:getConfig("config_data")
	arg0.selectedList = arg0:getSelectedList()
	arg0.curSelectOrder = 0
	arg0.curSelectIndex = 0
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	arg0:findUI()
	arg0:initMainPanel()
	arg0:addListener()
	arg0:initSD()
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var2 >= 1 and setColorStr(var0, "#947D80FF") or var0) .. "/" .. var1)
	arg0:updatePizza()
	arg0:updateMainSelectPanel()
	setActive(arg0.openBtn, arg0:isFinished())
	setActive(arg0.shareBtn, arg0:isFinished())
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0.OnDestroy(arg0)
	if arg0.spine then
		arg0.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar("chuixue_6", arg0.spine)

		arg0.spine = nil
	end

	if arg0.shareGo then
		PoolMgr.GetInstance():ReturnUI("PizzahutSharePage", arg0.shareGo)

		arg0.shareGo = nil
	end
end

function var0.findUI(arg0)
	arg0.shareBtn = arg0:findTF("share_btn", arg0.bg)
	arg0.empty = arg0:findTF("empty", arg0.bg)
	arg0.pizzaTF = arg0:findTF("Pizza", arg0.bg)
	arg0.openBtn = arg0:findTF("open_btn", arg0.bg)
	arg0.helpBtn = arg0:findTF("help_btn", arg0.bg)
	arg0.specialTF = arg0:findTF("Special")
	arg0.backBG = arg0:findTF("BG", arg0.specialTF)
	arg0.closeBtn = arg0:findTF("CloseBtn", arg0.specialTF)
	arg0.menuTF = arg0:findTF("Menu", arg0.specialTF)
	arg0.mainPanel = arg0:findTF("MainPanel", arg0.menuTF)
	arg0.mainToggleTFList = {}

	for iter0 = 1, 6 do
		arg0.mainToggleTFList[iter0] = arg0.mainPanel:GetChild(iter0 - 1)
	end

	arg0.secondPanel = arg0:findTF("SecondList", arg0.menuTF)
	arg0.selectBtn = arg0:findTF("SelectBtn", arg0.menuTF)
	arg0.mainPanelCG = GetComponent(arg0.mainPanel, "CanvasGroup")
	arg0.secondPanelCG = GetComponent(arg0.secondPanel, "CanvasGroup")
	arg0.selectBtnImg = GetComponent(arg0.selectBtn, "Image")
	arg0.resTF = arg0:findTF("Res")

	local var0 = arg0:findTF("1/1", arg0.resTF)
	local var1 = arg0:findTF("1/2", arg0.resTF)
	local var2 = arg0:findTF("1/3", arg0.resTF)
	local var3 = arg0:findTF("2/1/1", arg0.resTF)
	local var4 = arg0:findTF("2/1/2", arg0.resTF)
	local var5 = arg0:findTF("2/1/3", arg0.resTF)
	local var6 = arg0:findTF("2/2/1", arg0.resTF)
	local var7 = arg0:findTF("2/2/2", arg0.resTF)
	local var8 = arg0:findTF("2/2/3", arg0.resTF)
	local var9 = arg0:findTF("2/3/1", arg0.resTF)
	local var10 = arg0:findTF("2/3/2", arg0.resTF)
	local var11 = arg0:findTF("2/3/3", arg0.resTF)
	local var12 = arg0:findTF("3/1/1", arg0.resTF)
	local var13 = arg0:findTF("3/1/2", arg0.resTF)
	local var14 = arg0:findTF("3/1/3", arg0.resTF)
	local var15 = arg0:findTF("3/2/1", arg0.resTF)
	local var16 = arg0:findTF("3/2/2", arg0.resTF)
	local var17 = arg0:findTF("3/2/3", arg0.resTF)
	local var18 = arg0:findTF("3/3/1", arg0.resTF)
	local var19 = arg0:findTF("3/3/2", arg0.resTF)
	local var20 = arg0:findTF("3/3/3", arg0.resTF)
	local var21 = arg0:findTF("4/1", arg0.resTF)
	local var22 = arg0:findTF("4/2", arg0.resTF)
	local var23 = arg0:findTF("4/3", arg0.resTF)
	local var24 = arg0:findTF("5/1", arg0.resTF)
	local var25 = arg0:findTF("5/2", arg0.resTF)
	local var26 = arg0:findTF("5/3", arg0.resTF)
	local var27 = arg0:findTF("6/1", arg0.resTF)
	local var28 = arg0:findTF("6/2", arg0.resTF)
	local var29 = arg0:findTF("6/3", arg0.resTF)

	arg0.iconTable = {
		["1"] = {
			var0,
			var1,
			var2
		},
		["21"] = {
			var3,
			var4,
			var5
		},
		["22"] = {
			var6,
			var7,
			var8
		},
		["23"] = {
			var9,
			var10,
			var11
		},
		["311"] = {
			var12
		},
		["312"] = {
			var13
		},
		["313"] = {
			var14
		},
		["321"] = {
			var15
		},
		["322"] = {
			var16
		},
		["323"] = {
			var17
		},
		["331"] = {
			var18
		},
		["332"] = {
			var19
		},
		["333"] = {
			var20
		},
		["4"] = {
			var21,
			var22,
			var23
		},
		["5"] = {
			var24,
			var25,
			var26
		},
		["6"] = {
			var27,
			var28,
			var29
		}
	}
	arg0.pizzaResTF = arg0:findTF("Pizza")
	arg0.mainToggleSelectedTF = {}

	for iter1, iter2 in ipairs(arg0.mainToggleTFList) do
		arg0.mainToggleSelectedTF[iter1] = iter2:GetChild(0)
	end

	arg0.selectedIconResTF = arg0:findTF("SelectedIcon")
end

function var0.addListener(arg0)
	onButton(arg0, arg0.getBtn, function()
		local var0, var1, var2 = arg0.ptData:GetLevelProgress()
		local var3 = table.indexof(arg0.specialPhaseList, var0, 1)

		if var3 then
			arg0:openMainPanel(var3)
		else
			local var4 = {}
			local var5 = arg0.ptData:GetAward()
			local var6 = getProxy(PlayerProxy):getData()

			if var5.type == DROP_TYPE_RESOURCE and var5.id == PlayerConst.ResGold and var6:GoldMax(var5.count) then
				table.insert(var4, function(arg0)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
						onYes = arg0
					})
				end)
			end

			seriesAsync(var4, function()
				local var0, var1 = arg0.ptData:GetResProgress()

				arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 1,
					activity_id = arg0.ptData:GetId(),
					arg1 = var1
				})
			end)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.openBtn, function()
		arg0:openMainPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.pizzahut_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.shareBtn, function()
		arg0:share()
	end, SFX_PANEL)
end

function var0.initMainPanel(arg0)
	onButton(arg0, arg0.backBG, function()
		arg0:closeSpecial()

		if arg0:isFinished() then
			setActive(arg0.openBtn, true)
		end
	end, SFX_CANCEL)

	for iter0, iter1 in ipairs(arg0.mainToggleTFList) do
		onToggle(arg0, iter1, function(arg0)
			arg0.curSelectOrder = iter0

			if arg0 == true then
				local var0 = var0.PosList[iter0]

				setLocalPosition(arg0.secondPanel, {
					x = var0
				})
				setLocalPosition(arg0.selectBtn, {
					x = var0
				})

				local var1

				if iter0 == 1 then
					var1 = arg0.iconTable["1"]
				elseif iter0 == 2 then
					local var2 = 2 .. arg0.selectedList[1]

					var1 = arg0.iconTable[var2]
				elseif iter0 == 3 then
					local var3 = 3 .. arg0.selectedList[1] .. arg0.selectedList[2]

					var1 = arg0.iconTable[var3]
				elseif iter0 >= 4 and iter0 <= 6 then
					var1 = arg0.iconTable[tostring(iter0)]
				end

				local var4 = {}

				for iter0 = 1, 3 do
					var4[iter0] = arg0.secondPanel:GetChild(iter0 - 1)
				end

				if #var1 == 1 then
					setActive(var4[2], false)
					setActive(var4[3], false)

					local var5 = getImageSprite(var1[1])

					setImageSprite(arg0:findTF("icon", var4[1]), var5, true)
					onToggle(arg0, var4[1], function(arg0)
						if arg0 == true then
							arg0:openSelectBtn()

							arg0.curSelectIndex = 1
						end
					end, SFX_PANEL)
					triggerToggle(var4[1], true)
				else
					setActive(var4[2], true)
					setActive(var4[3], true)

					for iter1 = 1, 3 do
						local var6 = getImageSprite(var1[iter1])

						setImageSprite(arg0:findTF("icon", var4[iter1]), var6, true)
						onToggle(arg0, var4[iter1], function(arg0)
							if arg0 == true then
								arg0:openSelectBtn()

								arg0.curSelectIndex = iter1
							else
								setActive(arg0.selectBtn, false)

								arg0.curSelectIndex = 0
							end
						end, SFX_PANEL)
					end
				end

				for iter2 = 1, 3 do
					triggerToggle(var4[iter2], false)
				end

				arg0:openSecondPanel()
				setActive(arg0.selectBtn, false)
			else
				setActive(arg0.secondPanel, false)
				setActive(arg0.selectBtn, false)
			end

			arg0:updateMainSelectPanel()
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.selectBtn, function()
		if not arg0:isFinished() then
			if arg0.curSelectIndex then
				local var0, var1 = arg0.ptData:GetResProgress()

				arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 1,
					activity_id = arg0.ptData:GetId(),
					arg1 = var1,
					arg2 = arg0.curSelectIndex,
					callback = function()
						arg0.selectedList[arg0.curSelectOrder] = arg0.curSelectIndex

						arg0:closeSpecial()
					end
				})
			end
		else
			arg0:changeIndexSelect()
			arg0:updatePizza()
			arg0:updateMainSelectPanel()
		end
	end, SFX_PANEL)
end

function var0.openMainPanel(arg0, arg1)
	arg0.selectedList = arg0:getSelectedList()

	setActive(arg0.openBtn, false)

	for iter0 = 1, 6 do
		triggerToggle(arg0.mainToggleTFList[iter0], false)

		GetComponent(arg0.mainToggleTFList[iter0], "Toggle").interactable = arg0:isFinished()
	end

	arg0:updateMainSelectPanel()
	setActive(arg0.specialTF, true)
	LeanTween.value(go(arg0.mainPanel), 0, 1, var0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0)
		arg0.mainPanelCG.alpha = arg0
	end)):setOnComplete(System.Action(function()
		arg0.mainPanelCG.alpha = 1
	end))
	LeanTween.value(go(arg0.mainPanel), -640, 0, var0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0)
		setLocalPosition(arg0.mainPanel, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0.mainPanel, {
			x = 0
		})

		if arg1 and arg1 > 0 then
			triggerToggle(arg0.mainToggleTFList[arg1], true)
		end
	end))
end

function var0.closeMainPanel(arg0)
	LeanTween.value(go(arg0.mainPanel), 1, 0, var0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0)
		arg0.mainPanelCG.alpha = arg0
	end)):setOnComplete(System.Action(function()
		arg0.mainPanelCG.alpha = 0

		setActive(arg0.specialTF, false)
	end))
	LeanTween.value(go(arg0.mainPanel), 0, -640, var0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0)
		setLocalPosition(arg0.mainPanel, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0.mainPanel, {
			x = -640
		})
		setActive(arg0.specialTF, false)
	end))
end

function var0.openSecondPanel(arg0)
	setActive(arg0.secondPanel, true)
	LeanTween.value(go(arg0.secondPanel), 0, 1, var0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0)
		arg0.secondPanelCG.alpha = arg0
	end)):setOnComplete(System.Action(function()
		arg0.secondPanelCG.alpha = 1
	end))
	LeanTween.value(go(arg0.secondPanel), -530, -60, var0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0)
		setLocalPosition(arg0.secondPanel, {
			y = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0.secondPanel, {
			y = -60
		})
	end))
end

function var0.closeSecondPanel(arg0)
	LeanTween.value(go(arg0.secondPanel), 1, 0, var0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0)
		arg0.secondPanelCG.alpha = arg0
	end)):setOnComplete(System.Action(function()
		arg0.secondPanelCG.alpha = 0

		setActive(arg0.secondPanel, false)
	end))
	LeanTween.value(go(arg0.secondPanel), -60, -530, var0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0)
		setLocalPosition(arg0.secondPanel, {
			y = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0.secondPanel, {
			y = -530
		})
		setActive(arg0.secondPanel, false)
		arg0:closeMainPanel()
	end))
end

function var0.openSelectBtn(arg0)
	setActive(arg0.selectBtn, true)
	LeanTween.value(go(arg0.selectBtn), 0, 1, var0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0)
		setImageAlpha(arg0.selectBtn, arg0)
	end)):setOnComplete(System.Action(function()
		setImageAlpha(arg0.selectBtn, 1)
	end))
	LeanTween.value(go(arg0.selectBtn), -145, -210, var0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0)
		setLocalPosition(arg0.selectBtn, {
			y = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0.selectBtn, {
			y = -210
		})
	end))
end

function var0.closeSelectBtn(arg0)
	LeanTween.value(go(arg0.selectBtn), 1, 0, var0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0)
		setImageAlpha(arg0.selectBtn, arg0)
	end)):setOnComplete(System.Action(function()
		setImageAlpha(arg0.selectBtn, 0)
		setActive(arg0.selectBtn, false)
	end))
	LeanTween.value(go(arg0.selectBtn), -210, -145, var0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0)
		setLocalPosition(arg0.selectBtn, {
			y = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0.selectBtn, {
			y = -145
		})
		setActive(arg0.selectBtn, false)
	end))
end

function var0.closeSpecial(arg0)
	arg0:closeSelectBtn()
	arg0:closeSecondPanel()
end

function var0.updatePizza(arg0)
	setActive(arg0.empty, arg0.selectedList[1] == 0)
	setActive(arg0.pizzaTF, arg0.selectedList[1] > 0)

	local var0 = arg0:findTF("PizzaPan", arg0.pizzaTF)
	local var1 = arg0:findTF("PizzaSauce", arg0.pizzaTF)
	local var2 = arg0:findTF("PizzaCheese", arg0.pizzaTF)
	local var3 = arg0:findTF("EX1", arg0.pizzaTF)
	local var4 = arg0:findTF("EX2", arg0.pizzaTF)
	local var5 = arg0:findTF("EX3", arg0.pizzaTF)

	setActive(var0, arg0.selectedList[1] and arg0.selectedList[1] > 0)
	setActive(var1, arg0.selectedList[2] and arg0.selectedList[2] > 0)
	setActive(var2, arg0.selectedList[3] and arg0.selectedList[3] > 0)
	setActive(var3, arg0.selectedList[4] and arg0.selectedList[4] > 0)
	setActive(var4, arg0.selectedList[5] and arg0.selectedList[5] > 0)
	setActive(var5, arg0.selectedList[6] and arg0.selectedList[6] > 0)

	if arg0.selectedList[1] and arg0.selectedList[1] > 0 then
		local var6 = getImageSprite(arg0:findTF(tostring(arg0.selectedList[1]), arg0.pizzaResTF))

		setImageSprite(var0, var6, true)
	end

	if arg0.selectedList[2] and arg0.selectedList[2] > 0 then
		local var7 = arg0.selectedList[1] .. arg0.selectedList[2]
		local var8 = getImageSprite(arg0:findTF(var7, arg0.pizzaResTF))

		setImageSprite(var1, var8, true)
	end

	if arg0.selectedList[3] and arg0.selectedList[3] > 0 then
		local var9 = arg0.selectedList[1] .. arg0.selectedList[2] .. arg0.selectedList[3]
		local var10 = getImageSprite(arg0:findTF(var9, arg0.pizzaResTF))

		setImageSprite(var2, var10, true)
	end

	if arg0.selectedList[4] and arg0.selectedList[4] > 0 then
		local var11 = 4 .. arg0.selectedList[4]
		local var12 = getImageSprite(arg0:findTF(var11, arg0.pizzaResTF))

		setImageSprite(var3, var12, true)
	end

	if arg0.selectedList[5] and arg0.selectedList[5] > 0 then
		local var13 = 5 .. arg0.selectedList[5]
		local var14 = getImageSprite(arg0:findTF(var13, arg0.pizzaResTF))

		setImageSprite(var4, var14, true)
	end

	if arg0.selectedList[6] and arg0.selectedList[6] > 0 then
		local var15 = 6 .. arg0.selectedList[6]
		local var16 = getImageSprite(arg0:findTF(var15, arg0.pizzaResTF))

		setImageSprite(var5, var16, true)
	end
end

function var0.updateMainSelectPanel(arg0)
	if arg0.selectedList[1] and arg0.selectedList[1] > 0 then
		local var0 = getImageSprite(arg0:findTF(tostring(arg0.selectedList[1]), arg0.selectedIconResTF))

		setImageSprite(arg0.mainToggleSelectedTF[1], var0, true)
		setActive(arg0.mainToggleSelectedTF[1], true)
	end

	if arg0.selectedList[2] and arg0.selectedList[2] > 0 then
		local var1 = arg0.selectedList[1] .. arg0.selectedList[2]
		local var2 = getImageSprite(arg0:findTF(var1, arg0.selectedIconResTF))

		setImageSprite(arg0.mainToggleSelectedTF[2], var2, true)
		setActive(arg0.mainToggleSelectedTF[2], true)
	end

	if arg0.selectedList[3] and arg0.selectedList[3] > 0 then
		local var3 = arg0.selectedList[1] .. arg0.selectedList[2] .. arg0.selectedList[3]
		local var4 = getImageSprite(arg0:findTF(var3, arg0.selectedIconResTF))

		setImageSprite(arg0.mainToggleSelectedTF[3], var4, true)
		setActive(arg0.mainToggleSelectedTF[3], true)
	end

	if arg0.selectedList[4] and arg0.selectedList[4] > 0 then
		local var5 = 4 .. arg0.selectedList[4]
		local var6 = getImageSprite(arg0:findTF(var5, arg0.selectedIconResTF))

		setImageSprite(arg0.mainToggleSelectedTF[4], var6, true)
		setActive(arg0.mainToggleSelectedTF[4], true)
	end

	if arg0.selectedList[5] and arg0.selectedList[5] > 0 then
		local var7 = 5 .. arg0.selectedList[5]
		local var8 = getImageSprite(arg0:findTF(var7, arg0.selectedIconResTF))

		setImageSprite(arg0.mainToggleSelectedTF[5], var8, true)
		setActive(arg0.mainToggleSelectedTF[5], true)
	end

	if arg0.selectedList[6] and arg0.selectedList[6] > 0 then
		local var9 = 6 .. arg0.selectedList[6]
		local var10 = getImageSprite(arg0:findTF(var9, arg0.selectedIconResTF))

		setImageSprite(arg0.mainToggleSelectedTF[6], var10, true)
		setActive(arg0.mainToggleSelectedTF[6], true)
	end
end

function var0.isFinished(arg0)
	return #arg0.activity.data2_list == 6
end

function var0.changeIndexSelect(arg0)
	arg0.selectedList[arg0.curSelectOrder] = arg0.curSelectIndex

	local var0 = var0.Pizza_Save_Tag_Pre .. arg0.curSelectOrder

	PlayerPrefs.SetInt(var0, arg0.curSelectIndex)
end

function var0.getSelectedList(arg0)
	arg0.selectedList = {
		0,
		0,
		0,
		0,
		0,
		0
	}

	for iter0, iter1 in ipairs(arg0.activity.data2_list) do
		arg0.selectedList[iter0] = iter1
	end

	if arg0:isFinished() then
		for iter2 = 1, 6 do
			local var0 = var0.Pizza_Save_Tag_Pre .. iter2
			local var1 = PlayerPrefs.GetInt(var0, 0)

			if var1 > 0 then
				arg0.selectedList[iter2] = var1
			end
		end
	end

	arg0:saveSelectedList()

	return arg0.selectedList
end

function var0.saveSelectedList(arg0)
	for iter0 = 1, 6 do
		local var0 = var0.Pizza_Save_Tag_Pre .. iter0
		local var1 = arg0.selectedList[iter0]

		PlayerPrefs.SetInt(var0, var1)
	end
end

function var0.share(arg0)
	PoolMgr.GetInstance():GetUI("PizzahutSharePage", false, function(arg0)
		local var0 = GameObject.Find("UICamera/Canvas/UIMain")

		SetParent(arg0, var0, false)

		arg0.shareGo = arg0

		local var1 = arg0:findTF("PlayerName", arg0)
		local var2 = arg0:findTF("PizzaContainer", arg0)
		local var3 = getProxy(PlayerProxy):getData().name

		setText(var1, var3)

		local var4 = getProxy(PlayerProxy):getRawData()
		local var5 = getProxy(UserProxy):getRawData()
		local var6 = getProxy(ServerProxy):getRawData()[var5 and var5.server or 0]
		local var7 = var4 and var4.name or ""
		local var8 = var6 and var6.name or ""
		local var9 = arg0:findTF("deck", arg0)

		setText(var9:Find("name/value"), var7)
		setText(var9:Find("server/value"), var8)
		setText(var9:Find("lv/value"), var4.level)

		local var10 = cloneTplTo(arg0.pizzaTF, var2)

		setLocalPosition(tf(var10), {
			x = 0,
			y = 0
		})
		setLocalScale(tf(var10), {
			x = 1.4,
			y = 1.4
		})
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePizzahut)

		if arg0.shareGo then
			PoolMgr.GetInstance():ReturnUI("PizzahutSharePage", arg0.shareGo)

			arg0.shareGo = nil
		end
	end)
end

function var0.initSD(arg0)
	arg0.sdContainer = arg0:findTF("sdcontainer", arg0.bg)
	arg0.spine = nil
	arg0.spineLRQ = GetSpineRequestPackage.New("chuixue_6", function(arg0)
		SetParent(arg0, arg0.sdContainer)

		arg0.spine = arg0
		arg0.spine.transform.localScale = Vector3.one

		local var0 = arg0.spine:GetComponent("SpineAnimUI")

		if var0 then
			var0:SetAction("stand", 0)
		end

		arg0.spineLRQ = nil
	end):Start()

	setActive(arg0.sdContainer, true)
end

function var0.showBubble(arg0, arg1)
	local var0

	if not arg1 then
		if isActive(arg0.battleBtn) then
			var0 = i18n("sofmapsd_1")
		elseif isActive(arg0.getBtn) then
			var0 = i18n("sofmapsd_2")
		elseif isActive(arg0.gotBtn) then
			var0 = i18n("sofmapsd_4")
		end
	else
		var0 = arg1
	end

	setText(arg0.bubbleText, var0)

	local function var1(arg0)
		arg0.bubbleCG.alpha = arg0

		setLocalScale(arg0.bubble, Vector3.one * arg0)
	end

	local function var2()
		LeanTween.value(go(arg0.bubble), 1, 0, var0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var1)):setOnComplete(System.Action(function()
			setActive(arg0.bubble, false)
		end))
	end

	LeanTween.cancel(go(arg0.bubble))
	setActive(arg0.bubble, true)
	LeanTween.value(go(arg0.bubble), 0, 1, var0.FADE_TIME):setOnUpdate(System.Action_float(var1)):setOnComplete(System.Action(function()
		LeanTween.delayedCall(go(arg0.bubble), var0.SHOW_TIME, System.Action(var2))
	end))
end

return var0
