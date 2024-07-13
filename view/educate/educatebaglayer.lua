local var0_0 = class("EducateBagLayer", import(".base.EducateBaseUI"))
local var1_0 = "FFFFFF"
local var2_0 = "939495"

function var0_0.getUIName(arg0_1)
	return "EducateBagUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	arg0_3.itemVOs = getProxy(EducateProxy):GetItemList()
end

function var0_0.findUI(arg0_4)
	arg0_4.anim = arg0_4:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_4.animEvent = arg0_4:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_4.animEvent:SetEndEvent(function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end)

	arg0_4.windowTF = arg0_4:findTF("anim_root/window")

	setText(arg0_4:findTF("title/Text", arg0_4.windowTF), i18n("child_btn_bag"))

	arg0_4.closeBtn = arg0_4:findTF("close_btn", arg0_4.windowTF)
	arg0_4.togglesTF = arg0_4:findTF("toggles", arg0_4.windowTF)
	arg0_4.itemView = arg0_4:findTF("item_scrollview", arg0_4.windowTF)
	arg0_4.emptyTF = arg0_4:findTF("empty", arg0_4.windowTF)

	setText(arg0_4:findTF("Text", arg0_4.emptyTF), i18n("child_bag_empty_tip"))
end

function var0_0.addListener(arg0_6)
	onButton(arg0_6, arg0_6:findTF("anim_root/bg"), function()
		arg0_6:_close()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.closeBtn, function()
		arg0_6:_close()
	end, SFX_PANEL)
	eachChild(arg0_6.togglesTF, function(arg0_9)
		setText(arg0_6:findTF("Text", arg0_9), i18n("child_item_type" .. arg0_9.name))
		onToggle(arg0_6, arg0_9, function(arg0_10)
			local var0_10 = arg0_10 and var1_0 or var2_0

			setImageColor(arg0_6:findTF("icon", arg0_9), Color.NewHex(var0_10))
			setTextColor(arg0_6:findTF("Text", arg0_9), Color.NewHex(var0_10))

			if arg0_10 then
				arg0_6.anim:Play("anim_educate_bag_change")
				arg0_6:updateItems(tonumber(arg0_9.name))
			end
		end)
	end)
end

function var0_0.didEnter(arg0_11)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_11._tf, {
		groupName = arg0_11:getGroupNameFromData(),
		weight = arg0_11:getWeightFromData() + 1
	})
	arg0_11:initItems()
	triggerToggle(arg0_11:findTF("0", arg0_11.togglesTF), true)
end

function var0_0.initItems(arg0_12)
	arg0_12.itemRect = arg0_12.itemView:GetComponent("LScrollRect")

	function arg0_12.itemRect.onInitItem(arg0_13)
		arg0_12:initItem(arg0_13)
	end

	function arg0_12.itemRect.onUpdateItem(arg0_14, arg1_14)
		arg0_12:updateItem(arg0_14, arg1_14)
	end

	function arg0_12.itemRect.onReturnItem(arg0_15, arg1_15)
		arg0_12:returnItem(arg0_15, arg1_15)
	end
end

function var0_0.updateItems(arg0_16, arg1_16)
	arg0_16.showVOs = {}
	arg0_16.showVOs = underscore.select(arg0_16.itemVOs, function(arg0_17)
		return arg0_17:IsShow() and (arg1_16 == 0 or arg0_17:GetType() == arg1_16)
	end)

	table.sort(arg0_16.showVOs, CompareFuncs({
		function(arg0_18)
			return arg0_18:CanUse() and 1 or 0
		end,
		function(arg0_19)
			return -arg0_19:GetRarity()
		end,
		function(arg0_20)
			return -arg0_20.count
		end,
		function(arg0_21)
			return -arg0_21.id
		end
	}))
	arg0_16.itemRect:SetTotalCount(#arg0_16.showVOs, -1)
	setActive(arg0_16.emptyTF, #arg0_16.showVOs <= 0)
end

function var0_0.initItem(arg0_22, arg1_22)
	return
end

function var0_0.updateItem(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.showVOs[arg1_23 + 1]:GetShowInfo()

	EducateHelper.UpdateDropShow(arg2_23, var0_23)
	onButton(arg0_23, arg2_23, function()
		arg0_23:emit(var0_0.EDUCATE_ON_ITEM, {
			drop = var0_23
		})
	end, SFX_PANEL)
end

function var0_0.returnItem(arg0_25, arg1_25, arg2_25)
	removeOnButton(arg2_25)
end

function var0_0._close(arg0_26)
	arg0_26.anim:Play("anim_educate_bag_out")
end

function var0_0.onBackPressed(arg0_27)
	arg0_27:_close()
end

function var0_0.willExit(arg0_28)
	arg0_28.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_28._tf)
end

return var0_0
