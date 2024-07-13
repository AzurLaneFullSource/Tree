local var0_0 = class("BattleResultMetaExpView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BattleResultMetaExpUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initUITip()
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:addListener()
	arg0_2:updateIconList()
end

function var0_0.OnDestroy(arg0_3)
	arg0_3.closeCB()
	arg0_3:cleanManagedTween(true)
end

function var0_0.setData(arg0_4, arg1_4, arg2_4)
	arg0_4.lastMetaExpInfoList = arg1_4
	arg0_4.closeCB = arg2_4
end

function var0_0.initUITip(arg0_5)
	local var0_5 = arg0_5:findTF("Notch/Panel/Title/Text")

	setText(var0_5, i18n("battle_end_subtitle2"))
end

function var0_0.initData(arg0_6)
	arg0_6.metaProxy = getProxy(MetaCharacterProxy)
end

function var0_0.initUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("BG")
	arg0_7.iconTpl = arg0_7:findTF("IconTpl")
	arg0_7.panelTF = arg0_7:findTF("Notch/Panel")
	arg0_7.iconContainer = arg0_7:findTF("ScrollView/Content", arg0_7.panelTF)
	arg0_7.gridLayoutGroupSC = GetComponent(arg0_7.iconContainer, typeof(GridLayoutGroup))
	arg0_7.closeBtn = arg0_7:findTF("Button", arg0_7.panelTF)
	arg0_7.iconUIItemList = UIItemList.New(arg0_7.iconContainer, arg0_7.iconTpl)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:closePanel()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.closeBtn, function()
		arg0_8:closePanel()
	end, SFX_PANEL)
end

function var0_0.updateIconList(arg0_11)
	local var0_11 = arg0_11.lastMetaExpInfoList or arg0_11.metaProxy:getLastMetaSkillExpInfoList()
	local var1_11 = arg0_11:sortDataList(var0_11)
	local var2_11 = #var1_11

	arg0_11.gridLayoutGroupSC.constraintCount = var2_11 > 4 and 2 or 1

	arg0_11.iconUIItemList:make(function(arg0_12, arg1_12, arg2_12)
		arg1_12 = arg1_12 + 1

		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg0_11:findTF("Light", arg2_12)
			local var1_12 = arg0_11:findTF("Icon", arg2_12)
			local var2_12 = arg0_11:findTF("AddExpText", arg2_12)
			local var3_12 = arg0_11:findTF("LevelMaxText", arg2_12)
			local var4_12 = arg0_11:findTF("ExpMaxText", arg2_12)
			local var5_12 = arg0_11:findTF("Slider", arg2_12)
			local var6_12 = var1_11[arg1_12]
			local var7_12 = var6_12.shipID
			local var8_12 = var6_12.addDayExp
			local var9_12 = var6_12.isUpLevel
			local var10_12 = var6_12.isMaxLevel
			local var11_12 = var6_12.isExpMax
			local var12_12 = var6_12.progress
			local var13_12 = getProxy(BayProxy):getShipById(var7_12)
			local var14_12 = var13_12:getPainting()
			local var15_12 = "SquareIcon/" .. var14_12

			setImageSprite(var1_12, LoadSprite(var15_12, var14_12))
			setText(var2_12, "EXP + " .. var8_12)
			setActive(var0_12, var9_12 and var10_12)

			if var9_12 and var10_12 then
				setActive(var2_12, false)
				setActive(var3_12, true)
				setActive(var4_12, false)
			elseif var11_12 then
				setActive(var2_12, false)
				setActive(var3_12, false)
				setActive(var4_12, true)
			else
				setActive(var2_12, true)
				setActive(var3_12, false)
				setActive(var4_12, false)
			end

			setSlider(var5_12, 0, 1, var12_12)
			onButton(arg0_11, arg2_12, function()
				LoadContextCommand.LoadLayerOnTopContext(Context.New({
					viewComponent = MetaSkillDetailBoxLayer,
					mediator = MetaSkillDetailBoxMediator,
					data = {
						metaShipID = var13_12.id,
						expInfoList = arg0_11.lastMetaExpInfoList
					},
					onRemoved = function()
						arg0_11:updateIconList()
					end
				}))
			end, SFX_PANEL)
		end
	end)
	arg0_11.iconUIItemList:align(#var1_11)
end

local var1_0 = 0.3

function var0_0.openPanel(arg0_15)
	arg0_15:cleanManagedTween(true)
	Canvas.ForceUpdateCanvases()

	local var0_15 = 400
	local var1_15 = arg0_15.panelTF.sizeDelta.x
	local var2_15 = System.Action_float(function(arg0_16)
		setAnchoredPosition(arg0_15.panelTF, {
			x = arg0_16
		})
	end)
	local var3_15 = System.Action(function()
		setAnchoredPosition(arg0_15.panelTF, {
			x = 0
		})
	end)

	arg0_15:managedTween(LeanTween.value, nil, go(arg0_15.panelTF), var2_15, 400, 0, var1_0):setOnComplete(var3_15)
end

function var0_0.closePanel(arg0_18)
	arg0_18:cleanManagedTween(true)

	local var0_18 = 400
	local var1_18 = arg0_18.panelTF.sizeDelta.x
	local var2_18 = System.Action_float(function(arg0_19)
		setAnchoredPosition(arg0_18.panelTF, {
			x = arg0_19
		})
	end)
	local var3_18 = System.Action(function()
		setAnchoredPosition(arg0_18.panelTF, {
			x = 0
		})
		arg0_18:Destroy()
	end)

	arg0_18:managedTween(LeanTween.value, nil, go(arg0_18.panelTF), var2_18, 0, 400, var1_0):setOnComplete(var3_18)
end

function var0_0.sortDataList(arg0_21, arg1_21)
	table.sort(arg1_21, function(arg0_22, arg1_22)
		local var0_22 = arg0_22.isUpLevel and arg0_22.isMaxLevel and 9999 or 0
		local var1_22 = arg1_22.isUpLevel and arg1_22.isMaxLevel and 9999 or 0
		local var2_22 = arg0_22.progress
		local var3_22 = arg1_22.progress
		local var4_22 = var0_22 + var2_22
		local var5_22 = var1_22 + var3_22

		if var5_22 < var4_22 then
			return true
		elseif var4_22 == var5_22 then
			return arg0_22.shipID < arg1_22.shipID
		elseif var4_22 < var5_22 then
			return false
		end
	end)

	return arg1_21
end

return var0_0
