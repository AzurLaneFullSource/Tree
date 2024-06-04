local var0 = class("GuildMemberListPage", import("...base.GuildBasePage"))

function var0.getTargetUI(arg0)
	return "GuildMemberListBlueUI", "GuildMemberListRedUI"
end

function var0.OnLoaded(arg0)
	arg0.rectView = arg0:findTF("scroll")
	arg0.rectRect = arg0.rectView:GetComponent("LScrollRect")
	arg0.rankBtn = arg0:findTF("rank")
	arg0.blurBg = arg0:findTF("blur_bg", arg0._tf)
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.rankBtn, function()
		arg0.contextData.rankPage:ExecuteAction("Flush", arg0.ranks)
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0._tf, {
		pbList = {
			arg0.blurBg
		},
		overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
	})

	arg0.items = {}

	function arg0.rectRect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.rectRect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end
end

function var0.SetUp(arg0, arg1, arg2, arg3)
	arg0:Show()
	arg0:Flush(arg1, arg2, arg3)
end

function var0.Flush(arg0, arg1, arg2, arg3)
	arg0.ranks = arg3
	arg0.memberVOs = arg2
	arg0.guildVO = arg1

	arg0:SetTotalCount()
end

function var0.SetTotalCount(arg0)
	table.sort(arg0.memberVOs, function(arg0, arg1)
		if arg0.duty ~= arg1.duty then
			return arg0.duty < arg1.duty
		else
			return arg0.liveness > arg1.liveness
		end
	end)
	arg0.rectRect:SetTotalCount(#arg0.memberVOs, 0)
end

function var0.OnInitItem(arg0, arg1)
	local var0 = GuildMemberCard.New(arg1)

	onButton(arg0, var0.tf, function()
		if arg0.selected == var0 then
			return
		end

		if arg0.selected then
			arg0.selected:SetSelected(false)
		end

		arg0.selected = var0

		arg0.selected:SetSelected(true)

		arg0.selectedId = var0.memberVO.id

		if arg0.OnClickMember then
			arg0.OnClickMember(var0.memberVO)
		end
	end, SFX_PANEL)

	arg0.items[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.items[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.items[arg2]
	end

	local var1 = arg0.memberVOs[arg1 + 1]

	var0:Update(var1, arg0.guildVO)
	var0:SetSelected(arg0.selectedId and arg0.selectedId == var1.id)

	if not arg0.selected and arg1 == 0 then
		triggerButton(var0.tf)
	end
end

function var0.TriggerFirstCard(arg0)
	for iter0, iter1 in pairs(arg0.items) do
		if iter1.memberVO.id == arg0.memberVOs[1].id then
			triggerButton(iter1.tf)

			break
		end
	end
end

function var0.OnDestroy(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parentTf)

	for iter0, iter1 in pairs(arg0.items) do
		iter1:Dispose()
	end
end

return var0
