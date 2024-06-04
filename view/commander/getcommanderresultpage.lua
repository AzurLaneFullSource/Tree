local var0 = class("GetCommanderResultPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "GetCommanderResultUI"
end

function var0.OnLoaded(arg0)
	arg0.treePanel = CommanderTreePage.New(arg0._tf, arg0.event)
	arg0.uiList = UIItemList.New(arg0:findTF("frame/list"), arg0:findTF("frame/list/tpl"))
	arg0.uiList1 = UIItemList.New(arg0:findTF("frame/list1"), arg0:findTF("frame/list/tpl"))

	setText(arg0:findTF("frame/Text"), i18n("word_click_to_close"))
end

function var0.OnInit(arg0)
	arg0.paintings = {}

	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0:UpdateCommanders(arg1)
end

function var0.UpdateCommanders(arg0, arg1)
	arg0.uiList:align(0)
	arg0.uiList1:align(0)

	local var0 = #arg1 <= 5 and arg0.uiList1 or arg0.uiList

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateCommander(arg1[arg1 + 1], arg2)
		end
	end)

	local var1 = #arg1 <= 5 and #arg1 or 10

	var0:align(var1)
end

function var0.UpdateCommander(arg0, arg1, arg2)
	if arg1 then
		local var0 = {
			"",
			"",
			"R",
			"SR",
			"SSR"
		}
		local var1 = arg1:getRarity()
		local var2 = GetSpriteFromAtlas("ui/CommanderBuildResultUI_atlas", var0[var1])
		local var3 = arg1:getPainting()
		local var4 = arg2:Find("info/mask/paint")

		arg2:Find("info/frame"):GetComponent(typeof(Image)).sprite = var2

		setCommanderPaintingPrefab(var4, var3, "result2")
		arg0:UpdateTalent(arg1, arg2)

		arg0.paintings[var3] = var4

		setText(arg2:Find("info/Text"), arg1:getName())
	end

	setActive(arg2:Find("empty"), arg1 == nil)
	setActive(arg2:Find("info"), arg1)
end

function var0.UpdateTalent(arg0, arg1, arg2)
	local var0 = arg1:getTalents()
	local var1 = UIItemList.New(arg2:Find("info/talent"), arg2:Find("info/talent/tpl"))

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. var0:getConfig("icon"), "", arg2)
			onButton(arg0, arg2, function()
				arg0.treePanel:ExecuteAction("Show", var0)
			end, SFX_PANEL)
		end
	end)
	var1:align(#var0)
end

function var0.OnDestroy(arg0)
	if arg0.treePanel then
		arg0.treePanel:Destroy()

		arg0.treePanel = nil
	end

	for iter0, iter1 in ipairs(arg0.paintings) do
		retCommanderPaintingPrefab(iter1, iter0)
	end

	arg0.paintings = {}
end

return var0
