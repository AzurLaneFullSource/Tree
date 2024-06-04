local var0 = class("EducateBagLayer", import(".base.EducateBaseUI"))
local var1 = "FFFFFF"
local var2 = "939495"

function var0.getUIName(arg0)
	return "EducateBagUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	arg0.itemVOs = getProxy(EducateProxy):GetItemList()
end

function var0.findUI(arg0)
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0.windowTF = arg0:findTF("anim_root/window")

	setText(arg0:findTF("title/Text", arg0.windowTF), i18n("child_btn_bag"))

	arg0.closeBtn = arg0:findTF("close_btn", arg0.windowTF)
	arg0.togglesTF = arg0:findTF("toggles", arg0.windowTF)
	arg0.itemView = arg0:findTF("item_scrollview", arg0.windowTF)
	arg0.emptyTF = arg0:findTF("empty", arg0.windowTF)

	setText(arg0:findTF("Text", arg0.emptyTF), i18n("child_bag_empty_tip"))
end

function var0.addListener(arg0)
	onButton(arg0, arg0:findTF("anim_root/bg"), function()
		arg0:_close()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:_close()
	end, SFX_PANEL)
	eachChild(arg0.togglesTF, function(arg0)
		setText(arg0:findTF("Text", arg0), i18n("child_item_type" .. arg0.name))
		onToggle(arg0, arg0, function(arg0)
			local var0 = arg0 and var1 or var2

			setImageColor(arg0:findTF("icon", arg0), Color.NewHex(var0))
			setTextColor(arg0:findTF("Text", arg0), Color.NewHex(var0))

			if arg0 then
				arg0.anim:Play("anim_educate_bag_change")
				arg0:updateItems(tonumber(arg0.name))
			end
		end)
	end)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 1
	})
	arg0:initItems()
	triggerToggle(arg0:findTF("0", arg0.togglesTF), true)
end

function var0.initItems(arg0)
	arg0.itemRect = arg0.itemView:GetComponent("LScrollRect")

	function arg0.itemRect.onInitItem(arg0)
		arg0:initItem(arg0)
	end

	function arg0.itemRect.onUpdateItem(arg0, arg1)
		arg0:updateItem(arg0, arg1)
	end

	function arg0.itemRect.onReturnItem(arg0, arg1)
		arg0:returnItem(arg0, arg1)
	end
end

function var0.updateItems(arg0, arg1)
	arg0.showVOs = {}
	arg0.showVOs = underscore.select(arg0.itemVOs, function(arg0)
		return arg0:IsShow() and (arg1 == 0 or arg0:GetType() == arg1)
	end)

	table.sort(arg0.showVOs, CompareFuncs({
		function(arg0)
			return arg0:CanUse() and 1 or 0
		end,
		function(arg0)
			return -arg0:GetRarity()
		end,
		function(arg0)
			return -arg0.count
		end,
		function(arg0)
			return -arg0.id
		end
	}))
	arg0.itemRect:SetTotalCount(#arg0.showVOs, -1)
	setActive(arg0.emptyTF, #arg0.showVOs <= 0)
end

function var0.initItem(arg0, arg1)
	return
end

function var0.updateItem(arg0, arg1, arg2)
	local var0 = arg0.showVOs[arg1 + 1]:GetShowInfo()

	EducateHelper.UpdateDropShow(arg2, var0)
	onButton(arg0, arg2, function()
		arg0:emit(var0.EDUCATE_ON_ITEM, {
			drop = var0
		})
	end, SFX_PANEL)
end

function var0.returnItem(arg0, arg1, arg2)
	removeOnButton(arg2)
end

function var0._close(arg0)
	arg0.anim:Play("anim_educate_bag_out")
end

function var0.onBackPressed(arg0)
	arg0:_close()
end

function var0.willExit(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
