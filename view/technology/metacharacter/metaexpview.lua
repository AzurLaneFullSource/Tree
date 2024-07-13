local var0_0 = class("MetaExpView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MetaExpUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initUITip()
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:addListener()
	arg0_2:updateIconList()
end

function var0_0.OnDestroy(arg0_3)
	if arg0_3.closeCB then
		arg0_3.closeCB()
	end
end

function var0_0.setData(arg0_4, arg1_4, arg2_4)
	arg0_4.expInfoList = arg1_4
	arg0_4.closeCB = arg2_4
end

function var0_0.initUITip(arg0_5)
	local var0_5 = arg0_5:findTF("Panel/Title/Text")

	setText(var0_5, i18n("battle_end_subtitle2"))
end

function var0_0.initData(arg0_6)
	arg0_6.metaProxy = getProxy(MetaCharacterProxy)
end

function var0_0.initUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("BG")
	arg0_7.iconTpl = arg0_7:findTF("IconTpl")
	arg0_7.panelTF = arg0_7:findTF("Panel")
	arg0_7.iconContainer = arg0_7:findTF("ScrollView/Content", arg0_7.panelTF)
	arg0_7.gridLayoutGroupSC = GetComponent(arg0_7.iconContainer, typeof(GridLayoutGroup))
	arg0_7.iconUIItemList = UIItemList.New(arg0_7.iconContainer, arg0_7.iconTpl)
end

function var0_0.addListener(arg0_8)
	return
end

function var0_0.updateIconList(arg0_9)
	local var0_9 = arg0_9.expInfoList or arg0_9.metaProxy:getMetaTacticsInfoOnEnd()
	local var1_9 = arg0_9:sortDataList(var0_9)
	local var2_9 = #var1_9

	arg0_9.gridLayoutGroupSC.constraintCount = var2_9 > 4 and 2 or 1

	arg0_9.iconUIItemList:make(function(arg0_10, arg1_10, arg2_10)
		arg1_10 = arg1_10 + 1

		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_9:findTF("Icon", arg2_10)
			local var1_10 = arg0_9:findTF("AddExpText", arg2_10)
			local var2_10 = arg0_9:findTF("LevelMaxText", arg2_10)
			local var3_10 = arg0_9:findTF("ExpMaxText", arg2_10)
			local var4_10 = arg0_9:findTF("Slider", arg2_10)
			local var5_10 = arg0_9:findTF("Light", arg2_10)
			local var6_10 = var1_9[arg1_10]
			local var7_10 = var6_10.shipID
			local var8_10 = var6_10.addDayExp
			local var9_10 = var6_10.isUpLevel
			local var10_10 = var6_10.isMaxLevel
			local var11_10 = var6_10.isExpMax
			local var12_10 = var6_10.progressOld
			local var13_10 = var6_10.progressNew
			local var14_10 = getProxy(BayProxy):getShipById(var7_10)
			local var15_10 = var14_10:getPainting()
			local var16_10 = "SquareIcon/" .. var15_10

			setImageSprite(var0_10, LoadSprite(var16_10, var15_10))
			setText(var1_10, "EXP + " .. var8_10)
			setActive(var5_10, var9_10 and var10_10)

			if var9_10 and var10_10 then
				setActive(var1_10, false)
				setActive(var2_10, true)
				setActive(var3_10, false)
			elseif var11_10 then
				setActive(var1_10, false)
				setActive(var2_10, false)
				setActive(var3_10, true)
			else
				setActive(var1_10, true)
				setActive(var2_10, false)
				setActive(var3_10, false)
			end

			setSlider(var4_10, 0, 1, var13_10)
			onButton(arg0_9, arg2_10, function()
				LoadContextCommand.LoadLayerOnTopContext(Context.New({
					viewComponent = MetaSkillDetailBoxLayer,
					mediator = MetaSkillDetailBoxMediator,
					data = {
						metaShipID = var14_10.id,
						expInfoList = arg0_9.lastMetaExpInfoList
					},
					onRemoved = function()
						arg0_9:updateIconList()
					end
				}))
			end, SFX_PANEL)
		end
	end)
	arg0_9.iconUIItemList:align(#var1_9)
end

function var0_0.openPanel(arg0_13)
	if arg0_13.isAni == true then
		return
	end

	arg0_13.isAni = true

	Canvas.ForceUpdateCanvases()

	local var0_13 = arg0_13.panelTF.sizeDelta.x

	LeanTween.value(go(arg0_13.panelTF), 0, var0_13, 0.5):setOnUpdate(System.Action_float(function(arg0_14)
		setAnchoredPosition(arg0_13.panelTF, {
			x = -arg0_14
		})
	end)):setOnComplete(System.Action(function()
		arg0_13.isAni = false
	end))
end

function var0_0.closePanel(arg0_16)
	if arg0_16.isAni == true then
		return
	end

	arg0_16.isAni = true

	local var0_16 = arg0_16.panelTF.sizeDelta.x

	LeanTween.value(go(arg0_16.panelTF), -var0_16, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_17)
		setAnchoredPosition(arg0_16.panelTF, {
			x = arg0_17
		})
	end)):setOnComplete(System.Action(function()
		arg0_16.isAni = false

		arg0_16:Destroy()
	end))
end

function var0_0.sortDataList(arg0_19, arg1_19)
	table.sort(arg1_19, function(arg0_20, arg1_20)
		local var0_20 = arg0_20.isUpLevel and arg0_20.isMaxLevel and 9999 or 0
		local var1_20 = arg1_20.isUpLevel and arg1_20.isMaxLevel and 9999 or 0
		local var2_20 = arg0_20.progressNew
		local var3_20 = arg1_20.progressNew
		local var4_20 = var0_20 + var2_20
		local var5_20 = var1_20 + var3_20

		if var5_20 < var4_20 then
			return true
		elseif var4_20 == var5_20 then
			return arg0_20.shipID < arg1_20.shipID
		elseif var4_20 < var5_20 then
			return false
		end
	end)

	return arg1_19
end

return var0_0
