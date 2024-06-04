local var0 = class("CommanderTreePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderTreeUI"
end

function var0.OnInit(arg0)
	arg0.treePanel = arg0._tf
	arg0.treeList = UIItemList.New(arg0:findTF("bg/frame/bg/talents", arg0.treePanel), arg0:findTF("bg/frame/bg/talents/telent", arg0.treePanel))
	arg0.treeTalentDesTxt = arg0.treePanel:Find("bg/frame/bg/desc/Text"):GetComponent(typeof(Text))
	arg0.treePanelCloseBtn = arg0:findTF("bg/frame/close_btn", arg0.treePanel)

	setActive(arg0.treePanel, false)
	onButton(arg0, arg0.treePanel, function()
		arg0:closeTreePanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.treePanelCloseBtn, function()
		arg0:closeTreePanel()
	end, SFX_PANEL)
	setText(arg0._tf:Find("Text"), i18n("commander_choice_talent_4"))
end

function var0.Show(arg0, arg1, arg2)
	setActive(arg0.treePanel, true)
	arg0.treePanel:SetAsLastSibling()

	local function var0(arg0)
		arg0.treeTalentDesTxt.text = arg0:getConfig("desc")
	end

	local var1 = arg1:getTalentList()

	arg0.treeList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = CommanderTalent.New({
				origin = false,
				id = var1[arg1 + 1]
			})

			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					var0(var0)
				end
			end, SFX_PANEL)
			setText(arg2:Find("name"), var0:getConfig("name"))
			triggerToggle(arg2, arg1.id == var0.id)
			setActive(arg2:Find("curr"), arg1.id == var0.id)
			setActive(arg2:Find("arr"), arg1 ~= #var1 - 1)
			GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. var0:getConfig("icon"), "", arg2)
		end
	end)
	arg0.treeList:align(#var1)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = arg2 or LayerWeightConst.SECOND_LAYER
	})
end

function var0.Hide(arg0)
	arg0:closeTreePanel()
end

function var0.closeTreePanel(arg0)
	setActive(arg0.treePanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	return
end

return var0
