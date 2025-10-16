local var0_0 = class("IslandSeasonPtPanel", import("view.base.BaseSubView"))

var0_0.AWARD_SHOW_CNT = 6
var0_0.AWARD_OFFSET = 1e-05

function var0_0.getUIName(arg0_1)
	return "IslandSeasonPtPanel"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("pt")

	arg0_2.ptValueTF = var0_2:Find("pt/value")

	setText(var0_2:Find("Text"), i18n("island_season_pt_hold"))

	arg0_2.getAllBtn = arg0_2._tf:Find("get_all")

	setText(arg0_2.getAllBtn:Find("Text"), i18n("island_season_pt_collectall"))

	arg0_2.blurTF = arg0_2._tf:Find("content")
	arg0_2.scrollCom = arg0_2.blurTF:Find("view"):GetComponent("LScrollRect")
	arg0_2.importantAwardTF = arg0_2._tf:Find("important")
end

function var0_0.OnInit(arg0_3)
	function arg0_3.scrollCom.onUpdateItem(arg0_4, arg1_4)
		arg0_3:UpdateAward(arg0_4, tf(arg1_4))
	end

	onButton(arg0_3, arg0_3.getAllBtn, function()
		arg0_3:emit(IslandMediator.ON_GET_SEASON_PT_AWARD, 0)
	end, SFX_PANEL)
	arg0_3:BuildPhaseAwardScrollPos()
	arg0_3.scrollCom.onValueChanged:AddListener(function(arg0_6)
		arg0_3:UpdateNextAward(arg0_6.x)
	end)
end

function var0_0.UpdateAward(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.awardInfos[arg1_7 + 1]

	setText(arg2_7:Find("target"), var0_7.target)
	updateCustomDrop(arg2_7:Find("drop"), var0_7.drop)

	local var1_7 = arg0_7.pt >= var0_7.target
	local var2_7 = table.contains(arg0_7.gotList, var0_7.target)

	setActive(arg2_7:Find("got"), var2_7)
	setActive(arg2_7:Find("get"), not var2_7 and var1_7)
	setActive(arg2_7:Find("lock"), not var1_7)
	onButton(arg0_7, arg2_7:Find("get"), function()
		arg0_7:emit(IslandMediator.ON_GET_SEASON_PT_AWARD, var0_7.target)
	end, SFX_PANEL)
	onButton(arg0_7, arg2_7, function()
		arg0_7.contextData:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var0_7.drop
		})
	end)
end

function var0_0.Show(arg0_10)
	arg0_10.super.Show(arg0_10)
	arg0_10:Flush()
	arg0_10:OverlayPanel(arg0_10._tf, {
		pbList = {
			arg0_10.blurTF
		}
	})
	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_15")
end

function var0_0.Flush(arg0_11)
	if not arg0_11:isShowing() then
		return
	end

	arg0_11.pt = arg0_11.contextData.season:GetPt()
	arg0_11.gotList = arg0_11.contextData.season:GetGotPtAwardList()

	setText(arg0_11.ptValueTF, arg0_11.pt)
	setActive(arg0_11.getAllBtn, arg0_11.contextData.season:GanGetPtAward())
	arg0_11.scrollCom:SetTotalCount(#arg0_11.awardInfos)
	arg0_11:UpdateNextAward(arg0_11.scrollCom.value)
end

function var0_0.BuildPhaseAwardScrollPos(arg0_12)
	arg0_12.awardInfos = IslandSeason.GetPtAwardInfos(arg0_12.contextData.season.id)
	arg0_12.impTotalPos = arg0_12.scrollCom:HeadIndexToValue(#arg0_12.awardInfos - var0_0.AWARD_SHOW_CNT) - arg0_12.scrollCom:HeadIndexToValue(0)
	arg0_12.importantInfos = {}

	for iter0_12, iter1_12 in pairs(arg0_12.awardInfos) do
		if iter1_12.isImportant then
			table.insert(arg0_12.importantInfos, {
				idx = iter0_12,
				pos = arg0_12.scrollCom:HeadIndexToValue(iter0_12 - var0_0.AWARD_SHOW_CNT) / arg0_12.impTotalPos
			})
		end
	end
end

function var0_0.UpdateNextAward(arg0_13, arg1_13)
	arg1_13 = math.min(arg1_13, 1)

	for iter0_13, iter1_13 in pairs(arg0_13.importantInfos) do
		if arg1_13 + var0_0.AWARD_OFFSET < iter1_13.pos then
			setActive(arg0_13.importantAwardTF, true)
			arg0_13:UpdateAward(iter1_13.idx - 1, arg0_13.importantAwardTF)

			break
		elseif iter0_13 == #arg0_13.importantInfos then
			setActive(arg0_13.importantAwardTF, false)
		end
	end
end

function var0_0.Hide(arg0_14)
	arg0_14.super.Hide(arg0_14)
	arg0_14:OnHide()
end

function var0_0.OnHide(arg0_15)
	arg0_15:UnOverlayPanel(arg0_15._tf, arg0_15._parentTf)
end

function var0_0.OnDestroy(arg0_16)
	ClearLScrollrect(arg0_16.scrollCom)
	arg0_16:OnHide()
end

return var0_0
