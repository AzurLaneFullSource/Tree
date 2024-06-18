local var0_0 = class("GuildMemberListPage", import("...base.GuildBasePage"))

function var0_0.getTargetUI(arg0_1)
	return "GuildMemberListBlueUI", "GuildMemberListRedUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.rectView = arg0_2:findTF("scroll")
	arg0_2.rectRect = arg0_2.rectView:GetComponent("LScrollRect")
	arg0_2.rankBtn = arg0_2:findTF("rank")
	arg0_2.blurBg = arg0_2:findTF("blur_bg", arg0_2._tf)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.rankBtn, function()
		arg0_3.contextData.rankPage:ExecuteAction("Flush", arg0_3.ranks)
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_3._tf, {
		pbList = {
			arg0_3.blurBg
		},
		overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
	})

	arg0_3.items = {}

	function arg0_3.rectRect.onInitItem(arg0_5)
		arg0_3:OnInitItem(arg0_5)
	end

	function arg0_3.rectRect.onUpdateItem(arg0_6, arg1_6)
		arg0_3:OnUpdateItem(arg0_6, arg1_6)
	end
end

function var0_0.SetUp(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7:Show()
	arg0_7:Flush(arg1_7, arg2_7, arg3_7)
end

function var0_0.Flush(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8.ranks = arg3_8
	arg0_8.memberVOs = arg2_8
	arg0_8.guildVO = arg1_8

	arg0_8:SetTotalCount()
end

function var0_0.SetTotalCount(arg0_9)
	table.sort(arg0_9.memberVOs, function(arg0_10, arg1_10)
		if arg0_10.duty ~= arg1_10.duty then
			return arg0_10.duty < arg1_10.duty
		else
			return arg0_10.liveness > arg1_10.liveness
		end
	end)
	arg0_9.rectRect:SetTotalCount(#arg0_9.memberVOs, 0)
end

function var0_0.OnInitItem(arg0_11, arg1_11)
	local var0_11 = GuildMemberCard.New(arg1_11)

	onButton(arg0_11, var0_11.tf, function()
		if arg0_11.selected == var0_11 then
			return
		end

		if arg0_11.selected then
			arg0_11.selected:SetSelected(false)
		end

		arg0_11.selected = var0_11

		arg0_11.selected:SetSelected(true)

		arg0_11.selectedId = var0_11.memberVO.id

		if arg0_11.OnClickMember then
			arg0_11.OnClickMember(var0_11.memberVO)
		end
	end, SFX_PANEL)

	arg0_11.items[arg1_11] = var0_11
end

function var0_0.OnUpdateItem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.items[arg2_13]

	if not var0_13 then
		arg0_13:OnInitItem(arg2_13)

		var0_13 = arg0_13.items[arg2_13]
	end

	local var1_13 = arg0_13.memberVOs[arg1_13 + 1]

	var0_13:Update(var1_13, arg0_13.guildVO)
	var0_13:SetSelected(arg0_13.selectedId and arg0_13.selectedId == var1_13.id)

	if not arg0_13.selected and arg1_13 == 0 then
		triggerButton(var0_13.tf)
	end
end

function var0_0.TriggerFirstCard(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.items) do
		if iter1_14.memberVO.id == arg0_14.memberVOs[1].id then
			triggerButton(iter1_14.tf)

			break
		end
	end
end

function var0_0.OnDestroy(arg0_15)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15._tf, arg0_15._parentTf)

	for iter0_15, iter1_15 in pairs(arg0_15.items) do
		iter1_15:Dispose()
	end
end

return var0_0
