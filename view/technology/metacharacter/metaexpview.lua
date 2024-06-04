local var0 = class("MetaExpView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "MetaExpUI"
end

function var0.OnInit(arg0)
	arg0:initUITip()
	arg0:initData()
	arg0:initUI()
	arg0:addListener()
	arg0:updateIconList()
end

function var0.OnDestroy(arg0)
	if arg0.closeCB then
		arg0.closeCB()
	end
end

function var0.setData(arg0, arg1, arg2)
	arg0.expInfoList = arg1
	arg0.closeCB = arg2
end

function var0.initUITip(arg0)
	local var0 = arg0:findTF("Panel/Title/Text")

	setText(var0, i18n("battle_end_subtitle2"))
end

function var0.initData(arg0)
	arg0.metaProxy = getProxy(MetaCharacterProxy)
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.iconTpl = arg0:findTF("IconTpl")
	arg0.panelTF = arg0:findTF("Panel")
	arg0.iconContainer = arg0:findTF("ScrollView/Content", arg0.panelTF)
	arg0.gridLayoutGroupSC = GetComponent(arg0.iconContainer, typeof(GridLayoutGroup))
	arg0.iconUIItemList = UIItemList.New(arg0.iconContainer, arg0.iconTpl)
end

function var0.addListener(arg0)
	return
end

function var0.updateIconList(arg0)
	local var0 = arg0.expInfoList or arg0.metaProxy:getMetaTacticsInfoOnEnd()
	local var1 = arg0:sortDataList(var0)
	local var2 = #var1

	arg0.gridLayoutGroupSC.constraintCount = var2 > 4 and 2 or 1

	arg0.iconUIItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("Icon", arg2)
			local var1 = arg0:findTF("AddExpText", arg2)
			local var2 = arg0:findTF("LevelMaxText", arg2)
			local var3 = arg0:findTF("ExpMaxText", arg2)
			local var4 = arg0:findTF("Slider", arg2)
			local var5 = arg0:findTF("Light", arg2)
			local var6 = var1[arg1]
			local var7 = var6.shipID
			local var8 = var6.addDayExp
			local var9 = var6.isUpLevel
			local var10 = var6.isMaxLevel
			local var11 = var6.isExpMax
			local var12 = var6.progressOld
			local var13 = var6.progressNew
			local var14 = getProxy(BayProxy):getShipById(var7)
			local var15 = var14:getPainting()
			local var16 = "SquareIcon/" .. var15

			setImageSprite(var0, LoadSprite(var16, var15))
			setText(var1, "EXP + " .. var8)
			setActive(var5, var9 and var10)

			if var9 and var10 then
				setActive(var1, false)
				setActive(var2, true)
				setActive(var3, false)
			elseif var11 then
				setActive(var1, false)
				setActive(var2, false)
				setActive(var3, true)
			else
				setActive(var1, true)
				setActive(var2, false)
				setActive(var3, false)
			end

			setSlider(var4, 0, 1, var13)
			onButton(arg0, arg2, function()
				LoadContextCommand.LoadLayerOnTopContext(Context.New({
					viewComponent = MetaSkillDetailBoxLayer,
					mediator = MetaSkillDetailBoxMediator,
					data = {
						metaShipID = var14.id,
						expInfoList = arg0.lastMetaExpInfoList
					},
					onRemoved = function()
						arg0:updateIconList()
					end
				}))
			end, SFX_PANEL)
		end
	end)
	arg0.iconUIItemList:align(#var1)
end

function var0.openPanel(arg0)
	if arg0.isAni == true then
		return
	end

	arg0.isAni = true

	Canvas.ForceUpdateCanvases()

	local var0 = arg0.panelTF.sizeDelta.x

	LeanTween.value(go(arg0.panelTF), 0, var0, 0.5):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.panelTF, {
			x = -arg0
		})
	end)):setOnComplete(System.Action(function()
		arg0.isAni = false
	end))
end

function var0.closePanel(arg0)
	if arg0.isAni == true then
		return
	end

	arg0.isAni = true

	local var0 = arg0.panelTF.sizeDelta.x

	LeanTween.value(go(arg0.panelTF), -var0, 0, 0.5):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.panelTF, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		arg0.isAni = false

		arg0:Destroy()
	end))
end

function var0.sortDataList(arg0, arg1)
	table.sort(arg1, function(arg0, arg1)
		local var0 = arg0.isUpLevel and arg0.isMaxLevel and 9999 or 0
		local var1 = arg1.isUpLevel and arg1.isMaxLevel and 9999 or 0
		local var2 = arg0.progressNew
		local var3 = arg1.progressNew
		local var4 = var0 + var2
		local var5 = var1 + var3

		if var5 < var4 then
			return true
		elseif var4 == var5 then
			return arg0.shipID < arg1.shipID
		elseif var4 < var5 then
			return false
		end
	end)

	return arg1
end

return var0
