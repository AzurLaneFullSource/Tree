local var0_0 = class("GetCommanderResultPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GetCommanderResultUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.treePanel = CommanderTreePage.New(arg0_2._tf, arg0_2.event)
	arg0_2.uiList = UIItemList.New(arg0_2:findTF("frame/list"), arg0_2:findTF("frame/list/tpl"))
	arg0_2.uiList1 = UIItemList.New(arg0_2:findTF("frame/list1"), arg0_2:findTF("frame/list/tpl"))

	setText(arg0_2:findTF("frame/Text"), i18n("word_click_to_close"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.paintings = {}

	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5)
	var0_0.super.Show(arg0_5)
	arg0_5:UpdateCommanders(arg1_5)
end

function var0_0.UpdateCommanders(arg0_6, arg1_6)
	arg0_6.uiList:align(0)
	arg0_6.uiList1:align(0)

	local var0_6 = #arg1_6 <= 5 and arg0_6.uiList1 or arg0_6.uiList

	var0_6:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_6:UpdateCommander(arg1_6[arg1_7 + 1], arg2_7)
		end
	end)

	local var1_6 = #arg1_6 <= 5 and #arg1_6 or 10

	var0_6:align(var1_6)
end

function var0_0.UpdateCommander(arg0_8, arg1_8, arg2_8)
	if arg1_8 then
		local var0_8 = {
			"",
			"",
			"R",
			"SR",
			"SSR"
		}
		local var1_8 = arg1_8:getRarity()
		local var2_8 = GetSpriteFromAtlas("ui/CommanderBuildResultUI_atlas", var0_8[var1_8])
		local var3_8 = arg1_8:getPainting()
		local var4_8 = arg2_8:Find("info/mask/paint")

		arg2_8:Find("info/frame"):GetComponent(typeof(Image)).sprite = var2_8

		setCommanderPaintingPrefab(var4_8, var3_8, "result2")
		arg0_8:UpdateTalent(arg1_8, arg2_8)

		arg0_8.paintings[var3_8] = var4_8

		setText(arg2_8:Find("info/Text"), arg1_8:getName())
	end

	setActive(arg2_8:Find("empty"), arg1_8 == nil)
	setActive(arg2_8:Find("info"), arg1_8)
end

function var0_0.UpdateTalent(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg1_9:getTalents()
	local var1_9 = UIItemList.New(arg2_9:Find("info/talent"), arg2_9:Find("info/talent/tpl"))

	var1_9:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = var0_9[arg1_10 + 1]

			GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. var0_10:getConfig("icon"), "", arg2_10)
			onButton(arg0_9, arg2_10, function()
				arg0_9.treePanel:ExecuteAction("Show", var0_10)
			end, SFX_PANEL)
		end
	end)
	var1_9:align(#var0_9)
end

function var0_0.OnDestroy(arg0_12)
	if arg0_12.treePanel then
		arg0_12.treePanel:Destroy()

		arg0_12.treePanel = nil
	end

	for iter0_12, iter1_12 in ipairs(arg0_12.paintings) do
		retCommanderPaintingPrefab(iter1_12, iter0_12)
	end

	arg0_12.paintings = {}
end

return var0_0
