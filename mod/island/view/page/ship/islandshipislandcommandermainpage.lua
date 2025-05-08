local var0_0 = class("IslandShipIslandCommanderMainPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandCommanderMainUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("adapt/left_panel/back")
	arg0_2.homeBtn = arg0_2:findTF("adapt/home")

	setText(arg0_2:findTF("adapt/left_panel/title/Text"), i18n1("装扮"))
end

function var0_0.AddListeners(arg0_3)
	return
end

function var0_0.RemoveListeners(arg0_4)
	return
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.homeBtn, function()
		arg0_5:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.backBtn, function()
		if arg0_5.currentChildPage:CheckDressIsDirty() then
			arg0_5:ShowMsgBox({
				content = "装扮信息存在改动,是否保存当前装扮",
				type = IslandMsgBox.TYPE_COMMON,
				onYes = function()
					arg0_5.currentChildPage:SaveDressUpData()
					arg0_5:Hide()
				end,
				onNo = function()
					arg0_5:Hide()
				end
			})
		else
			arg0_5:Hide()
		end
	end, SFX_PANEL)
end

function var0_0.Show(arg0_10)
	var0_0.super.Show(arg0_10)
	arg0_10:Flush()

	arg0_10.currentChildPage = arg0_10:OpenPage(IslandShipDressUpPage)
end

function var0_0.Flush(arg0_11)
	return
end

function var0_0.Hide(arg0_12)
	var0_0.super.Hide(arg0_12)
end

function var0_0.OnDestroy(arg0_13)
	return
end

return var0_0
