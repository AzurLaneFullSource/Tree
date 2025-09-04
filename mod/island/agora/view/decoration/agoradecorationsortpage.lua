local var0_0 = class("AgoraDecorationSortPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandAgoraDecSortUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.sortUIItemList = UIItemList.New(arg0_2._tf:Find("frame"), arg0_2._tf:Find("frame/tpl"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5, arg2_5)
	var0_0.super.Show(arg0_5)

	arg0_5.indexData = arg1_5
	arg0_5.callback = arg2_5

	arg0_5:InitList()
end

function var0_0.InitList(arg0_6)
	arg0_6.sortUIItemList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = AgoraFurnitureType.SORT_LIST[arg1_7 + 1]
			local var1_7 = arg0_6.indexData.sortKey == var0_7

			setText(arg2_7:Find("Text"), setColorStr(AgoraFurnitureType.Sort2CN(var0_7), var1_7 and "#393a3c" or "#7c7e81"))
			onButton(arg0_6, arg2_7, function()
				if arg0_6.callback then
					arg0_6.callback(var0_7)
				end

				arg0_6:Hide()
			end, SFX_PANEL)
		end
	end)
	arg0_6.sortUIItemList:align(#AgoraFurnitureType.SORT_LIST)
end

function var0_0.Hide(arg0_9)
	var0_0.super.Hide(arg0_9)

	arg0_9.callback = nil
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10:isShowing() then
		arg0_10:Hide()
	end
end

return var0_0
