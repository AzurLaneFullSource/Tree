local var0_0 = class("CommanderTreePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderTreeUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2.treePanel = arg0_2._tf
	arg0_2.treeList = UIItemList.New(arg0_2:findTF("bg/frame/bg/talents", arg0_2.treePanel), arg0_2:findTF("bg/frame/bg/talents/telent", arg0_2.treePanel))
	arg0_2.treeTalentDesTxt = arg0_2.treePanel:Find("bg/frame/bg/desc/Text"):GetComponent(typeof(Text))
	arg0_2.treePanelCloseBtn = arg0_2:findTF("bg/frame/close_btn", arg0_2.treePanel)

	setActive(arg0_2.treePanel, false)
	onButton(arg0_2, arg0_2.treePanel, function()
		arg0_2:closeTreePanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.treePanelCloseBtn, function()
		arg0_2:closeTreePanel()
	end, SFX_PANEL)
	setText(arg0_2._tf:Find("Text"), i18n("commander_choice_talent_4"))
end

function var0_0.Show(arg0_5, arg1_5, arg2_5)
	setActive(arg0_5.treePanel, true)
	arg0_5.treePanel:SetAsLastSibling()

	local function var0_5(arg0_6)
		arg0_5.treeTalentDesTxt.text = arg0_6:getConfig("desc")
	end

	local var1_5 = arg1_5:getTalentList()

	arg0_5.treeList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = CommanderTalent.New({
				origin = false,
				id = var1_5[arg1_7 + 1]
			})

			onToggle(arg0_5, arg2_7, function(arg0_8)
				if arg0_8 then
					var0_5(var0_7)
				end
			end, SFX_PANEL)
			setText(arg2_7:Find("name"), var0_7:getConfig("name"))
			triggerToggle(arg2_7, arg1_5.id == var0_7.id)
			setActive(arg2_7:Find("curr"), arg1_5.id == var0_7.id)
			setActive(arg2_7:Find("arr"), arg1_7 ~= #var1_5 - 1)
			GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. var0_7:getConfig("icon"), "", arg2_7)
		end
	end)
	arg0_5.treeList:align(#var1_5)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf, false, {
		weight = arg2_5 or LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.Hide(arg0_9)
	arg0_9:closeTreePanel()
end

function var0_0.closeTreePanel(arg0_10)
	setActive(arg0_10.treePanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, arg0_10._parentTf)
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
