local var0_0 = class("IcecreamPTPage", import(".TemplatePage.PtTemplatePage"))

var0_0.FADE_TIME = 0.5
var0_0.SHOW_TIME = 1
var0_0.FADE_OUT_TIME = 0.5
var0_0.Menu_Ani_Open_Time = 0.5
var0_0.Menu_Ani_Close_Time = 0.3
var0_0.PosList = {
	188,
	70,
	-55,
	-178
}
var0_0.Icecream_Save_Tag_Pre = "Icecream_Tag_"

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

	local var0_3, var1_3, var2_3 = arg0_3.ptData:GetLevelProgress()

	setText(arg0_3.step, var0_3)

	if isActive(arg0_3.specialTF) then
		setActive(arg0_3.specialTF, false)
	end

	arg0_3:updateIcecream()
	arg0_3:updateMainSelectPanel()
	setActive(arg0_3.openBtn, arg0_3:isFinished())
	setActive(arg0_3.shareBtn, arg0_3:isFinished())
end

function var0_0.OnDestroy(arg0_4)
	if arg0_4.spine then
		arg0_4.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar("salatuojia_8", arg0_4.spine)

		arg0_4.spine = nil
	end

	if arg0_4.shareGo then
		PoolMgr.GetInstance():ReturnUI("IcecreamSharePage", arg0_4.shareGo)

		arg0_4.shareGo = nil
	end
end

function var0_0.findUI(arg0_5)
	arg0_5.shareBtn = arg0_5:findTF("Logo/share_btn", arg0_5.bg)
	arg0_5.icecreamTF = arg0_5:findTF("Icecream", arg0_5.bg)
	arg0_5.openBtn = arg0_5:findTF("open_btn", arg0_5.bg)
	arg0_5.helpBtn = arg0_5:findTF("help_btn", arg0_5.bg)
	arg0_5.specialTF = arg0_5:findTF("Special")
	arg0_5.backBG = arg0_5:findTF("BG", arg0_5.specialTF)
	arg0_5.menuTF = arg0_5:findTF("Menu", arg0_5.specialTF)
	arg0_5.mainPanel = arg0_5:findTF("MainPanel", arg0_5.menuTF)
	arg0_5.mainToggleTFList = {}

	for iter0_5 = 1, 4 do
		arg0_5.mainToggleTFList[iter0_5] = arg0_5.mainPanel:GetChild(iter0_5 - 1)
	end

	arg0_5.secondPanel = arg0_5:findTF("SecondList", arg0_5.menuTF)
	arg0_5.selectBtn = arg0_5:findTF("SelectBtn", arg0_5.menuTF)
	arg0_5.mainPanelCG = GetComponent(arg0_5.mainPanel, "CanvasGroup")
	arg0_5.secondPanelCG = GetComponent(arg0_5.secondPanel, "CanvasGroup")
	arg0_5.selectBtnImg = GetComponent(arg0_5.selectBtn, "Image")
	arg0_5.resTF = arg0_5:findTF("Res")

	local var0_5 = arg0_5:findTF("1/1", arg0_5.resTF)
	local var1_5 = arg0_5:findTF("1/2", arg0_5.resTF)
	local var2_5 = arg0_5:findTF("1/3", arg0_5.resTF)
	local var3_5 = arg0_5:findTF("2/1/1", arg0_5.resTF)
	local var4_5 = arg0_5:findTF("2/1/2", arg0_5.resTF)
	local var5_5 = arg0_5:findTF("2/1/3", arg0_5.resTF)
	local var6_5 = arg0_5:findTF("2/2/1", arg0_5.resTF)
	local var7_5 = arg0_5:findTF("2/2/2", arg0_5.resTF)
	local var8_5 = arg0_5:findTF("2/2/3", arg0_5.resTF)
	local var9_5 = arg0_5:findTF("2/3/1", arg0_5.resTF)
	local var10_5 = arg0_5:findTF("2/3/2", arg0_5.resTF)
	local var11_5 = arg0_5:findTF("2/3/3", arg0_5.resTF)
	local var12_5 = arg0_5:findTF("3/1", arg0_5.resTF)
	local var13_5 = arg0_5:findTF("3/2", arg0_5.resTF)
	local var14_5 = arg0_5:findTF("3/3", arg0_5.resTF)
	local var15_5 = arg0_5:findTF("4/1", arg0_5.resTF)
	local var16_5 = arg0_5:findTF("4/2", arg0_5.resTF)
	local var17_5 = arg0_5:findTF("4/3", arg0_5.resTF)

	arg0_5.iconTable = {
		["1"] = {
			var0_5,
			var1_5,
			var2_5
		},
		["21"] = {
			var3_5,
			var4_5,
			var5_5
		},
		["22"] = {
			var6_5,
			var7_5,
			var8_5
		},
		["23"] = {
			var9_5,
			var10_5,
			var11_5
		},
		["3"] = {
			var12_5,
			var13_5,
			var14_5
		},
		["4"] = {
			var15_5,
			var16_5,
			var17_5
		}
	}
	arg0_5.icecreamResTF = arg0_5:findTF("Icecream")
	arg0_5.mainToggleSelectedTF = {}
	arg0_5.mainToggleUnlockTF = {}

	for iter1_5, iter2_5 in ipairs(arg0_5.mainToggleTFList) do
		arg0_5.mainToggleSelectedTF[iter1_5] = iter2_5:GetChild(1)
		arg0_5.mainToggleUnlockTF[iter1_5] = iter2_5:GetChild(0)
	end
end

function var0_0.addListener(arg0_6)
	if IsUnityEditor then
		local var0_6 = arg0_6:findTF("Logo", arg0_6.bg)

		onButton(arg0_6, var0_6, function()
			for iter0_7 = 1, 4 do
				local var0_7 = var0_0.Icecream_Save_Tag_Pre .. iter0_7

				PlayerPrefs.SetInt(var0_7, 0)
			end
		end, SFX_PANEL)
	end

	onButton(arg0_6, arg0_6.getBtn, function()
		local var0_8, var1_8, var2_8 = arg0_6.ptData:GetLevelProgress()
		local var3_8 = table.indexof(arg0_6.specialPhaseList, var0_8, 1)

		if var3_8 then
			arg0_6:openMainPanel(var3_8)
		else
			local var4_8 = {}
			local var5_8 = arg0_6.ptData:GetAward()
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
				local var0_10, var1_10 = arg0_6.ptData:GetResProgress()

				arg0_6:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 1,
					activity_id = arg0_6.ptData:GetId(),
					arg1 = var1_10
				})
			end)
		end
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.battleBtn, function()
		arg0_6:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.openBtn, function()
		arg0_6:openMainPanel()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.icecream_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.shareBtn, function()
		arg0_6:share()
	end, SFX_PANEL)
end

function var0_0.initMainPanel(arg0_15)
	onButton(arg0_15, arg0_15.backBG, function()
		arg0_15:closeSpecial()

		if arg0_15:isFinished() then
			setActive(arg0_15.openBtn, true)
		end
	end, SFX_CANCEL)

	for iter0_15, iter1_15 in ipairs(arg0_15.mainToggleTFList) do
		onToggle(arg0_15, iter1_15, function(arg0_17)
			if arg0_17 == true then
				arg0_15.curSelectOrder = iter0_15

				local var0_17 = var0_0.PosList[iter0_15]

				setLocalPosition(arg0_15.secondPanel, {
					y = var0_17
				})
				setLocalPosition(arg0_15.selectBtn, {
					y = var0_17
				})

				local var1_17

				if iter0_15 == 1 then
					var1_17 = arg0_15.iconTable["1"]
				elseif iter0_15 == 2 then
					local var2_17 = 2 .. arg0_15.selectedList[1]

					var1_17 = arg0_15.iconTable[var2_17]
				elseif iter0_15 == 3 then
					var1_17 = arg0_15.iconTable["3"]
				elseif iter0_15 == 4 then
					var1_17 = arg0_15.iconTable["4"]
				end

				local var3_17 = {}

				for iter0_17 = 1, 3 do
					var3_17[iter0_17] = arg0_15.secondPanel:GetChild(iter0_17)
				end

				for iter1_17 = 1, 3 do
					local var4_17 = getImageSprite(var1_17[iter1_17])

					setImageSprite(arg0_15:findTF("icon", var3_17[iter1_17]), var4_17, true)
					onToggle(arg0_15, var3_17[iter1_17], function(arg0_18)
						if arg0_18 == true then
							local var0_18 = Clone(arg0_15.selectedList)

							var0_18[arg0_15.curSelectOrder] = iter1_17

							arg0_15:updateIcecream(var0_18)
							arg0_15:openSelectBtn()

							arg0_15.curSelectIndex = iter1_17
						else
							setActive(arg0_15.selectBtn, false)

							arg0_15.curSelectIndex = 0
						end
					end, SFX_PANEL)
				end

				for iter2_17 = 1, 3 do
					triggerToggle(var3_17[iter2_17], false)
				end

				arg0_15:openSecondPanel()
				setActive(arg0_15.selectBtn, false)
			else
				arg0_15.curSelectOrder = 0

				setActive(arg0_15.secondPanel, false)
				setActive(arg0_15.selectBtn, false)
			end

			arg0_15:updateMainSelectPanel()
		end, SFX_PANEL)
	end

	onButton(arg0_15, arg0_15.selectBtn, function()
		if not arg0_15:isFinished() then
			if arg0_15.curSelectIndex then
				local var0_19, var1_19 = arg0_15.ptData:GetResProgress()

				arg0_15:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 1,
					activity_id = arg0_15.ptData:GetId(),
					arg1 = var1_19,
					arg2 = arg0_15.curSelectIndex,
					callback = function()
						arg0_15.selectedList[arg0_15.curSelectOrder] = arg0_15.curSelectIndex

						arg0_15:closeSpecial()
					end
				})
			end
		else
			arg0_15:changeIndexSelect()
			arg0_15:updateIcecream()
			arg0_15:updateMainSelectPanel()
		end
	end, SFX_PANEL)
end

function var0_0.openMainPanel(arg0_21, arg1_21)
	arg0_21.selectedList = arg0_21:getSelectedList()

	setActive(arg0_21.displayBtn, false)
	setActive(arg0_21.slider, false)
	setActive(arg0_21.awardTF, false)
	setActive(arg0_21.progress, false)

	for iter0_21 = 1, 4 do
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
	LeanTween.value(go(arg0_21.mainPanel), -391, -271, var0_0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0_24)
		setLocalPosition(arg0_21.mainPanel, {
			x = arg0_24
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0_21.mainPanel, {
			x = -271
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
	LeanTween.value(go(arg0_26.mainPanel), -271, -391, var0_0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0_29)
		setLocalPosition(arg0_26.mainPanel, {
			x = arg0_29
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0_26.mainPanel, {
			x = -391
		})
		setActive(arg0_26.specialTF, false)
		arg0_26:updateIcecream()
		setActive(arg0_26.displayBtn, true)
		setActive(arg0_26.slider, true)
		setActive(arg0_26.awardTF, true)
		setActive(arg0_26.progress, true)
	end))
end

function var0_0.openSecondPanel(arg0_31)
	setActive(arg0_31.secondPanel, true)
	LeanTween.value(go(arg0_31.secondPanel), 0, 1, var0_0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0_32)
		arg0_31.secondPanelCG.alpha = arg0_32
	end)):setOnComplete(System.Action(function()
		arg0_31.secondPanelCG.alpha = 1
	end))
	LeanTween.value(go(arg0_31.secondPanel), -646, -213, var0_0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0_34)
		setLocalPosition(arg0_31.secondPanel, {
			x = arg0_34
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0_31.secondPanel, {
			x = -213
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
	LeanTween.value(go(arg0_36.secondPanel), -213, -646, var0_0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0_39)
		setLocalPosition(arg0_36.secondPanel, {
			x = arg0_39
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0_36.secondPanel, {
			x = -646
		})
		setActive(arg0_36.secondPanel, false)
		arg0_36:closeMainPanel()
	end))
end

function var0_0.openSelectBtn(arg0_41)
	setLocalPosition(arg0_41.selectBtn, {
		x = 287
	})
	setActive(arg0_41.selectBtn, true)
	LeanTween.value(go(arg0_41.selectBtn), 0, 1, var0_0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0_42)
		setImageAlpha(arg0_41.selectBtn, arg0_42)
	end)):setOnComplete(System.Action(function()
		setImageAlpha(arg0_41.selectBtn, 1)
	end))
end

function var0_0.closeSelectBtn(arg0_44)
	LeanTween.value(go(arg0_44.selectBtn), 1, 0, var0_0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0_45)
		setImageAlpha(arg0_44.selectBtn, arg0_45)
	end)):setOnComplete(System.Action(function()
		setImageAlpha(arg0_44.selectBtn, 0)
		setActive(arg0_44.selectBtn, false)
	end))
end

function var0_0.closeSpecial(arg0_47)
	arg0_47:closeSelectBtn()
	arg0_47:closeSecondPanel()
end

function var0_0.updateIcecream(arg0_48, arg1_48)
	local var0_48 = arg1_48 or arg0_48.selectedList

	setActive(arg0_48.icecreamTF, var0_48[1] > 0)

	local var1_48 = arg0_48:findTF("1", arg0_48.icecreamTF)
	local var2_48 = arg0_48:findTF("Taste", var1_48)
	local var3_48 = arg0_48:findTF("2", arg0_48.icecreamTF)
	local var4_48 = arg0_48:findTF("3", arg0_48.icecreamTF)
	local var5_48 = arg0_48:findTF("4", arg0_48.icecreamTF)
	local var6_48 = var0_48[1] and var0_48[1] > 0

	if var6_48 then
		for iter0_48, iter1_48 in pairs(var0_48) do
			if iter1_48 > 0 and iter0_48 > 1 then
				var6_48 = false
			end
		end
	end

	setActive(var1_48, var6_48)
	setActive(var3_48, var0_48[2] and var0_48[2] > 0)
	setActive(var4_48, var0_48[3] and var0_48[3] > 0)
	setActive(var5_48, var0_48[4] and var0_48[4] > 0)

	if var6_48 then
		local var7_48 = "1_" .. var0_48[1]
		local var8_48 = getImageSprite(arg0_48:findTF(var7_48, arg0_48.icecreamResTF))

		setImageSprite(var2_48, var8_48, true)
	end

	if var0_48[2] and var0_48[2] > 0 then
		local var9_48 = "2_" .. var0_48[1] .. var0_48[2]
		local var10_48 = getImageSprite(arg0_48:findTF(var9_48, arg0_48.icecreamResTF))

		setImageSprite(var3_48, var10_48, true)
	end

	if var0_48[3] and var0_48[3] > 0 then
		local var11_48 = "3_" .. var0_48[3]
		local var12_48 = getImageSprite(arg0_48:findTF(var11_48, arg0_48.icecreamResTF))

		setImageSprite(var4_48, var12_48, true)
	end

	if var0_48[4] and var0_48[4] > 0 then
		local var13_48 = "4_" .. var0_48[4]
		local var14_48 = getImageSprite(arg0_48:findTF(var13_48, arg0_48.icecreamResTF))

		setImageSprite(var5_48, var14_48, true)
	end
end

function var0_0.updateMainSelectPanel(arg0_49)
	for iter0_49 = 1, 4 do
		setActive(arg0_49.mainToggleUnlockTF[iter0_49], arg0_49.selectedList[iter0_49] and arg0_49.selectedList[iter0_49] > 0)
	end

	if arg0_49.curSelectOrder > 0 then
		setActive(arg0_49.mainToggleUnlockTF[arg0_49.curSelectOrder], true)
	end

	if arg0_49.selectedList[1] and arg0_49.selectedList[1] > 0 then
		local var0_49 = arg0_49.selectedList[1]
		local var1_49 = arg0_49.iconTable["1"][var0_49]
		local var2_49 = getImageSprite(var1_49)

		setImageSprite(arg0_49.mainToggleSelectedTF[1], var2_49, true)
		setActive(arg0_49.mainToggleSelectedTF[1], true)
	else
		setActive(arg0_49.mainToggleSelectedTF[1], false)
	end

	if arg0_49.selectedList[2] and arg0_49.selectedList[2] > 0 then
		local var3_49 = 2 .. arg0_49.selectedList[1]
		local var4_49 = arg0_49.selectedList[2]
		local var5_49 = arg0_49.iconTable[var3_49][var4_49]
		local var6_49 = getImageSprite(var5_49)

		setImageSprite(arg0_49.mainToggleSelectedTF[2], var6_49, true)
		setActive(arg0_49.mainToggleSelectedTF[2], true)
	else
		setActive(arg0_49.mainToggleSelectedTF[2], false)
	end

	if arg0_49.selectedList[3] and arg0_49.selectedList[3] > 0 then
		local var7_49 = arg0_49.selectedList[3]
		local var8_49 = arg0_49.iconTable["3"][var7_49]
		local var9_49 = getImageSprite(var8_49)

		setImageSprite(arg0_49.mainToggleSelectedTF[3], var9_49, true)
		setActive(arg0_49.mainToggleSelectedTF[3], true)
	else
		setActive(arg0_49.mainToggleSelectedTF[3], false)
	end

	if arg0_49.selectedList[4] and arg0_49.selectedList[4] > 0 then
		local var10_49 = arg0_49.selectedList[4]
		local var11_49 = arg0_49.iconTable["4"][var10_49]
		local var12_49 = getImageSprite(var11_49)

		setImageSprite(arg0_49.mainToggleSelectedTF[4], var12_49, true)
		setActive(arg0_49.mainToggleSelectedTF[4], true)
	else
		setActive(arg0_49.mainToggleSelectedTF[4], false)
	end
end

function var0_0.isFinished(arg0_50)
	return #arg0_50.activity.data2_list == 4
end

function var0_0.changeIndexSelect(arg0_51)
	arg0_51.selectedList[arg0_51.curSelectOrder] = arg0_51.curSelectIndex

	local var0_51 = var0_0.Icecream_Save_Tag_Pre .. arg0_51.curSelectOrder

	PlayerPrefs.SetInt(var0_51, arg0_51.curSelectIndex)
end

function var0_0.getSelectedList(arg0_52)
	arg0_52.selectedList = {
		0,
		0,
		0,
		0
	}

	for iter0_52, iter1_52 in ipairs(arg0_52.activity.data2_list) do
		arg0_52.selectedList[iter0_52] = iter1_52
	end

	if arg0_52:isFinished() then
		for iter2_52 = 1, 4 do
			local var0_52 = var0_0.Icecream_Save_Tag_Pre .. iter2_52
			local var1_52 = PlayerPrefs.GetInt(var0_52, 0)

			if var1_52 > 0 then
				arg0_52.selectedList[iter2_52] = var1_52
			end
		end
	end

	arg0_52:saveSelectedList()

	return arg0_52.selectedList
end

function var0_0.saveSelectedList(arg0_53)
	for iter0_53 = 1, 4 do
		local var0_53 = var0_0.Icecream_Save_Tag_Pre .. iter0_53
		local var1_53 = arg0_53.selectedList[iter0_53]

		PlayerPrefs.SetInt(var0_53, var1_53)
	end
end

function var0_0.share(arg0_54)
	PoolMgr.GetInstance():GetUI("IcecreamSharePage", false, function(arg0_55)
		local var0_55 = GameObject.Find("UICamera/Canvas/UIMain")

		SetParent(arg0_55, var0_55, false)

		arg0_54.shareGo = arg0_55

		local var1_55 = arg0_54:findTF("PlayerName", arg0_55)
		local var2_55 = arg0_54:findTF("IcecreamContainer", arg0_55)
		local var3_55 = getProxy(PlayerProxy):getData().name

		setText(var1_55, i18n("icecream_make_tip", var3_55))

		local var4_55 = getProxy(PlayerProxy):getRawData()
		local var5_55 = getProxy(UserProxy):getRawData()
		local var6_55 = getProxy(ServerProxy):getRawData()[var5_55 and var5_55.server or 0]
		local var7_55 = var4_55 and var4_55.name or ""
		local var8_55 = var6_55 and var6_55.name or ""
		local var9_55 = arg0_54:findTF("deck", arg0_55)

		setText(var9_55:Find("name/value"), var7_55)
		setText(var9_55:Find("server/value"), var8_55)
		setText(var9_55:Find("lv/value"), var4_55.level)

		local var10_55 = cloneTplTo(arg0_54.icecreamTF, var2_55)

		setLocalPosition(tf(var10_55), {
			x = 0,
			y = 0
		})
		setLocalScale(tf(var10_55), {
			x = 1.4,
			y = 1.4
		})
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeIcecream)

		if arg0_54.shareGo then
			PoolMgr.GetInstance():ReturnUI("IcecreamSharePage", arg0_54.shareGo)

			arg0_54.shareGo = nil
		end
	end)
end

function var0_0.initSD(arg0_56)
	arg0_56.sdContainer = arg0_56:findTF("sdcontainer", arg0_56.bg)
	arg0_56.spine = nil
	arg0_56.spineLRQ = GetSpineRequestPackage.New("salatuojia_8", function(arg0_57)
		SetParent(arg0_57, arg0_56.sdContainer)

		arg0_56.spine = arg0_57
		arg0_56.spine.transform.localScale = Vector3.one

		local var0_57 = arg0_56.spine:GetComponent("SpineAnimUI")

		if var0_57 then
			var0_57:SetAction("stand", 0)
		end

		arg0_56.spineLRQ = nil
	end):Start()

	setActive(arg0_56.sdContainer, true)
end

return var0_0
