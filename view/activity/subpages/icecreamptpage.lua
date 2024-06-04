local var0 = class("IcecreamPTPage", import(".TemplatePage.PtTemplatePage"))

var0.FADE_TIME = 0.5
var0.SHOW_TIME = 1
var0.FADE_OUT_TIME = 0.5
var0.Menu_Ani_Open_Time = 0.5
var0.Menu_Ani_Close_Time = 0.3
var0.PosList = {
	188,
	70,
	-55,
	-178
}
var0.Icecream_Save_Tag_Pre = "Icecream_Tag_"

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

	local var0, var1, var2 = arg0.ptData:GetLevelProgress()

	setText(arg0.step, var0)

	if isActive(arg0.specialTF) then
		setActive(arg0.specialTF, false)
	end

	arg0:updateIcecream()
	arg0:updateMainSelectPanel()
	setActive(arg0.openBtn, arg0:isFinished())
	setActive(arg0.shareBtn, arg0:isFinished())
end

function var0.OnDestroy(arg0)
	if arg0.spine then
		arg0.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar("salatuojia_8", arg0.spine)

		arg0.spine = nil
	end

	if arg0.shareGo then
		PoolMgr.GetInstance():ReturnUI("IcecreamSharePage", arg0.shareGo)

		arg0.shareGo = nil
	end
end

function var0.findUI(arg0)
	arg0.shareBtn = arg0:findTF("Logo/share_btn", arg0.bg)
	arg0.icecreamTF = arg0:findTF("Icecream", arg0.bg)
	arg0.openBtn = arg0:findTF("open_btn", arg0.bg)
	arg0.helpBtn = arg0:findTF("help_btn", arg0.bg)
	arg0.specialTF = arg0:findTF("Special")
	arg0.backBG = arg0:findTF("BG", arg0.specialTF)
	arg0.menuTF = arg0:findTF("Menu", arg0.specialTF)
	arg0.mainPanel = arg0:findTF("MainPanel", arg0.menuTF)
	arg0.mainToggleTFList = {}

	for iter0 = 1, 4 do
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
	local var12 = arg0:findTF("3/1", arg0.resTF)
	local var13 = arg0:findTF("3/2", arg0.resTF)
	local var14 = arg0:findTF("3/3", arg0.resTF)
	local var15 = arg0:findTF("4/1", arg0.resTF)
	local var16 = arg0:findTF("4/2", arg0.resTF)
	local var17 = arg0:findTF("4/3", arg0.resTF)

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
		["3"] = {
			var12,
			var13,
			var14
		},
		["4"] = {
			var15,
			var16,
			var17
		}
	}
	arg0.icecreamResTF = arg0:findTF("Icecream")
	arg0.mainToggleSelectedTF = {}
	arg0.mainToggleUnlockTF = {}

	for iter1, iter2 in ipairs(arg0.mainToggleTFList) do
		arg0.mainToggleSelectedTF[iter1] = iter2:GetChild(1)
		arg0.mainToggleUnlockTF[iter1] = iter2:GetChild(0)
	end
end

function var0.addListener(arg0)
	if IsUnityEditor then
		local var0 = arg0:findTF("Logo", arg0.bg)

		onButton(arg0, var0, function()
			for iter0 = 1, 4 do
				local var0 = var0.Icecream_Save_Tag_Pre .. iter0

				PlayerPrefs.SetInt(var0, 0)
			end
		end, SFX_PANEL)
	end

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
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.openBtn, function()
		arg0:openMainPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.icecream_help.tip
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
			if arg0 == true then
				arg0.curSelectOrder = iter0

				local var0 = var0.PosList[iter0]

				setLocalPosition(arg0.secondPanel, {
					y = var0
				})
				setLocalPosition(arg0.selectBtn, {
					y = var0
				})

				local var1

				if iter0 == 1 then
					var1 = arg0.iconTable["1"]
				elseif iter0 == 2 then
					local var2 = 2 .. arg0.selectedList[1]

					var1 = arg0.iconTable[var2]
				elseif iter0 == 3 then
					var1 = arg0.iconTable["3"]
				elseif iter0 == 4 then
					var1 = arg0.iconTable["4"]
				end

				local var3 = {}

				for iter0 = 1, 3 do
					var3[iter0] = arg0.secondPanel:GetChild(iter0)
				end

				for iter1 = 1, 3 do
					local var4 = getImageSprite(var1[iter1])

					setImageSprite(arg0:findTF("icon", var3[iter1]), var4, true)
					onToggle(arg0, var3[iter1], function(arg0)
						if arg0 == true then
							local var0 = Clone(arg0.selectedList)

							var0[arg0.curSelectOrder] = iter1

							arg0:updateIcecream(var0)
							arg0:openSelectBtn()

							arg0.curSelectIndex = iter1
						else
							setActive(arg0.selectBtn, false)

							arg0.curSelectIndex = 0
						end
					end, SFX_PANEL)
				end

				for iter2 = 1, 3 do
					triggerToggle(var3[iter2], false)
				end

				arg0:openSecondPanel()
				setActive(arg0.selectBtn, false)
			else
				arg0.curSelectOrder = 0

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
			arg0:updateIcecream()
			arg0:updateMainSelectPanel()
		end
	end, SFX_PANEL)
end

function var0.openMainPanel(arg0, arg1)
	arg0.selectedList = arg0:getSelectedList()

	setActive(arg0.displayBtn, false)
	setActive(arg0.slider, false)
	setActive(arg0.awardTF, false)
	setActive(arg0.progress, false)

	for iter0 = 1, 4 do
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
	LeanTween.value(go(arg0.mainPanel), -391, -271, var0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0)
		setLocalPosition(arg0.mainPanel, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0.mainPanel, {
			x = -271
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
	LeanTween.value(go(arg0.mainPanel), -271, -391, var0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0)
		setLocalPosition(arg0.mainPanel, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0.mainPanel, {
			x = -391
		})
		setActive(arg0.specialTF, false)
		arg0:updateIcecream()
		setActive(arg0.displayBtn, true)
		setActive(arg0.slider, true)
		setActive(arg0.awardTF, true)
		setActive(arg0.progress, true)
	end))
end

function var0.openSecondPanel(arg0)
	setActive(arg0.secondPanel, true)
	LeanTween.value(go(arg0.secondPanel), 0, 1, var0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0)
		arg0.secondPanelCG.alpha = arg0
	end)):setOnComplete(System.Action(function()
		arg0.secondPanelCG.alpha = 1
	end))
	LeanTween.value(go(arg0.secondPanel), -646, -213, var0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0)
		setLocalPosition(arg0.secondPanel, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0.secondPanel, {
			x = -213
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
	LeanTween.value(go(arg0.secondPanel), -213, -646, var0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0)
		setLocalPosition(arg0.secondPanel, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalPosition(arg0.secondPanel, {
			x = -646
		})
		setActive(arg0.secondPanel, false)
		arg0:closeMainPanel()
	end))
end

function var0.openSelectBtn(arg0)
	setLocalPosition(arg0.selectBtn, {
		x = 287
	})
	setActive(arg0.selectBtn, true)
	LeanTween.value(go(arg0.selectBtn), 0, 1, var0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function(arg0)
		setImageAlpha(arg0.selectBtn, arg0)
	end)):setOnComplete(System.Action(function()
		setImageAlpha(arg0.selectBtn, 1)
	end))
end

function var0.closeSelectBtn(arg0)
	LeanTween.value(go(arg0.selectBtn), 1, 0, var0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function(arg0)
		setImageAlpha(arg0.selectBtn, arg0)
	end)):setOnComplete(System.Action(function()
		setImageAlpha(arg0.selectBtn, 0)
		setActive(arg0.selectBtn, false)
	end))
end

function var0.closeSpecial(arg0)
	arg0:closeSelectBtn()
	arg0:closeSecondPanel()
end

function var0.updateIcecream(arg0, arg1)
	local var0 = arg1 or arg0.selectedList

	setActive(arg0.icecreamTF, var0[1] > 0)

	local var1 = arg0:findTF("1", arg0.icecreamTF)
	local var2 = arg0:findTF("Taste", var1)
	local var3 = arg0:findTF("2", arg0.icecreamTF)
	local var4 = arg0:findTF("3", arg0.icecreamTF)
	local var5 = arg0:findTF("4", arg0.icecreamTF)
	local var6 = var0[1] and var0[1] > 0

	if var6 then
		for iter0, iter1 in pairs(var0) do
			if iter1 > 0 and iter0 > 1 then
				var6 = false
			end
		end
	end

	setActive(var1, var6)
	setActive(var3, var0[2] and var0[2] > 0)
	setActive(var4, var0[3] and var0[3] > 0)
	setActive(var5, var0[4] and var0[4] > 0)

	if var6 then
		local var7 = "1_" .. var0[1]
		local var8 = getImageSprite(arg0:findTF(var7, arg0.icecreamResTF))

		setImageSprite(var2, var8, true)
	end

	if var0[2] and var0[2] > 0 then
		local var9 = "2_" .. var0[1] .. var0[2]
		local var10 = getImageSprite(arg0:findTF(var9, arg0.icecreamResTF))

		setImageSprite(var3, var10, true)
	end

	if var0[3] and var0[3] > 0 then
		local var11 = "3_" .. var0[3]
		local var12 = getImageSprite(arg0:findTF(var11, arg0.icecreamResTF))

		setImageSprite(var4, var12, true)
	end

	if var0[4] and var0[4] > 0 then
		local var13 = "4_" .. var0[4]
		local var14 = getImageSprite(arg0:findTF(var13, arg0.icecreamResTF))

		setImageSprite(var5, var14, true)
	end
end

function var0.updateMainSelectPanel(arg0)
	for iter0 = 1, 4 do
		setActive(arg0.mainToggleUnlockTF[iter0], arg0.selectedList[iter0] and arg0.selectedList[iter0] > 0)
	end

	if arg0.curSelectOrder > 0 then
		setActive(arg0.mainToggleUnlockTF[arg0.curSelectOrder], true)
	end

	if arg0.selectedList[1] and arg0.selectedList[1] > 0 then
		local var0 = arg0.selectedList[1]
		local var1 = arg0.iconTable["1"][var0]
		local var2 = getImageSprite(var1)

		setImageSprite(arg0.mainToggleSelectedTF[1], var2, true)
		setActive(arg0.mainToggleSelectedTF[1], true)
	else
		setActive(arg0.mainToggleSelectedTF[1], false)
	end

	if arg0.selectedList[2] and arg0.selectedList[2] > 0 then
		local var3 = 2 .. arg0.selectedList[1]
		local var4 = arg0.selectedList[2]
		local var5 = arg0.iconTable[var3][var4]
		local var6 = getImageSprite(var5)

		setImageSprite(arg0.mainToggleSelectedTF[2], var6, true)
		setActive(arg0.mainToggleSelectedTF[2], true)
	else
		setActive(arg0.mainToggleSelectedTF[2], false)
	end

	if arg0.selectedList[3] and arg0.selectedList[3] > 0 then
		local var7 = arg0.selectedList[3]
		local var8 = arg0.iconTable["3"][var7]
		local var9 = getImageSprite(var8)

		setImageSprite(arg0.mainToggleSelectedTF[3], var9, true)
		setActive(arg0.mainToggleSelectedTF[3], true)
	else
		setActive(arg0.mainToggleSelectedTF[3], false)
	end

	if arg0.selectedList[4] and arg0.selectedList[4] > 0 then
		local var10 = arg0.selectedList[4]
		local var11 = arg0.iconTable["4"][var10]
		local var12 = getImageSprite(var11)

		setImageSprite(arg0.mainToggleSelectedTF[4], var12, true)
		setActive(arg0.mainToggleSelectedTF[4], true)
	else
		setActive(arg0.mainToggleSelectedTF[4], false)
	end
end

function var0.isFinished(arg0)
	return #arg0.activity.data2_list == 4
end

function var0.changeIndexSelect(arg0)
	arg0.selectedList[arg0.curSelectOrder] = arg0.curSelectIndex

	local var0 = var0.Icecream_Save_Tag_Pre .. arg0.curSelectOrder

	PlayerPrefs.SetInt(var0, arg0.curSelectIndex)
end

function var0.getSelectedList(arg0)
	arg0.selectedList = {
		0,
		0,
		0,
		0
	}

	for iter0, iter1 in ipairs(arg0.activity.data2_list) do
		arg0.selectedList[iter0] = iter1
	end

	if arg0:isFinished() then
		for iter2 = 1, 4 do
			local var0 = var0.Icecream_Save_Tag_Pre .. iter2
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
	for iter0 = 1, 4 do
		local var0 = var0.Icecream_Save_Tag_Pre .. iter0
		local var1 = arg0.selectedList[iter0]

		PlayerPrefs.SetInt(var0, var1)
	end
end

function var0.share(arg0)
	PoolMgr.GetInstance():GetUI("IcecreamSharePage", false, function(arg0)
		local var0 = GameObject.Find("UICamera/Canvas/UIMain")

		SetParent(arg0, var0, false)

		arg0.shareGo = arg0

		local var1 = arg0:findTF("PlayerName", arg0)
		local var2 = arg0:findTF("IcecreamContainer", arg0)
		local var3 = getProxy(PlayerProxy):getData().name

		setText(var1, i18n("icecream_make_tip", var3))

		local var4 = getProxy(PlayerProxy):getRawData()
		local var5 = getProxy(UserProxy):getRawData()
		local var6 = getProxy(ServerProxy):getRawData()[var5 and var5.server or 0]
		local var7 = var4 and var4.name or ""
		local var8 = var6 and var6.name or ""
		local var9 = arg0:findTF("deck", arg0)

		setText(var9:Find("name/value"), var7)
		setText(var9:Find("server/value"), var8)
		setText(var9:Find("lv/value"), var4.level)

		local var10 = cloneTplTo(arg0.icecreamTF, var2)

		setLocalPosition(tf(var10), {
			x = 0,
			y = 0
		})
		setLocalScale(tf(var10), {
			x = 1.4,
			y = 1.4
		})
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeIcecream)

		if arg0.shareGo then
			PoolMgr.GetInstance():ReturnUI("IcecreamSharePage", arg0.shareGo)

			arg0.shareGo = nil
		end
	end)
end

function var0.initSD(arg0)
	arg0.sdContainer = arg0:findTF("sdcontainer", arg0.bg)
	arg0.spine = nil
	arg0.spineLRQ = GetSpineRequestPackage.New("salatuojia_8", function(arg0)
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

return var0
