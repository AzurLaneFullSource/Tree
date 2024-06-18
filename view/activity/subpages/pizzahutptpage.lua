local var0_0 = class("PizzahutPTPage", import(".TemplatePage.PtTemplatePage"))

var0_0.FADE_TIME = 0.5
var0_0.SHOW_TIME = 1
var0_0.FADE_OUT_TIME = 0.5
var0_0.Menu_Ani_Open_Time = 0.5
var0_0.Menu_Ani_Close_Time = 0.3
var0_0.PosList = {
	-256,
	-150,
	-50,
	55,
	160,
	263
}
var0_0.Pizza_Save_Tag_Pre = "Pizza_Tag_"

function var0_0.OnDataSetting(arg0_1)
	var0_0.super.OnDataSetting(arg0_1)

	arg0_1.specialPhaseList = arg0_1.activity:getConfig("config_data")
	arg0_1.selectedList = arg0_1:getSelectedList()
	arg0_1.curSelectOrder = 0
	arg0_1.curSelectIndex = 0
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	arg0_2:findUI()
	arg0_2:initMainPanel()
	arg0_2:addListener()
	arg0_2:initSD()
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)

	local var0_3, var1_3, var2_3 = arg0_3.ptData:GetResProgress()

	setText(arg0_3.progress, (var2_3 >= 1 and setColorStr(var0_3, "#947D80FF") or var0_3) .. "/" .. var1_3)
	arg0_3:updatePizza()
	arg0_3:updateMainSelectPanel()
	setActive(arg0_3.openBtn, arg0_3:isFinished())
	setActive(arg0_3.shareBtn, arg0_3:isFinished())
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_5)
	if arg0_5.spine then
		arg0_5.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar("chuixue_6", arg0_5.spine)

		arg0_5.spine = nil
	end

	if arg0_5.shareGo then
		PoolMgr.GetInstance():ReturnUI("PizzahutSharePage", arg0_5.shareGo)

		arg0_5.shareGo = nil
	end
end

function var0_0.findUI(arg0_6)
	arg0_6.shareBtn = arg0_6:findTF("share_btn", arg0_6.bg)
	arg0_6.empty = arg0_6:findTF("empty", arg0_6.bg)
	arg0_6.pizzaTF = arg0_6:findTF("Pizza", arg0_6.bg)
	arg0_6.openBtn = arg0_6:findTF("open_btn", arg0_6.bg)
	arg0_6.helpBtn = arg0_6:findTF("help_btn", arg0_6.bg)
	arg0_6.specialTF = arg0_6:findTF("Special")
	arg0_6.backBG = arg0_6:findTF("BG", arg0_6.specialTF)
	arg0_6.closeBtn = arg0_6:findTF("CloseBtn", arg0_6.specialTF)
	arg0_6.menuTF = arg0_6:findTF("Menu", arg0_6.specialTF)
	arg0_6.mainPanel = arg0_6:findTF("MainPanel", arg0_6.menuTF)
	arg0_6.mainToggleTFList = {}

	for iter0_6 = 1, 6 do
		arg0_6.mainToggleTFList[iter0_6] = arg0_6.mainPanel:GetChild(iter0_6 - 1)
	end

	arg0_6.secondPanel = arg0_6:findTF("SecondList", arg0_6.menuTF)
	arg0_6.selectBtn = arg0_6:findTF("SelectBtn", arg0_6.menuTF)
	arg0_6.mainPanelCG = GetComponent(arg0_6.mainPanel, "CanvasGroup")
	arg0_6.secondPanelCG = GetComponent(arg0_6.secondPanel, "CanvasGroup")
	arg0_6.selectBtnImg = GetComponent(arg0_6.selectBtn, "Image")
	arg0_6.resTF = arg0_6:findTF("Res")

	local var0_6 = arg0_6:findTF("1/1", arg0_6.resTF)
	local var1_6 = arg0_6:findTF("1/2", arg0_6.resTF)
	local var2_6 = arg0_6:findTF("1/3", arg0_6.resTF)
	local var3_6 = arg0_6:findTF("2/1/1", arg0_6.resTF)
	local var4_6 = arg0_6:findTF("2/1/2", arg0_6.resTF)
	local var5_6 = arg0_6:findTF("2/1/3", arg0_6.resTF)
	local var6_6 = arg0_6:findTF("2/2/1", arg0_6.resTF)
	local var7_6 = arg0_6:findTF("2/2/2", arg0_6.resTF)
	local var8_6 = arg0_6:findTF("2/2/3", arg0_6.resTF)
	local var9_6 = arg0_6:findTF("2/3/1", arg0_6.resTF)
	local var10_6 = arg0_6:findTF("2/3/2", arg0_6.resTF)
	local var11_6 = arg0_6:findTF("2/3/3", arg0_6.resTF)
	local var12_6 = arg0_6:findTF("3/1/1", arg0_6.resTF)
	local var13_6 = arg0_6:findTF("3/1/2", arg0_6.resTF)
	local var14_6 = arg0_6:findTF("3/1/3", arg0_6.resTF)
	local var15_6 = arg0_6:findTF("3/2/1", arg0_6.resTF)
	local var16_6 = arg0_6:findTF("3/2/2", arg0_6.resTF)
	local var17_6 = arg0_6:findTF("3/2/3", arg0_6.resTF)
	local var18_6 = arg0_6:findTF("3/3/1", arg0_6.resTF)
	local var19_6 = arg0_6:findTF("3/3/2", arg0_6.resTF)
	local var20_6 = arg0_6:findTF("3/3/3", arg0_6.resTF)
	local var21_6 = arg0_6:findTF("4/1", arg0_6.resTF)
	local var22_6 = arg0_6:findTF("4/2", arg0_6.resTF)
	local var23_6 = arg0_6:findTF("4/3", arg0_6.resTF)
	local var24_6 = arg0_6:findTF("5/1", arg0_6.resTF)
	local var25_6 = arg0_6:findTF("5/2", arg0_6.resTF)
	local var26_6 = arg0_6:findTF("5/3", arg0_6.resTF)
	local var27_6 = arg0_6:findTF("6/1", arg0_6.resTF)
	local var28_6 = arg0_6:findTF("6/2", arg0_6.resTF)
	local var29_6 = arg0_6:findTF("6/3", arg0_6.resTF)

	arg0_6.iconTable = {
		["1"] = {
			var0_6,
			var1_6,
			var2_6
		},
		["21"] = {
			var3_6,
			var4_6,
			var5_6
		},
		["22"] = {
			var6_6,
			var7_6,
			var8_6
		},
		["23"] = {
			var9_6,
			var10_6,
			var11_6
		},
		["311"] = {
			var12_6
		},
		["312"] = {
			var13_6
		},
		["313"] = {
			var14_6
		},
		["321"] = {
			var15_6
		},
		["322"] = {
			var16_6
		},
		["323"] = {
			var17_6
		},
		["331"] = {
			var18_6
		},
		["332"] = {
			var19_6
		},
		["333"] = {
			var20_6
		},
		["4"] = {
			var21_6,
			var22_6,
			var23_6
		},
		["5"] = {
			var24_6,
			var25_6,
			var26_6
		},
		["6"] = {
			var27_6,
			var28_6,
			var29_6
		}
	}
	arg0_6.pizzaResTF = arg0_6:findTF("Pizza")
	arg0_6.mainToggleSelectedTF = {}

	for iter1_6, iter2_6 in ipairs(arg0_6.mainToggleTFList) do
		arg0_6.mainToggleSelectedTF[iter1_6] = iter2_6:GetChild(0)
	end

	arg0_6.selectedIconResTF = arg0_6:findTF("SelectedIcon")
end

function var0_0.addListener(arg0_7)
	onButton(arg0_7, arg0_7.getBtn, function()
		local var0_8, var1_8, var2_8 = arg0_7.ptData:GetLevelProgress()
		local var3_8 = table.indexof(arg0_7.specialPhaseList, var0_8, 1)

		if var3_8 then
			arg0_7:openMainPanel(var3_8)
		else
			local var4_8 = {}
			local var5_8 = arg0_7.ptData:GetAward()
			local var6_8 = getProxy(PlayerProxy):getData()

			if var5_8.type == DROP_TYPE_RESOURCE and var5_8.id == PlayerConst.ResGold and var6_8:GoldMax(var5_8.count) then
				table.insert(var4_8, function(arg0_9)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
						onYes = arg0_9
					})
				end)
			end

			seriesAsync(var4_8, function()
				local var0_10, var1_10 = arg0_7.ptData:GetResProgress()

				arg0_7:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 1,
					activity_id = arg0_7.ptData:GetId(),
					arg1 = var1_10
				})
			end)
		end
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.openBtn, function()
		arg0_7:openMainPanel()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.pizzahut_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.shareBtn, function()
		arg0_7:share()
	end, SFX_PANEL)
end

function var0_0.initMainPanel(arg0_14)
	onButton(arg0_14, arg0_14.backBG, function()
		arg0_14:closeSpecial()

		if arg0_14:isFinished() then
			setActive(arg0_14.openBtn, true)
		end
	end, SFX_CANCEL)

	for iter0_14, iter1_14 in ipairs(arg0_14.mainToggleTFList) do
		onToggle(arg0_14, iter1_14, function(arg0_16)
			arg0_14.curSelectOrder = iter0_14

			if arg0_16 == true then
				local var0_16 = var0_0.PosList[iter0_14]

				setLocalPosition(arg0_14.secondPanel, {
					x = var0_16
				})
				setLocalPosition(arg0_14.selectBtn, {
					x = var0_16
				})

				local var1_16

				if iter0_14 == 1 then
					var1_16 = arg0_14.iconTable["1"]
				elseif iter0_14 == 2 then
					local var2_16 = 2 .. arg0_14.selectedList[1]

					var1_16 = arg0_14.iconTable[var2_16]
				elseif iter0_14 == 3 then
					local var3_16 = 3 .. arg0_14.selectedList[1] .. arg0_14.selectedList[2]

					var1_16 = arg0_14.iconTable[var3_16]
				elseif iter0_14 >= 4 and iter0_14 <= 6 then
					var1_16 = arg0_14.iconTable[tostring(iter0_14)]
				end

				local var4_16 = {}

				for iter0_16 = 1, 3 do
					var4_16[iter0_16] = arg0_14.secondPanel:GetChild(iter0_16 - 1)
				end

				if #var1_16 == 1 then
					setActive(var4_16[2], false)
					setActive(var4_16[3], false)

					local var5_16 = getImageSprite(var1_16[1])

					setImageSprite(arg0_14:findTF("icon", var4_16[1]), var5_16, true)
					onToggle(arg0_14, var4_16[1], function(arg0_17)
						if arg0_17 == true then
							arg0_14:openSelectBtn()

							arg0_14.curSelectIndex = 1
						end
					end, SFX_PANEL)
					triggerToggle(var4_16[1], true)
				else
					setActive(var4_16[2], true)
					setActive(var4_16[3], true)

					for iter1_16 = 1, 3 do
						local var6_16 = getImageSprite(var1_16[iter1_16])

						setImageSprite(arg0_14:findTF("icon", var4_16[iter1_16]), var6_16, true)
						onToggle(arg0_14, var4_16[iter1_16], function(arg0_18)
							if arg0_18 == true then
								arg0_14:openSelectBtn()

								arg0_14.curSelectIndex = iter1_16
							else
								setActive(arg0_14.selectBtn, false)

								arg0_14.curSelectIndex = 0
							end
						end, SFX_PANEL)
					end
				end

				for iter2_16 = 1, 3 do
					triggerToggle(var4_16[iter2_16], false)
				end

				arg0_14:openSecondPanel()
				setActive(arg0_14.selectBtn, false)
			else
				setActive(arg0_14.secondPanel, false)
				setActive(arg0_14.selectBtn, false)
			end

			arg0_14:updateMainSelectPanel()
		end, SFX_PANEL)
	end

	onButton(arg0_14, arg0_14.selectBtn, function()
		if not arg0_14:isFinished() then
			if arg0_14.curSelectIndex then
				local var0_19, var1_19 = arg0_14.ptData:GetResProgress()

				arg0_14:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 1,
					activity_id = arg0_14.ptData:GetId(),
					arg1 = var1_19,
					arg2 = arg0_14.curSelectIndex,
					callback = function()
						arg0_14.selectedList[arg0_14.curSelectOrder] = arg0_14.curSelectIndex

						arg0_14:closeSpecial()
					end
				})
			end
		else
			arg0_14:changeIndexSelect()
			arg0_14:updatePizza()
			arg0_14:updateMainSelectPanel()
		end
	end, SFX_PANEL)
end

function var0_0.openMainPanel(arg0_21, arg1_21)
	arg0_21.selectedList = arg0_21:getSelectedList()

	setActive(arg0_21.openBtn, false)

	for iter0_21 = 1, 6 do
		triggerToggle(arg0_21.mainToggleTFList[iter0_21], false)

		GetComponent(arg0_21.mainToggleTFList[iter0_21], "Toggle").interactable = arg0_21:isFinished()
	end

	arg0_21:updateMainSelectPanel()
	setActive(arg0_21.specialTF, true)
	LeanTween.value(go(arg0_21.mainPanel), 0, 1, var0_0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0_22)
		arg0_21.mainPanelCG.alpha = arg0_22
	end)):setOnComplete(System.Action(function()
		arg0_21.mainPanelCG.alpha = 1
	end))
	LeanTween.value(go(arg0_21.mainPanel), -640, 0, var0_0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0_24)
		setLocalPosition(arg0_21.mainPanel, {
			x = arg0_24
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0_21.mainPanel, {
			x = 0
		})

		if arg1_21 and arg1_21 > 0 then
			triggerToggle(arg0_21.mainToggleTFList[arg1_21], true)
		end
	end))
end

function var0_0.closeMainPanel(arg0_26)
	LeanTween.value(go(arg0_26.mainPanel), 1, 0, var0_0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0_27)
		arg0_26.mainPanelCG.alpha = arg0_27
	end)):setOnComplete(System.Action(function()
		arg0_26.mainPanelCG.alpha = 0

		setActive(arg0_26.specialTF, false)
	end))
	LeanTween.value(go(arg0_26.mainPanel), 0, -640, var0_0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0_29)
		setLocalPosition(arg0_26.mainPanel, {
			x = arg0_29
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0_26.mainPanel, {
			x = -640
		})
		setActive(arg0_26.specialTF, false)
	end))
end

function var0_0.openSecondPanel(arg0_31)
	setActive(arg0_31.secondPanel, true)
	LeanTween.value(go(arg0_31.secondPanel), 0, 1, var0_0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0_32)
		arg0_31.secondPanelCG.alpha = arg0_32
	end)):setOnComplete(System.Action(function()
		arg0_31.secondPanelCG.alpha = 1
	end))
	LeanTween.value(go(arg0_31.secondPanel), -530, -60, var0_0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0_34)
		setLocalPosition(arg0_31.secondPanel, {
			y = arg0_34
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0_31.secondPanel, {
			y = -60
		})
	end))
end

function var0_0.closeSecondPanel(arg0_36)
	LeanTween.value(go(arg0_36.secondPanel), 1, 0, var0_0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0_37)
		arg0_36.secondPanelCG.alpha = arg0_37
	end)):setOnComplete(System.Action(function()
		arg0_36.secondPanelCG.alpha = 0

		setActive(arg0_36.secondPanel, false)
	end))
	LeanTween.value(go(arg0_36.secondPanel), -60, -530, var0_0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0_39)
		setLocalPosition(arg0_36.secondPanel, {
			y = arg0_39
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0_36.secondPanel, {
			y = -530
		})
		setActive(arg0_36.secondPanel, false)
		arg0_36:closeMainPanel()
	end))
end

function var0_0.openSelectBtn(arg0_41)
	setActive(arg0_41.selectBtn, true)
	LeanTween.value(go(arg0_41.selectBtn), 0, 1, var0_0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0_42)
		setImageAlpha(arg0_41.selectBtn, arg0_42)
	end)):setOnComplete(System.Action(function()
		setImageAlpha(arg0_41.selectBtn, 1)
	end))
	LeanTween.value(go(arg0_41.selectBtn), -145, -210, var0_0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0_44)
		setLocalPosition(arg0_41.selectBtn, {
			y = arg0_44
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0_41.selectBtn, {
			y = -210
		})
	end))
end

function var0_0.closeSelectBtn(arg0_46)
	LeanTween.value(go(arg0_46.selectBtn), 1, 0, var0_0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0_47)
		setImageAlpha(arg0_46.selectBtn, arg0_47)
	end)):setOnComplete(System.Action(function()
		setImageAlpha(arg0_46.selectBtn, 0)
		setActive(arg0_46.selectBtn, false)
	end))
	LeanTween.value(go(arg0_46.selectBtn), -210, -145, var0_0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0_49)
		setLocalPosition(arg0_46.selectBtn, {
			y = arg0_49
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0_46.selectBtn, {
			y = -145
		})
		setActive(arg0_46.selectBtn, false)
	end))
end

function var0_0.closeSpecial(arg0_51)
	arg0_51:closeSelectBtn()
	arg0_51:closeSecondPanel()
end

function var0_0.updatePizza(arg0_52)
	setActive(arg0_52.empty, arg0_52.selectedList[1] == 0)
	setActive(arg0_52.pizzaTF, arg0_52.selectedList[1] > 0)

	local var0_52 = arg0_52:findTF("PizzaPan", arg0_52.pizzaTF)
	local var1_52 = arg0_52:findTF("PizzaSauce", arg0_52.pizzaTF)
	local var2_52 = arg0_52:findTF("PizzaCheese", arg0_52.pizzaTF)
	local var3_52 = arg0_52:findTF("EX1", arg0_52.pizzaTF)
	local var4_52 = arg0_52:findTF("EX2", arg0_52.pizzaTF)
	local var5_52 = arg0_52:findTF("EX3", arg0_52.pizzaTF)

	setActive(var0_52, arg0_52.selectedList[1] and arg0_52.selectedList[1] > 0)
	setActive(var1_52, arg0_52.selectedList[2] and arg0_52.selectedList[2] > 0)
	setActive(var2_52, arg0_52.selectedList[3] and arg0_52.selectedList[3] > 0)
	setActive(var3_52, arg0_52.selectedList[4] and arg0_52.selectedList[4] > 0)
	setActive(var4_52, arg0_52.selectedList[5] and arg0_52.selectedList[5] > 0)
	setActive(var5_52, arg0_52.selectedList[6] and arg0_52.selectedList[6] > 0)

	if arg0_52.selectedList[1] and arg0_52.selectedList[1] > 0 then
		local var6_52 = getImageSprite(arg0_52:findTF(tostring(arg0_52.selectedList[1]), arg0_52.pizzaResTF))

		setImageSprite(var0_52, var6_52, true)
	end

	if arg0_52.selectedList[2] and arg0_52.selectedList[2] > 0 then
		local var7_52 = arg0_52.selectedList[1] .. arg0_52.selectedList[2]
		local var8_52 = getImageSprite(arg0_52:findTF(var7_52, arg0_52.pizzaResTF))

		setImageSprite(var1_52, var8_52, true)
	end

	if arg0_52.selectedList[3] and arg0_52.selectedList[3] > 0 then
		local var9_52 = arg0_52.selectedList[1] .. arg0_52.selectedList[2] .. arg0_52.selectedList[3]
		local var10_52 = getImageSprite(arg0_52:findTF(var9_52, arg0_52.pizzaResTF))

		setImageSprite(var2_52, var10_52, true)
	end

	if arg0_52.selectedList[4] and arg0_52.selectedList[4] > 0 then
		local var11_52 = 4 .. arg0_52.selectedList[4]
		local var12_52 = getImageSprite(arg0_52:findTF(var11_52, arg0_52.pizzaResTF))

		setImageSprite(var3_52, var12_52, true)
	end

	if arg0_52.selectedList[5] and arg0_52.selectedList[5] > 0 then
		local var13_52 = 5 .. arg0_52.selectedList[5]
		local var14_52 = getImageSprite(arg0_52:findTF(var13_52, arg0_52.pizzaResTF))

		setImageSprite(var4_52, var14_52, true)
	end

	if arg0_52.selectedList[6] and arg0_52.selectedList[6] > 0 then
		local var15_52 = 6 .. arg0_52.selectedList[6]
		local var16_52 = getImageSprite(arg0_52:findTF(var15_52, arg0_52.pizzaResTF))

		setImageSprite(var5_52, var16_52, true)
	end
end

function var0_0.updateMainSelectPanel(arg0_53)
	if arg0_53.selectedList[1] and arg0_53.selectedList[1] > 0 then
		local var0_53 = getImageSprite(arg0_53:findTF(tostring(arg0_53.selectedList[1]), arg0_53.selectedIconResTF))

		setImageSprite(arg0_53.mainToggleSelectedTF[1], var0_53, true)
		setActive(arg0_53.mainToggleSelectedTF[1], true)
	end

	if arg0_53.selectedList[2] and arg0_53.selectedList[2] > 0 then
		local var1_53 = arg0_53.selectedList[1] .. arg0_53.selectedList[2]
		local var2_53 = getImageSprite(arg0_53:findTF(var1_53, arg0_53.selectedIconResTF))

		setImageSprite(arg0_53.mainToggleSelectedTF[2], var2_53, true)
		setActive(arg0_53.mainToggleSelectedTF[2], true)
	end

	if arg0_53.selectedList[3] and arg0_53.selectedList[3] > 0 then
		local var3_53 = arg0_53.selectedList[1] .. arg0_53.selectedList[2] .. arg0_53.selectedList[3]
		local var4_53 = getImageSprite(arg0_53:findTF(var3_53, arg0_53.selectedIconResTF))

		setImageSprite(arg0_53.mainToggleSelectedTF[3], var4_53, true)
		setActive(arg0_53.mainToggleSelectedTF[3], true)
	end

	if arg0_53.selectedList[4] and arg0_53.selectedList[4] > 0 then
		local var5_53 = 4 .. arg0_53.selectedList[4]
		local var6_53 = getImageSprite(arg0_53:findTF(var5_53, arg0_53.selectedIconResTF))

		setImageSprite(arg0_53.mainToggleSelectedTF[4], var6_53, true)
		setActive(arg0_53.mainToggleSelectedTF[4], true)
	end

	if arg0_53.selectedList[5] and arg0_53.selectedList[5] > 0 then
		local var7_53 = 5 .. arg0_53.selectedList[5]
		local var8_53 = getImageSprite(arg0_53:findTF(var7_53, arg0_53.selectedIconResTF))

		setImageSprite(arg0_53.mainToggleSelectedTF[5], var8_53, true)
		setActive(arg0_53.mainToggleSelectedTF[5], true)
	end

	if arg0_53.selectedList[6] and arg0_53.selectedList[6] > 0 then
		local var9_53 = 6 .. arg0_53.selectedList[6]
		local var10_53 = getImageSprite(arg0_53:findTF(var9_53, arg0_53.selectedIconResTF))

		setImageSprite(arg0_53.mainToggleSelectedTF[6], var10_53, true)
		setActive(arg0_53.mainToggleSelectedTF[6], true)
	end
end

function var0_0.isFinished(arg0_54)
	return #arg0_54.activity.data2_list == 6
end

function var0_0.changeIndexSelect(arg0_55)
	arg0_55.selectedList[arg0_55.curSelectOrder] = arg0_55.curSelectIndex

	local var0_55 = var0_0.Pizza_Save_Tag_Pre .. arg0_55.curSelectOrder

	PlayerPrefs.SetInt(var0_55, arg0_55.curSelectIndex)
end

function var0_0.getSelectedList(arg0_56)
	arg0_56.selectedList = {
		0,
		0,
		0,
		0,
		0,
		0
	}

	for iter0_56, iter1_56 in ipairs(arg0_56.activity.data2_list) do
		arg0_56.selectedList[iter0_56] = iter1_56
	end

	if arg0_56:isFinished() then
		for iter2_56 = 1, 6 do
			local var0_56 = var0_0.Pizza_Save_Tag_Pre .. iter2_56
			local var1_56 = PlayerPrefs.GetInt(var0_56, 0)

			if var1_56 > 0 then
				arg0_56.selectedList[iter2_56] = var1_56
			end
		end
	end

	arg0_56:saveSelectedList()

	return arg0_56.selectedList
end

function var0_0.saveSelectedList(arg0_57)
	for iter0_57 = 1, 6 do
		local var0_57 = var0_0.Pizza_Save_Tag_Pre .. iter0_57
		local var1_57 = arg0_57.selectedList[iter0_57]

		PlayerPrefs.SetInt(var0_57, var1_57)
	end
end

function var0_0.share(arg0_58)
	PoolMgr.GetInstance():GetUI("PizzahutSharePage", false, function(arg0_59)
		local var0_59 = GameObject.Find("UICamera/Canvas/UIMain")

		SetParent(arg0_59, var0_59, false)

		arg0_58.shareGo = arg0_59

		local var1_59 = arg0_58:findTF("PlayerName", arg0_59)
		local var2_59 = arg0_58:findTF("PizzaContainer", arg0_59)
		local var3_59 = getProxy(PlayerProxy):getData().name

		setText(var1_59, var3_59)

		local var4_59 = getProxy(PlayerProxy):getRawData()
		local var5_59 = getProxy(UserProxy):getRawData()
		local var6_59 = getProxy(ServerProxy):getRawData()[var5_59 and var5_59.server or 0]
		local var7_59 = var4_59 and var4_59.name or ""
		local var8_59 = var6_59 and var6_59.name or ""
		local var9_59 = arg0_58:findTF("deck", arg0_59)

		setText(var9_59:Find("name/value"), var7_59)
		setText(var9_59:Find("server/value"), var8_59)
		setText(var9_59:Find("lv/value"), var4_59.level)

		local var10_59 = cloneTplTo(arg0_58.pizzaTF, var2_59)

		setLocalPosition(tf(var10_59), {
			x = 0,
			y = 0
		})
		setLocalScale(tf(var10_59), {
			x = 1.4,
			y = 1.4
		})
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePizzahut)

		if arg0_58.shareGo then
			PoolMgr.GetInstance():ReturnUI("PizzahutSharePage", arg0_58.shareGo)

			arg0_58.shareGo = nil
		end
	end)
end

function var0_0.initSD(arg0_60)
	arg0_60.sdContainer = arg0_60:findTF("sdcontainer", arg0_60.bg)
	arg0_60.spine = nil
	arg0_60.spineLRQ = GetSpineRequestPackage.New("chuixue_6", function(arg0_61)
		SetParent(arg0_61, arg0_60.sdContainer)

		arg0_60.spine = arg0_61
		arg0_60.spine.transform.localScale = Vector3.one

		local var0_61 = arg0_60.spine:GetComponent("SpineAnimUI")

		if var0_61 then
			var0_61:SetAction("stand", 0)
		end

		arg0_60.spineLRQ = nil
	end):Start()

	setActive(arg0_60.sdContainer, true)
end

function var0_0.showBubble(arg0_62, arg1_62)
	local var0_62

	if not arg1_62 then
		if isActive(arg0_62.battleBtn) then
			var0_62 = i18n("sofmapsd_1")
		elseif isActive(arg0_62.getBtn) then
			var0_62 = i18n("sofmapsd_2")
		elseif isActive(arg0_62.gotBtn) then
			var0_62 = i18n("sofmapsd_4")
		end
	else
		var0_62 = arg1_62
	end

	setText(arg0_62.bubbleText, var0_62)

	local function var1_62(arg0_63)
		arg0_62.bubbleCG.alpha = arg0_63

		setLocalScale(arg0_62.bubble, Vector3.one * arg0_63)
	end

	local function var2_62()
		LeanTween.value(go(arg0_62.bubble), 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var1_62)):setOnComplete(System.Action(function()
			setActive(arg0_62.bubble, false)
		end))
	end

	LeanTween.cancel(go(arg0_62.bubble))
	setActive(arg0_62.bubble, true)
	LeanTween.value(go(arg0_62.bubble), 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var1_62)):setOnComplete(System.Action(function()
		LeanTween.delayedCall(go(arg0_62.bubble), var0_0.SHOW_TIME, System.Action(var2_62))
	end))
end

return var0_0
